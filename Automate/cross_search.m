 %  ��ʼʮ������ 
   keep_search = 1;
   counter =1;
   initial_y = rects_fixed(icp,2);
   max_xy = 0;
  
   while keep_search
       if mod(counter,2) == 1   % ����������Ҳ��������X+����
           for i = 0:new_n
               rects(1,1) = i;
               rects(1,2) = initial_y;
               rects(1,3) = nt;
               rects(1,4) = mt;
               A = imcrop(sub_moving,rects);  
               norm_cross_corr(counter,i+1) = confi_corr(sub_fixed,A);    % �������ϵ��
           end
       else                    %  ����������Ҳ��������Y+����
           for i = 0:new_m
               rects(1,1) = ind-1;
               rects(1,2) = i;
               rects(1,3) = nt;
               rects(1,4) = mt;
               A = imcrop(sub_moving,rects);  
               norm_cross_corr(counter,i+1) = confi_corr(sub_fixed,A);    % �������ϵ��
           end
       end
       % �ҳ�����ֵ����λ��
       ind = find(norm_cross_corr(counter,:)==(max(norm_cross_corr(counter,:))), 1);
       max_xy_new = norm_cross_corr(counter,ind);
       % �Ƚ��Ƿ���Ҫ��ʼ��һ������
        if max_xy_new <= max_xy
           keep_search = 0;
           if mod(counter,2) == 1
               ypeak = rects(1,2)-rects_fixed(icp,2);
               xpeak = ind -1-rects_fixed(icp,1);
           else
               ypeak = ind-1-rects_fixed(icp,2);
               xpeak = rects(1,1)-rects_fixed(icp,1);
           end
           break;
        else 
           initial_y = ind-1;
           keep_search = 1;
           counter = counter+1;
           max_xy = max_xy_new;
        end
   end