 % ----------------Բ������-----------------------
    if gridselection==2
        trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('��ѡ��Ҫ������������˳ʱ��ѡȡ��������Ϊ��߽磬�����ڱ߽���ѡȡһ���㣡','��ʾ','non-modal'));
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

    % ����
    if gridselection==3
         trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('��ͼƬ��ѡȡ��������Ϊ��������','��ʾ','non-modal'));
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

    % ����
    if gridselection==4
         trygrid = 1;
        while trygrid
            imshow(left_image);
            uiwait(msgbox('��ѡ��Ҫ����������ѡȡ��������Ϊ�߶ε������˵㣡','��ʾ','non-modal'));
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

    % �Ƴ������
    if gridselection==5
         trygrid = 1;
        while trygrid
            imshow(left_image);
            hold on                         
            plot(grid_x_L, grid_y_L,'.b')
            uiwait(msgbox('��ѡ���ĸ����γ�һ���ı��Σ�����ı����м������㽫ɾ����','��ʾ','non-modal'));
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
