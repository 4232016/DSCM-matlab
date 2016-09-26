function [grid_x_L,grid_y_L,generator_grid,trygrid] = twop_grid(left_image,x,y)

grid_x_L=[];
grid_y_L=[];

% Do you want to keep/add the grid?
confirmselection = menu(sprintf('对当前网格满意么？'),...
    '是','不，重来','回到主菜单');

    % Yes
    if confirmselection==1
        % Save settings and grid files in the image directory for visualization/plotting later
        x=reshape(x,[],1);
        y=reshape(y,[],1);
        grid_x_L=[grid_x_L;x];
        grid_y_L=[grid_y_L;y];
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

    % No, try again
    if confirmselection==2
        hold off;
        generator_grid = 1;
        trygrid = 1 ; 
    end
    
    % Go back to Main Menu
    if confirmselection==3
        cla;
        imshow(left_image);
        hold off;
        generator_grid = 1;
        trygrid = 0 ; 
    end
end