% go_calib_stereo.m
% Main output variables:
% om, R, T: relative rotation and translation of the right camera wrt the left camera
% fc_left, cc_left, kc_left, alpha_c_left, KK_left: New intrinsic parameters of the left camera
% fc_right, cc_right, kc_right, alpha_c_right, KK_right: New intrinsic parameters of the right camera
% Definition of the extrinsic parameters: R and om are related through the rodrigues formula (R=rodrigues(om)).
% Consider a point P of coordinates XL and XR in the left and right camera reference frames respectively.
% XL and XR are related to each other through the following rigid motion transformation:
% XR = R * XL + T
% R and T (or equivalently om and T) fully describe the relative displacement of the two cameras.




if ~exist('inconsistent_pairs_detection'),
    inconsistent_pairs_detection = 1;
end;



if inconsistent_pairs_detection,
    %- This threshold is used only to automatically identify non-consistant image pairs (set to Infinity to not reject pairs)
    threshold = 50; %1.673; %1e10; %50; 
else
    threshold = Inf;
end;


if ~exist('recompute_intrinsic_right'),
    recompute_intrinsic_right = 0;
end;


if ~exist('recompute_intrinsic_left'),
    recompute_intrinsic_left = 0;
end;

center_optim_left_st = center_optim_left;
est_alpha_left_st = est_alpha_left;
est_dist_left_st = est_dist_left;
est_fc_left_st = est_fc_left;
est_aspect_ratio_left_st = est_aspect_ratio_left; % just to fix conflicts
center_optim_right_st = center_optim_right;
est_alpha_right_st = est_alpha_right;
est_dist_right_st = est_dist_right;
est_fc_right_st = est_fc_right;
est_aspect_ratio_right_st = est_aspect_ratio_right; % just to fix conflicts

if ~recompute_intrinsic_left,
    center_optim_left_st = 0;
    est_alpha_left_st = 0;
    est_dist_left_st = zeros(5,1);
    est_fc_left_st = [0;0];
    est_aspect_ratio_left_st = 1; % just to fix conflicts
end;


if ~recompute_intrinsic_right,
    center_optim_right_st = 0;
    est_alpha_right_st = 0;
    est_dist_right_st = zeros(5,1);
    est_fc_right_st = [0;0];
    est_aspect_ratio_right_st = 1; % just to fix conflicts
end;

%- Set to zero the entries of the distortion vectors that are not attempted to be estimated.
kc_right = kc_right .* ~~est_dist_right;
kc_left = kc_left .* ~~est_dist_left;


active_images = active_images_left & active_images_right;

history = [];

fprintf(1,'\n标定图像组数量: %d\n',length(find(active_images)));
    

MaxIter = 100;
change = 1;
iter = 1;

