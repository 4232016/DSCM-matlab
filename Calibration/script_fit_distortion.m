
      satis_distort = 0;
      
      disp(['���ƽ���Ϊ: ' num2str(f_g) ' ����']);
      
      while ~satis_distort,

	 answer = inputdlg('������ʧ���kc  [-1,1] ��','����ʧ���',1,{'0'});
	 k_g = str2num(answer{1});
     
	 if isempty(k_g), k_g = 0; end;
      
	 xy_corners_undist = comp_distortion2([x' - c_g(1);y'-c_g(2)]/f_g,k_g);
	 
	 xu = xy_corners_undist(1,:)';
	 yu = xy_corners_undist(2,:)';
	 
	 [XXu] = projectedGrid ( [xu(1);yu(1)], [xu(2);yu(2)],[xu(3);yu(3)], [xu(4);yu(4)],n_sq_x+1,n_sq_y+1); % The full grid
	 
	 XX = (ones(2,1)*(1 + k_g * sum(XXu.^2))) .* XXu;
	 XX(1,:) = f_g*XX(1,:)+c_g(1);
	 XX(2,:) = f_g*XX(2,:)+c_g(2);
	 
	 figure(2);
	 image(I);
	 colormap(map);
	 zoom on;
	 hold on;
	 %plot(f_g*XXu(1,:)+c_g(1),f_g*XXu(2,:)+c_g(2),'ro');
	 plot(XX(1,:),XX(2,:),'r+');
	 title('��ɫʮ��Ӧ������������ǵ�ӽ�...');
	 hold off;
	 
     
     answer = inputdlg('��ʧ������������ô����0��������  ���������⣩','��ʾ',1,{'0'});
	 answer1 = str2num(answer{1}); 
	 satis_distort = ~isequal(answer1,0);
     
      end;
      