function [v1,v2,v3] = trans4(ecoords)
% 计算4节点壳单元中局部向量

% 定义节点1与节点2向量
d1 = ecoords(2,:)-ecoords(1,:);
% 定义节点1与节点4向量
d2 = ecoords(4,:)-ecoords(1,:);

% 向量V3 为向量 d1 d2 的叉积
v3 = cross(d1,d2);
v3 = v3/norm(v3);  % 向量单位化

% 向量v1 是 j 与v3的叉积
if v3(2) > 0.99999  %  如果v3与Y轴平行，v1与X轴平行
    v1(1) = [1 0 0];
else
    v1(1) = v3(3);  
    v1(2) = 0.0;
    v1(3) = -v3(1);
    v1 = v1/norm(v1);
end

% 向量v2 是 v1 与v3的叉积
v2 = cross(v3,v1);
v2 = v2/norm(v2);