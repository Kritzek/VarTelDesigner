function varargout = TestSliderAdjuster(varargin)
% TESTSLIDERADJUSTER MATLAB code for TestSliderAdjuster.fig
%      TESTSLIDERADJUSTER, by itself, creates a new TESTSLIDERADJUSTER or raises the existing
%      singleton*.
%
%      H = TESTSLIDERADJUSTER returns the handle to a new TESTSLIDERADJUSTER or the handle to
%      the existing singleton*.
%
%      TESTSLIDERADJUSTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TESTSLIDERADJUSTER.M with the given input arguments.
%
%      TESTSLIDERADJUSTER('Property','Value',...) creates a new TESTSLIDERADJUSTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TestSliderAdjuster_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TestSliderAdjuster_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TestSliderAdjuster

% Last Modified by GUIDE v2.5 21-Feb-2019 19:38:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TestSliderAdjuster_OpeningFcn, ...
                   'gui_OutputFcn',  @TestSliderAdjuster_OutputFcn, ...
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


% --- Executes just before TestSliderAdjuster is made visible.
function TestSliderAdjuster_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TestSliderAdjuster (see VARARGIN)

% Choose default command line output for TestSliderAdjuster
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TestSliderAdjuster wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TestSliderAdjuster_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function slider1_Callback(hObject, eventdata, handles)
handles.slidervalue.Value=handles.slider1.Value;
handles.slidervalue.String=num2str(handles.slider1.Value);


function slider1_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function slider1spec_Callback(hObject, eventdata, handles)
SliderAdjuster(handles.slider1,handles);



function slidervalue_Callback(hObject, eventdata, handles)


function slidervalue_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
