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
        title(['点击选取棋盘网格的四个极限角点（第一个点为坐标原点）... Image ' num2str(kk)]);
        disp('点击选取棋盘网格的四个极限角点（第一个点为坐标原点）...');

        wintx_save = wintx;
        winty_save = winty;

        x= [];y = [];
        figure(2); hold on;
        for count = 1:4,
            [xi,yi] = ginput4(1);      % 获取用户选择
            [xxi] = cornerfinder([xi;yi],I,winty,wintx); % 亚像素寻找角点
            xi = xxi(1);
            yi = xxi(2);
            figure(2);
            plot(xi,yi,'+','color',[ 1.000 0.314 0.510 ],'linewidth',2);                %图像上显示角点中心
             %显示正方形小格子
            plot(xi + [wintx+.5 -(wintx+.5) -(wintx+.5) wintx+.5 wintx+.5],yi + [winty+.5 winty+.5 -(winty+.5) -(winty+.5)  winty+.5],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);
            x = [x;xi];
            y = [y;yi];
            plot(x,y,'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);    %显示两个角点之间的连线                
            drawnow;
        end;
        plot([x;x(1)],[y;y(1)],'-','color',[ 1.000 0.314 0.510 ],'linewidth',2);       %显示第一个和第四个角点之间的连线
        drawnow;
        hold off;

        wintx = wintx_save;
        winty = winty_save;

        [Xc,good,bad,type] = cornerfinder([x';y'],I,winty,wintx); 

        bad_clicks = (sum(bad)>0);

    end;

    x = Xc(1,:)';
    y = Xc(2,:)';

    % 角点排序:
    x_mean = mean(x);  
    y_mean = mean(y);    %求平均值
    x_v = x - x_mean;
    y_v = y - y_mean;    %与平均值的差

    theta = atan2(-y_v,x_v);   %求与X轴夹角（第四象限）
    [junk,ind] = sort(theta);   %对夹角进行升序排序

    [junk,ind] = sort(mod(theta-theta(1),2*pi));

    ind = ind([4 3 2 1]); %-> New: the Z axis is pointing uppward

    x = x(ind);
    y = y(ind);

    x1= x(1); x2 = x(2); x3 = x(3); x4 = x(4);
    y1= y(1); y2 = y(2); y3 = y(3); y4 = y(4);

    % Find center:
    p_center = cross(cross([x1;y1;1],[x3;y3;1]),cross([x2;y2;1],[x4;y4;1]));  %求叉积
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
    % 显示识别出的棋盘网格
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

    % 尝试自动识别棋盘网格
    n_sq_x1 = count_squares(I,x1,y1,x2,y2,wintx);
    n_sq_x2 = count_squares(I,x3,y3,x4,y4,wintx);
    n_sq_y1 = count_squares(I,x2,y2,x3,y3,wintx);
    n_sq_y2 = count_squares(I,x4,y4,x1,y1,wintx);

    % 如果识别失败，需要进行手动输入
    if ((n_sq_x1~=n_sq_x2)||(n_sq_y1~=n_sq_y2)||...
            (min([n_sq_x1 n_sq_x2 n_sq_y1 n_sq_y2] < 0))),
        if ((n_sq_x1~=n_sq_x2)||(n_sq_y1~=n_sq_y2)||...
                (min([n_sq_x1 n_sq_x2 n_sq_y1 n_sq_y2] < 0))),
            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';
            answer = inputdlg({'X方向方格数量:','Y方向方格数量:'},'自动识别棋盘网格失败，请手动输入',1,{num2str(n_sq_x_default),num2str(n_sq_y_default)},options);
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
        h = helpdlg('无效网格，请重试！','提示');
        pause(1.5);
   %     close(h);
    end;
end;

n_sq_x_default = n_sq_x;
n_sq_y_default = n_sq_y;


if (exist('dX')~=1)||(exist('dY')~=1),
    % 输入每个网格的大小
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    answer = inputdlg({'X方向网格大小dX(mm):','Y方向网格大小dY(mm):'},'输入每个网格的大小',1,{num2str(dX_default),num2str(dY_default)},options);
    dX=str2double(answer(1));
    dY=str2double(answer(2)); 
else
   str1 = 'X方向网格大小 dX =' ;
   str1 = strcat(str1,num2str(dX));
   str1 = strcat(str1,' mm');
   str2 = 'Y方向网格大小 dY =' ;
   str2 = strcat(str2,num2str(dY));
   str2 = strcat(str2,' mm');
   h = helpdlg({str1,str2,'如果需要重置网格的大小，清除变量dX和dY即可！'},'提示');
   pause(3);
 %  close(h);
end;

% 计算内部点
a00 = [x(1);y(1);1];
a10 = [x(2);y(2);1];
a11 = [x(3);y(3);1];
a01 = [x(4);y(4);1];

% 计算平面共线: (返回规范化矩阵)
[Homo,Hnorm,inv_Hnorm] = compute_homography([a00 a10 a11 a01],[0 1 1 0;0 0 1 1;1 1 1 1]);

% 利用平面共线建立网格点:
x_l = ((0:n_sq_x)'*ones(1,n_sq_y+1))/n_sq_x;
y_l = (ones(n_sq_x+1,1)*(0:n_sq_y))/n_sq_y;
pts = [x_l(:) y_l(:) ones((n_sq_x+1)*(n_sq_y+1),1)]';
XX = Homo*pts;
XX = XX(1:2,:) ./ (ones(2,1)*XX(3,:));

% 形成完整的矩阵
W = n_sq_x*dX;
L = n_sq_y*dY;

%%%%%%%%%%%%%%%%%%%%%%%% 针对高度扭曲的图像额外增加的处理程序 %%%%%%%%%%%%%
figure(2);
hold on;
plot(XX(1,:),XX(2,:),'r+');
title('红色十字标记应该非常靠近棋盘格角点');
hold off;

str1 = '如果系统拟合的网格点（图像上的红色十字）与实际角点距离较远，';
str2 = '需要手动输入一个初始的径向畸变系数kc用于亚像素检测。';
str3 = '请选择是否需要进行亚像素检测：';
button = questdlg({str1,str2,str3},'提示','不要','要','不要');

if  button =='要'
    quest_distort = ~isempty(1);
    % 估计焦距的长度:
    c_g = [size(I,2);size(I,1)]/2 + .5;
    % 在知道k_dist扭曲因素情况下计算校正参数
    f_g = Distor2Calib(0,[[x(1) x(2) x(4) x(3)] - c_g(1);[y(1) y(2) y(4) y(3)] - c_g(2)],1,1,4,W,L,[-W/2 W/2 W/2 -W/2;L/2 L/2 -L/2 -L/2; 0 0 0 0],100,1,1);
    f_g = mean(f_g);
    script_fit_distortion;
end

%%%%%%%%%%%%%%%%%%%%% 针对高度扭曲的图像额外增加的程序到此为止 %%%%%%%%%%%%%

Np = (n_sq_x+1)*(n_sq_y+1);

disp('角点提取中...');

grid_pts = cornerfinder(XX,I,winty,wintx);   

%保存所有角点的x,y坐标

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
xlabel('Xc (相机坐标系下)');
ylabel('Yc (相机坐标系下)');
title('提取出的角点')


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