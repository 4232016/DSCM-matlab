function [filenamelist] = filelist_generator(ImageFolder,Firstimagename)


% 自动方式创建文件名列表函数

if Firstimagename~~[];
    % Get the number of image name
    cd(ImageFolder);
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
           % warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end

