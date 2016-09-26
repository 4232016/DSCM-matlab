function varargout = DIC(varargin)
% DIC MATLAB code for DIC.fig
%      DIC, by itself, creates a new DIC or raises the existing
%      singleton*.
%
%      H = DIC returns the handle to a new DIC or the handle to
%      the existing singleton*.
%
%      DIC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIC.M with the given input arguments.
%
%      DIC('Property','Value',...) creates a new DIC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIC_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIC_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIC

% Last Modified by GUIDE v2.5 30-Aug-2015 14:19:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIC_OpeningFcn, ...
                   'gui_OutputFcn',  @DIC_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before DIC is made visible.
function DIC_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DIC (see VARARGIN)

% Choose default command line output for DIC
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIC wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = DIC_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_pic.
function load_pic_Callback(hObject, eventdata, handles)
% hObject    handle to load_pic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fname,pname,index]=uigetfile({'*.bmp';'*.jpg'},'选择图片');           %读取图像，当用户取消选择时，3个输出参数都为0

if index                             %index不为0时，用户选择图像成功
    str=[pname fname];                   %定义图像路径和名称
    I=imread(str);                       %提取图像
    I=im2double(I);                      %将图像I转换成双精度数据
    M=2*size(I,1);                       %读取灰度矩阵的行数并加倍
    N=2*size(I,2);                       %读取灰度矩阵的列数并加倍
    u=-M/2:(M/2-1);                      %创建1*M向量，数值从-M/2到M/2-1
    v=-N/2:(N/2-1);                      %创建1*N向量，数值从-N/2到N/2-1
    [U,V]=meshgrid(u,v);                 %建立坐标系网格
    D=sqrt(U.^2+V.^2);                   %理想低通滤波器对图像进行平滑
    D0=40;                               %第二组取40，不同的实验也不一样。D0为理想低通滤波器的截止频率
    H=double(D<=D0);                     %D<=D0时元素取1，否则取0，H大小为u×v
    J=fftshift(fft2(I,size(H,1),size(H,2)));    %(傅立叶变换，时域图像转换到频域，两次size分别返回H的行数和列数)
    K=J.*H;                                     %矩阵对应元素相乘，滤波降噪
    L=ifft2(ifftshift(K));                      %傅里叶反变换
    L=L(1:size(I,1),1:size(I,2));               %截取前u行v列的数据
    BW=edge(L,'sobel');                         %索贝尔方式检测图像边缘
    axes(handles.axes1);                        %定位显示图像的位置
    imshow(BW);                                 %显示提取的边缘
    [BW1,rect]=imcrop(BW);                      %裁剪图像,rect是一个4维向量,定义裁剪窗口，rect=[xmin ymin width height]
    axes(handles.axes1);                        %定位显示图像的位置
    imshow(BW1);                                %显示裁剪后的图像
    step_r=1;                                   %径向分层
    step_angle=0.1;                             %周向划分
    r_min=45;               %根据具体实验要调整r_max r_min值,将mm值转换成像素值  mm*96(dpi)/25.4=像素值 这里牵扯到图像标定
    r_max=55;               %像素值*25.4/dpi(96)=mm
    p=0.51;
    [space,circle,para]=hough_circle(BW1,step_r,step_angle,r_min,r_max,p);  %调用霍夫识别圆的子程序
    get=[1 2 3];
    rect=rect(get);      %获取rect向量中前3个元素组成行向量，即将rect转换成3维向量
    temp=rect(1,1);      %获取position中的x值
    rect(1,1)=rect(1,2); %将position中的y值提前
    rect(1,2)=temp;      %将position中的x值放后 这些操作的目的是为了与para对应 [y x r]
    rect(1,3)=0;         %将width数据清除
    circleParaXYR=para+rect;     %按照裁剪矩阵对识别出的圆进行平移
    axes(handles.axes1);         %定义显示窗口
    imshow(I);                   %显示原始图像
    hold on                      %保持图像
    plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');    %红色+号显示识别出的圆的圆心
    %显示识别的圆%   
    t=0:0.01*pi:2*pi;                  %周向显示点的密度
    handles.amp1=1.5;
    handles.amp2=2;                    %amp为放大系数
    handles.circleParaXYR=circleParaXYR;
    guidata(hObject,handles);
    amp1=handles.amp1;
    amp2=handles.amp2;
    x1=amp1*cos(t).*circleParaXYR(1,3)+circleParaXYR(1,2);   %3代表半径   2代表X   1代表Y
    y1=amp1*sin(t).*circleParaXYR(1,3)+circleParaXYR(1,1);
    x2=amp2*cos(t).*circleParaXYR(1,3)+circleParaXYR(1,2);
    y2=amp2*sin(t).*circleParaXYR(1,3)+circleParaXYR(1,1);
    plot(x1,y1,'r-');               
    plot(x2,y2,'r-');                                    %得到的半径、圆心均为像素值
    axis off;                                            %不显示坐标轴
