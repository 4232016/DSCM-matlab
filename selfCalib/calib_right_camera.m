
% INPUT: x_1,x_2,x_3,...: Feature locations on the images
%       X_1,X_2,X_3,...: Corresponding grid coordinates
%
% OUTPUT: 焦距fc: Camera focal length
%        光轴点坐标cc: Principal point coordinates
%        alpha_c: Skew coefficient
%        kc: Distortion coefficients
%        KK: The camera matrix (containing fc and cc)
%        omc_1,omc_2,omc_3,...: 3D rotation vectors attached to the grid positions in space
%        Tc_1,Tc_2,Tc_3,...: 3D translation vectors attached to the grid positions in space
%        Rc_1,Rc_2,Rc_3,...: 3D rotation matrices corresponding to the omc vectors
%

n_ima = 6;
nx = 1624;
ny = 1236;
f = 65;                      % 相机标称焦距，单位mm
ccd = [18 13.5];
dX = 50;
dY = 50;


 cc = [(nx-1)/2;(ny-1)/2];
 alpha_c = 0;
 est_dist = [1;1;1;1;0];
 kc = zeros(5,1);
 kc = kc .* est_dist;
 
 dx = ccd(1)/nx;
 dy = ccd(2)/ny;
 fc(1) = f/dx;
 fc(2) = f/dy;
 fc = [fc(1);fc(2)];
 
 est_aspect_ratio = 0;
 check_cond = 0;
 est_fc = [1;1]; 
 recompute_extrinsic = 1 ; 
 active_images = ones(1,n_ima);
 
 load('x.mat');
 load('XX.mat');
 
 for kk = 1:n_ima,
    x = x_r(:,:,kk);
    eval(['x_' num2str(kk) ' = x;']);
    eval(['X_' num2str(kk) ' = X_r;']); 
end;

%%% Initialization of the extrinsic parameters for global minimization:
ext_calib;



%%% Initialization of the global parameter vector:

init_param = [fc;cc;alpha_c;kc;zeros(5,1)]; 

for kk = 1:n_ima,
    eval(['omckk = omc_' num2str(kk) ';']);
    eval(['Tckk = Tc_' num2str(kk) ';']);
    init_param = [init_param; omckk ; Tckk];    
end;
 
param = init_param;
solution = param;


% Extraction of the paramters for computing the right reprojection error:

fc = solution(1:2);
cc = solution(3:4);
alpha_c = solution(5);
kc = solution(6:10);

for kk = 1:n_ima,
    
    if active_images(kk), 
        
        omckk = solution(15+6*(kk-1) + 1:15+6*(kk-1) + 3);%***   
        Tckk = solution(15+6*(kk-1) + 4:15+6*(kk-1) + 6);%*** 
        Rckk = rodrigues(omckk);
        
    else
        
        omckk = NaN*ones(3,1);   
        Tckk = NaN*ones(3,1);
        Rckk = NaN*ones(3,3);
        
    end;
    
    eval(['omc_' num2str(kk) ' = omckk;']);
    eval(['Rc_' num2str(kk) ' = Rckk;']);
    eval(['Tc_' num2str(kk) ' = Tckk;']);
    
end;



% Extraction of the final intrinsic and extrinsic paramaters:

extract_parameters;


fprintf(1,'\n\n      优化后的标定结果 (含不确定度):\n\n');
fprintf(1,'焦 距 :            fc = [ %3.5f   %3.5f ] +/- [ %3.5f   %3.5f ]\n',[fc;fc_error]);
fprintf(1,'光轴点:            cc = [ %3.5f   %3.5f ] +/- [ %3.5f   %3.5f ]\n',[cc;cc_error]);
fprintf(1,'畸变:              alpha_c = [ %3.5f ] +/- [ %3.5f  ]   => 像素坐标角度 = %3.5f +/- %3.5f degrees\n',[alpha_c;alpha_c_error],90 - atan(alpha_c)*180/pi,atan(alpha_c_error)*180/pi);
fprintf(1,'失真度:            kc = [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ] +/- [ %3.5f   %3.5f   %3.5f   %3.5f  %5.5f ]\n',[kc;kc_error]);   

saving_calib_right;
