function [cordin]=cord_reconstruct(grid_x_L,grid_y_L,validx_L,validy_L,grid_x_R,grid_y_R,validx_R,validy_R,T,KK_left,KK_right)

%　计算每一组图像中每一个网格点的三维坐标（左相机相机坐标系为世界坐标系）

cordin_old_L(:,1,1) = grid_x_L(:,1);
cordin_old_L(:,2,1) = grid_y_L(:,1);
cordin_old_R(:,1,1) = grid_x_R(:,1);
cordin_old_R(:,2,1) = grid_y_R(:,1);

k=size(validx_L,2);
kk = size(validx_R,2);

% 计算左相机各图像上各网格点坐标
for i=2:k+1
    cordin_old_L(:,1,i) = validx_L(:,i-1);       % cordin_old 为三维矩阵，第三维表示的是图片总数，第1维表示的每张图片上网格点的数量，第二维是各个网格点的坐标
    cordin_old_L(:,2,i) = validy_L(:,i-1);
end
% 计算右相机各图像上各网格点坐标
for i=2:kk+1
    cordin_old_R(:,1,i) = validx_R(:,i-1);
    cordin_old_R(:,2,i) = validy_R(:,i-1);
end

kkk = size(cordin_old_L,1);

% 利用平行测量原理计算空间点坐标
if 0
    f = KK_left(1,1);      % 获得两相机的主距，单位像素 
    ccx_L = KK_left(1,3);      % 获得左相机的主点坐标列坐标，单位像素 
    ccy_L = KK_left(2,3);      % 获得左相机的主点坐标行坐标，单位像素 
    ccx_R = KK_right(1,3);     % 获得右相机的主点坐标列坐标，单位像素
    b = abs(T(1,1)) ;   % 计算基线距，单位mm

    % -------计算每个点的空间坐标
    cordin = zeros(kkk,3,kk);
    for i=1:kk+1            %每幅图像
        for j=1:kkk         %每个网格点
            dpx = -((cordin_old_R(j,1,i)-ccx_R)+(ccx_L-cordin_old_L(j,1,i)));  % 计算该点的视差,单位像素
            cordin(j,3,i) = b*f/dpx;  % 空间点的z坐标
            cordin(j,1,i) = cordin(j,3,i)*(cordin_old_L(j,1,i)-ccx_L)/f;
            cordin(j,2,i) = cordin(j,3,i)*(cordin_old_L(j,2,i)-ccy_L)/f;
        end
    end
    save('cordin.mat','cordin');
end
    
if 1 
    f = KK_left(1,1);      % 获得两相机的主距，单位像素 
    ccx_L = KK_left(1,3);      % 获得左相机的主点坐标列坐标，单位像素 
    ccy_L = KK_left(2,3);      % 获得左相机的主点坐标行坐标，单位像素 
    ccx_R = KK_right(1,3);     % 获得右相机的主点坐标列坐标，单位像素
    Tx = T(1,1);                % 计算基线距，单位mm
    Q = zeros(4,4);
    Q(1,1) = 1; Q(2,2) = 1; Q(1,4) = -ccx_L; Q(2,4) = -ccy_L;
    Q(3,4) = f; Q(4,3) = -1/Tx; Q(4,4) = (ccx_L-ccx_R)/Tx;
    
    cordin = zeros(kkk,3,kk);
    x = ones(4,1);
    X = zeros(4,1);
    
    for i=1:kk+1
        for j=1:kkk
            d = cordin_old_L(j,1,i) - cordin_old_R(j,1,i);
            x(1,1) = cordin_old_L(j,1,i);
            x(2,1) = cordin_old_L(j,2,i);
            x(3,1) = d;
            X = Q*x;
            cordin(j,1,i) = X(1,1)/X(4,1);
            cordin(j,2,i) = X(2,1)/X(4,1);
            cordin(j,3,i) = X(3,1)/X(4,1);
        end
    end
end



