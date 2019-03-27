function varargout = VarTelDesigner(varargin)
% VARTELDESIGNER MATLAB code for VarTelDesigner.fig
%      VARTELDESIGNER, by itself, creates a new VARTELDESIGNER or raises the existing
%      singleton*.
%
%      H = VARTELDESIGNER returns the handle to a new VARTELDESIGNER or the handle to
%      the existing singleton*.
%
%      VARTELDESIGNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VARTELDESIGNER.M with the given input arguments.
%
%      VARTELDESIGNER('Property','Value',...) creates a new VARTELDESIGNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VarTelDesigner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VarTelDesigner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VarTelDesigner

% Last Modified by GUIDE v2.5 21-Feb-2019 15:57:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VarTelDesigner_OpeningFcn, ...
                   'gui_OutputFcn',  @VarTelDesigner_OutputFcn, ...
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


% --- Executes just before VarTelDesigner is made visible.
function VarTelDesigner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VarTelDesigner (see VARARGIN)

% Choose default command line output for VarTelDesigner

f1=0.250;
f2=-0.150;
f3=0.200;

setup=OpticalSetup();
setup.AddComp(OptComp_Drift(1));
setup.AddComp(OptComp_ThinLens(f1));
setup.AddComp(OptComp_Drift(1));
setup.AddComp(OptComp_ThinLens(f2));
setup.AddComp(OptComp_Drift(1));
setup.AddComp(OptComp_ThinLens(f3));
setup.AddComp(OptComp_Drift(1));
handles.solselect=[1,3,5,7];
setup.Solve2Image(handles.solselect);

handles.output = {setup,hObject};
handles.setup=setup;

%Enter lenses to listbox
handles.maglineh=[];

handles=RefreshLensPosPlot(hObject,handles,0);
RefreshTrace(handles);
Fill_eltable(handles);
handles.tabsel=[1,1];

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VarTelDesigner wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VarTelDesigner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function mag_Callback(hObject, eventdata, handles)
handles=RefreshLensPosPlot(hObject,handles,1);
RefreshTrace(handles);
Fill_eltable(handles);


function mag_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function length_Callback(hObject, eventdata, handles)
handles=RefreshLensPosPlot(hObject,handles,0);
RefreshTrace(handles);
Fill_eltable(handles);
guidata(hObject, handles);


function length_CreateFcn(hObject, eventdata, handles)

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function offset_Callback(hObject, eventdata, handles)
try val=str2num(hObject.String); end
if ~isempty(val)
    hObject.Value=val;
end
RefreshTrace(handles,0);


function offset_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function angle_Callback(hObject, eventdata, handles)
try val=str2num(hObject.String); end
if ~isempty(val)
    hObject.Value=val;
end
RefreshTrace(handles,0);


function angle_CreateFcn(hObject, eventdata, handles)

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function RefreshTrace(handles,apply)
m=-1/handles.mag.Value;
l=handles.length.Value;

if nargin <2
    apply=1; 
end

if apply
    handles.setup.ApplyDrifts(m,l);
end
 l=sum([handles.setup.complist.thick]);

offset=handles.offset.Value;
angle=handles.angle.Value;

if handles.conestyle.Value
    svek1=[offset,angle];
    svek2=[offset,-angle];
    svek3=[offset,0];
else
    svek1=[offset+angle,0];
    svek2=[offset-angle,0];
    svek3=[offset,0];
end
       
[pos1 amp1]=handles.setup.GetTrace(svek1);
[pos2 amp2]=handles.setup.GetTrace(svek2);
[pos3 amp3]=handles.setup.GetTrace(svek3);

