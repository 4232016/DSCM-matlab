function [bcs,displ] = surffit(displ,Grid,xspacing,yspacing);

%  ��λ�����ݽ������������������

a = size(Grid,2)/2;     % aΪ����������
b = size(Grid,1);       % bΪ����������
xmax = a*xspacing-1;
ymax = b*yspacing-1;
x = 0:xspacing:xmax ;
y = 0:yspacing:ymax ;

k = size(displ,3);
for i=1:k
    z = displ(:,:,i);
    z = z';
    bcs(i) = csapi({x,y},z);
end
for


