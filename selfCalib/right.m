function [grid_x_R,grid_y_R,x_r] = right(grid_x_L,grid_y_L,left_image,right_image,x_r,n_ima)

n = n_ima+1;

input_points_x=grid_x_L;         %����������grid_x_L��ֵ��input_points_x  base_points_x
base_points_x=grid_x_L;
input_points_y=grid_y_L;         %����������grid_y_L��ֵ��input_points_y  base_points_y
base_points_y=grid_y_L;

base = uint8(mean(double(left_image),3));            % �����������׼ͼ��
input = uint8(mean(double(right_image),3));          % �����������׼ͼ��
input_points_for(:,1)=reshape(input_points_x,[],1);                 %reshape���Ըı�ָ���ľ�����״����Ԫ�ظ������䣬�൱�ڽ�input_points_xת���input_points_for�ĵ�1��
input_points_for(:,2)=reshape(input_points_y,[],1);                 %��input_points_yת���input_points_for�ĵ�2��
base_points_for(:,1)=reshape(base_points_x,[],1);                   %��base_points_xת���base_points_for�ĵ�1��
base_points_for(:,2)=reshape(base_points_y,[],1);                   %��base_points_yת���base_points_for�ĵ�2��
input_correl(:,:)=cpcorr(input_points_for,base_points_for,input, base);    % ��һ������������㣬��ø�ͼ���������Ƶ�
input_correl_x=input_correl(:,1);                                   % the results we get from cpcorr for the x-direction
input_correl_y=input_correl(:,2);                                   % the results we get from cpcorr for the y-direction
grid_x_R=input_correl_x;                                         % lets save the data

grid_y_R=input_correl_y;
 for i=1:121
        x_r(1,i,n) = grid_x_R(i);
        x_r(2,i,n) = grid_y_R(i);
    end
%save grid_x_R.dat grid_x_R -ascii -tabs   
%save grid_y_R.dat grid_y_R -ascii -tabs

end