end
theta=0:pi/90:2*pi;                                      %定义网格划分密度
r=round(amp1*circleParaXYR(1,3)):2:round(amp2*circleParaXYR(1,3)); %步距2表示在径向网格间距2像素
[theta,r]=meshgrid(theta,r);                             %画网格  
%假设向量theta的长度为u，向量r的长度为v,经过meshgrid函数后，theta和r均变为u×v的矩阵
%且矩阵theta的每一行都为原向量theta；矩阵r的每一列均为原向量r
grid_x=circleParaXYR(1,2)+r.*cos(theta);
grid_y=circleParaXYR(1,1)+r.*sin(theta);                 %计算每个网格点的值
handles.grid_x=circleParaXYR(1,2)+r.*cos(theta);
handles.grid_y=circleParaXYR(1,1)+r.*sin(theta);
guidata(hObject,handles);
fid=fopen('grid_x.dat','wt'); 
fprintf(fid,'%d\n',grid_x);
fclose(fid);                  %以文本形式输出网格节点坐标grid_x                                                                      
fid=fopen('grid_y.dat','wt');
fprintf(fid,'%d\n',grid_y);
fclose(fid);                  %以文本形式输出网格节点坐标grid_y 


% --- Executes on button press in imread.
function imread_Callback(hObject, eventdata, handles)
% hObject    handle to imread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Firstimagename ImageFolder]=uigetfile('*.bmp','Open First Image');  %弹出对话框显示选取图像界面，获取图像名称和路径
if  ~isempty(Firstimagename) ;                                       %假如文件名不为空时，if成立
    cd(ImageFolder);                                                 %改变当前工作路径到图像所在文件夹
