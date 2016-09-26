[calib_file_name,calib_file_path] = uigetfile({'.mat'},'ѡ������궨����Calib_Results_stereo.mat');

if ~isempty(calib_file_name),
    cd(calib_file_path);
end;

calib_data = load(calib_file_name);
 

KK_left = getfield(calib_data,'KK_left');
KK_right = getfield(calib_data,'KK_right');
kc_left = getfield(calib_data,'kc_left');
kc_right = getfield(calib_data,'kc_right');
om = getfield(calib_data,'om');
T = getfield(calib_data,'T');


 