%%% 计算所有有效标定图像的外部参数 

N_points_views = zeros(1,n_ima);
thresh_cond = 1e6;
active_images = ones(1,n_ima);
MaxIter = 30;

for kk = 1:n_ima,
        
    eval(['x_kk = x_' num2str(kk) ';']);
    eval(['X_kk = X_' num2str(kk) ';']);

    if active_images(kk),
        N_points_views(kk) = size(x_kk,2);
        [omckk,Tckk] = extrinsic_init(x_kk,X_kk,fc,cc,kc,alpha_c);
        [omckk,Tckk,Rckk,JJ_kk] = extrinsic_refine(omckk,Tckk,x_kk,X_kk,fc,cc,kc,alpha_c,20,thresh_cond);
        
        if isnan(omckk(1,1)),
            active_images(kk) = 0;
        end;
    else
        omckk = NaN*ones(3,1);
        Tckk = NaN*ones(3,1);
    end;
        
    eval(['omc_' num2str(kk) ' = omckk;']);
    eval(['Tc_' num2str(kk) ' = Tckk;']);
    
end;
