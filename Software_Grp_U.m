function varargout = Software_Grp_U(varargin)
% Software_Grp_U MATLAB code for Software_Grp_U.fig
%      Software_Grp_U, by itself, creates a new Software_Grp_U or raises the existing
%      singleton*.
%
%      H = Software_Grp_U returns the handle to a new Software_Grp_U or the handle to
%      the existing singleton*.
%
%      Software_Grp_U('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Software_Grp_U.M with the given input arguments.
%
%      Software_Grp_U('Property','Value',...) creates a new Software_Grp_U or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Software_Grp_U_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Software_Grp_U_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Software_Grp_U

% Last Modified by GUIDE v2.5 07-Apr-2023 16:19:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Software_Grp_U_OpeningFcn, ...
                   'gui_OutputFcn',  @Software_Grp_U_OutputFcn, ...
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


% --- Executes just before Software_Grp_U is made visible.
function Software_Grp_U_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Software_Grp_U (see VARARGIN)

% Choose default command line output for Software_Grp_U
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Software_Grp_U wait for user response (see UIRESUME)
% uiwait(handles.figureBG);
handles.channelMatrix = 1;
guidata(hObject,handles);
handles.fileName = 'eeg_feature_5Bands_band_1_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 1;
guidata(hObject,handles);
movegui('center');


% --- Outputs from this function are returned to the command line.
function varargout = Software_Grp_U_OutputFcn(~, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonGenerate.
function buttonGenerate_Callback(hObject, ~, handles)
% hObject    handle to buttonGenerate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
thisMatrix = handles.channelMatrix - 1;

if handles.channelMatrix == [1]
    f = warndlg('Please select at least ONE channel.','Warning');
else
    if length(handles.channelMatrix) == 2
        channelStr = [sprintf(' %g',thisMatrix(2))];
    elseif length(handles.channelMatrix) == 3
        channelStr = [sprintf(' %g, ',thisMatrix(2)) sprintf('%g',thisMatrix(3))];
    else
        channelStr = [sprintf(' %g, ',thisMatrix(2)) sprintf('%g, ',thisMatrix(3:end-1)) sprintf('%g',thisMatrix(end))];
    end 
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    displayMatrix(handles.bandNum, handles.channelStr, handles.c, handles.order);
end

function matAccuracy = calculateAccuracy(c)
format shortg
matDiagonal = c(1,1) + c(2,2) + c(3,3);
matAccuracy = round(matDiagonal/23 * 100,2);


function displayMatrix(bandNum, channelStr, c, order)
figure
cm = confusionchart(c,order);
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';
sortClasses(cm,["Awake","Tired","Drowsy"]);
% add band and channel name
str_title = strcat('Prediction of Vigilance against SEED-VIG Band  ', num2str(bandNum));
str_title = strcat(str_title, ' Channel ');
str_title = strcat(str_title, channelStr);
cm.Title = str_title;


function [bandNum, channelStr, c, order] = generateMatrix(fileName, channelMatrix, bandNum)
channelStr = ['[' sprintf('%g, ',channelMatrix(1:end-1)) sprintf('%g]',channelMatrix(end))];

s = xlsread(fileName,'A1:R24');
s = s(:,channelMatrix);
VarNames = {'Outcome''A''B''C''D''E''F''G''H''I''J''K''L''M''N''O''P''Q'};
X = double(s(:,2:end));
Y = s(:,1);
rng(0,'twister');
t = ClassificationTree.template();
a = fitensemble(X,Y,'AdaBoostM2',100,t,'PredictorNames', VarNames(2:end),'LearnRate',0.1,'kfold',21);
[Yfit,~] = kfoldPredict(a);
c = confusionmat(Y, Yfit);
order = categorical({'Awake';'Tired';'Drowsy'});



% --- Executes on button press in radioBand1.
function radioBand1_Callback(hObject, ~, handles)
% hObject    handle to radioBand1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.fileName = 'eeg_feature_5Bands_band_1_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 1;
guidata(hObject,handles);

% Hint: get(hObject,'Value') returns toggle state of radioBand1


% --- Executes on button press in radioBand2.
function radioBand2_Callback(hObject, ~, handles)
% hObject    handle to radioBand2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioBand2
handles.fileName = 'eeg_feature_5Bands_band_2_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 2;
guidata(hObject,handles);


% --- Executes on button press in radioBand3.
function radioBand3_Callback(hObject, ~, handles)
% hObject    handle to radioBand3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioBand3
handles.fileName = 'eeg_feature_5Bands_band_3_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 3;
guidata(hObject,handles);


% --- Executes on button press in radioBand4.
function radioBand4_Callback(hObject, ~, handles)
% hObject    handle to radioBand4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioBand4
handles.fileName = 'eeg_feature_5Bands_band_4_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 4;
guidata(hObject,handles);


% --- Executes on button press in radioBand5.
function radioBand5_Callback(hObject, ~, handles)
% hObject    handle to radioBand5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioBand5
handles.fileName = 'eeg_feature_5Bands_band_5_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 5;
guidata(hObject,handles);


% --- Executes on button press in buttonBest.
function buttonBest_Callback(hObject, ~, handles)
% hObject    handle to buttonBest (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radioBand5,'Value',1); 
set(handles.checkChannel4,'Value',1);
set(handles.checkChannel1,'Value',0);
set(handles.checkChannel2,'Value',0);
set(handles.checkChannel3,'Value',0);
set(handles.checkChannel5,'Value',0);
set(handles.checkChannel6,'Value',0);
set(handles.checkChannel7,'Value',0);
set(handles.checkChannel8,'Value',0);
set(handles.checkChannel9,'Value',0);
set(handles.checkChannel10,'Value',0);
set(handles.checkChannel11,'Value',0);
set(handles.checkChannel12,'Value',0);
set(handles.checkChannel13,'Value',0);
set(handles.checkChannel14,'Value',0);
set(handles.checkChannel15,'Value',0);
set(handles.checkChannel16,'Value',0);
set(handles.checkChannel17,'Value',0);

set(handles.edit_PA,'string',strcat(num2str(round(22/23 * 100,2)),' %'));
handles.fileName = 'eeg_feature_5Bands_band_5_psd_movingAve.xlsx';
guidata(hObject,handles);
handles.bandNum = 5;
guidata(hObject,handles);
handles.channelNum = 4;
guidata(hObject,handles);
handles.channelMatrix = [1 5];
guidata(hObject,handles);
[~, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
handles.channelStr = channelStr;
guidata(hObject,handles);
handles.c = c;
guidata(hObject,handles);
handles.order = order;
guidata(hObject,handles);



% --- Executes on button press in checkChannel1.
function checkChannel1_Callback(hObject, ~, handles)
% hObject    handle to checkChannel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel1
if get(handles.checkChannel1,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 2];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 2) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel2.
function checkChannel2_Callback(hObject, ~, handles)
% hObject    handle to checkChannel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel2
if get(handles.checkChannel2,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 3];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 3) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel3.
function checkChannel3_Callback(hObject, ~, handles)
% hObject    handle to checkChannel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel3
if get(handles.checkChannel3,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 4];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 4) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel4.
function checkChannel4_Callback(hObject, ~, handles)
% hObject    handle to checkChannel4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel4

