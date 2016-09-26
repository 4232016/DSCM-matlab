current_path = pwd;
[PathNameBase] = uigetdir('','ѡ�������ͼ���ļ��У�');
[file_path] = uigetdir('','ѡ�������ͼ���ļ��У�');
image_size = [964 1292];
load('filenamelist_L.mat');
load('filenamelist_R.mat');
if 1
    n_ima = size(filenamelist_L);
    nx = image_size(1,2);    % ͼ����
    ny = image_size(1,1);    % ͼ��߶�
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
end%mkdir('�½��ļ���')
cd(current_path);