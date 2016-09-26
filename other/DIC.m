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
[fname,pname,index]=uigetfile({'*.bmp';'*.jpg'},'ѡ��ͼƬ');           %��ȡͼ�񣬵��û�ȡ��ѡ��ʱ��3�����������Ϊ0

if index                             %index��Ϊ0ʱ���û�ѡ��ͼ��ɹ�
    str=[pname fname];                   %����ͼ��·��������
    I=imread(str);                       %��ȡͼ��
    I=im2double(I);                      %��ͼ��Iת����˫��������
    M=2*size(I,1);                       %��ȡ�ҶȾ�����������ӱ�
    N=2*size(I,2);                       %��ȡ�ҶȾ�����������ӱ�
    u=-M/2:(M/2-1);                      %����1*M��������ֵ��-M/2��M/2-1
    v=-N/2:(N/2-1);                      %����1*N��������ֵ��-N/2��N/2-1
    [U,V]=meshgrid(u,v);                 %��������ϵ����
    D=sqrt(U.^2+V.^2);                   %�����ͨ�˲�����ͼ�����ƽ��
    D0=40;                               %�ڶ���ȡ40����ͬ��ʵ��Ҳ��һ����D0Ϊ�����ͨ�˲����Ľ�ֹƵ��
    H=double(D<=D0);                     %D<=D0ʱԪ��ȡ1������ȡ0��H��СΪu��v
    J=fftshift(fft2(I,size(H,1),size(H,2)));    %(����Ҷ�任��ʱ��ͼ��ת����Ƶ������size�ֱ𷵻�H������������)
    K=J.*H;                                     %�����ӦԪ����ˣ��˲�����
    L=ifft2(ifftshift(K));                      %����Ҷ���任
    L=L(1:size(I,1),1:size(I,2));               %��ȡǰu��v�е�����
    BW=edge(L,'sobel');                         %��������ʽ���ͼ���Ե
    axes(handles.axes1);                        %��λ��ʾͼ���λ��
    imshow(BW);                                 %��ʾ��ȡ�ı�Ե
    [BW1,rect]=imcrop(BW);                      %�ü�ͼ��,rect��һ��4ά����,����ü����ڣ�rect=[xmin ymin width height]
    axes(handles.axes1);                        %��λ��ʾͼ���λ��
    imshow(BW1);                                %��ʾ�ü����ͼ��
    step_r=1;                                   %����ֲ�
    step_angle=0.1;                             %���򻮷�
    r_min=45;               %���ݾ���ʵ��Ҫ����r_max r_minֵ,��mmֵת��������ֵ  mm*96(dpi)/25.4=����ֵ ����ǣ����ͼ��궨
    r_max=55;               %����ֵ*25.4/dpi(96)=mm
    p=0.51;
    [space,circle,para]=hough_circle(BW1,step_r,step_angle,r_min,r_max,p);  %���û���ʶ��Բ���ӳ���
    get=[1 2 3];
    rect=rect(get);      %��ȡrect������ǰ3��Ԫ�����������������rectת����3ά����
    temp=rect(1,1);      %��ȡposition�е�xֵ
    rect(1,1)=rect(1,2); %��position�е�yֵ��ǰ
    rect(1,2)=temp;      %��position�е�xֵ�ź� ��Щ������Ŀ����Ϊ����para��Ӧ [y x r]
    rect(1,3)=0;         %��width�������
    circleParaXYR=para+rect;     %���ղü������ʶ�����Բ����ƽ��
    axes(handles.axes1);         %������ʾ����
    imshow(I);                   %��ʾԭʼͼ��
    hold on                      %����ͼ��
    plot(circleParaXYR(:,2), circleParaXYR(:,1), 'r+');    %��ɫ+����ʾʶ�����Բ��Բ��
    %��ʾʶ���Բ%   
    t=0:0.01*pi:2*pi;                  %������ʾ����ܶ�
    handles.amp1=1.5;
    handles.amp2=2;                    %ampΪ�Ŵ�ϵ��
    handles.circleParaXYR=circleParaXYR;
    guidata(hObject,handles);
    amp1=handles.amp1;
    amp2=handles.amp2;
    x1=amp1*cos(t).*circleParaXYR(1,3)+circleParaXYR(1,2);   %3����뾶   2����X   1����Y
    y1=amp1*sin(t).*circleParaXYR(1,3)+circleParaXYR(1,1);
    x2=amp2*cos(t).*circleParaXYR(1,3)+circleParaXYR(1,2);
    y2=amp2*sin(t).*circleParaXYR(1,3)+circleParaXYR(1,1);
    plot(x1,y1,'r-');               
    plot(x2,y2,'r-');                                    %�õ��İ뾶��Բ�ľ�Ϊ����ֵ
    axis off;                                            %����ʾ������
