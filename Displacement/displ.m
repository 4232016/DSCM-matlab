function [displx,disply,displz] = displ(cordin,Grid)

% ����ÿ��ͼ��ÿ��������λ�ƣ�x,y,z 3������ģ�

A = cordin;
a = size(Grid,2)/2;     % aΪ����������
b = size(Grid,1);       % bΪ����������
xspacing = 2*(Grid(1,2)-Grid(1,1));  % x���������ļ��
yspacing = 2*(Grid(2,a+1)-Grid(1,a+1));  % x���������ļ��


n_ima = size(A,3);   % ͼ������


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

[bcs_x,displx] = surffit(displx,Grid,xspacing,yspacing);   % ��X����λ�ƽ������������������
[bcs_y] = surffit(disply,Grid,xspacing,yspacing);   % ��Y����λ�ƽ������������������
[bcs_z] = surffit(displz,Grid,xspacing,yspacing);   % ��Z����λ�ƽ������������������


