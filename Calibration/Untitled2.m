[calib_file_name_left,calib_file_path_left] = uigetfile({'.mat'},'选择左相机标定数据');
data_dir = uigetdir(current_path,'选择标定数据所在的文件夹');
cd(data_dir);
dir('*mat');