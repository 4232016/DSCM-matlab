current_path = pwd;
addpath(current_path);
image_dir = uigetdir(current_path,'选择标定图像所在的文件夹');
cd(image_dir);

l_bmp = dir('*bmp');
s_bmp = size(l_bmp,1);
l_tif = dir('*tif');
s_tif = size(l_tif,1);
l_jpg = dir('*jpg');
s_jpg = size(l_jpg,1);


s_tot = s_bmp + s_tif + s_jpg ;

if s_tot < 1,
   fprintf(1,'当前路径下没有 tif、bmp、jeg格式的图片，请检查文件路径并重试。\n');
   break;
end;


dir;   % 显示当前路径下的所有文件

Nima_valid = 0;

while (Nima_valid==0),

   fprintf(1,'\n');
   calib_name = input('输入标定图像的基础名称 (不带数字编号和后缀): ','s');
   
   format_image = '0';
   
	while format_image == '0',
   
   	format_image =  input('图像格式: ([]=''b''=''bmp'', ''t''=''tif'', ''j''=''jpg'') ','s');
		
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
                    disp('无效图片格式');
                    format_image = '0'; 
                 end;
             end;
          end;
       end;     
     
   check_directory;
   
end;
