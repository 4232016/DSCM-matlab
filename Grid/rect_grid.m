function [grid_x_L,grid_y_L,generator_grid,trygrid,Grid] = rect_grid(left_image_small,x,y,file_path)

grid_x_L=[];
grid_y_L=[];

xmin = min(x);
xmax = max(x);
ymin = min(y);
ymax = max(y);

lowerline=[xmin ymin; xmax ymin];
upperline=[xmin ymax; xmax ymax];
leftline=[xmin ymin; xmin ymax];
rightline=[xmax ymin; xmax ymax];

plot(lowerline(:,1),lowerline(:,2),'-b')
plot(upperline(:,1),upperline(:,2),'-b')
plot(leftline(:,1),leftline(:,2),'-b')
plot(rightline(:,1),rightline(:,2),'-b')


prompt = {'输入网格的水平方向（x）间距 [像素]：', ...
    '输入网格的竖直方向（y）间距 [像素]：'};
dlg_title = '输入网格参数';
num_lines= 1;
def     = {'32','32'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
xspacing = str2double(cell2mat(answer(1,1)));
yspacing = str2double(cell2mat(answer(2,1)));


numXelem = ceil((xmax-xmin)/xspacing)-1;
numYelem = ceil((ymax-ymin)/yspacing)-1;

xmin_new = ceil((xmax+xmin)/2-((numXelem/2)*xspacing));
xmax_new = xmin_new + (numXelem*xspacing);
ymin_new = ceil((ymax+ymin)/2-((numYelem/2)*yspacing));
ymax_new = ymin_new + (numYelem*yspacing);

[x,y] = meshgrid(xmin_new:xspacing:xmax_new,ymin_new:yspacing:ymax_new);
Grid = [x,y];
 
cla;
imshow(left_image_small,'InitialMagnification',100);axis on;
hold on;
plot(grid_x_L,grid_y_L,'+r')
plot(x,y,'+b')



confirmselection = menu(sprintf('对当前网格满意么？'),...
    '是','不，重来','回到主菜单');

  
    if confirmselection==1
        
        x=reshape(x,[],1);
        y=reshape(y,[],1);
        grid_x_L=[grid_x_L;x];
        grid_y_L=[grid_y_L;y];
        cd(file_path);
        
       % 显示最终的网格
        cla;
        imshow(left_image_small,'InitialMagnification',100);axis on;
        hold on;                         
        plot(grid_x_L, grid_y_L,'+r')
        hold off;
        
       % 保存网格数据
        grid_x_L = grid_x_L*2;
        grid_y_L = grid_y_L*2;
        xspacing = 2*xspacing;
        yspacing = 2*yspacing;
        save grid_x_L.dat grid_x_L -ascii -tabs;
        save grid_y_L.dat grid_y_L -ascii -tabs;
        save ('Grid.mat','Grid','xspacing','yspacing');
        generator_grid = 1;
        trygrid = 0 ; 
    end;

    % No, try again
    if confirmselection==2
        hold off;
        generator_grid = 1;
        trygrid = 1 ; 
    end;
    
    % Go back to Main Menu
    if confirmselection==3
        cla;
        imshow(left_image_small,'InitialMagnification',100);axis on;
        hold off;
        generator_grid = 1;
        trygrid = 0 ; 
    end;
end