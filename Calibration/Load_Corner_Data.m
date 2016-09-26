button = questdlg('是否加载已有标定图像角点数据？','选择数据','加载','重新选择角点','加载');
 if button == '加载'
     [FileName,PathName] = uigetfile({'.mat'});
     current_path = pwd;
     addpath(current_path);
     cd(PathName);
     calib_data = load(FileName);
     n_ima = getfield(calib_data,'n_ima');
     active_images = getfield(calib_data,'active_images');
     map = getfield(calib_data,'map');
     dX_default = getfield(calib_data,'dX_default');
     dY_default = getfield(calib_data,'dY_default');
     calib_name = getfield(calib_data,'calib_name');
     format_image = getfield(calib_data,'format_image');
     first_num = getfield(calib_data,'first_num');
     image_numbers = getfield(calib_data,'image_numbers');
     N_slots = getfield(calib_data,'N_slots');
     type_numbering = getfield(calib_data,'type_numbering');
     Hcal = getfield(calib_data,'Hcal');
     Wcal = getfield(calib_data,'Wcal');
     ny = getfield(calib_data,'ny');
     nx = getfield(calib_data,'nx');
     wintx = getfield(calib_data,'wintx');
     winty = getfield(calib_data,'winty');
     dX = getfield(calib_data,'dX');
     dY = getfield(calib_data,'dY');
     
     ind_active = find(active_images);
     
     for kk = ind_active
         
          str = ['dX_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['dX_' num2str(kk) ' =a;']);
          
          str = ['dY_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['dY_' num2str(kk) ' =a;']);
          
          str = ['wintx_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['wintx_' num2str(kk) ' =a;']);
          
          str = ['winty_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['winty_' num2str(kk) ' =a;']);
      
          str = ['x_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['x_' num2str(kk) ' =a;']);
          
          str = ['X_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['X_' num2str(kk) ' =a;']);

          str = ['n_sq_x_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['n_sq_x_' num2str(kk) ' =a;']);
          
          str = ['n_sq_y_' num2str(kk)];
          str2 = load(FileName,str);
          a = getfield(str2,str);
          eval(['n_sq_y_' num2str(kk) ' =a;']);

     end
 end
 