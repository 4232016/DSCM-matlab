function [dN2xyz,dN1z] = Jacobians4(dNdrs,ecoords,v3,thick,t)

% 计算4结点壳单元中Jacobian矩阵及形函数导数

dhdr = dNdrs(1,:);  % dN/dr
dhds = dNdrs(2,:);  % dN/ds

xcoord = ecoords(:,1);  % [x1 x2 x3 x4]'
ycoord = ecoords(:,2);  % [y1 y2 y3 y4]'
zcoord = ecoords(:,3);  % [z1 z2 z3 z4]'

hz = thick*0.5*t;  %Hz
hzdt = thick*0.5;  %dHz/dt

%  Jacobian 矩阵中各元素
aj(1,1) = dhdr(1)*xcoord(1)+dhdr(2)*xcoord(2)+dhdr(3)*xcoord(3)+...
    dhdr(4)*xcoord(4)+dhdr(1)*hz*v3(1)+dhdr(2)*hz*v3(1)+...
    dhdr(3)*hz*v3(1)+dhdr(4)*hz*v3(1);
aj(2,1) = dhds(1)*xcoord(1)+dhds(2)*xcoord(2)+dhds(3)*xcoord(3)+...
    dhds(4)*xcoord(4)+dhds(1)*hz*v3(1)+dhds(2)*hz*v3(1)+...
    dhds(3)*hz*v3(1)+dhds(4)*hz*v3(1);
aj(3,1) = hzdt*v3(1);
aj(1,2) = dhdr(1)*ycoord(1)+dhdr(2)*ycoord(2)+dhdr(3)*ycoord(3)+...
    dhdr(4)*ycoord(4)+dhdr(1)*hz*v3(2)+dhdr(2)*hz*v3(2)+...
    dhdr(3)*hz*v3(2)+dhdr(4)*hz*v3(2);
aj(2,2) = dhds(1)*ycoord(1)+dhds(2)*ycoord(2)+dhds(3)*ycoord(3)+...
    dhds(4)*ycoord(4)+dhds(1)*hz*v3(2)+dhds(2)*hz*v3(2)+...
    dhds(3)*hz*v3(2)+dhds(4)*hz*v3(2);
aj(3,2) = hzdt*v3(2);
aj(1,3) = dhdr(1)*zcoord(1)+dhdr(2)*zcoord(2)+dhdr(3)*zcoord(3)+...
    dhdr(4)*zcoord(4)+dhdr(1)*hz*v3(3)+dhdr(2)*hz*v3(3)+...
    dhdr(3)*hz*v3(3)+dhdr(4)*hz*v3(3);
aj(2,3) = dhds(1)*zcoord(1)+dhds(2)*zcoord(2)+dhds(3)*zcoord(3)+...
    dhds(4)*zcoord(4)+dhds(1)*hz*v3(3)+dhds(2)*hz*v3(3)+...
    dhds(3)*hz*v3(3)+dhds(4)*hz*v3(3);
aj(3,3) = hzdt*v3(3);

invJ = inv(aj);   % Jacobian 逆矩阵
detJ = det(aj);   % Jacobian 行列式值

% 形函数对物理左边的倒数

for i=1:4
    dN2xyz(1,i) = invJ(1,1)*dhdr(i)+invJ(1,2)*dhds(i);  %dN/dx
    dN2xyz(2,i) = invJ(2,1)*dhdr(i)+invJ(2,2)*dhds(i);  %dN/dy
    dN2xyz(3,i) = invJ(3,1)*dhdr(i)+invJ(3,2)*dhds(i);  %dN/dz
    dN1z(1,i) = invJ(1,3)*hzdt; % dHz/dx
    dN1z(2,i) = invJ(2,3)*hzdt; % dHz/dy
    dN1z(3,i) = invJ(3,3)*hzdt; % dHz/dx
end