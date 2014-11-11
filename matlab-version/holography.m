function varargout = holography(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @holography_OpeningFcn, ...
    'gui_OutputFcn',  @holography_OutputFcn, ...
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

function holography_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

% Global Variant
handles.lambda  = 532.8;
handles.dist    = 0;
handles.ccd     = 5;
handles.oriFlag = 0;
handles.bgFlag  = 0;
handles.brightness = 6;
handles.img     = 0;
handles.bg = 0;
% Global Filter switches
handles.filter = 'rdWindow';
handles.filter_med = 0;
handles.filter_mean = 0;
guidata(hObject, handles);

function varargout = holography_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function slider1_Callback(hObject, eventdata, handles)
handles.brightness = get(hObject,'Value') * 30;
axes(handles.dhPic);
imshow(handles.img * handles.brightness);
guidata(hObject,handles)

function slider1_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0.2);
guidata(hObject,handles)

function saveBtn_Callback(hObject, eventdata, handles)
[fname,pname,ext] = uiputfile({'*.bmp','BMP (*.bmp)';'*.jpg','JPEG (*.jpg)';'*.tif','TIF (*.tif)'}, '保存全息图');
imwrite(handles.img * handles.brightness, [pname,fname]);

function oriPic_CreateFcn(hObject, eventdata, handles)
set(gca,'Visible','off');

function bgPic_CreateFcn(hObject, eventdata, handles)
set(gca,'Visible','off');

function dhPic_CreateFcn(hObject, eventdata, handles)
set(gca,'Visible','off');

function oriPic_ButtonDownFcn(hObject, eventdata, handles)
[fn, pn, fi] = uigetfile({'*.bmp','BMP (*.bmp)';'*.jpg','JPEG (*.jpg)';'*.tif','TIF (*.tif)'}, '选择原图');
if [fn, pn]
    axes(handles.oriPic);
    set(gca, 'Visible', 'on');
    img = imread([pn fn]);
    handles.oriFlag = [pn, fn];
    imshow(img);
    guidata(hObject,handles)
end

function oriPanel_ButtonDownFcn(hObject, eventdata, handles)
[fn, pn, fi] = uigetfile({'*.bmp','BMP (*.bmp)';'*.jpg','JPEG (*.jpg)';'*.tif','TIF (*.tif)'}, '选择原图');
if [fn, pn]
    axes(handles.oriPic);
    set(gca, 'Visible', 'on');
    img = imread([pn fn]);
    imshow(img);
    handles.oriFlag = [pn, fn];
    guidata(hObject,handles)
end

function bgPic_ButtonDownFcn(hObject, eventdata, handles)
[fn, pn, fi] = uigetfile({'*.bmp','BMP (*.bmp)';'*.jpg','JPEG (*.jpg)';'*.tif','TIF (*.tif)'}, '选择背景图');
if [fn, pn]
    axes(handles.bgPic);
    set(gca, 'Visible', 'on');
    img = imread([pn fn]);
    imshow(img);
    handles.bgFlag = [pn, fn];
    guidata(hObject,handles)
end

function bgPanel_ButtonDownFcn(hObject, eventdata, handles)
[fn, pn, fi] = uigetfile({'*.bmp','BMP (*.bmp)';'*.jpg','JPEG (*.jpg)';'*.tif','TIF (*.tif)'}, '选择背景图');
if [fn, pn]
    axes(handles.bgPic);
    set(gca, 'Visible', 'on');
    img = imread([pn fn]);
    handles.bgFlag = [pn, fn];
    imshow(img);
    guidata(hObject,handles)
end

function lambda_Callback(hObject, eventdata, handles)
lambda = str2double(get(hObject, 'String'));
if isnan(lambda)
    set(hObject, 'String', 532.8);
    errordlg('请输入正确的数字！', '错误');
else
    handles.lambda = lambda;
end
guidata(hObject,handles)

function lambda_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edDist_Callback(hObject, eventdata, handles)
dist = str2double(get(hObject, 'String'));
if isnan(dist)
    set(hObject, 'String', 0);
    errordlg('请输入正确的数字！', '错误');
else
    handles.dist = dist;
end
guidata(hObject,handles)

function edDist_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function ccd_Callback(hObject, eventdata, handles)
ccd = str2double(get(hObject, 'String'));
if isnan(ccd)
    set(hObject, 'String', 5.0);
    errordlg('请输入正确的数字！', '错误');
else
    handles.ccd = ccd;
end
guidata(hObject,handles)

function ccd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function calcBtn_Callback(hObject, eventdata, handles)
set(handles.txtWarn, 'Visible', 'off');
if (~handles.oriFlag)
    errordlg('请选择原图！', '错误');
else
    handles.img = imread(handles.oriFlag);
    if (handles.bgFlag)
        handles.bg  = imread(handles.bgFlag);
        if (size(handles.img) == size(handles.bg))
            handles.img  = imsubtract(handles.img, handles.bg);
        else
            set(handles.txtWarn, 'string', '原图与背景图尺寸不符，使用默认背景!');
            set(handles.txtWarn, 'Visible', 'on');
        end
    end
    
    if(size(size(handles.img), 2) > 2) 
        handles.img=rgb2gray(handles.img);
    end
    % before calculate
    switch handles.filter
        case 'rdWindow'
            handles.img = WindowFilter(handles.img);
        case 'rdLaplace'
            handles.img = LaplaceFilter(handles.img);
    end
    % calculate
    handles.img = calculate(handles.img, handles.lambda / 1000, handles.dist * 1000, handles.ccd);
    % after calculate
    if (handles.filter_med)
        handles.img = MedianFilter(handles.img);
    end
    if (handles.filter_mean)
        handles.img = MeanFilter(handles.img);
    end
    axes(handles.dhPic);
    set(gca, 'Visible', 'on');
    imshow(handles.img * handles.brightness);
    guidata(hObject,handles)
end

function cbMed_Callback(hObject, eventdata, handles)
handles.filter_med = get(hObject, 'value');
guidata(hObject,handles);

function ctrlPanle_SelectionChangeFcn(hObject, eventdata, handles)
handles.filter = get(hObject,'Tag');
guidata(hObject,handles);

function slider2_Callback(hObject, eventdata, handles)
set(handles.edDist,'String', (handles.dist + get(hObject, 'Value') - 0.5) * 20);
guidata(hObject,handles)

function slider2_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',0.5);
guidata(hObject,handles)

function cbMean_Callback(hObject, eventdata, handles)
handles.filter_mean = get(hObject, 'value');
guidata(hObject,handles);
