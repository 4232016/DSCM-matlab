function [filenamelist] = filelist_generator(ImageFolder,Firstimagename)


% �Զ���ʽ�����ļ����б���

if Firstimagename~~[];
    % Get the number of image name
    cd(ImageFolder);
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
           % warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end

