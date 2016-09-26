function out_image = Image_pyramid(in_image,k)

if 0                  % 高斯滤波器创建图像金字塔
    if k == 1
        out_image = in_image;
    elseif k == 2
        hgausspymd = vision.Pyramid;
        hgausspymd.PyramidLevel = 2;
        x= in_image;
        y = step(vision.Pyramid,x);
        out_image=mat2gray(double(y));
    else
        hgausspymd = vision.Pyramid;
        hgausspymd.PyramidLevel = 2;
        x= in_image;
        y = step(vision.Pyramid,x);
        x1=mat2gray(double(y));
        y1 = step(vision.Pyramid,x1);
        out_image=mat2gray(double(y1));
    end
end
if 1             %  2×2均值滤波器创建图像金字塔
    if k == 1
        out_image = in_image;
    elseif k == 2
        x= in_image;
        PSF = fspecial('average',2);
        size_x = size(x);
        y = imfilter(x,PSF);
        out_image = y(1:2:size_x(1),1:2:size_x(2));
    else
        x= in_image;
        PSF = fspecial('average',2);
        size_x = size(x);
        y = imfilter(x,PSF);
        x1 = y(1:2:size_x(1),1:2:size_x(2));
        size_x1 = size(x1);
        y1 = imfilter(x1,PSF);
        out_image = y1(1:2:size_x1(1),1:2:size_x1(2));
    end
end

