current_path = pwd;
[PathNameBase] = uigetdir('','选择左相机图像文件夹！');
[file_path] = uigetdir('','选择右相机图像文件夹！');
image_size = [964 1292];
load('filenamelist_L.mat');
load('filenamelist_R.mat');
if 1
    n_ima = size(filenamelist_L);
    nx = image_size(1,2);    % 图像宽度
    ny = image_size(1,1);    % 图像高度
    new_image = zeros(ny,2*nx);
    for i =1:3
        cd(PathNameBase);
        left_image = imread(filenamelist_L(1,:));
        cd(file_path);
        right_image = imread(filenamelist_R(1,:));

        %new_image(1:nx,:) = left_image;
        %new_image(nx+1:2*nx,:) = right_image;
        new_image = [left_image,right_image];
        figure
        imshow(new_image)
        hold on 
        x =[1:2*nx];
        for i = 1:20
            y = 20*i*ones(1,2*nx);
            plot(y,'g-');
        end
        hold off
    end
end%mkdir('新建文件夹')
cd(current_path);