end
% 检验文件名是 zimu+shuzi.tif ,从数字后面开始辨认 .
if ~isempty(Firstimagename);                                         %假如文件名不为空时，if成立
    % Get the number of image name
    letters=isletter(Firstimagename);                                %看图片名是否为字母，若是字母，letters=1
    Pointposition=strfind(Firstimagename,'.');                       %返回第一个图片名中的‘.’的位置
    Firstimagenamesize=size(Firstimagename);                         %第一图片名的大小
    counter=Pointposition-1;                                         %计数器指向“.”前一个字符的位置
    counterpos=1;                                                    %文件名长度计数器（不包括“.”后的字符）
    letterstest=0;                                                   %定义while循环初始值
    while letterstest==0                                             %从“.”前一个字符开始辨认，直到图像名的第一个字符
        letterstest=letters(counter);                                %此处等同于letterstest=isletter(Firstimagename(counter))
        if letterstest==1
            break                                                    %若这个字符是字母，则程序结束while循环
        end
        Numberpos(counterpos)=counter;                               %Numberpos为一维数组，其第counterpos个元素的值为counter
        % 当之前校验的字符不是字母是，进入下面的程序
        counter=counter-1;                                           %counter减1，继续校验前一个字符                  
        counterpos=counterpos+1;                                     %图片名长度计数器+1
        if counter==0                                                %校验完所有字符，退出while循环
            break
        end
    end
    
    Filename_first = Firstimagename(1:min(Numberpos)-1);             %提取图像名中最后一位字母之前的字符串
    Firstfilenumber=Firstimagename(min(Numberpos):max(Numberpos));   %提取图像名中“.”之前的数字部分
    Lastname_first = Firstimagename(max(Numberpos)+1:Firstimagenamesize(1,2));    %提取图像类型
    Firstfilenumbersize=size(Firstfilenumber);            %图像名中数字的的大小  1×n大小                                            
    onemore=10^(Firstfilenumbersize(1,2));                %图像中数字的n位数。即图片的最多个数。
    filenamelist(1,:)=Firstimagename;                     %filenamelist的第一行内容。
    Firstfilenumber=str2double(Firstfilenumber);          %字符串转成双精度数字        
    u=1+onemore+Firstfilenumber;                          %定义U的大小            
    ustr=num2str(u);                                      %数字u转换为字符
    filenamelist(2,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];  % filenamelist的第二行内容，图形的名字。
   % numberofimages=2;      
    counter=1;          
    
    while exist(filenamelist((counter+1),:),'file') ==2;  %% 0 不存在则返回值    1 name 可以是变量名，如果存在，返回值 2 函数名、m 文件名，存在则返回值 3 mex 文件、dll 文件，存在则返回值 4 内嵌的函数，存在则返回值 5 p码文件 ， 存在则返回值 6 目录，存在则返回值 7 路径，存在则返回值 8 Java class，存在则返回值 
                                                            
        counter=counter+1;
        u=1+u;
        ustr=num2str(u);
        filenamelist(counter+1,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];       % filenamelist的第三行以后内容。
        if exist(filenamelist((counter+1),:),'file') ==0;                 
            warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end
[FileNameBase,PathNameBase] = uiputfile('filenamelist.mat','Save as "filenamelist" in image directory (recommended)');   %生存文件名列表文件，并记录路径  
cd(PathNameBase)                                          %更改当前工作路径                         
save(FileNameBase,'filenamelist');

% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in automate.
[FileNameBase,PathNameBase,FilterIndex] = uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG','Image files (*.bmp,*.tif,*.jpg)';'*.*',  'All Files (*.*)'}, ...
    '打开参考图像');
if FilterIndex                               %当用户选择正常的话，FilterIndex为整数，用户取消选择时FilterIndex为0                                   
   cd(PathNameBase);                         %改变当前工作路径
   im_grid = imread(FileNameBase);           %读入网格数据
   axes(handles.axes2);
   imshow(im_grid);                          %显示网格数据
   grid_x=load('grid_x.dat');
   grid_y=load('grid_y.dat');
   hold on
   plot(grid_x, grid_y,'+r');
end
function automate_Callback(hObject, eventdata, handles)
% hObject    handle to automate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('grid_x')==0               %加载x方向网格
    load('grid_x.dat')              % file with x position, created by grid_generator.m
end
if exist('grid_y')==0               %加载y方向网格
    load('grid_y.dat')              % file with y position, created by grid_generator.m
end
if exist('filenamelist')==0         %加载图片列表
    load('filenamelist')            % file with the list of filenames to be processed
end
resume=0;                           %中断
if exist('validx')==1               %判断validx文件是否存在
    if exist('validy')==1           %判断validy文件是否存在
        resume=1;
        [Rasternum Imagenum]=size(validx);     %将validx的行列数赋值[Rasternum Imagenum]rasternum光栅点个数 imagenum照片个数
    end
end
% Initialize variables
input_points_x=grid_x;         %将网格坐标grid_x赋值给input_points_x  base_points_x
base_points_x=grid_x;
input_points_y=grid_y;         %将网格坐标grid_y赋值给input_points_y  base_points_y
base_points_y=grid_y;

