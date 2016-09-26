 % ----------------圆形网格-----------------------
    if gridselection==2
        trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('请选择要分析的区域：先顺时针选取三个点作为外边界，再在内边界上选取一个点！','提示','non-modal'));
            k = 4;
            while k
                waitforbuttonpress;
                pos=get(handles.imageL,'currentpoint');
                x(5-k,1)=round(pos(1,1));
                y(5-k,1)=round(pos(1,2));
                hold on
                plot(x(5-k,1),y(5-k,1),'+g')
                k = k-1;
            end
           [grid_x_L,grid_y_L,generator_grid,trygrid] = circ_grid(left_image,x,y);
        end    
    end

    % 两点
    if gridselection==3
         trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('在图片上选取两个点作为分析对象！','提示','non-modal'));
            k = 2;
            while k
                waitforbuttonpress;
                pos=get(handles.imageL,'currentpoint');
                x(3-k,1)=round(pos(1,1));
                y(3-k,1)=round(pos(1,2));
                hold on
                plot(x(3-k,1),y(3-k,1),'+b')
                k = k-1;
            end
           [grid_x_L,grid_y_L,generator_grid,trygrid] = twop_grid(left_image,x,y);
        end    
    end

    % 线形
    if gridselection==4
         trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('请选择要分析的区域：选取两个点作为线段的两个端点！','提示','non-modal'));
            k = 2;
            while k
                waitforbuttonpress;
                pos=get(handles.imageL,'currentpoint');
                x(3-k,1)=round(pos(1,1));
                y(3-k,1)=round(pos(1,2));
                hold on
                plot(x(3-k,1),y(3-k,1),'+b')
                k = k-1;
            end
           [grid_x_L,grid_y_L,generator_grid,trygrid] = line_grid(left_image,x,y);
        end    
    end

    % 移除网格点
    if gridselection==5
         trygrid = 1;
        while trygrid
            imshow(left_image);
            hold on                         
            plot(grid_x_L, grid_y_L,'.b')
            uiwait(msgbox('请选择四个点形成一个四边形，这个四边形中间的网格点将删除！','提示','non-modal'));
            k = 4;
            while k
                waitforbuttonpress;
                pos=get(handles.imageL,'currentpoint');
                x(5-k,1)=round(pos(1,1));
                y(5-k,1)=round(pos(1,2));
                hold on
                plot(x(5-k,1),y(5-k,1),'+g')
                k = k-1;
            end
           [grid_x_L,grid_y_L,generator_grid,trygrid] = removepoints(grid_x_L,grid_y_L,left_image,x,y);
        end    
    end;
