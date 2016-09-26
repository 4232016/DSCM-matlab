function [grid_x_L,grid_y_L,generator_grid,trygrid] = line_grid(left_image,x,y)

grid_x_L = [];
grid_y_L = [];

lineslope=(y(2,1)-y(1,1))/(x(2,1)-x(1,1));
intersecty=y(1,1)-lineslope*x(1,1);
ycalc=zeros(2,1);
ycalc=lineslope*x+intersecty;
plot(x(:,1),ycalc(:,1),'-b')


prompt = {'输入两点之间网格点数量：'};
dlg_title = '输入网格参数';
num_lines= 1;
def     = {'30'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
linediv = str2num(cell2mat(answer(1,1)));
linestep=((max(x)-min(x))/linediv);
x(1:linediv+1)=min(x)+linestep*(1:linediv+1)-linestep;
y=lineslope*x+intersecty;

plot(x,y,'ob')

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