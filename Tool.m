function varargout = Tool(varargin)
% TOOL MATLAB code for Tool.fig
%      TOOL, by itself, creates a new TOOL or raises the existing
%      singleton*.
%
%      H = TOOL returns the handle to a new TOOL or the handle to
%      the existing singleton*.
%
%      TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TOOL.M with the given input arguments.
%
%      TOOL('Property','Value',...) creates a new TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tool

% Last Modified by GUIDE v2.5 14-May-2013 11:11:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tool_OpeningFcn, ...
                   'gui_OutputFcn',  @Tool_OutputFcn, ...
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


% --- Executes just before Tool is made visible.
function Tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tool (see VARARGIN)

% Creating the initial whole brain data
global annot100;
global annot200;
global onto;
annot100 = load('100.mat');
annot100 = annot100.ANOGD;

annot200 = load('200.mat');
annot200 = annot200.ANOGD;
onto = load('Ontology.mat');
onto = onto.str;
Initialize(handles, hObject);

% Choose default command line output for Tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function Initialize(handles, hObject)
global annot;
global annot100;
global annot200;
global lowRes;
lowRes = get(handles.lowRes, 'Value');
annot = annot200;
if lowRes == 0
    annot = annot100;
end

% Sliders
sliderMax = size(annot,3);
set(handles.sliceSlider, 'Max', sliderMax);

plane = get(handles.sliceSlider, 'Value');
arrayfun(@cla,findall(0,'type','axes'));
Draw_Region(handles, '"root"', floor(plane), '.b');

%DrawSaved(handles,plane);
    
    

reg = get(handles.regionName, 'String');
if length(reg) ~= 0
    regions = strread(char(reg),'%s','delimiter',';');
    colors = {'.k','.g','.y','.m','.c'};
    for i = 1: length(regions)
        Draw_Region(handles, sprintf('"%s"',regions{i}), floor(plane), char(colors(mod(i,5)+1)));
    end
end

function DrawSaved(handles,plane)
global lowRes;
if lowRes == 0
    load allVoxels.mat;
    index = find(all(:,3) == floor(plane));
    x = all(index,1);
    y = all(index,2);
    z = all(index,3);
    plot3(handles.axes,x,y,z,'.r');
    hold(handles.axes,'on');
end

function Draw_Region(handles, abrv, plane, color)
%zoom on;
global annot;
global onto;
[~,ind] = ismember(abrv,onto(:,4));
id = str2num(char(onto(ind,1)));
voxels = getVoxels(id,onto,annot);
[i,j,k] = ind2sub(size(annot),voxels);

maxX = size(annot,1)+10;
maxY = size(annot,2)+10;
maxZ = size(annot,3)+10;


% Axonal Plane
axes(handles.axonal);
plot3(handles.axonal,i,j,k,color);
hold(handles.axonal,'on');
axis(handles.axonal,[0 maxX 0 maxY 0 maxZ]);
view(handles.axonal,[0,0]);
picTitle = sprintf('%s, Axonal Plane=%d', abrv, plane);
xlabel(handles.axonal,'X axis');
ylabel(handles.axonal,'Y axis');
zlabel(handles.axonal,'Z axis');
title(handles.axonal,picTitle);

x = [0,0,maxX,maxX,0];
y = [0,maxY,maxY,0,0];
z = [plane,plane,plane,plane,plane];
plot3(handles.axonal,x,y,z,'-r','LineWidth', 5);
axes(handles.axonal);
fill3(x,y,z,'r');
hold(handles.axonal,'on');
grid(handles.axonal,'on');
alpha(0.3);

% Displaying the slice in the sagittal plane
indices = find(k==plane);
i = i(indices);
j = j(indices);
k = k(indices);
axes(handles.axes);
plot3(handles.axes,i,j,k,color);
hold(handles.axes,'on');

axis(handles.axes,[0 maxX 0 maxY 0 maxZ]);
view(handles.axes,[0,-90]);
picTitle = sprintf('%s, Plane=%d', abrv, plane);
xlabel(handles.axes,'X axis');
ylabel(handles.axes,'Y axis');
zlabel(handles.axes,'Z axis');
title(handles.axes,picTitle);
hold(handles.axes,'on');

figHandle = findall(0,'type','figure');
dcm_obj = datacursormode(figHandle);
set(dcm_obj, 'updatefcn', @myfunction);
DrawSaved(handles,plane);

function output_txt = myfunction(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).

output_txt = {''};    

% --- Outputs from this function are returned to the command line.
function varargout = Tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in displayBttn.
function displayBttn_Callback(hObject, eventdata, handles)
% hObject    handle to displayBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
regionName = get(handles.regionName, 'String');

regions = strread(char(regionName),'%s','delimiter',';');

plane = get(handles.sliceSlider, 'Value');
colors = {'.k','.g','.y','.m','.c'};
for i =1 : length(regions)
    regionName = sprintf('"%s"',regions{i});
    if(length(regionName ~= 0))
        try
            Draw_Region(handles, regionName, floor(plane), char(colors(mod(i,5)+1)));
            set(handles.messageString, 'String', '');
        catch
            set(handles.messageString, 'String', 'Region not found!');
        end
    else
        set(handles.messageString, 'String', 'Please type a region Acronym first');
    end
end



function regionName_Callback(hObject, eventdata, handles)
% hObject    handle to regionName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regionName as text
%        str2double(get(hObject,'String')) returns contents of regionName as a double


% --- Executes during object creation, after setting all properties.
function regionName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regionName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in resetBttn.
function resetBttn_Callback(hObject, eventdata, handles)
% hObject    handle to resetBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Initialize(handles, hObject);


% --- Executes on slider movement.
function sliceSlider_Callback(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
plane = get(handles.sliceSlider, 'Value');
oldText = get(handles.sagittalText, 'String');
splits = regexp(oldText, 'Slice', 'split');
text = sprintf('%sSlice, %d', splits{1}, floor(plane)); 
set(handles.sagittalText, 'String', text);



% --- Executes during object creation, after setting all properties.
function sliceSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on sliceSlider and none of its controls.
function sliceSlider_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to sliceSlider (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in saveBttn.
function saveBttn_Callback(hObject, eventdata, handles)
% hObject    handle to saveBttn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    dcm_obj = datacursormode(get(0,'CurrentFigure'));
    info = getCursorInfo(dcm_obj);
    points = [];
    for i = 1 : length(info)
        points = [points; info(i).Position];
    end;
    filename = sprintf('%s_%d_%s.mat', get(handles.regionName, 'String'), floor(get(handles.sliceSlider, 'Value')), datestr(clock, 0));
    filename = strrep(filename, ':', '_');
    save(filename, 'points');
    set(handles.messageString, 'String', sprintf('Points saved to: %s', filename));
catch 
    set(handles.messageString, 'String','No data points selected!');
end