if get(handles.checkChannel4,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 5];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 5) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel5.
function checkChannel5_Callback(hObject, ~, handles)
% hObject    handle to checkChannel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel5
if get(handles.checkChannel5,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 6];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 6) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel6.
function checkChannel6_Callback(hObject, ~, handles)
% hObject    handle to checkChannel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel6
if get(handles.checkChannel6,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 7];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 7) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel7.
function checkChannel7_Callback(hObject, ~, handles)
% hObject    handle to checkChannel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel7
if get(handles.checkChannel7,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 8];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 8) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel8.
function checkChannel8_Callback(hObject, ~, handles)
% hObject    handle to checkChannel8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel8
if get(handles.checkChannel8,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 9];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 9) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel9.
function checkChannel9_Callback(hObject, ~, handles)
% hObject    handle to checkChannel9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel9
if get(handles.checkChannel9,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 10];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 10) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel10.
function checkChannel10_Callback(hObject, ~, handles)
% hObject    handle to checkChannel10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel10
if get(handles.checkChannel10,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 11];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 11) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel11.
function checkChannel11_Callback(hObject, ~, handles)
% hObject    handle to checkChannel11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel11
if get(handles.checkChannel11,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 12];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 12) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel12.
function checkChannel12_Callback(hObject, ~, handles)
% hObject    handle to checkChannel12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel12
if get(handles.checkChannel12,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 13];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 13) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel13.
function checkChannel13_Callback(hObject, ~, handles)
% hObject    handle to checkChannel13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel13
if get(handles.checkChannel13,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 14];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 14) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel14.
function checkChannel14_Callback(hObject, ~, handles)
% hObject    handle to checkChannel14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel14
if get(handles.checkChannel14,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 15];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 15) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel15.
function checkChannel15_Callback(hObject, ~, handles)
% hObject    handle to checkChannel15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel15
if get(handles.checkChannel15,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 16];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 16) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end