end
theta=0:pi/90:2*pi;                                      %�������񻮷��ܶ�
r=round(amp1*circleParaXYR(1,3)):2:round(amp2*circleParaXYR(1,3)); %����2��ʾ�ھ���������2����
[theta,r]=meshgrid(theta,r);                             %������  
%��������theta�ĳ���Ϊu������r�ĳ���Ϊv,����meshgrid������theta��r����Ϊu��v�ľ���
%�Ҿ���theta��ÿһ�ж�Ϊԭ����theta������r��ÿһ�о�Ϊԭ����r
grid_x=circleParaXYR(1,2)+r.*cos(theta);
grid_y=circleParaXYR(1,1)+r.*sin(theta);                 %����ÿ��������ֵ
handles.grid_x=circleParaXYR(1,2)+r.*cos(theta);
handles.grid_y=circleParaXYR(1,1)+r.*sin(theta);
guidata(hObject,handles);
fid=fopen('grid_x.dat','wt'); 
fprintf(fid,'%d\n',grid_x);
fclose(fid);                  %���ı���ʽ�������ڵ�����grid_x                                                                      
fid=fopen('grid_y.dat','wt');
fprintf(fid,'%d\n',grid_y);
fclose(fid);                  %���ı���ʽ�������ڵ�����grid_y 


% --- Executes on button press in imread.
function imread_Callback(hObject, eventdata, handles)
% hObject    handle to imread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[Firstimagename ImageFolder]=uigetfile('*.bmp','Open First Image');  %�����Ի�����ʾѡȡͼ����棬��ȡͼ�����ƺ�·��
if  ~isempty(Firstimagename) ;                                       %�����ļ�����Ϊ��ʱ��if����
    cd(ImageFolder);                                                 %�ı䵱ǰ����·����ͼ�������ļ���
