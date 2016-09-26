function [cordin]=cord_reconstruct(grid_x_L,grid_y_L,validx_L,validy_L,grid_x_R,grid_y_R,validx_R,validy_R,T,KK_left,KK_right)

%������ÿһ��ͼ����ÿһ����������ά���꣨������������ϵΪ��������ϵ��

cordin_old_L(:,1,1) = grid_x_L(:,1);
cordin_old_L(:,2,1) = grid_y_L(:,1);
cordin_old_R(:,1,1) = grid_x_R(:,1);
cordin_old_R(:,2,1) = grid_y_R(:,1);

k=size(validx_L,2);
kk = size(validx_R,2);

% �����������ͼ���ϸ����������
for i=2:k+1
    cordin_old_L(:,1,i) = validx_L(:,i-1);       % cordin_old Ϊ��ά���󣬵���ά��ʾ����ͼƬ��������1ά��ʾ��ÿ��ͼƬ���������������ڶ�ά�Ǹ�������������
    cordin_old_L(:,2,i) = validy_L(:,i-1);
end
% �����������ͼ���ϸ����������
for i=2:kk+1
    cordin_old_R(:,1,i) = validx_R(:,i-1);
    cordin_old_R(:,2,i) = validy_R(:,i-1);
end

kkk = size(cordin_old_L,1);

% ����ƽ�в���ԭ�����ռ������
if 0
    f = KK_left(1,1);      % �������������࣬��λ���� 
    ccx_L = KK_left(1,3);      % �����������������������꣬��λ���� 
    ccy_L = KK_left(2,3);      % �����������������������꣬��λ���� 
    ccx_R = KK_right(1,3);     % �����������������������꣬��λ����
    b = abs(T(1,1)) ;   % ������߾࣬��λmm

    % -------����ÿ����Ŀռ�����
    cordin = zeros(kkk,3,kk);
    for i=1:kk+1            %ÿ��ͼ��
        for j=1:kkk         %ÿ�������
            dpx = -((cordin_old_R(j,1,i)-ccx_R)+(ccx_L-cordin_old_L(j,1,i)));  % ����õ���Ӳ�,��λ����
            cordin(j,3,i) = b*f/dpx;  % �ռ���z����
            cordin(j,1,i) = cordin(j,3,i)*(cordin_old_L(j,1,i)-ccx_L)/f;
            cordin(j,2,i) = cordin(j,3,i)*(cordin_old_L(j,2,i)-ccy_L)/f;
        end
    end
    save('cordin.mat','cordin');
end
    
if 1 
    f = KK_left(1,1);      % �������������࣬��λ���� 
    ccx_L = KK_left(1,3);      % �����������������������꣬��λ���� 
    ccy_L = KK_left(2,3);      % �����������������������꣬��λ���� 
    ccx_R = KK_right(1,3);     % �����������������������꣬��λ����
    Tx = T(1,1);                % ������߾࣬��λmm
    Q = zeros(4,4);
    Q(1,1) = 1; Q(2,2) = 1; Q(1,4) = -ccx_L; Q(2,4) = -ccy_L;
    Q(3,4) = f; Q(4,3) = -1/Tx; Q(4,4) = (ccx_L-ccx_R)/Tx;
    
    cordin = zeros(kkk,3,kk);
    x = ones(4,1);
    X = zeros(4,1);
    
    for i=1:kk+1
        for j=1:kkk
            d = cordin_old_L(j,1,i) - cordin_old_R(j,1,i);
            x(1,1) = cordin_old_L(j,1,i);
            x(2,1) = cordin_old_L(j,2,i);
            x(3,1) = d;
            X = Q*x;
            cordin(j,1,i) = X(1,1)/X(4,1);
            cordin(j,2,i) = X(2,1)/X(4,1);
            cordin(j,3,i) = X(3,1)/X(4,1);
        end
    end
end



