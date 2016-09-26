
%批量修改文件名
[Firstimagename ImageFolder]=uigetfile('*.bmp','打开编号为 1 的图像');       %弹出对话框显示选取图像界面，获取图像名称和路径
if ~isempty(Firstimagename);                                               %假如文件名不为空时，if成立
    cd(ImageFolder);                                                       %改变当前工作路径到图像所在文件夹
end

filename = input('请输入图像名称（5个字母以内）：','s');                      %提示输入字符串作为图像的名称
x = dir('*.bmp');                                                          %计算当前文件夹中.BMP格式文件数量
y = length(x);
a = (1:y)';
b = num2str(a);
b(b==32)=48;
for k=1:y
    oldname=x(k).name;
    newname=[filename b(k,:) '.bmp']; 
    status = system(['rename'  ' ' oldname  ' ' newname]);
    if status~=0
       % disp(['文件' oldname  '重命名失败'])
        movefile(oldname,newname);
    end  
end
