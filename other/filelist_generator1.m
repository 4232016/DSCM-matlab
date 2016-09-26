function [FileNameBase,PathNameBase,filenamelist]=filelist_generator

% 建立文件名列表的代码
% Code to construct a list of 9999 or less filenames
% Programmed by Rob, changed by Chris. Automatic filelist generation 
% and image time aquisition added by Chris.
% Last revision: 12/25/06

filenamelistmode = menu(sprintf('How do you want to create the filenamelist?'),...           %弹出菜单，用户选择创建列表的方式
    'Manually','Automatically','Cancel');
if filenamelistmode==3                                                                       %取消选择
    return
end
if filenamelistmode==2                                                                       %自动方式创建
    [FileNameBase,PathNameBase,filenamelist]=automatically;
end
if filenamelistmode==1                                                                       %手动方式创建
    [FileNameBase,PathNameBase,filenamelist]=manually;
end

[FileNameBase,PathNameBase,filenamelist]=imagetime(FileNameBase,PathNameBase,filenamelist);

%  -------------------------------------------------------

function [Firstimagename,ImageFolder,filenamelist]=automatically

% 自动方式创建文件名列表函数

[Firstimagename ImageFolder]=uigetfile('*.BMP','Open First Image');                       %弹出对话框显示选取图像界面，获取图像名称和路径
if ~isempty(Firstimagename);                                                              %假如文件名不为空时，if成立
    cd(ImageFolder);                                                                      %改变当前工作路径到图像所在文件夹
end

if Firstimagename~~[];
    % Get the number of image name
    letters=isletter(Firstimagename);                              %查看文件名是否是字母表中的字符
    Pointposition=findstr(Firstimagename,'.');                     %定位“.”的位置
    Firstimagenamesize=size(Firstimagename);                       %文件名长短
    counter=Pointposition-1;                                       %计数器指向“.”前一个字符的位置
    counterpos=1;                                                  %文件名长度计数器（不包括“.”后的字符）
    letterstest=0;                                                 %定义while循环初始值
    while letterstest==0                                           %从“.”前一个字符开始辨认，直到图像名的第一个字符
        letterstest=letters(counter);                              %此处等同于letterstest=isletter(Firstimagename(counter))
        if letterstest==1                                          %若这个字符是字母，则程序结束while循环
            break
        end
        Numberpos(counterpos)=counter;                             %Numberpos为一维数组，其第counterpos个元素的值为counter
        counter=counter-1;                                         %counter减1，继续校验前一个字符
        counterpos=counterpos+1;                                   %图片名长度计数器+1
        if counter==0                                              %校验完所有字符，退出while循环
            break
        end
    end

    Filename_first = Firstimagename(1:min(Numberpos)-1);           %提取图像名中最后一位字母之前的字符串
    Firstfilenumber=Firstimagename(min(Numberpos):max(Numberpos)); %提取图像名中“.”之前的数字部分
    Lastname_first = Firstimagename(max(Numberpos)+1:Firstimagenamesize(1,2));   %提取图像类型
    Firstfilenumbersize=size(Firstfilenumber);                                   %图像名中数字的的大小  1×n大小
    onemore=10^(Firstfilenumbersize(1,2));                                       %图像中数字的n位数。即图片的最多个数。
    filenamelist(1,:)=Firstimagename;                                            %filenamelist的第一行内容。

    Firstfilenumber=str2num(Firstfilenumber);                                    %字符串转成双精度数字
    u=1+onemore+Firstfilenumber;                                                 %定义U的大小
    ustr=num2str(u);                                                             %数字u转换为字符
    filenamelist(2,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];     % filenamelist的第二行内容，图形的名字。
   
    counter=1;                                                                                %接下来处理其他图像
    
    while exist(filenamelist((counter+1),:),'file') ==2;                                      %文件夹下仍然存在文件          
        counter=counter+1;
        u=1+u;
        ustr=num2str(u);
        filenamelist(counter+1,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];
        if exist(filenamelist((counter+1),:),'file') ==0;                                    %文件夹下没有文件
            warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end
[FileNameBase,PathNameBase] = uiputfile('filenamelist.mat','Save as "filenamelist" in image directory (recommended)');      %生存文件名列表文件，并记录路径
cd(PathNameBase)
save(FileNameBase,'filenamelist');

%  -------------------------------------------------------
function [FileNameBase,PathNameBase,filenamelist]=manually;
% Prompt user for images to be used for analysis  

prompt = {'Enter number of first image (i.e. "3" for PIC00003):','Enter number of last image (i.e. "100" for PIC00100):'};
dlg_title = 'Input images to be used for the analysis';
num_lines= 1;
def     = {'1','100'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
F2 = str2num(cell2mat(answer(1,1)));
F = str2num(cell2mat(answer(2,1)));

if F >= 10000
    error0 = menu('!!! ERROR - Code will only work properly for 9999 or less picture files !!!','Restart');
    return
end

% Choose first name of images
G = 'PIC1';
prompt = {'Enter Image Name (first 4 letters):'};
dlg_title = 'Input images to be used for the analysis';
num_lines= 1;
def     = {'PIC1'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
G = cell2mat(answer(1,1));

E='.tif';

namelist(1:F-F2+1,1)=G(1,1);
namelist(1:F-F2+1,2)=G(1,2);
namelist(1:F-F2+1,3)=G(1,3);
namelist(1:F-F2+1,4)=G(1,4);

% create the numberlist
num=((10000+F2):(10000+F))';

% Creation of final results
filenamelist=namelist;
str=num2str(num);
filenamelist(:,5:8)=str(:,2:5);

filenamelist(1:F-F2+1,9)=E(1,1);
filenamelist(1:F-F2+1,10)=E(1,2);
filenamelist(1:F-F2+1,11)=E(1,3);
filenamelist(1:F-F2+1,12)=E(1,4);


% Save results
[FileNameBase,PathNameBase] = uiputfile('filenamelist.mat','Save as "filenamelist" in image directory (recommended)');
cd(PathNameBase)
save(FileNameBase,'filenamelist');


%  ----------------------------------------
% Extract the time from images?

function [FileNameBase,PathNameBase,filenamelist]=imagetime(FileNameBase,PathNameBase,filenamelist)

selection_time_image = menu(sprintf('Do you also want to extract the time from images to match stress and strain?'),'Yes','No');

if selection_time_image==1
  
    % Loop through all images in imagetimelist to get all image capture times
    
    [ri,ci]=size(filenamelist);
    
    o=waitbar(0,'Extracting the image capture times...');
    
    for q=1:ri
        
        waitbar(q/ri);
        info=imfinfo(filenamelist(q,:));
        time=datevec(info.FileModDate,13);
        seconds(q)=time(1,4)*3600+time(1,5)*60+time(1,6);
        
    end
    
    close(o)
    
    % Configure and then save image number vs. image capture time text file
    
    im_num_im_cap_time=[(1:ri)' seconds'];
    save time_image.txt im_num_im_cap_time -ascii -tabs
    
end