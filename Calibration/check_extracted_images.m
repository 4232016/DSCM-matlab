check_active_images;

for kk =  ind_active,
   
   if ~exist(['x_' num2str(kk)]),
      
      fprintf(1,'����: ��%d��ͼ����Ҫѡȡ��������ǵ�\n',kk);
      
      active_images(kk) = 0;
      
      eval(['dX_' num2str(kk) ' = NaN;']);
      eval(['dY_' num2str(kk) ' = NaN;']);  
      
      eval(['wintx_' num2str(kk) ' = NaN;']);
      eval(['winty_' num2str(kk) ' = NaN;']);

      eval(['x_' num2str(kk) ' = NaN*ones(2,1);']);
      eval(['X_' num2str(kk) ' = NaN*ones(3,1);']);
      
      eval(['n_sq_x_' num2str(kk) ' = NaN;']);
      eval(['n_sq_y_' num2str(kk) ' = NaN;']);
   
   else
      
      eval(['xkk = x_' num2str(kk) ';']);
      
      if isnan(xkk(1)),
	 
	 fprintf(1,'����: ͼ��%d��Ҫѡȡ��������ǵ� - ���ͼ���ѱ�����Ϊ������\n',kk);

	 active_images(kk) = 0;
	 
      end;
      
   end;
   
end;
