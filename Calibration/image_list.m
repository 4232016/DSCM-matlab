current_path = pwd;
addpath(current_path);
image_dir = uigetdir(current_path,'ѡ��궨ͼ�����ڵ��ļ���');
cd(image_dir);

l_bmp = dir('*bmp');
s_bmp = size(l_bmp,1);
l_tif = dir('*tif');
s_tif = size(l_tif,1);
l_jpg = dir('*jpg');
s_jpg = size(l_jpg,1);


s_tot = s_bmp + s_tif + s_jpg ;

if s_tot < 1,
   fprintf(1,'��ǰ·����û�� tif��bmp��jeg��ʽ��ͼƬ�������ļ�·�������ԡ�\n');
   break;
end;


dir;   % ��ʾ��ǰ·���µ������ļ�

Nima_valid = 0;

while (Nima_valid==0),

   fprintf(1,'\n');
   calib_name = input('����궨ͼ��Ļ������� (�������ֱ�źͺ�׺): ','s');
   
   format_image = '0';
   
	while format_image == '0',
   
   	format_image =  input('ͼ���ʽ: ([]=''b''=''bmp'', ''t''=''tif'', ''j''=''jpg'') ','s');
		
		if isempty(format_image),
   		format_image = 'bmp';
		end;
      
        if lower(format_image(1)) == 'b',
            format_image = 'bmp';
         else
            if lower(format_image(1)) == 't',
               format_image = 'tif';
            else
                if lower(format_image(1)) == 'j',
                   format_image = 'jpg';
                else
                    disp('��ЧͼƬ��ʽ');
                    format_image = '0'; 
                 end;
             end;
          end;
       end;     
     
   check_directory;
   
end;
