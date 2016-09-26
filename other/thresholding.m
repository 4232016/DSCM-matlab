function thresholding

% �Ա궨ͼ�����Otsu��ֵ�ָ���зָ��ʹ��ȡ��Ե��׼ȷ

I = imread('Halcon.jpg');                %����ͼ��
I = im2double(I);
T = graythresh(I);                       %��ȡ��ֵ
J = im2bw(I,T);                          %ͼ��ָ�
[K,thresh] = edge(J,'Canny');            %����Canny������ȡ��Ե
%figure;
%subplot(131);  imshow(I);                %��ʾԭͼ��
%subplot(132);  imshow(J);                %��ʾ���
%subplot(133);  imshow(K);]

[c,r,metric] = imfindcircles(K,[10 20],'ObjectPolarity','bright');
metric
figure;
imshow(K);
viscircles(c,r, 'LineWidth',0.5);
end