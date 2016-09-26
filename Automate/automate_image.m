function [validx,validy]=automate_image(grid_x,grid_y,filenamelist)


% 初始化变量
input_points_x=grid_x;
base_points_x=grid_x;

input_points_y=grid_y;
base_points_y=grid_y;

[row,col]=size(base_points_x);              % 确定网格点的数量
r=size(filenamelist,1);                     % 确定图像的数量

validx = zeros(row,r-1);
validy = zeros(row,r-1);

firstimage=1;

for i=firstimage:(r-1)                          % 循环处理所有图像
        
    %tic                                        % 开启时钟
    fprintf('开始第%d 幅图像匹配！\n',i+1);
    base = im2double(imread(filenamelist(1,:)));            % 读入基准图像（通常为编号为1的图像，有时候光照条件变化时可能会是其他图像）由于imread后为2维矩阵，所以mean后矩阵不变
    input = im2double(imread(filenamelist((i+1),:)));       % 通过for循环读入剩下的图像
    
    input_points_for(:,1)=input_points_x;                 % reshape可以改变指定的矩阵形状，但元素个数不变，相当于将input_points_x转变成input_points_for的第1列
    input_points_for(:,2)=input_points_y;                 % 将input_points_y转变成input_points_for的第2列
    base_points_for(:,1)=base_points_x;                   % 将base_points_x转变成base_points_for的第1列
    base_points_for(:,2)=base_points_y;                   % 将base_points_y转变成base_points_for的第2列
    input_correl(:,:)=search(input_points_for, base_points_for, input, base);           % 进行搜索与相关匹配运算
    input_correl_x=input_correl(:,1);                                       % X方向的匹配结果
    input_correl_y=input_correl(:,2);                                       % Y方向的匹配结果
    
    
    validx(:,i)=input_correl_x;                                                     % 保存数据
    validy(:,i)=input_correl_y;
      
    % 更新 search.m 的输入参数 base 和 input
    base_points_x=grid_x;
    base_points_y=grid_y;
    input_points_x=input_correl_x;
    input_points_y=input_correl_y;
    
    cla;
    image_small = Image_pyramid(input,2);
    imshow(image_small,'InitialMagnification',100);axis on;                                                   % 更新图像
    hold on
    display_grid_x = grid_x/2;
    display_grid_y = grid_y/2;
    display_input_correl_x = input_correl_x/2;
    display_input_correl_y = input_correl_y/2;
    plot(display_grid_x,display_grid_y,'g+')                                                        % 显示网格点的起始位置
    plot(display_input_correl_x,display_input_correl_y,'r+')                                        % 显示网格点的实际位置
    drawnow                                          
    title([' 图像总数： ', num2str((r)),'； 正在处理： ', num2str((i+1)),'；  网格数量：',num2str(row*col)])    % 显示状态
    drawnow
    
end   
    title('相关计算完成') 



