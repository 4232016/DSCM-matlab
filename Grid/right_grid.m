function [grid_x_R,grid_y_R] = right_grid(grid_x_L,grid_y_L,left_image,right_image,file_path,Grid)


input_points_x=grid_x_L;         %����������grid_x_L��ֵ��input_points_x  base_points_x
base_points_x=grid_x_L;
input_points_y=grid_y_L;         %����������grid_y_L��ֵ��input_points_y  base_points_y
base_points_y=grid_y_L;


base =double(left_image);            % �����������׼ͼ��
input = double(right_image);          % �����������׼ͼ��
input_points_for(:,1)=input_points_x;                 %reshape���Ըı�ָ���ľ�����״����Ԫ�ظ������䣬�൱�ڽ�input_points_xת���input_points_for�ĵ�1��
input_points_for(:,2)=input_points_y;                 %��input_points_yת���input_points_for�ĵ�2��
base_points_for(:,1)=base_points_x;                   %��base_points_xת���base_points_for�ĵ�1��
base_points_for(:,2)=base_points_y;                   %��base_points_yת���base_points_for�ĵ�2��
input_correl(:,:)=line_cpcorr(input_points_for,base_points_for,input, base,Grid);    % ��һ������������㣬��ø�ͼ���������Ƶ�
input_correl_x=input_correl(:,1);                                   % the results we get from cpcorr for the x-direction
input_correl_y=input_correl(:,2);                                   % the results we get from cpcorr for the y-direction
  

grid_x_R=input_correl_x;                                         % lets save the data
grid_y_R=input_correl_y;

cd(file_path);   
save grid_x_R.dat grid_x_R -ascii -tabs   
save grid_y_R.dat grid_y_R -ascii -tabs

end