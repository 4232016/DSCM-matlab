answer = inputdlg({'请输入文件名：'},'保存标定结果数据',1,{'Calib_Results_L'});
save_name = answer{:};

if ~exist('n_ima')|~exist('fc'),
   fprintf(1,'没有有效的标定数据。\n');
   return;
end;

if ~exist('no_image'),
    no_image = 0;
end;

if ~exist('est_alpha'),
    est_alpha = 0;
end;

if ~exist('center_optim'),
    center_optim = 1;
end;

if ~exist('est_aspect_ratio'),
    est_aspect_ratio = 1;
end;

if ~exist('est_fc');
    est_fc = [1;1]; % Set to zero if you do not want to estimate the focal length (it may be useful! believe it or not!)
end;

if exist('est_dist'),
   if length(est_dist) == 4,
      est_dist = [est_dist ; 0];
   end;
end;

if exist('kc'),
   if length(kc) == 4;
      kc = [kc;0];
   end;
end;

if ~exist('fc_error'),
   fc_error = NaN*ones(2,1);
end;

if ~exist('kc_error'),
   kc_error = NaN*ones(5,1);
end;

if ~exist('cc_error'),
   cc_error = NaN*ones(2,1);
end;

if ~exist('alpha_c_error'),
   alpha_c_error = NaN;
end;

check_active_images;

if ~exist('solution_init'), solution_init = []; end;

for kk = 1:n_ima,
   if ~exist(['dX_' num2str(kk)]), eval(['dX_' num2str(kk) '= dX;']); end;
   if ~exist(['dY_' num2str(kk)]), eval(['dY_' num2str(kk) '= dY;']); end;
end;

if ~exist('solution'),
    solution = [];
end;

if ~exist('param_list'),
   param_list = solution;
end;

if ~exist('wintx'),
   wintx = [];
   winty = [];
end;

if ~exist('dX_default'),
   dX_default = [];
   dY_default = [];
end;

if ~exist('dX'),
    dX = [];
end;
if ~exist('dY'),
    dY = dX;
end;

if ~exist('Hcal'),
    Hcal = [];
end;
if ~exist('Wcal'),
    Wcal = [];
end;
if ~exist('map'),
    map = [];
end;

if ~exist('wintx_default')|~exist('winty_default'),
    wintx_default = max(round(nx/128),round(ny/96));
    winty_default = wintx_default;
end;

if ~exist('alpha_c'),
   alpha_c = 0;
end;

if ~exist('err_std'),
    err_std = [NaN;NaN];
end;

for kk = 1:n_ima,
   if ~exist(['y_' num2str(kk)]),
   	eval(['y_' num2str(kk) ' = NaN*ones(2,1);']);
   end;
   if ~exist(['n_sq_x_' num2str(kk)]),
   	eval(['n_sq_x_' num2str(kk) ' = NaN;']);
   	eval(['n_sq_y_' num2str(kk) ' = NaN;']);
   end; 
   if ~exist(['wintx_' num2str(kk)]),
   	eval(['wintx_' num2str(kk) ' = NaN;']);
   	eval(['winty_' num2str(kk) ' = NaN;']);
   end;
   if ~exist(['Tc_' num2str(kk)]),
    eval(['Tc_' num2str(kk) ' = [NaN;NaN;NaN];']);
   end;
   if ~exist(['omc_' num2str(kk)]),
    eval(['omc_' num2str(kk) ' = [NaN;NaN;NaN];']);
    eval(['Rc_' num2str(kk) ' = NaN * ones(3,3);']);
   end;
   if ~exist(['omc_error_' num2str(kk)]),
      eval(['omc_error_' num2str(kk) ' = NaN*ones(3,1);']);
   end;
   if ~exist(['Tc_error_' num2str(kk)]),
      eval(['Tc_error_' num2str(kk) ' = NaN*ones(3,1);']);
   end;
   if ~exist(['Rc_' num2str(kk)]),
    eval(['Rc_' num2str(kk) ' = rodrigues(omc_' num2str(kk) ');']);
   end;
end;

if ~exist('small_calib_image'),
    small_calib_image = 0;
end;

if ~exist('check_cond'),
    check_cond = 1;
end;

if ~exist('MaxIter'),
    MaxIter = 30;
end;

%save_name = 'Calib_Results';

if exist([ save_name '.mat'])==2,
   % disp('警告：同名标定结果文件已经存在！');
 
        oldname = 'Calib_Results_L.mat';
        newname = 'Calib_Results_L_old.mat'; 
        status = system(['rename'  ' ' oldname  ' ' newname]);
        cont_save = 1;
else
    cont_save = 1;
end;

if cont_save,

    if exist('calib_name'),
        fprintf(1,['\n保存标定结果数据到文件 ' save_name '.mat\n']);
        string_save = ['save ' save_name ' center_optim param_list active_images ind_active est_alpha est_dist est_aspect_ratio est_fc fc kc cc alpha_c fc_error kc_error cc_error alpha_c_error  err_std ex x y solution solution_init wintx winty n_ima type_numbering N_slots small_calib_image first_num image_numbers format_image calib_name Hcal Wcal nx ny map dX_default dY_default KK inv_KK dX dY wintx_default winty_default no_image check_cond MaxIter'];
        for kk = 1:n_ima,
            string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' omc_error_' num2str(kk) ' Tc_error_' num2str(kk) ' H_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
        end;
    else
        fprintf(1,['\nSaving calibration results under ' save_name '.mat (no image version)\n']);
        string_save = ['save ' save_name ' center_optim param_list active_images ind_active est_alpha est_dist est_aspect_ratio est_fc fc kc cc alpha_c fc_error kc_error cc_error alpha_c_error err_std ex x y solution solution_init wintx winty n_ima nx ny dX_default dY_default KK inv_KK dX dY wintx_default winty_default no_image check_cond MaxIter'];
        for kk = 1:n_ima,
            string_save = [string_save ' X_' num2str(kk) ' x_' num2str(kk) ' y_' num2str(kk) ' ex_' num2str(kk) ' omc_' num2str(kk) ' Rc_' num2str(kk) ' Tc_' num2str(kk) ' omc_error_' num2str(kk) ' Tc_error_' num2str(kk) ' H_' num2str(kk) ' n_sq_x_' num2str(kk) ' n_sq_y_' num2str(kk) ' wintx_' num2str(kk) ' winty_' num2str(kk) ' dX_' num2str(kk) ' dY_' num2str(kk)];
        end;
    end;
    
    eval(string_save);
   % saving_calib_ascii;
    fprintf(1,'完成！\n');
end;
