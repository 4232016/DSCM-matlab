dis = [0,1,3,5;0,1,3,5;0,1,3,5];
x = [0,30,60,90];
y = [0,30,60];
dis = dis';
X = {x,y};
 bcs_tex = csapi({x,y},dis);
 figure(1)
 fnplt(bcs_tex);
 figure(2)
a =fndir(bcs_tex,[1;0]);
fnplt(a);
figure(3)
b = fndir(bcs_tex,[0;1]);
fnplt(b);