if resume==1                   %如果validx、validy文件存在
    input_points_x=validx(:,Imagenum);     %将validx第Imagenum列数据赋值给input_points_x
    input_points_y=validy(:,Imagenum);     %将validy第Imagenum列数据赋值给input_points_y
    inputpoints=1;
end
[row,col]=size(base_points_x);      %row表示网格点个数     % this will determine the number of rasterpoints we have to run through
[r,c]=size(filenamelist);           %r=照片数 c=照片名字   % this will determine the number of images we have to loop through
% Open new figure so previous ones (if open) are not overwritten
axes(handles.axes2);
imshow(filenamelist(1,:))           % show the first image
hold on
plot(grid_x,grid_y,'g+')            % plot the grid onto the image   g代表green
hold off
% Start image correlation using cpcorr.m
firstimage=1;
if resume==1                 %如果validx、validy文件存在
    firstimage=Imagenum+1    %不需要再处理图片，重新计算validx、validy了
end
for i=firstimage:(r-1)        % run through all images    
    base = uint8(mean(double(imread(filenamelist(1,:))),3));            % 读入基准图像（通常为编号为1的图像，有时候光照条件变化时可能会是其他图像）由于imread后为2维矩阵，所以mean后矩阵不变
    input = uint8(mean(double(imread(filenamelist((i+1),:))),3));       % 通过for循环读入剩下的图像
    input_points_for(:,1)=reshape(input_points_x,[],1);                 %reshape可以改变指定的矩阵形状，但元素个数不变，相当于将input_points_x转变成input_points_for的第1列
    input_points_for(:,2)=reshape(input_points_y,[],1);                 %将input_points_y转变成input_points_for的第2列
    base_points_for(:,1)=reshape(base_points_x,[],1);                   %将base_points_x转变成base_points_for的第1列
    base_points_for(:,2)=reshape(base_points_y,[],1);                   %将base_points_y转变成base_points_for的第2列
    input_correl(:,:)=cpcorr(round(input_points_for), round(base_points_for), input, base);    % 第一步进行相关运算，获得各图像搜索控制点
    input_correl_x=input_correl(:,1);                                   % the results we get from cpcorr for the x-direction
    input_correl_y=input_correl(:,2);                                   % the results we get from cpcorr for the y-direction
    validx(:,i)=input_correl_x;                                         % lets save the data
    savelinex=input_correl_x';                                          %将列向量转换成行向量
    dlmwrite('resultsimcorrx.txt', savelinex , 'delimiter', '\t', '-append');       % Here we save the result from each image; if you are desperately want to run this function with e.g. matlab 6.5 then you should comment this line out. If you do that the data will be saved at the end of the correlation step - good luck ;-)
    validy(:,i)=input_correl_y;
    saveliney=input_correl_y';
    dlmwrite('resultsimcorry.txt', saveliney , 'delimiter', '\t', '-append');
    % Update base and input points for cpcorr.m  更新base_points input_points
    base_points_x=grid_x;                                              %恢复基准图像的坐标
    base_points_y=grid_y;
    input_points_x=input_correl_x;                                     %跟新变形图像的坐标，进行下一次迭代
    input_points_y=input_correl_y;
    axes(handles.axes2);
    imshow(filenamelist(i+1,:))                     % update image
    hold on
    plot(grid_x,grid_y,'g+')                        % plot start position of raster
    plot(input_correl_x,input_correl_y,'r+')        % plot actual postition of raster
    hold off
    drawnow
