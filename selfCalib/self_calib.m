current_path = pwd;
addpath(current_path);
image_dir = uigetdir(current_path,'ѡ��궨ͼ�����ڵ��ļ���');
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
        [file_name] = uigetfile({'*.tif';'*.bmp';'*.BMP';'*.jpg'},'ѡ�����������ͼƬ'); % ѡ��������ı궨ͼ��
        left_image = imread(file_name);
        imshow(left_image);
        trygrid = 1;
        while trygrid
            uiwait(msgbox('����ͼ������ѡ��һ���㣬ϵͳ���Զ���������㣡','��ʾ','non-modal'));
            [x, y] = ginput(1);
            plot(x(1,1),y(1,1),'+b')
            [grid_x_L,grid_y_L,trygrid,x_l] = autogrid(left_image,x,y,x_l,n_ima);
        end

        [file_name2] = uigetfile({'*.tif';'*.bmp';'*.BMP';'*.jpg'},'ѡ�����������ͼƬ'); % ѡ��������ı궨ͼ��
        right_image = imread(file_name2);
        [grid_x_R,grid_y_R,x_r] = right(grid_x_L,grid_y_L,left_image,right_image,x_r,n_ima);
        figure;
        imshow(right_image);
        title('���������')
        hold on                                         % ��ʾ���������ͼ�������
        plot(grid_x_R, grid_y_R,'+r')
        hold off;
        n_ima = n_ima + 1;
        button = questdlg('��Ҫ����ѡ��ͼ�񻮷�����ô','�Ƿ����','����','����','����');
        if strcmpi(button,'����')
            close all;
            keep_calib = 0;
            break;
        end
        close all;
     end

    save ('x.mat','x_l','x_r');    %  ������������������ϵ������
    save ('XX.mat','X_l','X_r');   %  �������������������ϵ������

    [nx,ny] = size(left_image);
    cd(current_path);
end

 % ��������Ҫ�ı궨���򣬱궨�ڲξ������ξ���
%calib_left_camera;
%calib_right_camera;
stereo_gui;