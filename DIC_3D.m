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
[FileNameBase,PathNameBase,FilterIndex] = uigetfile({'*.bmp';'*.BMP';'*.tif';'*.jpg'},'ѡ�����������ͼƬ'); % ѡ��������Ļ���ͼ��
if  ~isempty(FileNameBase) ;                                          %�����ļ�����Ϊ��ʱ��if����
    cd(PathNameBase);                                                 %�ı䵱ǰ����·����ͼ�������ļ���
    addpath(PathNameBase); 
end
if FilterIndex          % ��ѡ����ͼƬ�ļ�
    str = [PathNameBase FileNameBase];
    left_image = im2double(imread(str));
    image_size = size(left_image);
    left_image_small = gauss_pyramid(left_image);
    axes(handles.imageL);
    imshow(left_image_small,'InitialMagnification',100);
    axis on;
end
[fname2,pname2,FilterIndex] = uigetfile({'*.bmp';'*.BMP';'*.tif';'*.jpg'},'ѡ�����������ͼƬ'); % ѡ��������Ļ���ͼ��
if FilterIndex          % ��ѡ����ͼƬ�ļ�
    str2 = [pname2 fname2];
    right_image = im2double(imread(str2));
    right_image_small = gauss_pyramid(right_image);
    axes(handles.imageR);
    imshow(right_image_small,'InitialMagnification',100);
    axis on;
end
    addpath(pname2); 
    
[file_path] = uigetdir('','ѡ�񱣴���ʱ���ݵ��ļ��У�');
if  ~isempty(file_path) ;                                             
    addpath(file_path);                                                 
end
    

uiwait(msgbox('�������������������ͼ����ļ����б�','��ʾ','non-modal'));
[filenamelist_L] = filelist_generator(PathNameBase,FileNameBase);
cd(file_path);
save('filenamelist_L.mat','filenamelist_L');
uiwait(msgbox('�������������������ͼ����ļ����б�','��ʾ','non-modal'));
[filenamelist_R] = filelist_generator(pname2,fname2);
cd(file_path);
save('filenamelist_R.mat','filenamelist_R');

uiwait(msgbox('�ļ����б�����ɣ�','��ʾ','non-modal'));

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

uiwait(msgbox('��������������궨���ݽ����������ͼ��','��ʾ','non-modal'));
  
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
uiwait(msgbox('ͼ���������ɣ�','��ʾ','non-modal'));

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


%-----------  �Ƿ����������������       -----------
%if loadgrid
loadoldgrid=menu(sprintf('������������?'),...
'��','��');

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

% ----------------  ���»����� ------------- 
 generator_grid = 1;

while generator_grid == 1
    gridselection = menu(sprintf('���񴴽����˵�'),'����','�������������','���');

    % -----------��������--------------
    if gridselection==1
        trygrid = 1;
        while trygrid
            axes(handles.imageL);
            imshow(left_image_small,'InitialMagnification',100);axis on;
            uiwait(msgbox('��ѡ��Ҫ���������򣺵���ѡȡ���������Ͻǵĵ�����½ǵĵ��γɾ�������','��ʾ','non-modal'));
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

   
    % �������ͼ������
    if gridselection==2
           cd(pname2); 
        if ~exist('grid_x_L')||isempty(grid_x_L)               %�ж�grid_x_L�ļ��Ƿ����
            uiwait(msgbox('���ȸ������ͼ�񻮷�������ִ�д˲�����','��ʾ','non-modal'));
            generator_grid = 1;
        else
            axes(handles.imageR);
            imshow(right_image_small,'InitialMagnification',100);axis on;
            [grid_x_R,grid_y_R] = right_grid(grid_x_L,grid_y_L,left_image,right_image,file_path,Grid);
            hold on                                         % ��ʾ���������ͼ�������
            grid_x_R = grid_x_R/2;
            grid_y_R = grid_y_R/2;
            plot(grid_x_R, grid_y_R,'+r')
            hold off;
            generator_grid = 1;
        end      
    end
    
    % ���
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
    cameraselection = menu(sprintf('ѡ����ؼ����ͼ��'),...
        '�����ͼ��','�����ͼ��','���');
  %---------------�����ͼ����ؼ���----------------    
    if cameraselection==1 
        
         axes(handles.imageL);
         imshow(left_image_small,'InitialMagnification',100);axis on;

        if exist('grid_x_L')==0               %����x��������
            load('grid_x_L.dat');            
        end
        if exist('grid_y_L')==0               %����y��������
            load('grid_y_L.dat');            
        end
        if exist('filenamelist_L')==0           %����ͼƬ�б�
            load('filenamelist_L');       
        end

          title('��ʼ��ͼ����ؼ��������� (��ɫʮ�ֵ�)')        
          hold on
          display_grid_x_L = grid_x_L/2;
          display_grid_y_L = grid_y_L/2;
          plot(display_grid_x_L,display_grid_y_L,'g+')                    % ��ʾ�����
          uiwait(msgbox('��ʼ������ؼ��㣬�����ĵȴ���','��ʾ','non-modal'));

         [validx_L,validy_L]=automate_image(grid_x_L,grid_y_L,filenamelist_L);
         save validx_L.dat validx_L -ascii -tabs
         save validy_L.dat validy_L -ascii -tabs
         
         docpcorr = 1;
 
    end
 
 %---------------�����ͼ����ؼ���----------------
    if cameraselection==2
         axes(handles.imageR);
         imshow(right_image_small,'InitialMagnification',100);axis on;

        if exist('grid_x_R')==0               %����x��������
            load('grid_x_R.dat')            
        end
        if exist('grid_y_R')==0               %����y��������
            load('grid_y_R.dat')            
        end
        if exist('filenamelist_R')==0           %����ͼƬ�б�
            load('filenamelist_R')        
        end

          title('��ʼ��ͼ����ؼ��������� (��ɫʮ�ֵ�)')        
          hold on
          display_grid_x_R = grid_x_R/2;
          display_grid_y_R = grid_y_R/2;
          plot(display_grid_x_R,display_grid_y_R,'g+')                    % ��ʾ�����
          uiwait(msgbox('��ʼ������ؼ��㣬�����ĵȴ���','��ʾ','non-modal'));

         [validx_R,validy_R]=automate_image(grid_x_R,grid_y_R,filenamelist_R);
         save validx_R.dat validx_R -ascii -tabs
         save validy_R.dat validy_R -ascii -tabs
         
         docpcorr = 1;
 
    end
    
    %------------���-----------
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
  
[cordin] = cord_reconstruct(grid_x_L,grid_y_L,validx_L,validy_L,grid_x_R,grid_y_R,validx_R,validy_R,T_new,KK_left_new,KK_right_new);  % ������������ά����
save('cordin.mat','cordin');
[displx,disply,displz] = displ(cordin,Grid);         % ����ÿһ��������λ��
save('displacement.mat','displx','disply','displz');
uiwait(msgbox('λ�Ƽ�����ɣ�','��ʾ','non-modal'));


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

[bcs_x] = surffit(displx,Grid,xspacing,yspacing);   % ��X����λ�ƽ������������������
[bcs_y] = surffit(disply,Grid,xspacing,yspacing);   % ��Y����λ�ƽ������������������
[bcs_z] = surffit(displz,Grid,xspacing,yspacing);   % ��Z����λ�ƽ������������������

a = size(Grid,2)/2;     % aΪ����������
b = size(Grid,1);       % bΪ����������

% ------------ ������������������Ӧ�����
prompt = {'������Ҫ����Ӧ���ͼ����[0 ��ʾ����ͼ��]��'};
dlg_title = '����ͼ����';
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
