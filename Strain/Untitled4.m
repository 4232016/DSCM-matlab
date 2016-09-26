syms s r t real
N2(1) = 0.25 *(r-1)*(s-1);
N2(2) = -0.25 *(r+1)*(s-1);
N2(3) = 0.25 *(r+1)*(s+1);
N2(4) = -0.25 *(r-1)*(s+1);
dNdrs = [diff(N2,r,1);diff(N2,s,1)]