while (change > 5e-6)&(iter <= MaxIter),
    
   
    % Jacobian:
    
    J = [];
    e = [];
    if iter == 1,
        e_ref = [];
    end;
    
    param = [fc_left;cc_left;alpha_c_left;kc_left;fc_right;cc_right;alpha_c_right;kc_right;om;T];
    
    
    for kk = 1:n_ima,
        
        if active_images(kk),
            
            % Project the structure onto the left view:
            
            eval(['Xckk = X_left_' num2str(kk) ';']);
            eval(['omckk = omc_left_' num2str(kk) ';']);
            eval(['Tckk = Tc_left_' num2str(kk) ';']);
            
            eval(['xlkk = x_left_' num2str(kk) ';']);
            eval(['xrkk = x_right_' num2str(kk) ';']);
            
            param = [param;omckk;Tckk];
            
            % number of points:
            Nckk = size(Xckk,2);
            
            
            Jkk = sparse(4*Nckk,20+(1+n_ima)*6);
            ekk = zeros(4*Nckk,1);
            
            
            if ~est_aspect_ratio_left,
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left(1),cc_left,kc_left,alpha_c_left);
                dxldfl = repmat(dxldfl,[1 2]);
            else
                [xl,dxldomckk,dxldTckk,dxldfl,dxldcl,dxldkl,dxldalphal] = project_points2(Xckk,omckk,Tckk,fc_left,cc_left,kc_left,alpha_c_left);
            end;
        
            
            ekk(1:2*Nckk) = xlkk(:) - xl(:);
            
            Jkk(1:2*Nckk,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxldomckk);
            Jkk(1:2*Nckk,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxldTckk);
            
            Jkk(1:2*Nckk,1:2) = sparse(dxldfl);
            Jkk(1:2*Nckk,3:4) = sparse(dxldcl);
            Jkk(1:2*Nckk,5) = sparse(dxldalphal);
            Jkk(1:2*Nckk,6:10) = sparse(dxldkl);
            
            
            % Project the structure onto the right view:
            
            [omr,Tr,domrdomckk,domrdTckk,domrdom,domrdT,dTrdomckk,dTrdTckk,dTrdom,dTrdT] = compose_motion(omckk,Tckk,om,T);
            
            if ~est_aspect_ratio_right,
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right(1),cc_right,kc_right,alpha_c_right);
                dxrdfr = repmat(dxrdfr,[1 2]);
            else
                [xr,dxrdomr,dxrdTr,dxrdfr,dxrdcr,dxrdkr,dxrdalphar] = project_points2(Xckk,omr,Tr,fc_right,cc_right,kc_right,alpha_c_right);
            end;
            
            
            ekk(2*Nckk+1:end) = xrkk(:) - xr(:);
            
            
            dxrdom = dxrdomr * domrdom + dxrdTr * dTrdom;
            dxrdT = dxrdomr * domrdT + dxrdTr * dTrdT;
            
            dxrdomckk = dxrdomr * domrdomckk + dxrdTr * dTrdomckk;
            dxrdTckk = dxrdomr * domrdTckk + dxrdTr * dTrdTckk;
            
            
            Jkk(2*Nckk+1:end,1+20:3+20) =  sparse(dxrdom);
            Jkk(2*Nckk+1:end,4+20:6+20) =  sparse(dxrdT);
            
            
            Jkk(2*Nckk+1:end,6*(kk-1)+7+20:6*(kk-1)+7+2+20) = sparse(dxrdomckk);
            Jkk(2*Nckk+1:end,6*(kk-1)+7+3+20:6*(kk-1)+7+5+20) = sparse(dxrdTckk);
            
            Jkk(2*Nckk+1:end,11:12) = sparse(dxrdfr);
            Jkk(2*Nckk+1:end,13:14) = sparse(dxrdcr);
            Jkk(2*Nckk+1:end,15) = sparse(dxrdalphar);
            Jkk(2*Nckk+1:end,16:20) = sparse(dxrdkr);
            
            
            emax = max(abs(ekk));
            
            if iter == 1;
                e_ref = [e_ref;ekk];
            end;
            
            
            if emax < threshold,
                
                J = [J;Jkk];
                e = [e;ekk];           
                
            else
                
                fprintf(1,'Disabling view %d - Reason: the left and right images are found inconsistent (try help calib_stereo for more information)\n',kk);
                
                active_images(kk) = 0;
                active_images_left(kk) = 0;
                active_images_right(kk) = 0;
                
            end;
            
        else
            
            param = [param;NaN*ones(6,1)];
            
        end;
        
    end;
    
    history = [history param];
    
    ind_Jac = find([est_fc_left_st & [1;est_aspect_ratio_left_st];center_optim_left_st*ones(2,1);est_alpha_left_st;est_dist_left_st;est_fc_right_st & [1;est_aspect_ratio_right_st];center_optim_right_st*ones(2,1);est_alpha_right_st;est_dist_right_st;ones(6,1);reshape(ones(6,1)*active_images,6*n_ima,1)]);
    
    ind_active = find(active_images);
    
    J = J(:,ind_Jac);
    J2 = J'*J;
    J2_inv = inv(J2);
    
    param_update = J2_inv*J'*e;
    
    
    param(ind_Jac) = param(ind_Jac) + param_update;
    
    fc_left = param(1:2);
    cc_left = param(3:4);
    alpha_c_left = param(5);
    kc_left = param(6:10);
    fc_right = param(11:12);
    cc_right = param(13:14);
    alpha_c_right = param(15);
    kc_right = param(16:20);
    
    
    if ~est_aspect_ratio_left_st,
        fc_left(2) = fc_left(1);
    end;
    if ~est_aspect_ratio_right_st,
        fc_right(2) = fc_right(1);
    end;
    
    om_old = om;
    T_old = T;
    
    om = param(1+20:3+20);
    T = param(4+20:6+20);
    
    
    for kk = 1:n_ima;
        
        if active_images(kk),
            
            omckk = param(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
            Tckk = param(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
            
            eval(['omc_left_' num2str(kk) ' = omckk;']);
            eval(['Tc_left_' num2str(kk) ' = Tckk;']);
            
        end;
        
    end;
    
    change = norm([T;om] - [T_old;om_old])/norm([T;om]);
    iter = iter + 1;
    
end;


history = [history param];

inconsistent_images = ~active_images & (active_images_left & active_images_right);


%%%--------------------------- Computation of the error of estimation:


sigma_x = std(e(:));
param_error = zeros(20 + (1+n_ima)*6,1);
param_error(ind_Jac) =  3*sqrt(full(diag(J2_inv)))*sigma_x;

for kk = 1:n_ima;
    
    if active_images(kk),
        
        omckk_error = param_error(6*(kk-1)+7+20:6*(kk-1)+7+2+20);
        Tckk = param_error(6*(kk-1)+7+3+20:6*(kk-1)+7+5+20);
        
        eval(['omc_left_error_' num2str(kk) ' = omckk;']);
        eval(['Tc_left_error_' num2str(kk) ' = Tckk;']);
        
    else
        
        eval(['omc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['omc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        eval(['Tc_left_error_' num2str(kk) ' = NaN*ones(3,1);']);
        
    end;
    
end;

fc_left_error = param_error(1:2);
cc_left_error = param_error(3:4);
alpha_c_left_error = param_error(5);
kc_left_error = param_error(6:10);
fc_right_error = param_error(11:12);
cc_right_error = param_error(13:14);
alpha_c_right_error = param_error(15);
kc_right_error = param_error(16:20);

if ~est_aspect_ratio_left_st,
    fc_left_error(2) = fc_left_error(1);
end;
if ~est_aspect_ratio_right_st,
    fc_right_error(2) = fc_right_error(1);
end;


om_error = param_error(1+20:3+20);
T_error = param_error(4+20:6+20);


KK_left = [fc_left(1) fc_left(1)*alpha_c_left cc_left(1);0 fc_left(2) cc_left(2); 0 0 1];
KK_right = [fc_right(1) fc_right(1)*alpha_c_right cc_right(1);0 fc_right(2) cc_right(2); 0 0 1];


R = rodrigues(om);

if 0
    fprintf(1,'\n\n\nStereo calibration parameters after optimization:\n');


    fprintf(1,'\n\nIntrinsic parameters of left camera:\n\n');
    fprintf(1,'Focal Length:          fc_left = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[fc_left;fc_left_error]);
    fprintf(1,'Principal point:       cc_left = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[cc_left;cc_left_error]);
    fprintf(1,'Skew:             alpha_c_left = [ %3.5f ] ?[ %3.5f  ]   => angle of pixel axes = %3.5f ?%3.5f degrees\n',[alpha_c_left;alpha_c_left_error],90 - atan(alpha_c_left)*180/pi,atan(alpha_c_left_error)*180/pi);
    fprintf(1,'Distortion:            kc_left = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ?[ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_left;kc_left_error]);   


    fprintf(1,'\n\nIntrinsic parameters of right camera:\n\n');
    fprintf(1,'Focal Length:          fc_right = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[fc_right;fc_right_error]);
    fprintf(1,'Principal point:       cc_right = [ %3.5f   %3.5f ] ?[ %3.5f   %3.5f ]\n',[cc_right;cc_right_error]);
    fprintf(1,'Skew:             alpha_c_right = [ %3.5f ] ?[ %3.5f  ]   => angle of pixel axes = %3.5f ?%3.5f degrees\n',[alpha_c_right;alpha_c_right_error],90 - atan(alpha_c_right)*180/pi,atan(alpha_c_right_error)*180/pi);
    fprintf(1,'Distortion:            kc_right = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] ?[ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc_right;kc_right_error]);   


    fprintf(1,'\n\nExtrinsic parameters (position of right camera wrt left camera):\n\n');
    fprintf(1,'Rotation vector:             om = [ %3.5f   %3.5f  %3.5f ] ?[ %3.5f   %3.5f  %3.5f ]\n',[om;om_error]);
    fprintf(1,'Translation vector:           T = [ %3.5f   %3.5f  %3.5f ] ?[ %3.5f   %3.5f  %3.5f ]\n',[T;T_error]);


    fprintf(1,'\n\nNote: The numerical errors are approximately three times the standard deviations (for reference).\n\n')
end
