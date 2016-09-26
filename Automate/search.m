function xymoving=search(varargin)

%  利用金字塔搜索法进行相关匹配
%function search()
if 0                        %  验证与调试程序时用
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

CORRSIZE = 16;                       % 定义模板大小

ncp = size(xymoving_in,1);           %  目标点的数量

rects_moving_i = zeros(ncp,4);
rects_moving = ones(ncp,4);
xymoving_offset = zeros(ncp,2);
%offset_initial = xymoving_in-xyfixed_in;

check_point = zeros(ncp,1);        %  检查某个点的状态，默认是0，将要进行匹配搜索，若此值为1，则将跳过此点
 
k = 3;       % 图像金字塔层数


for pyramid_i = 1:k
     fprintf('开始第%d层金字塔图像匹配！\n',k-pyramid_i+1);
     new_fixed = Image_pyramid(fixed,k-pyramid_i+1);            % 定义金字塔后的模板图像
     new_moving = Image_pyramid(moving,k-pyramid_i+1);          % 定义金字塔后的目标图像
    
     if pyramid_i == k
         new_xyfixed = xyfixed_in;
         new_xymoving = xymoving_in;
     else
         new_xyfixed = xyfixed_in/(2*(k-pyramid_i));
         new_xymoving = xymoving_in/(2*(k-pyramid_i));
     end
     
     rects_fixed = calc_rects(new_xyfixed,CORRSIZE,new_fixed);      % 定义每个目标点的灰度特征区域：模板


    for icp = 1:ncp
        
       if check_point(icp)        % 跳过此点，不进行搜索
           continue
       end
        
       if isequal(rects_fixed(icp,3:4),[0 0]) 
         fprintf('第%d个目标点太靠近边界，无法匹配！\n',icp);
         check_point(icp)=1;
         continue
      end
        
      sub_fixed = imcrop(new_fixed,rects_fixed(icp,:));          % 提取金字塔后的模板区域
      
      if pyramid_i == 1
         sub_moving = new_moving;                                  % 定义金字塔后的目标搜索区域：全图 
      else
         rects_moving(icp,1:2) =  2*(rects_moving(icp,1:2) + rects_moving_i(icp,1:2)-ones(1:2));
         rects_moving(icp,3:4) = 2*(rects_moving_i(icp,3:4));
         sub_moving = imcrop(new_moving,rects_moving(icp,:));
      end
      
       if any(~isfinite(sub_moving(:))) || any(~isfinite(sub_fixed(:)))
          fprintf('第%d个目标点无法匹配！\n',icp);
         check_point(icp)=1;
          continue
       end
      if std(sub_moving(:))==0
          fprintf('第%d个目标点匹配模板无特征，无法匹配！\n',icp);
         check_point(icp)=1;
          continue
      end
  
      %  开始全图搜索
     norm_cross_corr = normxcorr2(sub_fixed,sub_moving);
     if icp == 0
       figure, surf(norm_cross_corr), shading flat
     end
     
      amplitude = max(norm_cross_corr(:));
     
      THRESHOLD = 0.4;                                                     % 判断匹配系数阈值
      if  (amplitude < THRESHOLD) 
         fprintf('第%d个目标点匹配系数太小！\n',icp);
         check_point(icp)=1;
         continue
      end   
      
     [ypeak, xpeak]  = find(norm_cross_corr==max(norm_cross_corr(:)));
     ypeak = ypeak-size(sub_fixed,1)+1;
     xpeak = xpeak-size(sub_fixed,2)+1;
     corr_offset = [xpeak ypeak];                                     %  匹配出区域的角点坐标             

       
      dis = corr_offset+rects_moving(icp,1:2)-new_xymoving(icp,:)+ (CORRSIZE-1)*ones(1,2);            % 判断匹配出的点的位移
      ind = find((abs(dis)*(k-pyramid_i)) > (CORRSIZE), 1);
      if ~isempty(ind)                                                                                
         fprintf('第%d个目标点偏移量过大，匹配无效！\n',icp);
         check_point(icp)=1;
         continue
      end
      
      xymoving_offset(icp,:) = xymoving_offset(icp,:) + (2^(k-pyramid_i))*corr_offset;
      rects_moving_i(icp,:) = [xpeak, ypeak, size(sub_fixed,2)-1, size(sub_fixed,1)-1];     % 计算另一层级金字塔图像的新的搜索区域

    end
    
      % 显示匹配区域
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
   if check_point(icp)        % 跳过此点，不进行搜索,将此点坐标值设为前一个状态的坐标
       xymoving_offset(icp,:) = xymoving_in(icp,:)+(2^(k-1)-1-CORRSIZE)*ones(1,2)-fixed_fractional_offset(icp,:);
   end
 end


xymoving = xymoving_offset + (CORRSIZE+1-2^(k-1))*ones(ncp,2)+fixed_fractional_offset;   %  计算最终匹配位置坐标

 for icp =1:ncp
      % fprintf('横坐标：%.2f,纵坐标：%.2f\n',xymoving(icp,1),xymoving(icp,2));
 end




%-------------------------------
%
function rect = calc_rects(xy,halfwidth,img)

%   定义每个目标点的灰度特征区域

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