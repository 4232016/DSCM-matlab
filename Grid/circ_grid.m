function [grid_x_L,grid_y_L,generator_grid,trygrid] = circ_grid(left_image,x,y)

grid_x_L=[];
grid_y_L=[];

xnew=x(1:3,1);
ynew=y(1:3,1);

% Calculate center between the 3 sorted points and the normal slope of the vectors
slope12=-1/((ynew(2,1)-ynew(1,1))/(xnew(2,1)-xnew(1,1)));
slope23=-1/((ynew(3,1)-ynew(2,1))/(xnew(3,1)-xnew(2,1)));
center12(1,1)=(xnew(2,1)-xnew(1,1))/2+xnew(1,1);
center12(1,2)=(ynew(2,1)-ynew(1,1))/2+ynew(1,1);
center23(1,1)=(xnew(3,1)-xnew(2,1))/2+xnew(2,1);
center23(1,2)=(ynew(3,1)-ynew(2,1))/2+ynew(2,1);



% Calculate the crossing point of the two vectors
achsenabschnitt1=center12(1,2)-center12(1,1)*slope12;
achsenabschnitt2=center23(1,2)-center23(1,1)*slope23;
xcross=(achsenabschnitt2-achsenabschnitt1)/(slope12-slope23);
ycross=slope12*xcross+achsenabschnitt1;
plot(xcross,ycross,'or')

% Calculate radius 
R=sqrt((xcross-xnew(1,1))*(xcross-xnew(1,1))+(ycross-ynew(1,1))*(ycross-ynew(1,1)));

% Calculate angle between vectors
xvector=[1;0];
x1vec(1,1)=xnew(1,1)-xcross;x1vec(2,1)=ynew(1,1)-ycross;
x3vec(1,1)=xnew(3,1)-xcross;x3vec(2,1)=ynew(3,1)-ycross;
alpha13=acos((dot(x1vec,x3vec))/(sqrt(x1vec'*x1vec)*sqrt(x3vec'*x3vec)))*180/pi;
alpha03=acos((dot(xvector,x3vec))/(sqrt(xvector'*xvector)*sqrt(x3vec'*x3vec)))*180/pi;
totalangle=alpha13;
maxangle=alpha03;
angldiv=abs(round(totalangle))*10;
anglstep=(totalangle/angldiv);
anglall(1:angldiv+1)=maxangle+anglstep*(1:angldiv+1)-anglstep;
xcircle(1:angldiv+1)=xcross+R*cos(-anglall(1:angldiv+1)/180*pi);
ycircle(1:angldiv+1)=ycross+R*sin(-anglall(1:angldiv+1)/180*pi);
plot(xcircle,ycircle,'-b')

confirmcircselection = menu(sprintf('�Ƿ��������Բ����Ϊ��׼��'),...
    '��','��������','���ص����˵�');
    
    % No, try again
    if confirmcircselection==2
        hold off;
        generator_grid = 1;
        trygrid = 1 ; 
    end
    
    % Go back to grid-type selection
    if confirmcircselection==3
        cla;
        imshow(left_image);
        hold off;
        generator_grid = 1;
        trygrid = 0 ; 
    end

    % Yes
    if confirmcircselection==1

        prompt = {'�����Բ����������������'};
        dlg_title = '�����������';
        num_lines= 1;
        def     = {'30'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        angldiv = str2double(cell2mat(answer(1,1)));

        anglstep=(totalangle/angldiv);
        anglall(1:angldiv+1)=maxangle+anglstep*(1:angldiv+1)-anglstep;

        markerxpos(1:angldiv+1)=xcross+R*cos(-anglall(1:angldiv+1)/180*pi);
        markerypos(1:angldiv+1)=ycross+R*sin(-anglall(1:angldiv+1)/180*pi);
        
        plot(markerxpos,markerypos,'ob');
        
        lowboundx=x(4,1);
        lowboundy=y(4,1);

        R2=sqrt((xcross-lowboundx(1,1))*(xcross-lowboundx(1,1))+(ycross-lowboundy(1,1))*(ycross-lowboundy(1,1)));
        markerxposlb(1:angldiv+1)=xcross+R2*cos(-anglall(1:angldiv+1)/180*pi);
        markeryposlb(1:angldiv+1)=ycross+R2*sin(-anglall(1:angldiv+1)/180*pi);

        plot(markerxposlb,markeryposlb,'ob');
        
        prompt = {'�����ϱ߽����±߽�֮��������������'};
        dlg_title = '�����������';
        num_lines= 1;
        def     = {'5'};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        Rdiv = str2double(cell2mat(answer(1,1)));

        Rstep=((R-R2)/Rdiv);
        Rall(1:Rdiv+1)=R2+Rstep*(1:Rdiv+1)-Rstep;

        x=ones(Rdiv+1,angldiv+1)*xcross;
        y=ones(Rdiv+1,angldiv+1)*ycross;
        x=x+Rall'*cos(-anglall(1:angldiv+1)/180*pi);
        y=y+Rall'*sin(-anglall(1:angldiv+1)/180*pi);

        cla;
        imshow(left_image);
        hold on;
        plot(grid_x_L,grid_y_L,'+r')    
        plot(x,y,'.b') 
        
            % Do you want to keep/add the grid?
        confirmselection = menu(sprintf('�Ե�ǰ���������ô��'),...
        '��','��������','�ص����˵�');

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
            hold off
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
end