function [strain_xyz] = strain(displx,disply,displz,cordin,bcs_x,bcs_y,bcs_z,number,a,b)

%  计算指定图像指定点的应变状态（三个方向的应变与三个方向的切应变）
thick = 1;  % 节点处板厚
strain_xyz = zeros(a*b,6);


%  定义形函数
syms s r t real
N2(1) = 0.25 *(r-1)*(s-1);
N2(2) = -0.25 *(r+1)*(s-1);
N2(3) = 0.25 *(r+1)*(s+1);
N2(4) = -0.25 *(r-1)*(s+1);
dNdrs = [diff(N2,r,1);diff(N2,s,1)];

A = cordin(:,:,1);             %  基础图像中的网格点坐标
NElems = (a-1)*(b-1);          %  四节点壳单元的总数

%  建立单元格节点编号矩阵
for i=1:NElems
    j = mod(i,b-1);
    k = fix(i/(b-1));
    if j == 0
        cont = k*b + j -1;
    else
        cont = k*b + j;
    end
    Elems(i,1)= cont;
    Elems(i,2)= cont + b;
    Elems(i,3)= cont + b + 1;
    Elems(i,4)= cont + 1;
end

ecor = cordin(:,:,1);    %  各节点坐标

% 计算每一个网格节点的应力

for i=1:NElems
    ecoords = [];
    B = [];
    uk = zeros(6,4);
    
    % 计算每一个网格的四个结点的位移
    for j =1:4
        nod = Elems(i,j);
        ecoords(j,:) = ecor(nod,:);
        X(1,1) = ecoords(j,1);
        X(2,1) = ecoords(j,2);
        uk(1,j) = cordin(nod,1,number)-cordin(nod,1,1);
        uk(2,j) = cordin(nod,2,number)-cordin(nod,2,1);
        uk(3,j) = cordin(nod,3,number)-cordin(nod,3,1);
        uk(4,j) = fnval(fndir(bcs_z(number-1),[1;0]),X);
        uk(5,j) = fnval(fndir(bcs_z(number-1),[0;1]),X);
    end
    
    % 计算每一个网格的四个结点的应变
    [v1,v2,v3] = trans4(ecoords);   % 计算单位向量 v1 v2 v3
    [dN2xyz,dN1z] = Jacobians4(dNdrs,ecoords,v3,thick,t); % 计算雅可比矩阵
    B = Bs4(dN2xyz,N2,dN1z,v1,v2,thick,t);  %  计算B矩阵
    [sigma_i] = sigma(B,uk);    % 计算每个网格四个结点的应变
    for j=1:4
        nod = Elems(i,j);
        if any(strain_xyz(nod,:))==0
            strain_xyz(nod,:)= sigma_i(j,:);
        else
            aa = strain_xyz(nod,:);
            bb = 0.5*(aa+sigma_i(j,:));
            strain_xyz(nod,:) = bb;
        end
    end
end




