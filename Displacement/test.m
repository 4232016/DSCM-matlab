current_path = pwd;
[file_path] = uigetdir('','选择保存临时数据的文件夹！');
if  ~isempty(file_path) ;                                             
    cd(file_path);                                                 
end

% 加载左相机网格数据
load('Calib_Results_rectified.mat');
calib_data_L = load('calib_data_L.mat');
n_ima = getfield(calib_data_L,'n_ima');
for i=1:n_ima
     str = ['x_' num2str(i)];;
     a = getfield(calib_data_L,str); 
     a = a';
    if i==1
        grid_x_L = a(:,1);
        grid_y_L = a(:,2);
    else
        validx_L(:,i-1) = a(:,1);
        validy_L(:,i-1) = a(:,2);
    end
end

% 加载右相机网格数据
calib_data_R = load('calib_data_R.mat');
n_ima = getfield(calib_data_R,'n_ima');
for i=1:n_ima
     str = ['x_' num2str(i)];
     a = getfield(calib_data_R,str); 
     a = a';
    if i==1
        grid_x_R = a(:,1);
        grid_y_R = a(:,2);
    else
        validx_R(:,i-1) = a(:,1);
        validy_R(:,i-1) = a(:,2);
    end
end

[cordin] = cord_reconstruct(grid_x_L,grid_y_L,validx_L,validy_L,grid_x_R,grid_y_R,validx_R,validy_R,T_new,KK_left_new,KK_right_new);
image = size(cordin,3);
for i=1:iamge
    x = cordin(:,1,i);
    y = cordin(:,2,i);
    z = cordin(:,3,i);
    figure
    grid on
    plot3(x,y,z,'g*');
            xlabel('X')
            ylabel('Y')
            zlabel('Z')
    hold on
    if 1
    for j=1:15     % 自己的标定板j=1:15
        for k=0:15
            x1 = x(j+k*16);
            x2 = x(j+1+k*16);
            y1 = y(j+k*16);
            y2 = y(j+1+k*16);
            z1 = z(j+k*16);
            z2 = z(j+1+k*16);
            plot3([x1 x2],[y1 y2],[z1 z2],'r');
            distance=sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2);
            dis(j,k+1,i)=distance;
        end
    end
    end
    if 0
        for j=1:5     % 自己的标定板j=1:15
        for k=0:8
            x1 = x(j+k*6);
            x2 = x(j+1+k*6);
            y1 = y(j+k*6);
            y2 = y(j+1+k*6);
            z1 = z(j+k*6);
            z2 = z(j+1+k*6);
            plot3([x1 x2],[y1 y2],[z1 z2],'r');
            distance=sqrt((x2-x1).^2+(y2-y1).^2+(z2-z1).^2);
            dis(j,k+1,i)=distance;
        end
        end
    end
    %scatter3([0],[0],[0]);
    hold off
end
cd(current_path);