handles.figure1.CurrentAxes=handles.trace;
plot(pos1,amp1,pos2,amp2,pos3,amp3);
xlim([0,l]);
%axes(ax1,[0,l,min([amp1,amp2,amp3]),max([amp1,amp2,amp3])]
hold on
for i=2:length(pos1)-1
    plot([pos1(i),pos1(i)],[-1,1],'r')
end
text(0.05,0.9,num2str(-1/m),'FontSize',20,'Units','normalized')
xlabel='Distance []m]';
ylabel='Amplitude';
title='Raytrace';
hold off
status=handles.setup.GetStatusText;
handles.status.String=status;

function handles=RefreshLensPosPlot(hObject,handles,markeronly)
mmin=-2;
mmax=-1/15;
m=linspace(mmin,mmax,500);
lsys=handles.length.Value;
ymin=-0.2;
ymax=lsys;
%Don't recalculate for simple moving of Mag marker
if ~markeronly
    [handles.dout handles.valids]=handles.setup.GetDrifts(m,lsys);
    handles.figure1.CurrentAxes=handles.distplot;
    [nd ~ ]= size(handles.dout);
    plot(flip(-1./m),flip(handles.dout(1,:)));
    hold on
    for i=2:nd
    plot(flip(-1./m),flip(handles.dout(i,:)));
    end
    plot([-1/mmin,-1/mmax],[0,0],'-r');
    symss=[handles.setup.complist(handles.setup.solinds).hid_sym];
    legend(arrayfun(@char, symss, 'uniform', 0),'Location','northeast');

    %Some additional Info
    handles.distplot.YLim(1)=ymin;
    handles.distplot.YLim(2)=ymax;
    %Valid Range
    valid=flip(handles.valids.*ymax);
    fill([flip(-1./m) -1./m ],[valid, zeros(size(valid))],'k','LineStyle','none')
    plot(-1./m,flip(valid),'r');
    alpha(0.15)
    %Current Magnification
end
cmag=handles.mag.Value;
% try
if ishandle(handles.maglineh)
    handles.maglineh.Visible='Off';
    handles.maglineh.delete;  
end
handles.maglineh=hgtransform(handles.distplot);
plot(handles.maglineh,[cmag,cmag],[ymin,ymax],'-b');
%rectangle('Position',[-8,ymin,1,ymax-ymin], 'FaceColor', [0 0 0 0.1])
hold off  
guidata(hObject, handles);


function conestyle_Callback(hObject, eventdata, handles)
RefreshTrace(handles,0);


function eltable_CellEditCallback(hObject, eventdata, handles)
dat=handles.eltable.Data';
switch eventdata.Indices(2)
    case 3
        solinds=find(cell2mat(dat(3,:)));
        handles.solselect=solinds;
    case 2 
        [handles.setup.complist.hid]=dat{2,:};
        if ~sum(eventdata.Indices(1) == handles.setup.solinds)
            handles=RefreshLensPosPlot(hObject,handles,0);
            RefreshTrace(handles,0);
        else
        RefreshTrace(handles,0);
        end
end
guidata(hObject, handles);


function Fill_eltable(handles)
nel=length(handles.setup.complist);
syms=[handles.setup.complist.hid_sym];
sstr = arrayfun(@char, syms, 'uniform', 0);
vals=[handles.setup.complist.hid];
edits=zeros(1,nel);
edits(handles.setup.solinds)=1;
edits=logical(edits(1:nel));
tabdat=cat(1,sstr,mat2cell(vals,1,ones(1,nel)),mat2cell(edits,1,ones(1,nel)));
handles.eltable.Data=tabdat';


function solveb_Callback(hObject, eventdata, handles)
handles.setup.Solve2Image(handles.solselect);
handles=RefreshLensPosPlot(hObject,handles,0);
RefreshTrace(handles);
Fill_eltable(handles);
% Update handles structure
guidata(hObject, handles);

function add_lens_Callback(hObject, eventdata, handles)
handles.setup.AddComp(OptComp_ThinLens(0.1));
Fill_eltable(handles);


function add_drift_Callback(hObject, eventdata, handles)
handles.setup.AddComp(OptComp_Drift(0.1));
Fill_eltable(handles);


function elremove_Callback(hObject, eventdata, handles)
handles.setup.complist(handles.tabsel(1))=[];
Fill_eltable(handles);
guidata(hObject, handles);


function eltable_CellSelectionCallback(hObject, eventdata, handles)
handles.tabsel=eventdata.Indices;
guidata(hObject, handles);
