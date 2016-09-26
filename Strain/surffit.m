function [bcs,displ] = surffit(displ,Grid,xspacing,yspacing);

%  对位移数据进行三次样条曲面拟合

a = size(Grid,2)/2;     % a为网格点的列数
b = size(Grid,1);       % b为网格点的行数
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


