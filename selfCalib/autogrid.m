function [grid_x_L,grid_y_L,trygrid,x_l] = autogrid(left_image,x,y,x_l,n_ima);

n = n_ima+1;
cla;
imshow(left_image);
hold on;  

grid_x_L=[];
grid_y_L=[];

x = round(x);
y = round(y);

xmin = x-50*5;
xmax = x+50*5;
ymin = y-50*5;
ymax = y+50*5;

lowerline=[xmin ymin; xmax ymin];
upperline=[xmin ymax; xmax ymax];
leftline=[xmin ymin; xmin ymax];
rightline=[xmax ymin; xmax ymax];

plot(lowerline(:,1),lowerline(:,2),'-b')
plot(upperline(:,1),upperline(:,2),'-b')
plot(leftline(:,1),leftline(:,2),'-b')
plot(rightline(:,1),rightline(:,2),'-b')

xspacing = 50;
yspacing = 50;


% Create the analysis grid and show user
[x,y] = meshgrid(xmin:xspacing:xmax,ymin:yspacing:ymax);
Grid = [x,y];
 
plot(grid_x_L,grid_y_L,'+r')
plot(x,y,'+b')


% Do you want to keep/add the grid?
confirmselection = menu(sprintf('对当前网格满意么？'),...
    '是','不，重来');

    % Yes
    if confirmselection==1
        % Save settings and grid files in the image directory for visualization/plotting later
        x=reshape(x,[],1);
        y=reshape(y,[],1);
        grid_x_L=[grid_x_L;x];
        grid_y_L=[grid_y_L;y];
        for i=1:121
            x_l(1,i,n) = grid_x_L(i);
            x_l(2,i,n) = grid_y_L(i);
        end
        %save settings.dat xspacing yspacing xmin_new xmax_new ymin_new ymax_new -ascii -tabs;
        %save grid_x_L.dat grid_x_L -ascii -tabs;
        %save grid_y_L.dat grid_y_L -ascii -tabs;
        %save ('Grid.mat','Grid','xspacing','yspacing');
         
        cla;
        imshow(left_image);
        hold on;  
        plot(grid_x_L, grid_y_L,'+r')
        hold off;
        trygrid = 0 ; 
    end;

    % No, try again
    if confirmselection==2
        hold off;
        trygrid = 1 ; 
    end;
    
end