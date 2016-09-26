function B =  Bs4(dN2xyz,N2,dN1z,v1,v2,thick,t)

% ����4���ǵ�Ԫ��Ӧ�����B  sigma = B u

%B = zeros(6,24);
hz = thick * 0.5 * t;

for i = 1:4
    i1 = (i-1)*6+1;
    i2 = i1+1;
    i3 = i2+1;
    i4 = i3+1;
    i5 = i4+1;
    i6 = i5+1;
    
    gk1 = dN2xyz(1,i)*hz + N2(i)*dN1z(1,i);
    gk2 = dN2xyz(2,i)*hz + N2(i)*dN1z(2,i);
    gk3 = dN2xyz(3,i)*hz + N2(i)*dN1z(3,i);
    
    B(1,i1) = dN2xyz(1,i);   %  �����x����Ӧ�������
    B(1,i4) = gk1*(-v2(1));
    B(1,i5) = gk1*(v1(1));
    B(1,i6) = 0;
    B(2,i2) = dN2xyz(2,i);   %  �����y����Ӧ�������
    B(2,i4) = gk2*(-v2(2));
    B(2,i5) = gk2*(v1(2));
    B(3,i3) = dN2xyz(3,i);   %  �����z����Ӧ�������
    B(3,i4) = gk3*(-v2(3));
    B(3,i5) = gk3*(v1(3)); 
    B(4,i1) = dN2xyz(2,i);   %  �����xy��Ӧ�������
    B(4,i2) = dN2xyz(1,i);
    B(4,i4) = gk2*(-v2(1))+gk1*(-v2(2));
    B(4,i5) = gk2*v1(1)+gk1*v1(2);
    B(5,i2) = dN2xyz(3,i);   %  �����yz��Ӧ�������
    B(5,i3) = dN2xyz(2,i);
    B(5,i4) = gk3*(-v2(2))+gk2*(-v2(3));
    B(5,i5) = gk3*v1(2)+gk2*v1(3);
    B(6,i1) = dN2xyz(3,i);   %  �����xz��Ӧ�������
    B(6,i3) = dN2xyz(1,i);
    B(6,i4) = gk3*(-v2(1))+gk1*(-v2(3));
    B(6,i5) = gk3*v1(1)+gk1*v1(3);
end