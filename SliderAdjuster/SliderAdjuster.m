function varargout = SliderAdjuster(varargin)
% SLIDERADJUSTER MATLAB code for SliderAdjuster.fig
%      SLIDERADJUSTER, by itself, creates a new SLIDERADJUSTER or raises the existing
%      singleton*.
%
%      H = SLIDERADJUSTER returns the handle to a new SLIDERADJUSTER or the handle to
%      the existing singleton*.
%
%      SLIDERADJUSTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLIDERADJUSTER.M with the given input arguments.
%
%      SLIDERADJUSTER('Property','Value',...) creates a new SLIDERADJUSTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SliderAdjuster_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SliderAdjuster_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SliderAdjuster

% Last Modified by GUIDE v2.5 21-Feb-2019 20:51:34

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SliderAdjuster_OpeningFcn, ...
                   'gui_OutputFcn',  @SliderAdjuster_OutputFcn, ...
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


% --- Executes just before SliderAdjuster is made visible.
function SliderAdjuster_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SliderAdjuster (see VARARGIN)

handles.sliderh=varargin{1};
handles.tguihans=varargin{2};
if ~strcmp(handles.sliderh.Style,'slider')
    disp(['Expected slider handle but got ',handles.sliderh.Style]);
end

handles.figure1.Name=[handles.figure1.Name,' for ', handles.sliderh.Tag];

% Choose default command line output for SliderAdjuster
handles.output = hObject;

UpdateGui(handles);
guidata(hObject, handles);

% UIWAIT makes SliderAdjuster wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SliderAdjuster_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;


function smin_Callback(hObject, eventdata, handles)
val = GetNumEdit(hObject);
if handles.sliderh.Value < val
    handles.sliderh.Value = val;
end
 handles.sliderh.Min = val;
UpdateGui(handles);
guidata(hObject, handles);


function smin_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function smax_Callback(hObject, eventdata, handles)
val = GetNumEdit(hObject);
if handles.sliderh.Value > val
    handles.sliderh.Value = val;
end
 handles.sliderh.Max = val;
UpdateGui(handles);
guidata(hObject, handles);



function smax_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cval_Callback(hObject, eventdata, handles)
val = GetNumEdit(hObject);
if handles.autominmax.Value
    oran=find([(val>handles.sliderh.Max ),(val<handles.sliderh.Min)]);
    if isempty(oran)
        oran=0;
    end
    switch oran
        case 0
            handles.sliderh.Value = val;
        case 1
            handles.sliderh.Max=val;
            handles.sliderh.Value = val;
        case 2    
            handles.sliderh.Min=val;
            handles.sliderh.Value = val;
    end
else
    if (handles.sliderh.Max >= val) & (handles.sliderh.Min <= val)
        handles.sliderh.Value = val;
    else
        handles.status.String='Value out of Range';
    end
end
UpdateGui(handles);
guidata(hObject, handles);



function cval_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function cstep_Callback(hObject, eventdata, handles)
val = GetNumEdit(hObject);
AdjustStep(handles);



function cstep_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function exec_Callback(hObject, eventdata, handles)
evdat.Source=hObject;
evdat.EventName='SliderAdjusterCall';
feval(handles.sliderh.Callback,handles.sliderh,evdat);
UpdateGui(handles);


function fstep_Callback(hObject, eventdata, handles)
val = GetNumEdit(hObject);
AdjustStep(handles);



function fstep_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateGui(handles)
sh=handles.sliderh;
sstep=sh.SliderStep;
handles.smin.Value=sh.Min;
handles.smin.String=num2str(sh.Min);
handles.smax.Value=sh.Max;
handles.smax.String=num2str(sh.Max);
handles.cval.Value=sh.Value;
handles.cval.String=num2str(sh.Value);
sran=sh.Max-sh.Min;
handles.cstep.Value=sstep(2)*sran;
handles.cstep.String=num2str(sstep(2)*sran);
handles.fstep.Value=sstep(1)*sran;
handles.fstep.String=num2str(sstep(1)*sran);



function autominmax_Callback(hObject, eventdata, handles)


function refresh_Callback(hObject, eventdata, handles)
UpdateGui(handles)

function AdjustStep(handles)
%sstep=handles.sliderh.SliderStep;
sran=handles.sliderh.Max-handles.sliderh.Min;
crel=handles.cstep.Value/sran;
frel=handles.fstep.Value/sran;
handles.sliderh.SliderStep=[frel,crel];
handles.status.String=['SliderStep(relative) set to [',num2str(crel),',',num2str(frel),']'];
