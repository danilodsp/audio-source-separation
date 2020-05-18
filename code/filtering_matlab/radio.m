function varargout = radio(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @radio_OpeningFcn, ...
                   'gui_OutputFcn',  @radio_OutputFcn, ...
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


% --- Executes just before radio is made visible.
function radio_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to radio (see VARARGIN)

% Choose default command line output for radio
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

global y;
global f;
global SampleRate;


% UIWAIT makes radio wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = radio_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sel= get(handles.inst,'selectedObject');
sel2=get(sel,'String');
url2 = get(handles.TxtFile,'String');

if strcmp(url2,'...')==0
    global y
    
[y,Fs] = audioread(url2);
info = audioinfo(url2);
info

%Visibilidade Painel de Música
set(handles.painelMusic,'Visible','on');
set(handles.PlayOriginal,'Visible','on');
set(handles.Stop,'Visible','on');
set(handles.PlayFilter,'Visible','on');


switch sel2
    case 'Baixo'
        display('Baixo')
     set(handles.statsInts,'String','Baixo');
        corteA=41;
        corteB=424;
        n=3;
    case 'Guitarra Elétrica'
        display('Guitarra')
        set(handles.statsInts,'String','Guitarra');
        corteA=82;
        corteB=1300;
        n=4;
    case 'Bateria'
        display('Bateria')
        set(handles.statsInts,'String','Bateria');
       corteA=850;
        corteB=1050;
        n=4;
end

global SampleRate;
SampleRate=Fs;
fftOriginal = fft(y);

[b,a] = ellip(n,1,50,[corteA corteB]/(SampleRate),'bandpass');
[b2,a2] = butter(10,(corteB+200)/(SampleRate/2));


global f;
f = filter(b,a,y);
f=f*4;
f = filter(b2,a2,f);
fftFilter=fft(f);

figure(1)
subplot(2,1,1);
plot(real(fftOriginal));
xlim([0 2000]);
ylim([-500 500]);
title('Reposta em Frequencia da Música Original');
xlabel('frequency');ylabel('magnitude');
subplot(2,1,2);
plot(real(fftFilter));
xlim([0 2000]);
ylim([-500 500]);
title('Resposta em Frequência da Musica Filtrada');
xlabel('frequency');ylabel('magnitude');

figure(2)
freqz(b,a)
title('Filtro Elíptico');

 figure(3)
 freqz(b2,a2)
 title('Filtro Passa-Baixa');

left=y(:,1); % Left channel 
left2=f(:,1); % Left channel 
right=y(:,2); % Right channel

figure(4)
subplot(2,1,1);
spectrogram(left)
title('Espectograma do Sinal Original');
subplot(2,1,2);
spectrogram(left2)
title('Espectograma do Sinal Filtrado');



set(handles.PlayFilter,'Enable','on');


else
    h = msgbox('Nenhum arquivo selecionado', 'Error','error');
end



% --- Executes on button press in Abrir.
function Abrir_Callback(hObject, eventdata, handles)

[FileName,PathName] = uigetfile({'*.mp3';'*.wav'},'Selecione a música');

url = strcat(PathName,FileName);

set(handles.TxtFile,'String',url);


% --- Executes on button press in PlayOriginal.
function PlayOriginal_Callback(hObject, eventdata, handles)
set(handles.Stop,'Enable','on');
global y
global SampleRate
  sound(y,SampleRate);


% --- Executes on button press in Stop.
function Stop_Callback(hObject, eventdata, handles)
clear sound
set(handles.Stop,'Enable','off');


% --- Executes on button press in PlayFilter.
function PlayFilter_Callback(hObject, eventdata, handles)
global f
global SampleRate
sound(f,SampleRate);
set(handles.Stop,'Enable','on');