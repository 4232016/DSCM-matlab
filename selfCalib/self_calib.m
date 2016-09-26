current_path = pwd;
addpath(current_path);
image_dir = uigetdir(current_path,'选择标定图像所在的文件夹');
cd(image_dir);
slect_images = 0;

if slect_images
    keep_calib = 1;
    n_ima = 0;
    x_l = [];
    x_r = [];

    X_l = zeros(3,121);
    for i=1:11
        for j=1:11
            k = 11*(i-1)+j;
            X_l(1,k) =50*(i-1);
            X_l(2,k) =50*(j-1);
        end
    end
    X_r = X_l;

     while keep_calib
        [file_name] = uigetfile({'*.tif';'*.bmp';'*.BMP';'*.jpg'},'选择左相机基础图片'); % 选择左相机的标定图像
        left_image = imread(file_name);
        imshow(left_image);
        trygrid = 1;
        while trygrid
            uiwait(msgbox('请在图像中心选择一个点，系统将自动划分网格点！','提示','non-modal'));
            [x, y] = ginput(1);
            plot(x(1,1),y(1,1),'+b')
            [grid_x_L,grid_y_L,trygrid,x_l] = autogrid(left_image,x,y,x_l,n_ima);
        end

        [file_name2] = uigetfile({'*.tif';'*.bmp';'*.BMP';'*.jpg'},'选择右相机基础图片'); % 选择右相机的标定图像
        right_image = imread(file_name2);
        [grid_x_R,grid_y_R,x_r] = right(grid_x_L,grid_y_L,left_image,right_image,x_r,n_ima);
        figure;
        imshow(right_image);
        title('右相机网格')
        hold on                                         % 显示右相机基础图像的网格
        plot(grid_x_R, grid_y_R,'+r')
        hold off;
        n_ima = n_ima + 1;
        button = questdlg('需要继续选择图像划分网格么','是否继续','继续','结束','继续');
        if strcmpi(button,'结束')
            close all;
            keep_calib = 0;
            break;
        end
        close all;
     end

    save ('x.mat','x_l','x_r');    %  保存网格点在相机坐标系中坐标
    save ('XX.mat','X_l','X_r');   %  保存网格点在世界坐标系中坐标

    [nx,ny] = size(left_image);
    cd(current_path);
end

 % 下面是主要的标定程序，标定内参矩阵和外参矩阵
%calib_left_camera;
%calib_right_camera;
stereo_gui;