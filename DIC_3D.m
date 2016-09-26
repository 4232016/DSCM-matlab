function varargout = DIC_3D(varargin)
% DIC_3D MATLAB code for DIC_3D.fig
%      DIC_3D, by itself, creates a new DIC_3D or raises the existing
%      singleton*.
%
%      H = DIC_3D returns the handle to a new DIC_3D or the handle to
%      the existing singleton*.
%
%      DIC_3D('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIC_3D.M with the given input arguments.
%
%      DIC_3D('Property','Value',...) creates a new DIC_3D or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIC_3D_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIC_3D_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIC_3D

% Last Modified by GUIDE v2.5 09-Aug-2016 16:28:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIC_3D_OpeningFcn, ...
                   'gui_OutputFcn',  @DIC_3D_OutputFcn, ...
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


% --- Executes just before DIC_3D is made visible.
function DIC_3D_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DIC_3D (see VARARGIN)

% Choose default command line output for DIC_3D
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIC_3D wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DIC_3D_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in imageread.
function imageread_Callback(hObject, eventdata, handles)
% hObject    handle to imageread (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileNameBase,PathNameBase,FilterIndex] = uigetfile({'*.bmp';'*.BMP';'*.tif';'*.jpg'},'选择左相机基础图片'); % 选择左相机的基础图像
if  ~isempty(FileNameBase) ;                                          %假如文件名不为空时，if成立
    cd(PathNameBase);                                                 %改变当前工作路径到图像所在文件夹
    addpath(PathNameBase); 
end
if FilterIndex          % 若选择了图片文件
    str = [PathNameBase FileNameBase];
    left_image = im2double(imread(str));
    image_size = size(left_image);
    left_image_small = gauss_pyramid(left_image);
    axes(handles.imageL);
    imshow(left_image_small,'InitialMagnification',100);
    axis on;
end
[fname2,pname2,FilterIndex] = uigetfile({'*.bmp';'*.BMP';'*.tif';'*.jpg'},'选择右相机基础图片'); % 选择右相机的基础图像
if FilterIndex          % 若选择了图片文件
    str2 = [pname2 fname2];
    right_image = im2double(imread(str2));
    right_image_small = gauss_pyramid(right_image);
    axes(handles.imageR);
    imshow(right_image_small,'InitialMagnification',100);
    axis on;
end
    addpath(pname2); 
    
[file_path] = uigetdir('','选择保存临时数据的文件夹！');
if  ~isempty(file_path) ;                                             
    addpath(file_path);                                                 
end
    

uiwait(msgbox('接下来创建左相机所测图像的文件名列表！','提示','non-modal'));
[filenamelist_L] = filelist_generator(PathNameBase,FileNameBase);
cd(file_path);
save('filenamelist_L.mat','filenamelist_L');
uiwait(msgbox('接下来创建右相机所测图像的文件名列表！','提示','non-modal'));
[filenamelist_R] = filelist_generator(pname2,fname2);
cd(file_path);
save('filenamelist_R.mat','filenamelist_R');

uiwait(msgbox('文件名列表创建完成！','提示','non-modal'));

handles.FileNameBase = FileNameBase;
handles.PathNameBase = PathNameBase;
handles.left_image = left_image;
handles.left_image_small = left_image_small;
handles.pname2 = pname2;
handles.right_image = right_image;
handles.right_image_small = right_image_small;
handles.image_size = image_size;
handles.file_path = file_path;
guidata(hObject,handles);


% --- Executes on button press in rect_image.
function rect_image_Callback(hObject, eventdata, handles)
% hObject    handle to rect_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PathNameBase = handles.PathNameBase;
pname2 = handles.pname2;
image_size = handles.image_size;
file_path = handles.file_path;

uiwait(msgbox('接下来利用相机标定数据矫正已拍摄的图像！','提示','non-modal'));
  
Load_Calib_Data;

cd(file_path);
load('filenamelist_L.mat');
load('filenamelist_R.mat');

[om_new T_new KK_left_new KK_right_new,filenamelist_L,filenamelist_R]=rectify_stereo(KK_left,kc_left,KK_right,kc_right,om,T,filenamelist_L,filenamelist_R,image_size,PathNameBase,pname2);
cd(file_path);
save('filenamelist_L.mat','filenamelist_L');
save('filenamelist_R.mat','filenamelist_R');
save Calib_Results_rectified om_new T_new KK_left_new KK_right_new
cd(PathNameBase);
left_image = im2double(imread(filenamelist_L(1,:)));
cd(pname2);
right_image = im2double(imread(filenamelist_R(1,:)));
cd(file_path);
uiwait(msgbox('图像矫正已完成！','提示','non-modal'));

handles.left_image = left_image;
handles.right_image = right_image;
guidata(hObject,handles);


% --- Executes on button press in grid.
function grid_Callback(hObject, eventdata, handles)
% hObject    handle to grid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if exist('grid_x_L','var')~=1
    grid_x_L=[];
end

if exist('grid_y_L','var')~=1
    grid_y_L=[];
end

PathNameBase = handles.PathNameBase;
pname2 = handles.pname2;
file_path = handles.file_path;
left_image = handles.left_image;
right_image = handles.right_image;
left_image_small = gauss_pyramid(left_image);
right_image_small = gauss_pyramid(right_image);


%-----------  是否加载已有网格数据       -----------
%if loadgrid
loadoldgrid=menu(sprintf('加载已有网格?'),...
'是','否');

if loadoldgrid==1
    
    cd(file_path);
    
    grid_x_L=importdata('grid_x_L.dat','\t');
    grid_y_L=importdata('grid_y_L.dat','\t');
    display_grid_x_L = grid_x_L/2;
    display_grid_y_L = grid_y_L/2;
    axes(handles.imageL);
    imshow(left_image_small,'InitialMagnification',100);axis on;
    hold on                          
    plot(display_grid_x_L, display_grid_y_L,'+r')
    hold off;
    
    grid_x_R=importdata('grid_x_R.dat','\t');
    grid_y_R=importdata('grid_y_R.dat','\t');
    display_grid_x_R = grid_x_R/2;
    display_grid_y_R = grid_y_R/2;
    axes(handles.imageR);
    imshow(right_image_small,'InitialMagnification',100);axis on;
    hold on                          
    plot(display_grid_x_R, display_grid_y_R,'+r')
    hold off;
    
    Grid_data = load('Grid.mat');
    Grid = getfield(Grid_data,'Grid');
    
end

 cd(PathNameBase); 
 axes(handles.imageL);

% ----------------  重新画网格 ------------- 
 generator_grid = 1;

while generator_grid == 1
    gridselection = menu(sprintf('网格创建主菜单'),'矩形','生成右相机网格','完成');

    % -----------矩形网格--------------
    if gridselection==1
        trygrid = 1;
        while trygrid
            axes(handles.imageL);
            imshow(left_image_small,'InitialMagnification',100);axis on;
            uiwait(msgbox('请选择要分析的区域：单击选取该区域左上角的点和右下角的点形成矩形网格！','提示','non-modal'));
            k = 2;
            while k
                waitforbuttonpress;
                pos=get(handles.imageL,'currentpoint');
                x(3-k,1)=round(pos(1,1));
                y(3-k,1)=round(pos(1,2));
                hold on
                plot(x(3-k,1),y(3-k,1),'+b')
                k = k-1;
            end
           [grid_x_L,grid_y_L,generator_grid,trygrid,Grid] = rect_grid(left_image_small,x,y,file_path);
       end
   end

   
    % 画右相机图像网格
    if gridselection==2
           cd(pname2); 
        if ~exist('grid_x_L')||isempty(grid_x_L)               %判断grid_x_L文件是否存在
            uiwait(msgbox('请先给左相机图像划分网格，再执行此操作！','提示','non-modal'));
            generator_grid = 1;
        else
            axes(handles.imageR);
            imshow(right_image_small,'InitialMagnification',100);axis on;
            [grid_x_R,grid_y_R] = right_grid(grid_x_L,grid_y_L,left_image,right_image,file_path,Grid);
            hold on                                         % 显示右相机基础图像的网格
            grid_x_R = grid_x_R/2;
            grid_y_R = grid_y_R/2;
            plot(grid_x_R, grid_y_R,'+r')
            hold off;
            generator_grid = 1;
        end      
    end
    
    % 完成
    if gridselection==3,
       axes(handles.imageL);
       cla;
       imshow(left_image_small,'InitialMagnification',100);axis on;
       axes(handles.imageR);
       cla;
       imshow(right_image_small,'InitialMagnification',100);axis on;
       cd(file_path);
       generator_grid = 0;
    end;
end

handles.left_image_small = left_image_small;
handles.right_image_small = right_image_small;

guidata(hObject,handles);


% --- Executes on button press in automate.
function automate_Callback(hObject, eventdata, handles)
% hObject    handle to automate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

left_image = handles.left_image;
right_image = handles.right_image;
file_path = handles.file_path;
left_image_small = handles.left_image_small;
right_image_small = handles.right_image_small;

cd(file_path); 

docpcorr = 1;
while docpcorr == 1;
    cameraselection = menu(sprintf('选择相关计算的图像'),...
        '左相机图像','右相机图像','完成');
  %---------------左相机图像相关计算----------------    
    if cameraselection==1 
        
         axes(handles.imageL);
         imshow(left_image_small,'InitialMagnification',100);axis on;

        if exist('grid_x_L')==0               %加载x方向网格
            load('grid_x_L.dat');            
        end
        if exist('grid_y_L')==0               %加载y方向网格
            load('grid_y_L.dat');            
        end
        if exist('filenamelist_L')==0           %加载图片列表
            load('filenamelist_L');       
        end

          title('初始化图像相关计算的网格点 (绿色十字点)')        
          hold on
          display_grid_x_L = grid_x_L/2;
          display_grid_y_L = grid_y_L/2;
          plot(display_grid_x_L,display_grid_y_L,'g+')                    % 显示网格点
          uiwait(msgbox('开始进行相关计算，请耐心等待！','提示','non-modal'));

         [validx_L,validy_L]=automate_image(grid_x_L,grid_y_L,filenamelist_L);
         save validx_L.dat validx_L -ascii -tabs
         save validy_L.dat validy_L -ascii -tabs
         
         docpcorr = 1;
 
    end
 
 %---------------右相机图像相关计算----------------
    if cameraselection==2
         axes(handles.imageR);
         imshow(right_image_small,'InitialMagnification',100);axis on;

        if exist('grid_x_R')==0               %加载x方向网格
            load('grid_x_R.dat')            
        end
        if exist('grid_y_R')==0               %加载y方向网格
            load('grid_y_R.dat')            
        end
        if exist('filenamelist_R')==0           %加载图片列表
            load('filenamelist_R')        
        end

          title('初始化图像相关计算的网格点 (绿色十字点)')        
          hold on
          display_grid_x_R = grid_x_R/2;
          display_grid_y_R = grid_y_R/2;
          plot(display_grid_x_R,display_grid_y_R,'g+')                    % 显示网格点
          uiwait(msgbox('开始进行相关计算，请耐心等待！','提示','non-modal'));

         [validx_R,validy_R]=automate_image(grid_x_R,grid_y_R,filenamelist_R);
         save validx_R.dat validx_R -ascii -tabs
         save validy_R.dat validy_R -ascii -tabs
         
         docpcorr = 1;
 
    end
    
    %------------完成-----------
    if cameraselection==3
       axes(handles.imageL);
       cla;
       imshow(left_image_small,'InitialMagnification',100);axis on;
       axes(handles.imageR);
       cla;
       imshow(right_image_small,'InitialMagnification',100);axis on;
        docpcorr = 0;
    end
end


% --- Executes on button press in displace.
function displace_Callback(hObject, eventdata, handles)
% hObject    handle to displace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file_path = handles.file_path;

cd(file_path);
load('grid_x_L.dat');
load('grid_y_L.dat');
load('validx_L.dat');
load('validy_L.dat');
Grid_data = load('Grid.mat');
Grid = getfield(Grid_data,'Grid');
load('grid_x_R.dat');
load('grid_y_R.dat');
load('validx_R.dat');
load('validy_R.dat');
load('Calib_Results_rectified.mat');
  
[cordin] = cord_reconstruct(grid_x_L,grid_y_L,validx_L,validy_L,grid_x_R,grid_y_R,validx_R,validy_R,T_new,KK_left_new,KK_right_new);  % 计算网格点的三维坐标
save('cordin.mat','cordin');
[displx,disply,displz] = displ(cordin,Grid);         % 计算每一个网格点的位移
save('displacement.mat','displx','disply','displz');
uiwait(msgbox('位移计算完成！','提示','non-modal'));


% --- Executes on button press in strain.
function strain_Callback(hObject, eventdata, handles)
% hObject    handle to strain (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PathNameBase = handles.PathNameBase;a
pname2 = handles.pname2;
left_image = handles.left_image;
right_image = handles.right_image;
file_path = handles.file_path;

cd(file_path);
load('displacement.mat');
load('Grid.mat');
load('cordin.mat');

[bcs_x] = surffit(displx,Grid,xspacing,yspacing);   % 对X方向位移进行三次样条曲面拟合
[bcs_y] = surffit(disply,Grid,xspacing,yspacing);   % 对Y方向位移进行三次样条曲面拟合
[bcs_z] = surffit(displz,Grid,xspacing,yspacing);   % 对Z方向位移进行三次样条曲面拟合

a = size(Grid,2)/2;     % a为网格点的列数
b = size(Grid,1);       % b为网格点的行数

% ------------ 各个网格点三个方向的应变计算
prompt = {'输入需要分析应变的图像编号[0 表示所有图像]：'};
dlg_title = '输入图像编号';
num_lines= 1;
def     = {'0'};
answer = inputdlg(prompt,dlg_title,num_lines,def);
image_num = str2double(cell2mat(answer));

if image_num == 0
    k = size(displx,3);
    for i = 1:k
        [strain_xyz] = strain(displx,disply,displz,cordin,bcs_x,bcs_y,bcs_z,i,a,b);
    end
else
        [strain_xyz] = strain(displx,disply,displz,cordin,bcs_x,bcs_y,bcs_z,image_num,a,b);
end
