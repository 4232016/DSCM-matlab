function varargout = calib_gui(varargin)
% CALIB_GUI MATLAB code for calib_gui.fig
%      CALIB_GUI, by itself, creates a new CALIB_GUI or raises the existing
%      singleton*.
%
%      H = CALIB_GUI returns the handle to a new CALIB_GUI or the handle to
%      the existing singleton*.
%
%      CALIB_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CALIB_GUI.M with the given input arguments.
%
%      CALIB_GUI('Property','Value',...) creates a new CALIB_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before calib_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to calib_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help calib_gui

% Last Modified by GUIDE v2.5 29-Aug-2016 20:10:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @calib_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @calib_gui_OutputFcn, ...
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


% --- Executes just before calib_gui is made visible.
function calib_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to calib_gui (see VARARGIN)

% Choose default command line output for calib_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes calib_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = calib_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inputimage_l.
function inputimage_l_Callback(hObject, eventdata, handles)
% hObject    handle to inputimage_l (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image_read;
Corner;


% --- Executes on button press in inputimage_r.
function inputimage_r_Callback(hObject, eventdata, handles)
% hObject    handle to inputimage_r (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image_read;
Corner;


% --- Executes on button press in Calibra_L.
function Calibra_L_Callback(hObject, eventdata, handles)
% hObject    handle to Calibra_L (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


go_calib;
load('Calib_Results_L.mat');
set(handles.fc1_l,'string',num2str(fc(1,1)));
set(handles.alpha_l,'string',num2str(alpha_c));
set(handles.cc1_l,'string',num2str(cc(1,1)));
set(handles.L21,'string','0');
set(handles.fc2_l,'string',num2str(fc(2,1)));
set(handles.cc2_l,'string',num2str(cc(2,1)));
set(handles.L31,'string','0');
set(handles.L32,'string','0');
set(handles.L33,'string','1');

% --- Executes on button press in Calibra_R.
function Calibra_R_Callback(hObject, eventdata, handles)
% hObject    handle to Calibra_R (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

go_calib;
load('Calib_Results_R.mat');
set(handles.fc1_r,'string',num2str(fc(1,1)));
set(handles.alpha_r,'string',num2str(alpha_c));
set(handles.cc1_r,'string',num2str(cc(1,1)));
set(handles.R21,'string','0');
set(handles.fc2_r,'string',num2str(fc(2,1)));
set(handles.cc2_r,'string',num2str(cc(2,1)));
set(handles.R31,'string','0');
set(handles.R32,'string','0');
set(handles.R33,'string','1');

% --- Executes on button press in stereo.
function stereo_Callback(hObject, eventdata, handles)
% hObject    handle to stereo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load_stereo_calib_files;   % 加载已有的相机标定数据

go_calib_stereo;           % 进行双目标定
data_dir = uigetdir(current_path,'选择标定数据保存文件夹');
cd(data_dir);
saving_stereo_calib;       % 保存标定结果
load('Calib_Results_stereo');

set(handles.om1,'string',num2str(om(1,1)));
set(handles.om2,'string',num2str(om(2,1)));
set(handles.om3,'string',num2str(om(3,1)));
set(handles.t1,'string',num2str(T(1,1)));
set(handles.t2,'string',num2str(T(2,1)));
set(handles.t3,'string',num2str(T(3,1)));
%stereo_gui;
