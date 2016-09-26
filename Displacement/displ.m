function [displx,disply,displz] = displ(cordin,Grid)

% 计算每幅图像每个网格点的位移（x,y,z 3个方向的）

A = cordin;
a = size(Grid,2)/2;     % a为网格点的列数
b = size(Grid,1);       % b为网格点的行数
xspacing = 2*(Grid(1,2)-Grid(1,1));  % x方向网格点的间距
yspacing = 2*(Grid(2,a+1)-Grid(1,a+1));  % x方向网格点的间距


n_ima = size(A,3);   % 图像数量


displx = zeros(b,a,n_ima-1);
disply = zeros(b,a,n_ima-1);
displz = zeros(b,a,n_ima-1);


for i = 2:n_ima
    for j=1:a
        for k = 1:b
            m = (j-1)*b + k;
            displx(k,j,i-1) = A(m,1,i)-A(m,1,1);
            disply(k,j,i-1) = A(m,2,i)-A(m,2,1);
            displz(k,j,i-1) = A(m,3,i)-A(m,3,1);
        end
    end
end

[bcs_x,displx] = surffit(displx,Grid,xspacing,yspacing);   % 对X方向位移进行三次样条曲面拟合
[bcs_y] = surffit(disply,Grid,xspacing,yspacing);   % 对Y方向位移进行三次样条曲面拟合
[bcs_z] = surffit(displz,Grid,xspacing,yspacing);   % 对Z方向位移进行三次样条曲面拟合