end
% �����ļ����� zimu+shuzi.tif ,�����ֺ��濪ʼ���� .
if ~isempty(Firstimagename);                                         %�����ļ�����Ϊ��ʱ��if����
    % Get the number of image name
    letters=isletter(Firstimagename);                                %��ͼƬ���Ƿ�Ϊ��ĸ��������ĸ��letters=1
    Pointposition=strfind(Firstimagename,'.');                       %���ص�һ��ͼƬ���еġ�.����λ��
    Firstimagenamesize=size(Firstimagename);                         %��һͼƬ���Ĵ�С
    counter=Pointposition-1;                                         %������ָ��.��ǰһ���ַ���λ��
    counterpos=1;                                                    %�ļ������ȼ���������������.������ַ���
    letterstest=0;                                                   %����whileѭ����ʼֵ
    while letterstest==0                                             %�ӡ�.��ǰһ���ַ���ʼ���ϣ�ֱ��ͼ�����ĵ�һ���ַ�
        letterstest=letters(counter);                                %�˴���ͬ��letterstest=isletter(Firstimagename(counter))
        if letterstest==1
            break                                                    %������ַ�����ĸ����������whileѭ��
        end
        Numberpos(counterpos)=counter;                               %NumberposΪһά���飬���counterpos��Ԫ�ص�ֵΪcounter
        % ��֮ǰУ����ַ�������ĸ�ǣ���������ĳ���
        counter=counter-1;                                           %counter��1������У��ǰһ���ַ�                  
        counterpos=counterpos+1;                                     %ͼƬ�����ȼ�����+1
        if counter==0                                                %У���������ַ����˳�whileѭ��
            break
        end
    end
    
    Filename_first = Firstimagename(1:min(Numberpos)-1);             %��ȡͼ���������һλ��ĸ֮ǰ���ַ���
    Firstfilenumber=Firstimagename(min(Numberpos):max(Numberpos));   %��ȡͼ�����С�.��֮ǰ�����ֲ���
    Lastname_first = Firstimagename(max(Numberpos)+1:Firstimagenamesize(1,2));    %��ȡͼ������
    Firstfilenumbersize=size(Firstfilenumber);            %ͼ���������ֵĵĴ�С  1��n��С                                            
    onemore=10^(Firstfilenumbersize(1,2));                %ͼ�������ֵ�nλ������ͼƬ����������
    filenamelist(1,:)=Firstimagename;                     %filenamelist�ĵ�һ�����ݡ�
    Firstfilenumber=str2double(Firstfilenumber);          %�ַ���ת��˫��������        
    u=1+onemore+Firstfilenumber;                          %����U�Ĵ�С            
    ustr=num2str(u);                                      %����uת��Ϊ�ַ�
    filenamelist(2,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];  % filenamelist�ĵڶ������ݣ�ͼ�ε����֡�
   % numberofimages=2;      
    counter=1;          
    
    while exist(filenamelist((counter+1),:),'file') ==2;  %% 0 �������򷵻�ֵ    1 name �����Ǳ�������������ڣ�����ֵ 2 ��������m �ļ����������򷵻�ֵ 3 mex �ļ���dll �ļ��������򷵻�ֵ 4 ��Ƕ�ĺ����������򷵻�ֵ 5 p���ļ� �� �����򷵻�ֵ 6 Ŀ¼�������򷵻�ֵ 7 ·���������򷵻�ֵ 8 Java class�������򷵻�ֵ 
                                                            
        counter=counter+1;
        u=1+u;
        ustr=num2str(u);
        filenamelist(counter+1,:)=[Filename_first ustr(2:Firstfilenumbersize(1,2)+1) Lastname_first];       % filenamelist�ĵ������Ժ����ݡ�
        if exist(filenamelist((counter+1),:),'file') ==0;                 
            warning('Last image detected')
            filenamelist(counter+1,:)=[];
            break
        end
    end
end
[FileNameBase,PathNameBase] = uiputfile('filenamelist.mat','Save as "filenamelist" in image directory (recommended)');   %�����ļ����б��ļ�������¼·��  
cd(PathNameBase)                                          %���ĵ�ǰ����·��                         
save(FileNameBase,'filenamelist');

% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on button press in automate.
[FileNameBase,PathNameBase,FilterIndex] = uigetfile( ...
    {'*.bmp;*.tif;*.jpg;*.TIF;*.BMP;*.JPG','Image files (*.bmp,*.tif,*.jpg)';'*.*',  'All Files (*.*)'}, ...
    '�򿪲ο�ͼ��');
if FilterIndex                               %���û�ѡ�������Ļ���FilterIndexΪ�������û�ȡ��ѡ��ʱFilterIndexΪ0                                   
   cd(PathNameBase);                         %�ı䵱ǰ����·��
   im_grid = imread(FileNameBase);           %������������
   axes(handles.axes2);
   imshow(im_grid);                          %��ʾ��������
   grid_x=load('grid_x.dat');
   grid_y=load('grid_y.dat');
   hold on
   plot(grid_x, grid_y,'+r');
end
function automate_Callback(hObject, eventdata, handles)
% hObject    handle to automate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if exist('grid_x')==0               %����x��������
    load('grid_x.dat')              % file with x position, created by grid_generator.m
end
if exist('grid_y')==0               %����y��������
    load('grid_y.dat')              % file with y position, created by grid_generator.m
