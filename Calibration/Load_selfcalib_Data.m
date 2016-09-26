n_ima = 6;
nx = 1624;
ny = 1236;
dX = 50;
dY = 50;
active_images = ones(1,n_ima);

[FileName,PathName] = uigetfile({'.mat'});
current_path = pwd;
addpath(current_path);
cd(PathName);
load('x.mat');
load('XX.mat');
ind_active = find(active_images);
     
 for kk = 1:n_ima
    x = x_l(:,:,kk);
    eval(['x_' num2str(kk) ' = x;']);
    eval(['X_' num2str(kk) ' = X_l;']); 
    eval(['dX_' num2str(kk) ' = 50;']); 
    eval(['dY_' num2str(kk) ' = 50;']); 
end

 cd(current_path);