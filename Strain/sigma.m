function [sigma_i] = sigma(B,uk)

     for j=1:4
        aa = [];
        Be = [];
        if j==1
            Be = B(:,1:6);
            aa = Be*uk(:,1);
            s=-1;
            r=-1;
            t=1;
            bb = double(subs(aa));
        end
        
       if j==2
        Be = B(:,7:12);
        aa = Be*uk(:,3);
        s=-1;
        r=1;
        t=1;
        bb = double(subs(aa));
       end
        
      if j==3
        Be = B(:,13:18);
        aa = Be*uk(:,3);
        s=1;
        r=1;
        t=1;
        bb = double(subs(aa));
      end

      if j==4
        Be = B(:,19:24);
        aa = Be*uk(:,4);
        s=1;
        r=-1;
        t=1;
        bb = double(subs(aa));
      end
              
        for k=1:6
            sigma_i(j,k) = bb(k);
        end
    end