end
if exist('filenamelist')==0         %����ͼƬ�б�
    load('filenamelist')            % file with the list of filenames to be processed
end
resume=0;                           %�ж�
if exist('validx')==1               %�ж�validx�ļ��Ƿ����
    if exist('validy')==1           %�ж�validy�ļ��Ƿ����
        resume=1;
        [Rasternum Imagenum]=size(validx);     %��validx����������ֵ[Rasternum Imagenum]rasternum��դ����� imagenum��Ƭ����
    end
end
% Initialize variables
input_points_x=grid_x;         %����������grid_x��ֵ��input_points_x  base_points_x
base_points_x=grid_x;
input_points_y=grid_y;         %����������grid_y��ֵ��input_points_y  base_points_y
base_points_y=grid_y;

if resume==1                   %���validx��validy�ļ�����
    input_points_x=validx(:,Imagenum);     %��validx��Imagenum�����ݸ�ֵ��input_points_x
    input_points_y=validy(:,Imagenum);     %��validy��Imagenum�����ݸ�ֵ��input_points_y
    inputpoints=1;
end
[row,col]=size(base_points_x);      %row��ʾ��������     % this will determine the number of rasterpoints we have to run through
[r,c]=size(filenamelist);           %r=��Ƭ�� c=��Ƭ����   % this will determine the number of images we have to loop through
% Open new figure so previous ones (if open) are not overwritten
axes(handles.axes2);
imshow(filenamelist(1,:))           % show the first image
hold on
plot(grid_x,grid_y,'g+')            % plot the grid onto the image   g����green
hold off
% Start image correlation using cpcorr.m
firstimage=1;
if resume==1                 %���validx��validy�ļ�����
    firstimage=Imagenum+1    %����Ҫ�ٴ���ͼƬ�����¼���validx��validy��
end
for i=firstimage:(r-1)        % run through all images    
    base = uint8(mean(double(imread(filenamelist(1,:))),3));            % �����׼ͼ��ͨ��Ϊ���Ϊ1��ͼ����ʱ����������仯ʱ���ܻ�������ͼ������imread��Ϊ2ά��������mean����󲻱�
    input = uint8(mean(double(imread(filenamelist((i+1),:))),3));       % ͨ��forѭ������ʣ�µ�ͼ��
    input_points_for(:,1)=reshape(input_points_x,[],1);                 %reshape���Ըı�ָ���ľ�����״����Ԫ�ظ������䣬�൱�ڽ�input_points_xת���input_points_for�ĵ�1��
    input_points_for(:,2)=reshape(input_points_y,[],1);                 %��input_points_yת���input_points_for�ĵ�2��
    base_points_for(:,1)=reshape(base_points_x,[],1);                   %��base_points_xת���base_points_for�ĵ�1��
    base_points_for(:,2)=reshape(base_points_y,[],1);                   %��base_points_yת���base_points_for�ĵ�2��
    input_correl(:,:)=cpcorr(round(input_points_for), round(base_points_for), input, base);    % ��һ������������㣬��ø�ͼ���������Ƶ�
    input_correl_x=input_correl(:,1);                                   % the results we get from cpcorr for the x-direction
    input_correl_y=input_correl(:,2);                                   % the results we get from cpcorr for the y-direction
    validx(:,i)=input_correl_x;                                         % lets save the data
    savelinex=input_correl_x';                                          %��������ת����������
    dlmwrite('resultsimcorrx.txt', savelinex , 'delimiter', '\t', '-append');       % Here we save the result from each image; if you are desperately want to run this function with e.g. matlab 6.5 then you should comment this line out. If you do that the data will be saved at the end of the correlation step - good luck ;-)
    validy(:,i)=input_correl_y;
    saveliney=input_correl_y';
    dlmwrite('resultsimcorry.txt', saveliney , 'delimiter', '\t', '-append');
    % Update base and input points for cpcorr.m  ����base_points input_points
    base_points_x=grid_x;                                              %�ָ���׼ͼ�������
    base_points_y=grid_y;
    input_points_x=input_correl_x;                                     %���±���ͼ������꣬������һ�ε���
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
   title(['total Im: ', num2str((r-1)),'; processing Im: ', num2str((i)),';����: ',num2str(row*col), ';ʱ��:[h:m:s] ']) % plot a title onto the image
   drawnow    
