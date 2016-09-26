function [grid_x_L,grid_y_L,generator_grid,trygrid] = removepoints(grid_x_L,grid_y_L,left_image,x,y)

grid_xtemp=grid_x_L;
grid_ytemp=grid_y_L;

deletepoints=find(grid_x_L>min(x) & grid_x_L<max(x) & grid_y_L<max(y) & grid_y_L>min(y));

grid_xtemp(deletepoints,:)=[];
grid_ytemp(deletepoints,:)=[];

plot(grid_xtemp, grid_ytemp,'ob');
hold off,


% delete point permanently?
keepchanges = menu(sprintf('你确定要永久删除这些网格点么？'),'确定','取消');
if keepchanges==1
    grid_x_L=grid_xtemp;
    grid_y_L=grid_ytemp;
    save grid_x_L.dat grid_x_L -ascii -tabs
    save grid_y_L.dat grid_y_L -ascii -tabs
    cla;
    imshow(left_image);
    hold on;                         
    plot(grid_x_L, grid_y_L,'+r')
    hold off;
    generator_grid = 1;
    trygrid = 0 ; 
end

if keepchanges==2
    cla;
    imshow(left_image);
    hold on;                         
    plot(grid_x_L, grid_y_L,'+r')
    hold off;
    generator_grid = 1;
    trygrid = 0 ; 
end

end