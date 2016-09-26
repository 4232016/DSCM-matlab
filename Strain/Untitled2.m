a = 80 ;
b = 30;
thick = 1;
load('displacement.mat');
load('Grid.mat');
load('cordin.mat');
[bcs_z] = surffit(displz,Grid,xspacing,yspacing);   % ��Z����λ�ƽ������������������

%  �����κ���
syms s r t real
N2(1) = 0.25 *(r-1)*(s-1);
N2(2) = -0.25 *(r+1)*(s-1);
N2(3) = 0.25 *(r+1)*(s+1);
N2(4) = -0.25 *(r-1)*(s+1);
dNdrs = [diff(N2,r,1);diff(N2,s,1)];

NElems = (a-1)*(b-1);          %  �Ľڵ�ǵ�Ԫ������

%  ������Ԫ��ڵ��ž���
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

ecor = cordin(:,:,1);    %  ���ڵ�����

    ecoords = [];
    B = [];
    uk = zeros(6,4);
    for j =1:4
        nod = Elems(1,j);
        ecoords(j,:) = ecor(nod,:);
        X(1,1) = ecoords(j,1);
        X(2,1) = ecoords(j,2);
        uk(1,j) = cordin(nod,1,2)-cordin(nod,1,1);
        uk(2,j) = cordin(nod,2,2)-cordin(nod,2,1);
        uk(3,j) = cordin(nod,3,2)-cordin(nod,3,1);
        uk(4,j) = fnval(fndir(bcs_z(1),[1;0]),X);
        uk(5,j) = fnval(fndir(bcs_z(1),[0;1]),X);
    end
    [v1,v2,v3] = trans4(ecoords);   % ���㵥λ���� v1 v2 v3
    [dN2xyz,dN1z] = Jacobians4(dNdrs,ecoords,v3,thick,t); % �����ſɱȾ���
    B = Bs4(dN2xyz,N2,dN1z,v1,v2,thick,t);  %  ����B����
    
     % ����ÿһ��������ĸ�����Ӧ��
    [sigma_i] = sigma(B,uk);

  

    