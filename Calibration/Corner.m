% 本函数用来指导用户选取标定图像中的角点

var2fix = 'dX_default';
fixvariable;
var2fix = 'dY_default';
fixvariable;
var2fix = 'map';
fixvariable;

% 清除内存中缓存的图片
for kk = 1:3,
    if (exist(['I_' num2str(kk)])==1),
        clear(['I_' num2str(kk)]);
    end;
end;

 helpdlg('接下来由用户选取每幅标定图像的四个角点','提示');
 pause(3);

if (exist('map')~=1), map = gray(256); end;

if exist('dX'),
    dX_default = dX;
end;

if exist('dY'),
    dY_default = dY;
end;

if exist('n_sq_x'),
    n_sq_x_default = n_sq_x;
end;

if exist('n_sq_y'),
    n_sq_y_default = n_sq_y;
end;

if ~exist('dX_default')|~exist('dY_default');
    
    % Setup of JY - 3D calibration rig at Intel (new at Intel) - use units in mm to match Zhang
    dX_default = 30;
    dY_default = 30;
    
end;


if ~exist('n_sq_x_default')|~exist('n_sq_y_default'),
    n_sq_x_default = 10;
    n_sq_y_default = 10;
end;


if ~exist('wintx_default')|~exist('winty_default'),
    if ~exist('nx'),
        wintx_default = 5;
        winty_default = wintx_default;
        clear wintx winty
    else
        wintx_default = max(round(nx/128),round(ny/96));
        winty_default = wintx_default;
        clear wintx winty
    end;
end;


if ~exist('dont_ask'),
    dont_ask = 0;
end;

corner_count = 1;
while corner_count
    
    if ~dont_ask,
         answer = inputdlg('输入图像编号（0表示全部图像）','提示');
         ima_numbers = str2double(answer(1));
     else
        ima_numbers = 0;
    end;

    if ima_numbers == 0,
        ima_proc = 1:n_ima;
    else
        ima_proc = ima_numbers;
    end;


    % Useful option to add images:
    kk_first = ima_proc(1); 

    if exist(['wintx_' num2str(kk_first)])

        eval(['wintxkk = wintx_' num2str(kk_first) ';']);

        if isempty(wintxkk) | isnan(wintxkk)

            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';;
            answer = inputdlg({'X = :','Y = :'},'设置选取角点的光标点大小（像素）',1,{num2str(wintx_default),num2str(winty_default)},options);
            wintx=str2double(answer(1));
            winty=str2double(answer(2)); 
            wintx = round(wintx);
            winty = round(winty);       
            fprintf(1,'Window size = %dx%d\n',2*wintx+1,2*winty+1);       
        end
    else

            options.Resize='on';
            options.WindowStyle='normal';
            options.Interpreter='tex';;
            answer = inputdlg({'X = :','Y = :'},'设置选取角点的光标点大小（像素）',1,{num2str(wintx_default),num2str(winty_default)},options);
            wintx=str2double(answer(1));
            winty=str2double(answer(2)); 
            wintx = round(wintx);
            winty = round(winty);       
            fprintf(1,'光标大小 = %dx%d\n',2*wintx+1,2*winty+1);   
    end

    for kk = ima_proc,  
        %kk
        if ~type_numbering,   
            number_ext =  num2str(image_numbers(kk));
        else
            number_ext = sprintf(['%.' num2str(N_slots) 'd'],image_numbers(kk));
        end;

        ima_name = [calib_name  number_ext '.' format_image];

        if exist(ima_name),

            fprintf(1,'\n处理图像 %d...\n',kk);
            fprintf(1,'加载图像 %s...\n',ima_name);   

            I = double(imread(ima_name)); 

            if size(I,3)>1,
                I = 0.299 * I(:,:,1) + 0.5870 * I(:,:,2) + 0.114 * I(:,:,3);
            end;

            [ny,nx,junk] = size(I);
            Wcal = nx; % to avoid errors later
            Hcal = ny; % to avoid errors later
            %close(findobj('menubar','figure','-or','menubar','none'));
            %close all;
            close(figure(2));
            close(figure(3));
            click_ima_calib

            active_images(kk) = 1;

        else
            eval(['dX_' num2str(kk) ' = NaN;']);
            eval(['dY_' num2str(kk) ' = NaN;']);  

            eval(['wintx_' num2str(kk) ' = NaN;']);
            eval(['winty_' num2str(kk) ' = NaN;']);

            eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
            eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);

            eval(['n_sq_x_' num2str(kk) ' = NaN;']);
            eval(['n_sq_y_' num2str(kk) ' = NaN;']);
        end;
    end;

    check_active_images;

    % 解决可能的不存在变量

    for kk = 1:n_ima,
        if ~exist(['x_' num2str(kk)]),
            eval(['dX_' num2str(kk) ' = NaN;']);
            eval(['dY_' num2str(kk) ' = NaN;']);  

            eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
            eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);

            eval(['n_sq_x_' num2str(kk) ' = NaN;']);
            eval(['n_sq_y_' num2str(kk) ' = NaN;']);
        end;

        if ~exist(['wintx_' num2str(kk)]) | ~exist(['winty_' num2str(kk)]),

            eval(['wintx_' num2str(kk) ' = NaN;']);
            eval(['winty_' num2str(kk) ' = NaN;']);

        end;
    end;
      
    button = questdlg('是否继续选取图像角点？','提示','继续','取消','继续');
    if button =='继续'
        corner_count = 1;
        %close all;
        %close(findobj('menubar','figure','-or','menubar','none'));
        close(figure(2));
        close(figure(3));
    else corner_count = 0;
        %close all;
        %close(findobj('menubar','figure','-or','menubar','none'));
        close(figure(2));
        close(figure(3));
    end
end

    answer = inputdlg({'请输入文件名：'},'保存数据',1,{'calib_data_L'});
    filename = answer{:};
    string_save = ['save ' filename ' active_images ind_active wintx winty n_ima type_numbering N_slots first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default dX dY'];
  

    for kk = 1:n_ima,
        string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
    end;

    eval(string_save);

    disp('完成');