% --- Executes on button press in checkChannel16.
function checkChannel16_Callback(hObject, ~, handles)
% hObject    handle to checkChannel16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel16
if get(handles.checkChannel16,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 17];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 17) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --- Executes on button press in checkChannel17.
function checkChannel17_Callback(hObject, ~, handles)
% hObject    handle to checkChannel17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkChannel17
if get(handles.checkChannel17,'Value') == 1
    handles.channelMatrix = [handles.channelMatrix 18];
    handles.channelMatrix = sort(handles.channelMatrix);
else
    handles.channelMatrix(handles.channelMatrix == 18) = [];
end
guidata(hObject,handles);
if handles.channelMatrix == [1]
else
    set(handles.staticCalc,'visible','on');
    [bandNum, channelStr, c, order] = generateMatrix(handles.fileName, handles.channelMatrix, handles.bandNum);
    handles.bandNum = bandNum;
    guidata(hObject,handles);
    handles.channelStr = channelStr;
    guidata(hObject,handles);
    handles.c = c;
    guidata(hObject,handles);
    handles.order = order;
    guidata(hObject,handles);
    matAccuracy = calculateAccuracy(c);
    set(handles.edit_PA,'string',strcat(num2str(matAccuracy),' %'));
    pause(1);
    set(handles.staticCalc,'visible','off');
end


% --------------------------------------------------------------------
function menu_aboutUs_Callback(~, ~, handles)
% hObject    handle to menu_aboutUs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.menu_aboutUs,'checked','off');
msgbox({'Program Name: EEG Prediction Model for Level of Drowsiness (Version 1.0)','Last updated 21 April 2023','',...
        'Group Number: Group U','(Ooi Jing Ru, Leo Tan Hai Ken, Richard Gan Soon Ching, Chong Chen Kai)','',...
        'Module: COMP 2019 Software Engineering Group Project','University of Nottingham Malaysia',''...
        'This EEG Prediction Model takes in the selection of the user and determines which frequency band and channel(s) to use as input. The prediction accuracy of each selected combination will be shown on the bottom right of the screen.',...
        '','The user may click on the "Generate Confusion Matrix" button to generate the respective confusion matrix.','','The "Generate Best Solution" button will automatically display the combination of EEG frequency band and channel(s) that gives the highest prediction accuracy.',...
        '','Features Included:','- Warning messages (if no channels are selected)','- Theme selection (light and dark themes may be selected based on preference of the user)'},...
        'About','modal');