%  [h,m,s] = hms2mat(timedim(estimatedtime,'seconds','hms'));
%  title(['# Im.: ', num2str((r-1)),'; Proc. Im. #: ', num2str((i)),'; # Rasterp.:',num2str(row*col), '; Est. Time [h:m:s] ', num2str(h),':',num2str(m),':',num2str(s)])    % plot a title onto the image
   title(['total Im: ', num2str((r-1)),'; processing Im: ', num2str((i)),';点阵: ',num2str(row*col), ';时间:[h:m:s] ']) % plot a title onto the image
   drawnow    
end    
save validx.dat validx -ascii -tabs   % save validx.dat validy.dat
save validy.dat validy -ascii -tabs


% --- Executes on button press in StrainX.
function StrainX_Callback(hObject, eventdata, handles)
% hObject    handle to StrainX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validx =load('validx.dat');                      %加载数据
validy =load('validy.dat');
sizevalidx=size(validx);                         %validx validy是一个矩阵，其行数代表结点个数，列数代表照片个数 数值代表变形后各网格点的坐标
sizevalidy=size(validy);                         %size函数返回一个行向量[validx行数 validx列数]
looppoints=sizevalidx(1,1);                      %总共的结点个数                    
loopimages=sizevalidx(1,2);                      %总共的照片数
%calculate the displacement relative to the first image in x and y direction 计算各网格点的x向与y向的位移
clear displx;
validxfirst=zeros(size(validx));                 %构建一个和validx大小相同的矩阵
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %构建第一张图像的[1...........1(照片个数)]，validx（:,1）第一张图所有网格点x方向位移,mean()之后仍是其本身
displx=validx-validxfirst;       %做差会求出所有网格点的x向位移displx是个矩阵，行数代表网格节点数，列数代表照片数
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %画入插值点网格
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic立方插值
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20]; 
straincolor = [-0.3 0.3];       %原来是[-0.005 0.03] 现在修改为[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %找出最大/最小的位移值做差
maxminusminvalidy=(max(max(validy))-min(min(validy))); %这处作了修改，将第一个validx改成了validy，估计原来是笔误!
displ=sqrt(displx.^2+disply.^2);   %求得某一点的总位移
axes(handles.axes3);
figure;
for i=1:(loopimages-1)             
	ZIX=griddata(validx(:,i),validy(:,i),displx(:,i),XI,YI,'cubic'); 
    ZIXsize=size(ZIX);
    [FX,FY]=gradient(ZIX,(maxminusminvalidx/ZIXsize(1,1)),(maxminusminvalidy/ZIXsize(1,2)));% FX=偏u/偏x=ex FY=偏u/偏y [FX,FY]=gradient(F)将矩阵F进行微分求取各点x向应变
    pcolor(XI,YI,FX)
	axis('equal')          %axis设置坐标轴的最小最大值 用法axis([xmin,xmax,ymin,ymax]) axis equal 横纵坐标轴采取等长刻度   hold on保持当前图形窗口
    shading('interp')
    caxis(straincolor)      %设定颜色坐标轴 caxis(V),V是由两个元素组成的向量[cmin,cmax]
    colorbar('EastOutside');              %设定字体大小
    title(  ['ROI区域X向应变'] )
    drawnow; 
end
save FX.dat FX -ascii -tabs
% --- Executes on button press in stress.
function stress_Callback(hObject, eventdata, handles)
% hObject    handle to stress (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validx=load('validx.dat');
validy=load('validy.dat');
sizevalidx=size(validx);
sizevalidy=size(validy);
looppoints=sizevalidx(1,1);
loopimages=sizevalidx(1,2);
clear displx;
validxfirst=zeros(size(validx)); %构建一个和validx大小相同的矩阵
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %构建第一张图像的[1...........1(照片个数)]，validx（:,1）第一张图所有网格点x方向位移
displx=validx-validxfirst;  %做差会求出所有网格点的x向位移displx是个矩阵，行数代表网格节点数，列数代表照片数
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
displ=sqrt(displx.^2+disply.^2);
grid_x=handles.grid_x;
[radial circumference]=size(grid_x);      %径向、周向结点个数 size(grid_y)也可 报错
T=displ(:,loopimages);   %获取最后一张图像上所有节点的位移
for i=1:circumference                         %因为displ是列向量，取点规则是：由内到外，同一半径下逆时针取点
ddirec(i,:)=T(radial*(i-1)+1:radial*i,1);
end                                 %构造出的新位移矩阵ddirec[theta,r] 行表示同一角度下径向去点位置，列表示同一径向下不同角度取点
h=6;      %孔深=6
E=71.7;   %弹性模量E=71.7GPa 
r0=63;    %孔径r0=63 
v=0.33;
stresscolor=[0 100];
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));% 各个圆的半径
for i=1:radial     %径向标志点数
    for t=1:circumference   %圆周标志点数
        A(t,i)=(1+v)*r(1,i)/2*E+h/4*E*cos(2*(t-1)*pi/180);  % A=r0*(1+v)*a/2*E B=r0*b/2*E a=r/r0 b=h/2*r0 
        B(t,i)=(1+v)*r(1,i)/2*E-h/4*E*cos(2*(t-1)*pi/180);
        C(t,i)=2*h/4*E*sin(2*(t-1)*pi/180);
    end                               %通过这步可以获得系数矩阵[A=A+2Bcos(theta)] [B=A+2Bcos(theta)] [C=2B*sin(theta)]
        coe=[A(:,i) B(:,i) C(:,i)];                   %建立系数矩阵
        stress(:,i)=inv(coe'*coe)*coe'*ddirec(:,i)*1000;%由最小二乘法求得[stressx stressy shearxy] 结果单位为MPa inv就是求逆的过程
end
xlswrite('stress',stress)
%接下来计算主应力
for i=1:radial           %MTS即最大、最小主应力main true stress % MTS(1,1)最大主应力 MTS(2,1)最小主应力 MTS(3,1)方向角
    MTS(1,i)=(stress(1,i)+stress(2,i))/2+1/2*sqrt((stress(2,i)-stress(1,i)).^2+4*stress(3,i).^2);              
	MTS(2,i)=(stress(1,i)+stress(2,i))/2-1/2*sqrt((stress(2,i)-stress(1,i)).^2+4*stress(3,i).^2);
	MTS(3,i)=1/2*atan(2*stress(3,i)/(stress(2,i)-stress(1,i)))*180/pi;
end
xlswrite('MTS',MTS)


% --- Executes on button press in StrainY.
function StrainY_Callback(hObject, eventdata, handles)
% hObject    handle to StrainY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validx =load('validx.dat');
validy =load('validy.dat');
sizevalidx=size(validx);                         %validx validy是一个矩阵，其行数代表结点个数，列数代表照片个数 数值代表变形后各网格点的坐标
sizevalidy=size(validy);                         %size函数返回一个行向量[validx行数 validx列数]
looppoints=sizevalidx(1,1);  %总共的结点个数                    
loopimages=sizevalidx(1,2);  %总共的照片数
%calculate the displacement relative to the first image in x and y direction 计算各网格点的x向与y向的位移
clear displx;
validxfirst=zeros(size(validx)); %构建一个和validx大小相同的矩阵
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %构建第一张图像的[1...........1(照片个数)]，validx（:,1）第一张图所有网格点x方向位移
displx=validx-validxfirst;       %做差会求出所有网格点的x向位移displx是个矩阵，行数代表网格节点数，列数代表照片数
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %画入插值点网格
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic立方插值
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20];               %原来是[-7 1] 现在修改为[-20 20] 
straincolor = [-0.3 0.3];       %原来是[-0.005 0.03] 现在修改为[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %找出最大/最小的位移值做差
maxminusminvalidy=(max(max(validy))-min(min(validy))); %这处作了修改，将第一个validx改成了validy，估计原来是笔误!
displ=sqrt(displx.^2+disply.^2);   %求得某一点的总位移
figure;
for i=1:(loopimages-1)             %求得每张照片y方向的应变ey
	ZIY=griddata(validx(:,i),validy(:,i),disply(:,i),XI,YI,'cubic'); 			
    ZIYsize=size(ZIY);
    [GX,GY]=gradient(ZIY,(maxminusminvalidx/ZIYsize(1,1)),(maxminusminvalidy/ZIYsize(1,2)));% GX=偏v/偏x GY=偏v/偏y=ey
	pcolor(XI,YI,GY)
    axis('equal')
    shading('interp')
    caxis(straincolor)
    colorbar('EastOutside');                                   %将 962 963 964行删除 暂时换成colorbar('EastOutside')可以运行，但后面还要改进
    title(['ROI区域Y向应变'])
	drawnow;
end
save GY.dat GY -ascii -tabs
% --- Executes on button press in ShearXY.
function ShearXY_Callback(hObject, eventdata, handles)
% hObject    handle to ShearXY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validx =load('validx.dat');
validy =load('validy.dat');
sizevalidx=size(validx);                         %validx validy是一个矩阵，其行数代表结点个数，列数代表照片个数 数值代表变形后各网格点的坐标
sizevalidy=size(validy);                         %size函数返回一个行向量[validx行数 validx列数]
looppoints=sizevalidx(1,1);  %总共的结点个数                    
loopimages=sizevalidx(1,2);  %总共的照片数
%calculate the displacement relative to the first image in x and y direction 计算各网格点的x向与y向的位移
clear displx;
validxfirst=zeros(size(validx)); %构建一个和validx大小相同的矩阵
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %构建第一张图像的[1...........1(照片个数)]，validx（:,1）第一张图所有网格点x方向位移
displx=validx-validxfirst;       %做差会求出所有网格点的x向位移displx是个矩阵，行数代表网格节点数，列数代表照片数
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %画入插值点网格
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic立方插值
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20];               %原来是[-7 1] 现在修改为[-20 20] 
straincolor = [-0.3 0.3];       %原来是[-0.005 0.03] 现在修改为[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %找出最大/最小的位移值做差
maxminusminvalidy=(max(max(validy))-min(min(validy))); %这处作了修改，将第一个validx改成了validy，估计原来是笔误!
displ=sqrt(displx.^2+disply.^2);   %求得某一点的总位移
for i=1:(loopimages-1)             
	ZIX=griddata(validx(:,i),validy(:,i),displx(:,i),XI,YI,'cubic'); 
    ZIXsize=size(ZIX);
    [FX,FY]=gradient(ZIX,(maxminusminvalidx/ZIXsize(1,1)),(maxminusminvalidy/ZIXsize(1,2)));% FX=偏u/偏x=ex FY=偏u/偏y [FX,FY]=gradient(F)将矩阵F进行微分求取各点x向应变
end
for i=1:(loopimages-1)             %求得每张照片y方向的应变ey
	ZIY=griddata(validx(:,i),validy(:,i),disply(:,i),XI,YI,'cubic'); 			
    ZIYsize=size(ZIY);
    [GX,GY]=gradient(ZIY,(maxminusminvalidx/ZIYsize(1,1)),(maxminusminvalidy/ZIYsize(1,2)));% GX=偏v/偏x GY=偏v/偏y=ey
end
ShearXY=FY+GX;         %计算剪应变
figure;
ZI=ShearXY;
pcolor(XI,YI,ZI)
axis('equal')          %axis设置坐标轴的最小最大值 用法axis([xmin,xmax,ymin,ymax]) axis equal 横纵坐标轴采取等长刻度   hold on保持当前图形窗口
shading('interp')
caxis(straincolor)      %设定颜色坐标轴 caxis(V),V是由两个元素组成的向量[cmin,cmax]
colorbar('EastOutside');               %设定字体大小
title(['ROI区域剪应变 '])
drawnow; 
save ShearXY.dat ShearXY -ascii -tabs