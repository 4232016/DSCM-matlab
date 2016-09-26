function xymoving=search(varargin)

%  ���ý������������������ƥ��
%function search()
if 0                        %  ��֤����Գ���ʱ��
    %xyfixed_in = [504,324;350,480;150,240];
    xyfixed_in = [504.3,324.3];
    xymoving_in = [514.6,326];
   % xymoving_in = xyfixed_in;
    moving = im2double(imread('ImageL02.tif'));
    %moving = moving(201:800,201:800);
    fixed = im2double(imread('ImageL01.tif'));
    %fixed = fixed(201:800,201:800);
end

[xymoving_in,xyfixed_in,moving,fixed] = ParseInputs(varargin{:});

CORRSIZE = 16;                       % ����ģ���С

ncp = size(xymoving_in,1);           %  Ŀ��������

rects_moving_i = zeros(ncp,4);
rects_moving = ones(ncp,4);
xymoving_offset = zeros(ncp,2);
%offset_initial = xymoving_in-xyfixed_in;

check_point = zeros(ncp,1);        %  ���ĳ�����״̬��Ĭ����0����Ҫ����ƥ������������ֵΪ1���������˵�
 
k = 3;       % ͼ�����������


for pyramid_i = 1:k
     fprintf('��ʼ��%d�������ͼ��ƥ�䣡\n',k-pyramid_i+1);
     new_fixed = Image_pyramid(fixed,k-pyramid_i+1);            % ������������ģ��ͼ��
     new_moving = Image_pyramid(moving,k-pyramid_i+1);          % ������������Ŀ��ͼ��
    
     if pyramid_i == k
         new_xyfixed = xyfixed_in;
         new_xymoving = xymoving_in;
     else
         new_xyfixed = xyfixed_in/(2*(k-pyramid_i));
         new_xymoving = xymoving_in/(2*(k-pyramid_i));
     end
     
     rects_fixed = calc_rects(new_xyfixed,CORRSIZE,new_fixed);      % ����ÿ��Ŀ���ĻҶ���������ģ��


    for icp = 1:ncp
        
       if check_point(icp)        % �����˵㣬����������
           continue
       end
        
       if isequal(rects_fixed(icp,3:4),[0 0]) 
         fprintf('��%d��Ŀ���̫�����߽磬�޷�ƥ�䣡\n',icp);
         check_point(icp)=1;
         continue
      end
        
      sub_fixed = imcrop(new_fixed,rects_fixed(icp,:));          % ��ȡ���������ģ������
      
      if pyramid_i == 1
         sub_moving = new_moving;                                  % ������������Ŀ����������ȫͼ 
      else
         rects_moving(icp,1:2) =  2*(rects_moving(icp,1:2) + rects_moving_i(icp,1:2)-ones(1:2));
         rects_moving(icp,3:4) = 2*(rects_moving_i(icp,3:4));
         sub_moving = imcrop(new_moving,rects_moving(icp,:));
      end
      
       if any(~isfinite(sub_moving(:))) || any(~isfinite(sub_fixed(:)))
          fprintf('��%d��Ŀ����޷�ƥ�䣡\n',icp);
         check_point(icp)=1;
          continue
       end
      if std(sub_moving(:))==0
          fprintf('��%d��Ŀ���ƥ��ģ�����������޷�ƥ�䣡\n',icp);
         check_point(icp)=1;
          continue
      end
  
      %  ��ʼȫͼ����
     norm_cross_corr = normxcorr2(sub_fixed,sub_moving);
     if icp == 0
       figure, surf(norm_cross_corr), shading flat
     end
     
      amplitude = max(norm_cross_corr(:));
     
      THRESHOLD = 0.4;                                                     % �ж�ƥ��ϵ����ֵ
      if  (amplitude < THRESHOLD) 
         fprintf('��%d��Ŀ���ƥ��ϵ��̫С��\n',icp);
         check_point(icp)=1;
         continue
      end   
      
     [ypeak, xpeak]  = find(norm_cross_corr==max(norm_cross_corr(:)));
     ypeak = ypeak-size(sub_fixed,1)+1;
     xpeak = xpeak-size(sub_fixed,2)+1;
     corr_offset = [xpeak ypeak];                                     %  ƥ�������Ľǵ�����             

       
      dis = corr_offset+rects_moving(icp,1:2)-new_xymoving(icp,:)+ (CORRSIZE-1)*ones(1,2);            % �ж�ƥ����ĵ��λ��
      ind = find((abs(dis)*(k-pyramid_i)) > (CORRSIZE), 1);
      if ~isempty(ind)                                                                                
         fprintf('��%d��Ŀ���ƫ��������ƥ����Ч��\n',icp);
         check_point(icp)=1;
         continue
      end
      
      xymoving_offset(icp,:) = xymoving_offset(icp,:) + (2^(k-pyramid_i))*corr_offset;
      rects_moving_i(icp,:) = [xpeak, ypeak, size(sub_fixed,2)-1, size(sub_fixed,1)-1];     % ������һ�㼶������ͼ����µ���������

    end
    
      % ��ʾƥ������
      if 0
           hFig = figure;
           hAx  = axes;
           imshow(sub_moving,'Parent', hAx);
           hold on 
           for icp =1:ncp
              imrect(hAx, rects_moving_i(icp,:));
              plot(new_xyfixed(icp,1),new_xyfixed(icp,2),'r*');
           end
           hold off
      end       
