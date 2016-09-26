 %  开始十字搜索 
   keep_search = 1;
   counter =1;
   initial_y = rects_fixed(icp,2);
   max_xy = 0;
  
   while keep_search
       if mod(counter,2) == 1   % 横向搜索，也就是沿着X+方向
           for i = 0:new_n
               rects(1,1) = i;
               rects(1,2) = initial_y;
               rects(1,3) = nt;
               rects(1,4) = mt;
               A = imcrop(sub_moving,rects);  
               norm_cross_corr(counter,i+1) = confi_corr(sub_fixed,A);    % 计算相关系数
           end
       else                    %  纵向搜索，也就是沿着Y+方向
           for i = 0:new_m
               rects(1,1) = ind-1;
               rects(1,2) = i;
               rects(1,3) = nt;
               rects(1,4) = mt;
               A = imcrop(sub_moving,rects);  
               norm_cross_corr(counter,i+1) = confi_corr(sub_fixed,A);    % 计算相关系数
           end
       end
       % 找出极大值所在位置
       ind = find(norm_cross_corr(counter,:)==(max(norm_cross_corr(counter,:))), 1);
       max_xy_new = norm_cross_corr(counter,ind);
       % 比较是否需要开始下一次搜索
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