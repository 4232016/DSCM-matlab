function [FileNameBase,PathNameBase,filenamelist]=filelist_generator

% �����ļ����б�Ĵ���
% Code to construct a list of 9999 or less filenames
% Programmed by Rob, changed by Chris. Automatic filelist generation 
% and image time aquisition added by Chris.
% Last revision: 12/25/06

filenamelistmode = menu(sprintf('How do you want to create the filenamelist?'),...           %�����˵����û�ѡ�񴴽��б�ķ�ʽ
    'Manually','Automatically','Cancel');
if filenamelistmode==3                                                                       %ȡ��ѡ��
    return
end
if filenamelistmode==2                                                                       %�Զ���ʽ����
    [FileNameBase,PathNameBase,filenamelist]=automatically;
end
if filenamelistmode==1                                                                       %�ֶ���ʽ����
    [FileNameBase,PathNameBase,filenamelist]=manually;
end

[FileNameBase,PathNameBase,filenamelist]=imagetime(FileNameBase,PathNameBase,filenamelist);

%  -------------------------------------------------------

function [Firstimagename,ImageFolder,filenamelist]=automatically

% �Զ���ʽ�����ļ����б���

[Firstimagename ImageFolder]=uigetfile('*.BMP','Open First Image');                       %�����Ի�����ʾѡȡͼ����棬��ȡͼ�����ƺ�·��
if ~isempty(Firstimagename);                                                              %�����ļ�����Ϊ��ʱ��if����
    cd(ImageFolder);                                                                      %�ı䵱ǰ����·����ͼ�������ļ���
end

if Firstimagename~~[];
    % Get the number of image name
    letters=isletter(Firstimagename);                              %�鿴�ļ����Ƿ�����ĸ���е��ַ�
    Pointposition=findstr(Firstimagename,'.');                     %��λ��.����λ��
    Firstimagenamesize=size(Firstimagename);                       %�ļ�������
    counter=Pointposition-1;                                       %������ָ��.��ǰһ���ַ���λ��
    counterpos=1;                                                  %�ļ������ȼ���������������.������ַ���
    letterstest=0;                                                 %����whileѭ����ʼֵ
    while letterstest==0                                           %�ӡ�.��ǰһ���ַ���ʼ���ϣ�ֱ��ͼ�����ĵ�һ���ַ�
        letterstest=letters(counter);                              %�˴���ͬ��letterstest=isletter(Firstimagename(counter))
        if letterstest==1                                          %������ַ�����ĸ����������whileѭ��
            break
        end
        Numberpos(counterpos)=counter;                             %NumberposΪһά���飬���counterpos��Ԫ�ص�ֵΪcounter
        counter=counter-1;                                         %counter��1������У��ǰһ���ַ�
        counterpos=counterpos+1;                                   %ͼƬ�����ȼ�����+1
        if counter==0                                              %У���������ַ����˳�whileѭ��
            break
        end
    end

    Filename_first = Firstimagename(1:min(Numberpos)-1);           %��ȡͼ���������һλ��ĸ֮ǰ���ַ���
    Firstfilenumber=Firstimagename(min(Numberpos):max(Numberpos)); %��ȡͼ�����С�.��֮ǰ�����ֲ���
    Lastname_first = Firstimagename(max(Numberpos)+1:Firstimagenamesize(1,2));   %��ȡͼ������
    Firstfilenumbersize=size(Firstfilenumber);                                   %ͼ���������ֵĵĴ�С  1��n��С
    onemore=10^(Firstfilenumbersize(1,2));                                       %ͼ�������ֵ�nλ������ͼƬ����������
    filenamelist(1,:)=Firstimagename;                                            %filenamelist�ĵ�һ�����ݡ�

    Firstfilenumber=str2num(Firstfilenumber);                                    %�ַ���ת��˫��������
    u=1+onemore+Firstfilenumber;                                                 %����U�Ĵ�С
    ustr=num2str(u);                                                             %����uת��Ϊ�ַ�
    filenamelist(2,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];     % filenamelist�ĵڶ������ݣ�ͼ�ε����֡�
   
    counter=1;                                                                                %��������������ͼ��
    
    while exist(filenamelist((counter+1),:),'file') ==2;                                      %�ļ�������Ȼ�����ļ�          
        counter=counter+1;
        u=1+u;
        ustr=num2str(u);
        filenamelist(counter+1,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];
        if exist(filenamelist((counter+1),:),'file') ==0;                                    %�ļ�����û���ļ�
            warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end
[FileNameBase,PathNameBase] = uiputfile('filenamelist.mat','Save as "filenamelist" in image directory (recommended)');      %�����ļ����б��ļ�������¼·��
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