end


fixed_fractional_offset = xyfixed_in - round(xyfixed_in);

for icp = 1:ncp    
   if check_point(icp)        % �����˵㣬����������,���˵�����ֵ��Ϊǰһ��״̬������
       xymoving_offset(icp,:) = xymoving_in(icp,:)+(2^(k-1)-1-CORRSIZE)*ones(1,2)-fixed_fractional_offset(icp,:);
   end
 end


xymoving = xymoving_offset + (CORRSIZE+1-2^(k-1))*ones(ncp,2)+fixed_fractional_offset;   %  ��������ƥ��λ������

 for icp =1:ncp
      % fprintf('�����꣺%.2f,�����꣺%.2f\n',xymoving(icp,1),xymoving(icp,2));
 end




%-------------------------------
%
function rect = calc_rects(xy,halfwidth,img)

%   ����ÿ��Ŀ���ĻҶ���������

default_width = 2*halfwidth;
default_height = 2*halfwidth;

% xy specifies center of rectangle, need upper left
upperleft = round(xy) - halfwidth;

% need to modify for pixels near edge of images
upper = upperleft(:,2);
left = upperleft(:,1);
lower = upper + default_height;
right = left + default_width;
width = default_width * ones(size(upper));
height = default_height * ones(size(upper));

% check edges for coordinates outside image
[upper,height] = adjust_lo_edge(upper,1,height);
[~,height] = adjust_hi_edge(lower,size(img,1),height);
[left,width] = adjust_lo_edge(left,1,width);
[~,width] = adjust_hi_edge(right,size(img,2),width);

% set width and height to zero when less than default size
iw = find(width<default_width);
ih = find(height<default_height);
idx = unique([iw; ih]);
width(idx) = 0;
height(idx) = 0;

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

%-------------------------------
%
function [xymoving_in,xyfixed_in,moving,fixed] = ParseInputs(varargin)

narginchk(4,4);

xymoving_in = varargin{1};
xyfixed_in = varargin{2};
if size(xymoving_in,2) ~= 2 || size(xyfixed_in,2) ~= 2
    error(message('images:cpcorr:cpMatrixMustBeMby2'))
end

if size(xymoving_in,1) ~= size(xyfixed_in,1)
    error(message('images:cpcorr:needSameNumOfControlPoints'))
end

moving = varargin{3};
fixed = varargin{4};
if ~ismatrix(moving) || ~ismatrix(fixed)
    error(message('images:cpcorr:intensityImagesReq'))
end

moving = double(moving);
fixed = double(fixed);

if any(xymoving_in(:)<0.5) || any(xymoving_in(:,1)>size(moving,2)+0.5) || ...
   any(xymoving_in(:,2)>size(moving,1)+0.5) || ...
   any(xyfixed_in(:)<0.5) || any(xyfixed_in(:,1)>size(fixed,2)+0.5) || ...
   any(xyfixed_in(:,2)>size(fixed,1)+0.5)
    error(message('images:cpcorr:cpPointsMustBeInPixCoord'))
end