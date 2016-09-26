function thresholding

% 对标定图像采用Otsu阈值分割法进行分割，以使提取边缘更准确

I = imread('Halcon.jpg');                %读入图像
I = im2double(I);
T = graythresh(I);                       %获取阈值
J = im2bw(I,T);                          %图像分割
[K,thresh] = edge(J,'Canny');            %采用Canny算子提取边缘
%figure;
%subplot(131);  imshow(I);                %显示原图像
%subplot(132);  imshow(J);                %显示结果
%subplot(133);  imshow(K);]

[c,r,metric] = imfindcircles(K,[10 20],'ObjectPolarity','bright');
metric
figure;
imshow(K);
viscircles(c,r, 'LineWidth',0.5);
end