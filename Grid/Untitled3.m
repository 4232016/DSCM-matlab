  % Load images
   if 1
       onion   = rgb2gray(imread('onion.png'));
       onion = onion(:,1:197);
       onion = im2double(onion);
       peppers = rgb2gray(imread('peppers.png'));
       peppers = im2double(peppers);
       imshowpair(peppers,onion,'montage')
   end
   if 0
   peppers = imread('L000001.bmp');
   peppers = im2double(peppers);
   onion = peppers(300:500,500:800);
   figure
   imshowpair(peppers,onion,'montage')
   end
   if 0
   [mt,nt] = size(onion);
   [ma,na] = size(peppers);
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
           A = imcrop(peppers,rects);  
           c(i+1,j+1) = confi_corr(onion,A);
       end
   end
   end
   c = normxcorr2(onion,peppers);
   
   figure, surf(c), shading flat
   %subpixel = true;
   [ypeak, xpeak]   = find(c==max(c(:)));
    %[a, b, amplitude] = findpeak(c,subpixel);   % 匹配相关系数的极值点
%   % account for padding that normxcorr2 adds
   yoffSet = ypeak-size(onion,1);
   xoffSet = xpeak-size(onion,2);
   
%   % Display matched area
   hFig = figure;
   hAx  = axes;
   imshow(peppers,'Parent', hAx);
      hold on
   imrect(hAx, [xoffSet, yoffSet, size(onion,2), size(onion,1)]);

   plot(xpeak,ypeak,'g*')
   hold off
   
  