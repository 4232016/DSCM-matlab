function [validx,validy]=automate_image(grid_x,grid_y,filenamelist)


% ��ʼ������
input_points_x=grid_x;
base_points_x=grid_x;

input_points_y=grid_y;
base_points_y=grid_y;

[row,col]=size(base_points_x);              % ȷ������������
r=size(filenamelist,1);                     % ȷ��ͼ�������

validx = zeros(row,r-1);
validy = zeros(row,r-1);

firstimage=1;

for i=firstimage:(r-1)                          % ѭ����������ͼ��
        
    %tic                                        % ����ʱ��
    fprintf('��ʼ��%d ��ͼ��ƥ�䣡\n',i+1);
    base = im2double(imread(filenamelist(1,:)));            % �����׼ͼ��ͨ��Ϊ���Ϊ1��ͼ����ʱ����������仯ʱ���ܻ�������ͼ������imread��Ϊ2ά��������mean����󲻱�
    input = im2double(imread(filenamelist((i+1),:)));       % ͨ��forѭ������ʣ�µ�ͼ��
    
    input_points_for(:,1)=input_points_x;                 % reshape���Ըı�ָ���ľ�����״����Ԫ�ظ������䣬�൱�ڽ�input_points_xת���input_points_for�ĵ�1��
    input_points_for(:,2)=input_points_y;                 % ��input_points_yת���input_points_for�ĵ�2��
    base_points_for(:,1)=base_points_x;                   % ��base_points_xת���base_points_for�ĵ�1��
    base_points_for(:,2)=base_points_y;                   % ��base_points_yת���base_points_for�ĵ�2��
    input_correl(:,:)=search(input_points_for, base_points_for, input, base);           % �������������ƥ������
    input_correl_x=input_correl(:,1);                                       % X�����ƥ����
    input_correl_y=input_correl(:,2);                                       % Y�����ƥ����
    
    
    validx(:,i)=input_correl_x;                                                     % ��������
    validy(:,i)=input_correl_y;
      
    % ���� search.m ��������� base �� input
    base_points_x=grid_x;
    base_points_y=grid_y;
    input_points_x=input_correl_x;
    input_points_y=input_correl_y;
    
    cla;
    image_small = Image_pyramid(input,2);
    imshow(image_small,'InitialMagnification',100);axis on;                                                   % ����ͼ��
    hold on
    display_grid_x = grid_x/2;
    display_grid_y = grid_y/2;
    display_input_correl_x = input_correl_x/2;
    display_input_correl_y = input_correl_y/2;
    plot(display_grid_x,display_grid_y,'g+')                                                        % ��ʾ��������ʼλ��
    plot(display_input_correl_x,display_input_correl_y,'r+')                                        % ��ʾ������ʵ��λ��
    drawnow                                          
    title([' ͼ�������� ', num2str((r)),'�� ���ڴ��� ', num2str((i+1)),'��  ����������',num2str(row*col)])    % ��ʾ״̬
    drawnow
    
end   
    title('��ؼ������') 