end    
save validx.dat validx -ascii -tabs   % save validx.dat validy.dat
save validy.dat validy -ascii -tabs


% --- Executes on button press in StrainX.
function StrainX_Callback(hObject, eventdata, handles)
% hObject    handle to StrainX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
validx =load('validx.dat');                      %��������
validy =load('validy.dat');
sizevalidx=size(validx);                         %validx validy��һ���������������������������������Ƭ���� ��ֵ������κ������������
sizevalidy=size(validy);                         %size��������һ��������[validx���� validx����]
looppoints=sizevalidx(1,1);                      %�ܹ��Ľ�����                    
loopimages=sizevalidx(1,2);                      %�ܹ�����Ƭ��
%calculate the displacement relative to the first image in x and y direction �����������x����y���λ��
clear displx;
validxfirst=zeros(size(validx));                 %����һ����validx��С��ͬ�ľ���
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %������һ��ͼ���[1...........1(��Ƭ����)]��validx��:,1����һ��ͼ���������x����λ��,mean()֮�������䱾��
displx=validx-validxfirst;       %������������������x��λ��displx�Ǹ�����������������ڵ���������������Ƭ��
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %�����ֵ������
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic������ֵ
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20]; 
straincolor = [-0.3 0.3];       %ԭ����[-0.005 0.03] �����޸�Ϊ[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %�ҳ����/��С��λ��ֵ����
maxminusminvalidy=(max(max(validy))-min(min(validy))); %�⴦�����޸ģ�����һ��validx�ĳ���validy������ԭ���Ǳ���!
displ=sqrt(displx.^2+disply.^2);   %���ĳһ�����λ��
axes(handles.axes3);
figure;
for i=1:(loopimages-1)             
	ZIX=griddata(validx(:,i),validy(:,i),displx(:,i),XI,YI,'cubic'); 
    ZIXsize=size(ZIX);
    [FX,FY]=gradient(ZIX,(maxminusminvalidx/ZIXsize(1,1)),(maxminusminvalidy/ZIXsize(1,2)));% FX=ƫu/ƫx=ex FY=ƫu/ƫy [FX,FY]=gradient(F)������F����΢����ȡ����x��Ӧ��
    pcolor(XI,YI,FX)
	axis('equal')          %axis�������������С���ֵ �÷�axis([xmin,xmax,ymin,ymax]) axis equal �����������ȡ�ȳ��̶�   hold on���ֵ�ǰͼ�δ���
    shading('interp')
    caxis(straincolor)      %�趨��ɫ������ caxis(V),V��������Ԫ����ɵ�����[cmin,cmax]
    colorbar('EastOutside');              %�趨�����С
    title(  ['ROI����X��Ӧ��'] )
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
validxfirst=zeros(size(validx)); %����һ����validx��С��ͬ�ľ���
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %������һ��ͼ���[1...........1(��Ƭ����)]��validx��:,1����һ��ͼ���������x����λ��
displx=validx-validxfirst;  %������������������x��λ��displx�Ǹ�����������������ڵ���������������Ƭ��
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
displ=sqrt(displx.^2+disply.^2);
grid_x=handles.grid_x;
[radial circumference]=size(grid_x);      %������������� size(grid_y)Ҳ�� ����
T=displ(:,loopimages);   %��ȡ���һ��ͼ�������нڵ��λ��
for i=1:circumference                         %��Ϊdispl����������ȡ������ǣ����ڵ��⣬ͬһ�뾶����ʱ��ȡ��
ddirec(i,:)=T(radial*(i-1)+1:radial*i,1);
end                                 %���������λ�ƾ���ddirec[theta,r] �б�ʾͬһ�Ƕ��¾���ȥ��λ�ã��б�ʾͬһ�����²�ͬ�Ƕ�ȡ��
h=6;      %����=6
E=71.7;   %����ģ��E=71.7GPa 
r0=63;    %�׾�r0=63 
v=0.33;
stresscolor=[0 100];
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));% ����Բ�İ뾶
for i=1:radial     %�����־����
    for t=1:circumference   %Բ�ܱ�־����
        A(t,i)=(1+v)*r(1,i)/2*E+h/4*E*cos(2*(t-1)*pi/180);  % A=r0*(1+v)*a/2*E B=r0*b/2*E a=r/r0 b=h/2*r0 
        B(t,i)=(1+v)*r(1,i)/2*E-h/4*E*cos(2*(t-1)*pi/180);
        C(t,i)=2*h/4*E*sin(2*(t-1)*pi/180);
    end                               %ͨ���ⲽ���Ի��ϵ������[A=A+2Bcos(theta)] [B=A+2Bcos(theta)] [C=2B*sin(theta)]
        coe=[A(:,i) B(:,i) C(:,i)];                   %����ϵ������
        stress(:,i)=inv(coe'*coe)*coe'*ddirec(:,i)*1000;%����С���˷����[stressx stressy shearxy] �����λΪMPa inv��������Ĺ���
end
xlswrite('stress',stress)
%������������Ӧ��
for i=1:radial           %MTS�������С��Ӧ��main true stress % MTS(1,1)�����Ӧ�� MTS(2,1)��С��Ӧ�� MTS(3,1)�����
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
sizevalidx=size(validx);                         %validx validy��һ���������������������������������Ƭ���� ��ֵ������κ������������
sizevalidy=size(validy);                         %size��������һ��������[validx���� validx����]
looppoints=sizevalidx(1,1);  %�ܹ��Ľ�����                    
loopimages=sizevalidx(1,2);  %�ܹ�����Ƭ��
%calculate the displacement relative to the first image in x and y direction �����������x����y���λ��
clear displx;
validxfirst=zeros(size(validx)); %����һ����validx��С��ͬ�ľ���
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %������һ��ͼ���[1...........1(��Ƭ����)]��validx��:,1����һ��ͼ���������x����λ��
displx=validx-validxfirst;       %������������������x��λ��displx�Ǹ�����������������ڵ���������������Ƭ��
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %�����ֵ������
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic������ֵ
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20];               %ԭ����[-7 1] �����޸�Ϊ[-20 20] 
straincolor = [-0.3 0.3];       %ԭ����[-0.005 0.03] �����޸�Ϊ[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %�ҳ����/��С��λ��ֵ����
maxminusminvalidy=(max(max(validy))-min(min(validy))); %�⴦�����޸ģ�����һ��validx�ĳ���validy������ԭ���Ǳ���!
displ=sqrt(displx.^2+disply.^2);   %���ĳһ�����λ��
figure;
for i=1:(loopimages-1)             %���ÿ����Ƭy�����Ӧ��ey
	ZIY=griddata(validx(:,i),validy(:,i),disply(:,i),XI,YI,'cubic'); 			
    ZIYsize=size(ZIY);
    [GX,GY]=gradient(ZIY,(maxminusminvalidx/ZIYsize(1,1)),(maxminusminvalidy/ZIYsize(1,2)));% GX=ƫv/ƫx GY=ƫv/ƫy=ey
	pcolor(XI,YI,GY)
    axis('equal')
    shading('interp')
    caxis(straincolor)
    colorbar('EastOutside');                                   %�� 962 963 964��ɾ�� ��ʱ����colorbar('EastOutside')�������У������滹Ҫ�Ľ�
    title(['ROI����Y��Ӧ��'])
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
sizevalidx=size(validx);                         %validx validy��һ���������������������������������Ƭ���� ��ֵ������κ������������
sizevalidy=size(validy);                         %size��������һ��������[validx���� validx����]
looppoints=sizevalidx(1,1);  %�ܹ��Ľ�����                    
loopimages=sizevalidx(1,2);  %�ܹ�����Ƭ��
%calculate the displacement relative to the first image in x and y direction �����������x����y���λ��
clear displx;
validxfirst=zeros(size(validx)); %����һ����validx��С��ͬ�ľ���
validxfirst=mean(validx(:,1),2)*ones(1,sizevalidx(1,2)); %������һ��ͼ���[1...........1(��Ƭ����)]��validx��:,1����һ��ͼ���������x����λ��
displx=validx-validxfirst;       %������������������x��λ��displx�Ǹ�����������������ڵ���������������Ƭ��
clear validxfirst
clear disply;
validyfirst=zeros(size(validy));
validyfirst=mean(validy(:,1),2)*ones(1,sizevalidy(1,2));
disply=validy-validyfirst;
clear validyfirst
theta=0:pi/180:2*pi;                %�����ֵ������
amp1=handles.amp1;
amp2=handles.amp2;
circleParaXYR=handles.circleParaXYR;
r=round(amp1*circleParaXYR(1,3)):1:round(amp2*circleParaXYR(1,3));
[theta,r]=meshgrid(theta,r);
XI=circleParaXYR(1,2)+r.*cos(theta);
YI=circleParaXYR(1,1)+r.*sin(theta);
ZIX=griddata(validx(:,1),validy(:,1),displx(:,1),XI,YI,'cubic'); % cubic������ֵ
ZIXsize=size(ZIX);
ZIY=griddata(validx(:,1),validy(:,1),disply(:,1),XI,YI,'cubic');
ZIYsize=size(ZIY);
displcolor = [-20 20];               %ԭ����[-7 1] �����޸�Ϊ[-20 20] 
straincolor = [-0.3 0.3];       %ԭ����[-0.005 0.03] �����޸�Ϊ[-0.3 0.3]
maxminusminvalidx=(max(max(validx))-min(min(validx))); %�ҳ����/��С��λ��ֵ����
maxminusminvalidy=(max(max(validy))-min(min(validy))); %�⴦�����޸ģ�����һ��validx�ĳ���validy������ԭ���Ǳ���!
displ=sqrt(displx.^2+disply.^2);   %���ĳһ�����λ��
for i=1:(loopimages-1)             
	ZIX=griddata(validx(:,i),validy(:,i),displx(:,i),XI,YI,'cubic'); 
    ZIXsize=size(ZIX);
    [FX,FY]=gradient(ZIX,(maxminusminvalidx/ZIXsize(1,1)),(maxminusminvalidy/ZIXsize(1,2)));% FX=ƫu/ƫx=ex FY=ƫu/ƫy [FX,FY]=gradient(F)������F����΢����ȡ����x��Ӧ��
end
for i=1:(loopimages-1)             %���ÿ����Ƭy�����Ӧ��ey
	ZIY=griddata(validx(:,i),validy(:,i),disply(:,i),XI,YI,'cubic'); 			
    ZIYsize=size(ZIY);
    [GX,GY]=gradient(ZIY,(maxminusminvalidx/ZIYsize(1,1)),(maxminusminvalidy/ZIYsize(1,2)));% GX=ƫv/ƫx GY=ƫv/ƫy=ey
end
ShearXY=FY+GX;         %�����Ӧ��
figure;
ZI=ShearXY;
pcolor(XI,YI,ZI)
axis('equal')          %axis�������������С���ֵ �÷�axis([xmin,xmax,ymin,ymax]) axis equal �����������ȡ�ȳ��̶�   hold on���ֵ�ǰͼ�δ���
shading('interp')
caxis(straincolor)      %�趨��ɫ������ caxis(V),V��������Ԫ����ɵ�����[cmin,cmax]
colorbar('EastOutside');               %�趨�����С
title(['ROI�����Ӧ�� '])
drawnow; 
save ShearXY.dat ShearXY -ascii -tabs