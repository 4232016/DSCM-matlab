if exist(['wintx_' num2str(kk)]),
    eval(['wintxkk = wintx_' num2str(kk) ';']);
    if ~isempty(wintxkk) & ~isnan(wintxkk),
        eval(['wintx = wintx_' num2str(kk) ';']);
        eval(['winty = winty_' num2str(kk) ';']);        
    end;
end;

grid_success = 0;

while (~grid_success)
    
    bad_clicks = 1;

    while bad_clicks,

        figure(2); clf;
        image(I);
        colormap(map);
        axis image;
        set(2,'color',[1 1 1]);
        title(['���ѡȡ����������ĸ����޽ǵ㣨��һ����Ϊ����ԭ�㣩... Image ' num2str(kk)]);
        disp('���ѡȡ����������ĸ����޽ǵ㣨��һ����Ϊ����ԭ�㣩...');

        wintx_save = wintx;
        winty_save = winty;

        x= [];y = [];
        figure(2); hold on;
        for count = 1:4,
            [xi,yi] = ginput4(1);      % ��ȡ�û�ѡ��
            [xxi] = cornerfinder([xi;yi],I,winty,wintx); % ������Ѱ�ҽǵ�
            xi = xxi(1);
            yi = xxi(2);
            figure(2);
            plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);                %ͼ������ʾ�ǵ�����
             %��ʾ������С����
            plot(xi + [wintx+.5 -(wintx+.5) -(wintx+.5) wintx+.5 wintx+.5],yi + [winty+.5 winty+.5 -(winty+.5) -(winty+.5)  winty+.5],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
            x = [x;xi];
            y = [y;yi];
            plot(x,y,'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);    %��ʾ�����ǵ�֮�������                
            drawnow;
        end;
        plot([x;x(1)],[y;y(1)],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);       %��ʾ��һ���͵��ĸ��ǵ�֮�������
        drawnow;
        hold off;

        wintx = wintx_save;
        winty = winty_save;

        [Xc,good,bad,type] = cornerfinder([x';y'],I,winty,wintx); 

        bad_clicks = (sum(bad)>0);

    end;

    x = Xc(1,:)';
    y = Xc(2,:)';

    % �ǵ�����:
    x_mean = mean(x);  
    y_mean = mean(y);    %��ƽ��ֵ
    x_v = x - x_mean;
    y_v = y - y_mean;    %��ƽ��ֵ�Ĳ�

    theta = atan2(-y_v,x_v);   %����X��нǣ��������ޣ�
    [junk,ind] = sort(theta);   %�Լнǽ�����������

    [junk,ind] = sort(mod(theta-theta(1),2*pi));

    ind = ind([4 3 2 1]); %-> New: the Z axis is pointing uppward

    x = x(ind);
    y = y(ind);

    x1= x(1); x2 = x(2); x3 = x(3); x4 = x(4);
    y1= y(1); y2 = y(2); y3 = y(3); y4 = y(4);

    % Find center:
    p_center = cross(cross([x1;y1;1],[x3;y3;1]),cross([x2;y2;1],[x4;y4;1]));  %����
    x5 = p_center(1)/p_center(3);
    y5 = p_center(2)/p_center(3);

    % center on the X axis:
    x6 = (x3 + x4)/2;
    y6 = (y3 + y4)/2;

    % center on the Y axis:
    x7 = (x1 + x4)/2;
    y7 = (y1 + y4)/2;

    % Direction of displacement for the X axis:
    vX = [x6-x5;y6-y5];
    vX = vX / norm(vX);

    % Direction of displacement for the X axis:
    vY = [x7-x5;y7-y5];
    vY = vY / norm(vY);

    % Direction of diagonal:
    vO = [x4 - x5; y4 - y5];
    vO = vO / norm(vO);

    delta = 30;
    % ��ʾʶ�������������
    figure(2); image(I);
    axis image;
    colormap(map);
    hold on;
    plot([x;x(1)],[y;y(1)],'g-');
    plot(x,y,'og');
    hx=text(x6 + delta * vX(1) ,y6 + delta*vX(2),'X');
    set(hx,'color','g','Fontsize',14);
    hy=text(x7 + delta*vY(1), y7 + delta*vY(2),'Y');
    set(hy,'color','g','Fontsize',14);
    hO=text(x4 + delta * vO(1) ,y4 + delta*vO(2),'O','color','g','Fontsize',14);
    for iii = 1:4,
        text(x(iii),y(iii),num2str(iii));
    end;
    hold off;

    % �����Զ�ʶ����������
    n_sq_x1 = count_squares(I,x1,y1,x2,y2,wintx);
    n_sq_x2 = count_squares(I,x3,y3,x4,y4,wintx);
    n_sq_y1 = count_squares(I,x2,y2,x3,y3,wintx);
    n_sq_y2 = count_squares(I,x4,y4,x1,y1,wintx);

    % ���ʶ��ʧ�ܣ���Ҫ�����ֶ�����
    if ((n_sq_x1~=n_sq_x2)||(n_sq_y1~=n_sq_y2)||...
            (min([n_sq_x1 n_sq_x2 n_sq_y1 n_sq_y2] < 0))),
        if ((n_sq_x1~=n_sq_x2)||(n_sq_y1~=n_sq_y2)||...
                (min([n_sq_x1 n_sq_x2 n_sq_y1 n_sq_y2] < 0))),
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            answer = inputdlg({'X���򷽸�����:','Y���򷽸�����:'},'�Զ�ʶ����������ʧ�ܣ����ֶ�����',1,{num2str(n_sq_x_default),num2str(n_sq_y_default)},options);
            n_sq_x=str2double(answer(1));
            n_sq_y=str2double(answer(2)); 
            grid_success = 1;
        else
            n_sq_x = n_sq_x1;
            n_sq_y = n_sq_y1;
            grid_success = 1;
        end;
    else
        n_sq_x = n_sq_x1;
        n_sq_y = n_sq_y1;
        grid_success = 1;
    end;
    if ~grid_success
        h = helpdlg('��Ч���������ԣ�','��ʾ');
        pause(1.5);
   %     close(h);
    end;
end;

n_sq_x_default = n_sq_x;
n_sq_y_default = n_sq_y;


if (exist('dX')~=1)||(exist('dY')~=1),
    % ����ÿ������Ĵ�С
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer = inputdlg({'X���������СdX(mm):','Y���������СdY(mm):'},'����ÿ������Ĵ�С',1,{num2str(dX_default),num2str(dY_default)},options);
    dX=str2double(answer(1));
    dY=str2double(answer(2)); 
else
   str1 = 'X���������С dX =' ;
   str1 = strcat(str1,num2str(dX));
   str1 = strcat(str1,' mm');
   str2 = 'Y���������С dY =' ;
   str2 = strcat(str2,num2str(dY));
   str2 = strcat(str2,' mm');
   h = helpdlg({str1,str2,'�����Ҫ��������Ĵ�С���������dX��dY���ɣ�'},'��ʾ');
   pause(3);
 %  close(h);
end;

% �����ڲ���
a00 = [x(1);y(1);1];
a10 = [x(2);y(2);1];
a11 = [x(3);y(3);1];
a01 = [x(4);y(4);1];

% ����ƽ�湲��: (���ع淶������)
[Homo,Hnorm,inv_Hnorm] = compute_homography([a00 a10 a11 a01],[0 1 1 0;0 0 1 1;1 1 1 1]);

% ����ƽ�湲�߽��������:
x_l = ((0:n_sq_x)'*ones(1,n_sq_y+1))/n_sq_x;
y_l = (ones(n_sq_x+1,1)*(0:n_sq_y))/n_sq_y;
pts = [x_l(:) y_l(:) ones((n_sq_x+1)*(n_sq_y+1),1)]';
XX = Homo*pts;
XX = XX(1:2,:) ./ (ones(2,1)*XX(3,:));

% �γ������ľ���
W = n_sq_x*dX;
L = n_sq_y*dY;

%%%%%%%%%%%%%%%%%%%%%%%% ��Ը߶�Ť����ͼ��������ӵĴ������ %%%%%%%%%%%%%
figure(2);
hold on;
plot(XX(1,:),XX(2,:),'r+');
title('��ɫʮ�ֱ��Ӧ�÷ǳ��������̸�ǵ�');
hold off;

str1 = '���ϵͳ��ϵ�����㣨ͼ���ϵĺ�ɫʮ�֣���ʵ�ʽǵ�����Զ��';
str2 = '��Ҫ�ֶ�����һ����ʼ�ľ������ϵ��kc���������ؼ�⡣';
str3 = '��ѡ���Ƿ���Ҫ���������ؼ�⣺';
button = questdlg({str1,str2,str3},'��ʾ','��Ҫ','Ҫ','��Ҫ');

if  button =='Ҫ'
    quest_distort = ~isempty(1);
    % ���ƽ���ĳ���:
    c_g = [size(I,2);size(I,1)]/2 + .5;
    % ��֪��k_distŤ����������¼���У������
    f_g = Distor2Calib(0,[[x(1) x(2) x(4) x(3)] - c_g(1);[y(1) y(2) y(4) y(3)] - c_g(2)],1,1,4,W,L,[-W/2 W/2 W/2 -W/2;L/2 L/2 -L/2 -L/2; 0 0 0 0],100,1,1);
    f_g = mean(f_g);
    script_fit_distortion;
end

%%%%%%%%%%%%%%%%%%%%% ��Ը߶�Ť����ͼ��������ӵĳ��򵽴�Ϊֹ %%%%%%%%%%%%%

Np = (n_sq_x+1)*(n_sq_y+1);

disp('�ǵ���ȡ��...');

grid_pts = cornerfinder(XX,I,winty,wintx);   

%�������нǵ��x,y����

grid_pts = grid_pts - 1; % subtract 1 to bring the origin to (0,0) instead of (1,1) in matlab (not necessary in C)

ind_corners = [1 n_sq_x+1 (n_sq_x+1)*n_sq_y+1 (n_sq_x+1)*(n_sq_y+1)]; % index of the 4 corners
ind_orig = (n_sq_x+1)*n_sq_y + 1;
xorig = grid_pts(1,ind_orig);
yorig = grid_pts(2,ind_orig);
dxpos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig+1)]');
dypos = mean([grid_pts(:,ind_orig) grid_pts(:,ind_orig-n_sq_x-1)]');


x_box_kk = [grid_pts(1,:)-(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)+(wintx+.5);grid_pts(1,:)-(wintx+.5);grid_pts(1,:)-(wintx+.5)];
y_box_kk = [grid_pts(2,:)-(winty+.5);grid_pts(2,:)-(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)+(winty+.5);grid_pts(2,:)-(winty+.5)];


figure(3);
image(I); axis image; colormap(map); hold on;
plot(grid_pts(1,:)+1,grid_pts(2,:)+1,'r+');
plot(x_box_kk+1,y_box_kk+1,'-b');
plot(grid_pts(1,ind_corners)+1,grid_pts(2,ind_corners)+1,'mo');
plot(xorig+1,yorig+1,'*m');
h = text(xorig+delta*vO(1),yorig+delta*vO(2),'O');
set(h,'Color','m','FontSize',14);
h2 = text(dxpos(1)+delta*vX(1),dxpos(2)+delta*vX(2),'dX');
set(h2,'Color','g','FontSize',14);
h3 = text(dypos(1)+delta*vY(1),dypos(2)+delta*vY(2),'dY');
set(h3,'Color','g','FontSize',14);
xlabel('Xc (�������ϵ��)');
ylabel('Yc (�������ϵ��)');
title('��ȡ���Ľǵ�')


zoom on;
drawnow;
hold off;


Xi = reshape(([0:n_sq_x]*dX)'*ones(1,n_sq_y+1),Np,1)';
Yi = reshape(ones(n_sq_x+1,1)*[n_sq_y:-1:0]*dY,Np,1)';
Zi = zeros(1,Np);

Xgrid = [Xi;Yi;Zi];


% All the point coordinates (on the image, and in 3D) - for global optimization:

x = grid_pts;
X = Xgrid;


% Saves all the data into variables:

eval(['dX_' num2str(kk) ' = dX;']);
eval(['dY_' num2str(kk) ' = dY;']);  

eval(['wintx_' num2str(kk) ' = wintx;']);
eval(['winty_' num2str(kk) ' = winty;']);

eval(['x_' num2str(kk) ' = x;']);
eval(['X_' num2str(kk) ' = X;']);

eval(['n_sq_x_' num2str(kk) ' = n_sq_x;']);
eval(['n_sq_y_' num2str(kk) ' = n_sq_y;']);