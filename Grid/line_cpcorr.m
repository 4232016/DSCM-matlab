  %  function line_cpcorr()
function xymoving = line_cpcorr(xymoving_in,xyfixed_in,moving,fixed,Grid)
%  ���ڽ������ͼ������ƥ�䣬��ͬһ�߶ȵĵ�
if 1


ny = size(Grid,1);     % ny Ϊ���������
nx = size(Grid,2)/2;                % nx Ϊ���������

if ny==0 || nx==0
    fprintf('�������������������\n');
    return
end

xspace = 2*(Grid(1,2)-Grid(1,1));

else
    %xyfixed_in = [504,324;350,480;150,240];
    xyfixed_in = [504.3,324.6;438 423; 354 671];
    xymoving_in = [508,328];
   % xymoving_in = xyfixed_in;
    moving = im2double(imread('ImageL01.tif'));
    %moving = moving(201:800,201:800);
    fixed = im2double(imread('ImageL01.tif'));
    %fixed = fixed(201:800,201:800);
end

CORRSIZE = 16;

 fixed_fractional_offset = xyfixed_in - round(xyfixed_in);

rects_fixed = calc_rects(xyfixed_in,CORRSIZE,fixed);      % ����ÿ��Ŀ���ĻҶ���������ģ��
rects_moving = calc_rects2(xyfixed_in,2*CORRSIZE,moving);    % ����Ŀ����������ROI

ncp = size(xyfixed_in,1);

max_amplitude = zeros(ncp,1);
xymoving = xymoving_in; 

for icp = 1:ncp

    if  isequal(rects_fixed(icp,3:4),[0 0]) 
        fprintf('��%d��Ŀ���̫�����߽磬�޷�ƥ�䣡\n',icp);
        continue
    end
    
    sub_moving = imcrop(moving,rects_moving(icp,:));        % ��ȡĿ������
    sub_fixed = imcrop(fixed,rects_fixed(icp,:));           % ��ȡģ������
    
        % make sure finite
    if any(~isfinite(sub_fixed(:)))
       fprintf('��%d��Ŀ����޷�ƥ�䣡\n',icp);
        continue
    end

    
      %  ��ʼȫͼ����
   norm_cross_corr = normxcorr2(sub_fixed,sub_moving);
 
  
   %figure, surf(norm_cross_corr), shading flat
   amplitude = max(norm_cross_corr(:));
   max_amplitude(icp) = amplitude;

    THRESHOLD = 0.9;
    if (amplitude < THRESHOLD) 
        fprintf('��%d��Ŀ���ƥ��ϵ����С��\n',icp);
        continue
    end
    
     [~, xpeak]  = find(norm_cross_corr==max(norm_cross_corr(:)));
     ypeak = round(xyfixed_in(icp,2));
     xpeak = xpeak-size(sub_fixed,2)+1+CORRSIZE;
     corr_offset = [xpeak ypeak];                                     %  ƥ�������Ľǵ����� 
   
     xymoving(icp,:) =corr_offset + fixed_fractional_offset(icp,:);
  % fprintf('�����꣺%.2f,�����꣺%.2f\n',xymoving(icp,1),xymoving(icp,2));
end

%  ����ƥ��ʧ�ܵ������

ind  = max_amplitude==max(max_amplitude(:,1));
check_point = ones(ncp,1);
check_point(ind) = 0;

for icp = 1:ncp
    if check_point(icp) == 0     %  ������Ѿ�ƥ��ɹ�
        continue
    end
    
    if icp == 1
       for i = 2:ncp
           if check_point(i) == 0       %  ������Ѿ�ƥ��ɹ�
               n = fix(i/ny);           % ��������һ����֮����в�
               if mod(i,ny)==0
                   n = n-1;
               end
               xymoving(icp,1) = xymoving(i,1) - n*xspace;
               xymoving(icp,2) = xyfixed_in(icp,2);
               break
           end
       end
       if i == ncp                 % ���е㶼ƥ��ʧ��
           fprintf('����ͼ�����ϴ��޷�ƥ�䣬�������������������\n');
           xymoving = xyfixed_in;
           break
       end
    else
        if mod(icp,ny) == 1    %  ������ǵ�һ�еĵ�
            xymoving(icp,1) = xymoving(icp-1,1) + xspace;
            xymoving(icp,2) = xyfixed_in(icp,2);
        else
            xymoving(icp,1) = xymoving(icp-1,1);
            xymoving(icp,2) = xyfixed_in(icp,2);
        end
    end
end
 
 


%-------------------------------
%
function rect = calc_rects(xy,halfwidth,img)

%   ����ÿ��Ŀ���ĻҶ���������

default_width = 2*halfwidth;
default_height = 2*halfwidth;

upperleft = round(xy) - halfwidth;


upper = upperleft(:,2);
left = upperleft(:,1);
lower = upper + default_height;
right = left + default_width;
width = default_width * ones(size(upper));
height = default_height * ones(size(upper));


[upper,height] = adjust_lo_edge(upper,1,height);
[~,height] = adjust_hi_edge(lower,size(img,1),height);
[left,width] = adjust_lo_edge(left,1,width);
[~,width] = adjust_hi_edge(right,size(img,2),width);

iw = find(width<default_width);
ih = find(height<default_height);
idx = unique([iw; ih]);
width(idx) = 0;
height(idx) = 0;

rect = [left upper width height];

%-------------------------------
%
function rect = calc_rects2(xy,halfwidth,img)

%   ����Ŀ����������
default_height = 2*halfwidth;


upperleft = round(xy) - halfwidth;

upper = upperleft(:,2);
left = ones(size(upper));
lower = upper + default_height;
right = size(img,2)*ones(size(upper));
width = right-left;
height = default_height * ones(size(upper));

[upper,height] = adjust_lo_edge(upper,1,height);
[~,height] = adjust_hi_edge(lower,size(img,1),height);
[left,width] = adjust_lo_edge(left,1,width);
[~,width] = adjust_hi_edge(right,size(img,2),width);

rect = [left upper width height];

%-------------------------------
%
function [coordinates, breadth] = adjust_lo_edge(coordinates,edge,breadth)

indx = find( coordinates<edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end

%-------------------------------
%
function [coordinates, breadth] = adjust_hi_edge(coordinates,edge,breadth)

indx = find( coordinates>edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end

