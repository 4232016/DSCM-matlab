function [grid_x_R,grid_y_R,x_r] = right(grid_x_L,grid_y_L,left_image,right_image,x_r,n_ima)

n = n_ima+1;

input_points_x=grid_x_L;         %将网格坐标grid_x_L赋值给input_points_x  base_points_x
base_points_x=grid_x_L;
input_points_y=grid_y_L;         %将网格坐标grid_y_L赋值给input_points_y  base_points_y
base_points_y=grid_y_L;

base = uint8(mean(double(left_image),3));            % 读入左相机基准图像
input = uint8(mean(double(right_image),3));          % 读入右相机基准图像
input_points_for(:,1)=reshape(input_points_x,[],1);                 %reshape可以改变指定的矩阵形状，但元素个数不变，相当于将input_points_x转变成input_points_for的第1列
input_points_for(:,2)=reshape(input_points_y,[],1);                 %将input_points_y转变成input_points_for的第2列
base_points_for(:,1)=reshape(base_points_x,[],1);                   %将base_points_x转变成base_points_for的第1列
base_points_for(:,2)=reshape(base_points_y,[],1);                   %将base_points_y转变成base_points_for的第2列
input_correl(:,:)=cpcorr(input_points_for,base_points_for,input, base);    % 第一步进行相关运算，获得各图像搜索控制点
input_correl_x=input_correl(:,1);                                   % the results we get from cpcorr for the x-direction
input_correl_y=input_correl(:,2);                                   % the results we get from cpcorr for the y-direction
grid_x_R=input_correl_x;                                         % lets save the data

grid_y_R=input_correl_y;
 for i=1:121
        x_r(1,i,n) = grid_x_R(i);
        x_r(2,i,n) = grid_y_R(i);
    end
%save grid_x_R.dat grid_x_R -ascii -tabs   
%save grid_y_R.dat grid_y_R -ascii -tabs

end