% --------------------------------------------------------------------
function menu_theme_Callback(~, ~, ~)
% hObject    handle to menu_theme (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_themeLight_Callback(~, ~, handles)
% hObject    handle to menu_themeLight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = get(handles.menu_themeLight,'Enable');
if t == 'on'
    set(handles.figureBG,'Color','#ffeebf');
    set(handles.title_GUI,'BackgroundColor','#ffeebf');
    set(handles.title_GUI,'ForegroundColor','#000000');
    set(handles.title_PA,'BackgroundColor','#ffeebf');
    set(handles.title_PA,'ForegroundColor','#000000');
    set(handles.staticCalc,'BackgroundColor','#ffeebf');
    set(handles.staticCalc,'ForegroundColor','#000000');
    set(handles.edit_PA,'BackgroundColor','#ffeebf');
    set(handles.edit_PA,'ForegroundColor','#000000');
    
    set(handles.firstScreen,'BackgroundColor','#fccaca');
    set(handles.firstScreenTitle,'BackgroundColor','#fccaca');
    set(handles.firstScreenTitle,'ForegroundColor','#000000');
    set(handles.firstScreenGroupName,'BackgroundColor','#fccaca');
    set(handles.firstScreenGroupName,'ForegroundColor','#000000');
    set(handles.firstScreenButton,'BackgroundColor','#e38a8a');
    set(handles.firstScreenButton,'ForegroundColor','#000000');
    
    set(handles.groupBands,'BackgroundColor','#bfecff');
    set(handles.groupBands,'ForegroundColor','#000000');
    set(handles.radioBand1,'BackgroundColor','#bfecff');
    set(handles.radioBand1,'ForegroundColor','#000000');
    set(handles.radioBand2,'BackgroundColor','#bfecff');
    set(handles.radioBand2,'ForegroundColor','#000000');
    set(handles.radioBand3,'BackgroundColor','#bfecff');
    set(handles.radioBand3,'ForegroundColor','#000000');
    set(handles.radioBand4,'BackgroundColor','#bfecff');
    set(handles.radioBand4,'ForegroundColor','#000000');
    set(handles.radioBand5,'BackgroundColor','#bfecff');
    set(handles.radioBand5,'ForegroundColor','#000000');
    
    set(handles.groupChannels,'BackgroundColor','#bfc4ff');
    set(handles.groupChannels,'ForegroundColor','#000000');
    set(handles.checkChannel1,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel1,'ForegroundColor','#000000');
    set(handles.checkChannel2,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel2,'ForegroundColor','#000000');
    set(handles.checkChannel3,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel3,'ForegroundColor','#000000');
    set(handles.checkChannel4,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel4,'ForegroundColor','#000000');
    set(handles.checkChannel5,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel5,'ForegroundColor','#000000');
    set(handles.checkChannel6,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel6,'ForegroundColor','#000000');
    set(handles.checkChannel7,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel7,'ForegroundColor','#000000');
    set(handles.checkChannel8,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel8,'ForegroundColor','#000000');
    set(handles.checkChannel9,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel9,'ForegroundColor','#000000');
    set(handles.checkChannel10,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel10,'ForegroundColor','#000000');
    set(handles.checkChannel11,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel11,'ForegroundColor','#000000');
    set(handles.checkChannel12,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel12,'ForegroundColor','#000000');
    set(handles.checkChannel13,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel13,'ForegroundColor','#000000');
    set(handles.checkChannel14,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel14,'ForegroundColor','#000000');
    set(handles.checkChannel15,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel15,'ForegroundColor','#000000');
    set(handles.checkChannel16,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel16,'ForegroundColor','#000000');
    set(handles.checkChannel17,'BackgroundColor','#bfc4ff');
    set(handles.checkChannel17,'ForegroundColor','#000000');
    
    set(handles.buttonGenerate,'BackgroundColor','#9aff75');
    set(handles.buttonGenerate,'ForegroundColor','#000000');
    set(handles.buttonBest,'BackgroundColor','#9aff75');
    set(handles.buttonBest,'ForegroundColor','#000000');
    
    %menu highlighted option
    set(handles.menu_themeLight,'Checked','on');
    set(handles.menu_themeDark,'Checked','off');
end


% --------------------------------------------------------------------
function menu_themeDark_Callback(~, ~, handles)
% hObject    handle to menu_themeDark (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
t = get(handles.menu_themeDark,'Enable');
if t == 'on'
    set(handles.figureBG,'Color','#000000');
    set(handles.title_GUI,'BackgroundColor','#000000');
    set(handles.title_GUI,'ForegroundColor','#ffffff');
    set(handles.title_PA,'BackgroundColor','#000000');
    set(handles.title_PA,'ForegroundColor','#ffffff');
    set(handles.staticCalc,'BackgroundColor','#000000');
    set(handles.staticCalc,'ForegroundColor','#ffffff');
    set(handles.edit_PA,'BackgroundColor','#000000');
    set(handles.edit_PA,'ForegroundColor','#ffffff');
    
    set(handles.firstScreen,'BackgroundColor','#000000');
    set(handles.firstScreenTitle,'BackgroundColor','#000000');
    set(handles.firstScreenTitle,'ForegroundColor','#ffffff');
    set(handles.firstScreenGroupName,'BackgroundColor','#000000');
    set(handles.firstScreenGroupName,'ForegroundColor','#ffffff');
    set(handles.firstScreenButton,'BackgroundColor','#b54a4a');
    set(handles.firstScreenButton,'ForegroundColor','#ffffff');
    
    set(handles.groupBands,'BackgroundColor','#0a73a1');
    set(handles.groupBands,'ForegroundColor','#ffffff');
    set(handles.radioBand1,'BackgroundColor','#0a73a1');
    set(handles.radioBand1,'ForegroundColor','#ffffff');
    set(handles.radioBand2,'BackgroundColor','#0a73a1');
    set(handles.radioBand2,'ForegroundColor','#ffffff');
    set(handles.radioBand3,'BackgroundColor','#0a73a1');
    set(handles.radioBand3,'ForegroundColor','#ffffff');
    set(handles.radioBand4,'BackgroundColor','#0a73a1');
    set(handles.radioBand4,'ForegroundColor','#ffffff');
    set(handles.radioBand5,'BackgroundColor','#0a73a1');
    set(handles.radioBand5,'ForegroundColor','#ffffff');
  
    set(handles.groupChannels,'BackgroundColor','#6a5bde');
    set(handles.groupChannels,'ForegroundColor','#ffffff');
    set(handles.checkChannel1,'BackgroundColor','#6a5bde');
    set(handles.checkChannel1,'ForegroundColor','#ffffff');
    set(handles.checkChannel2,'BackgroundColor','#6a5bde');
    set(handles.checkChannel2,'ForegroundColor','#ffffff');
    set(handles.checkChannel3,'BackgroundColor','#6a5bde');
    set(handles.checkChannel3,'ForegroundColor','#ffffff');
    set(handles.checkChannel4,'BackgroundColor','#6a5bde');
    set(handles.checkChannel4,'ForegroundColor','#ffffff');
    set(handles.checkChannel5,'BackgroundColor','#6a5bde');
    set(handles.checkChannel5,'ForegroundColor','#ffffff');
    set(handles.checkChannel6,'BackgroundColor','#6a5bde');
    set(handles.checkChannel6,'ForegroundColor','#ffffff');
    set(handles.checkChannel7,'BackgroundColor','#6a5bde');
    set(handles.checkChannel7,'ForegroundColor','#ffffff');
    set(handles.checkChannel8,'BackgroundColor','#6a5bde');
    set(handles.checkChannel8,'ForegroundColor','#ffffff');
    set(handles.checkChannel9,'BackgroundColor','#6a5bde');
    set(handles.checkChannel9,'ForegroundColor','#ffffff');
    set(handles.checkChannel10,'BackgroundColor','#6a5bde');
    set(handles.checkChannel10,'ForegroundColor','#ffffff');
    set(handles.checkChannel11,'BackgroundColor','#6a5bde');
    set(handles.checkChannel11,'ForegroundColor','#ffffff');
    set(handles.checkChannel12,'BackgroundColor','#6a5bde');
    set(handles.checkChannel12,'ForegroundColor','#ffffff');
    set(handles.checkChannel13,'BackgroundColor','#6a5bde');
    set(handles.checkChannel13,'ForegroundColor','#ffffff');
    set(handles.checkChannel14,'BackgroundColor','#6a5bde');
    set(handles.checkChannel14,'ForegroundColor','#ffffff');
    set(handles.checkChannel15,'BackgroundColor','#6a5bde');
    set(handles.checkChannel15,'ForegroundColor','#ffffff');
    set(handles.checkChannel16,'BackgroundColor','#6a5bde');
    set(handles.checkChannel16,'ForegroundColor','#ffffff');
    set(handles.checkChannel17,'BackgroundColor','#6a5bde');
    set(handles.checkChannel17,'ForegroundColor','#ffffff');
   
    set(handles.buttonGenerate,'BackgroundColor','#247a05');
    set(handles.buttonGenerate,'ForegroundColor','#ffffff');
    set(handles.buttonBest,'BackgroundColor','#247a05');
    set(handles.buttonBest,'ForegroundColor','#ffffff');
    
    %menu highlighted option
    set(handles.menu_themeLight,'Checked','off');
    set(handles.menu_themeDark,'Checked','on');
end


% --------------------------------------------------------------------
function menu_Help_Callback(~, ~, ~)
% hObject    handle to menu_Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in firstScreenButton.
function firstScreenButton_Callback(~, ~, handles)
% hObject    handle to firstScreenButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.firstScreenButton,'Visible','off');
set(handles.firstScreen,'Visible','off');
set(handles.firstScreenTitle,'Visible','off');
set(handles.firstScreenGroupName,'Visible','off');


% --------------------------------------------------------------------
function menu_Exit_Callback(~, ~, ~)
% hObject    handle to menu_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
q = questdlg('Do you want to exit the program?','Exit','Yes','Cancel','Yes');
switch q
    case 'Yes'
        close(Software_Grp_U);
    case 'Cancel'
        return;
    case 'Yes'
        close(Software_Grp_U);
end
