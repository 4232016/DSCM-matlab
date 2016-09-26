function [v1,v2,v3] = trans4(ecoords)
% ����4�ڵ�ǵ�Ԫ�оֲ�����

% ����ڵ�1��ڵ�2����
d1 = ecoords(2,:)-ecoords(1,:);
% ����ڵ�1��ڵ�4����
d2 = ecoords(4,:)-ecoords(1,:);

% ����V3 Ϊ���� d1 d2 �Ĳ��
v3 = cross(d1,d2);
v3 = v3/norm(v3);  % ������λ��

% ����v1 �� j ��v3�Ĳ��
if v3(2) > 0.99999  %  ���v3��Y��ƽ�У�v1��X��ƽ��
    v1(1) = [1 0 0];
else
    v1(1) = v3(3);  
    v1(2) = 0.0;
    v1(3) = -v3(1);
    v1 = v1/norm(v1);
end

% ����v2 �� v1 ��v3�Ĳ��
v2 = cross(v3,v1);
v2 = v2/norm(v2);