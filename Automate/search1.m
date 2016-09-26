function search1()

%   自写 相关算法与matlab自带相关算法的比较
clear,clc;

xyfixed_in = [254,324;50,80;150,240];
%xyfixed_in = [254,324];
%xymoving_in = xyfixed_in;

moving = im2double(imread('ImageL01.tif'));
fixed = im2double(imread('ImageL01.tif'));
peppers = moving(400:800,200:600);
fixed =   fixed(400:800,200:600);

CORRSIZE = 20;     % 定义模板大

rects_fixed = calc_rects(xyfixed_in,CORRSIZE,fixed);      % 定义每个目标点的灰度特征区域：模板
%rects_moving = calc_rects(xyfixed_in,3*CORRSIZE,peppers);

ncp = size(xyfixed_in,1);
xoffSet = zeros(ncp,1);
yoffSet = zeros(ncp,1);
sub_moving = peppers;

for icp = 1:ncp
    
 onion =   imcrop(fixed,rects_fixed(icp,:));
 %sub_moving = imcrop(peppers,rects_moving);

 %figure
 %imshowpair(sub_moving,onion,'montage')
 
  if 0                      %  0 的时候用matlab 自带算法，1 的时候用自己写的
       [mt,nt] = size(onion);
       [ma,na] = size(sub_moving);
       new_m = ma - mt;
       new_n = na - nt;
       c = zeros(new_m+1,new_n+1);
       rects = zeros(1,4);

       for i = 0:new_m
           for j = 0:new_n
               rects(1,1) = j;
               rects(1,2) = i;
               rects(1,3) = nt;
               rects(1,4) = mt;
               A = imcrop(sub_moving,rects);  
               c(i+1,j+1) = confi_corr(onion,A);
           end
       end
    [ypeak, xpeak]   = find(c==max(c(:)));
    max_xy = max(c(:))
    xpeak = xpeak-1;
    ypeak = ypeak-1;
    yoffSet(icp,1) = ypeak;
    xoffSet(icp,1) = xpeak;
  else
     c = normxcorr2(onion,sub_moving);
     [ypeak, xpeak]   = find(c==max(c(:)));
     max_xy = max(c(:))
     yoffSet(icp,1) = ypeak-size(onion,1);
     xoffSet(icp,1) = xpeak-size(onion,2);
  end
      
   figure, surf(c), shading flat
end

  %Display matched area
  hFig = figure;
  hAx  = axes;
  imshow(sub_moving,'Parent', hAx);
  hold on 
  for icp =1:ncp
    imrect(hAx, [xoffSet(icp,1), yoffSet(icp,1), size(onion,2), size(onion,1)]);
     plot(xyfixed_in(icp,1),xyfixed_in(icp,2),'r*');
  end
   hold off
end
   
   
   
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
end

  
function [coordinates, breadth] = adjust_lo_edge(coordinates,edge,breadth)

indx = find( coordinates<edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end
end

function [coordinates, breadth] = adjust_hi_edge(coordinates,edge,breadth)

indx = find( coordinates>edge );
if ~isempty(indx)
    breadth(indx) = breadth(indx) - abs(coordinates(indx)-edge);
    coordinates(indx) = edge;
end
end

