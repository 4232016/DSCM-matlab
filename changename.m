
%�����޸��ļ���
[Firstimagename ImageFolder]=uigetfile('*.bmp','�򿪱��Ϊ 1 ��ͼ��');       %�����Ի�����ʾѡȡͼ����棬��ȡͼ�����ƺ�·��
if ~isempty(Firstimagename);                                               %�����ļ�����Ϊ��ʱ��if����
    cd(ImageFolder);                                                       %�ı䵱ǰ����·����ͼ�������ļ���
end

filename = input('������ͼ�����ƣ�5����ĸ���ڣ���','s');                      %��ʾ�����ַ�����Ϊͼ�������
x = dir('*.bmp');                                                          %���㵱ǰ�ļ�����.BMP��ʽ�ļ�����
y = length(x);
a = (1:y)';
b = num2str(a);
b(b==32)=48;
for k=1:y
    oldname=x(k).name;
    newname=[filename b(k,:) '.bmp']; 
    status = system(['rename'  ' ' oldname  ' ' newname]);
    if status~=0
       % disp(['�ļ�' oldname  '������ʧ��'])
        movefile(oldname,newname);
    end  
end
