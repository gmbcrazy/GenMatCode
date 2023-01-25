function varargout = msMARCau(varargin)
% MSMARCAU Application M-file for msMARCau.fig
%    FIG = MSMARCAU launch msMARCau GUI.
%    MSMARCAU('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 13-Nov-2004 23:55:44

if nargin == 0 |nargin == 2 % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    
    %initial the data.
    tmp_struct=varargin{2};
    handles.FileInfo=tmp_struct.FileInfo;
    handles.RawData=tmp_struct.RawData;
    
%///////////Initial the dialog///////////////////////////////////////////////////////////////////////
    %initial the listbox:rawlist
    tmp_str=getliststr(handles.RawData.chnno,handles.FileInfo.chnname);
    set(handles.rawlistone,'String',tmp_str,'Value',1);
    set(handles.sellistone,'String','');
    
    %initial the pushbutton
    set(handles.addselone,'Enable','on');
    set(handles.delselone,'Enable','off');
    
    %initial the data used for analysis
    handles.AnaData.SelOneNo=0;%total number of the selected channel
    handles.AnaData.SelOneChn=[];%the channel number in raw data
    
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    set(handles.rawlisttwo,'String',tmp_str,'Value',1);
    set(handles.sellisttwo,'String','');
    
    %initial the pushbutton
    set(handles.addseltwo,'Enable','on');
    set(handles.delseltwo,'Enable','off');
    
    %initial the data used for analysis
    handles.AnaData.SelTwoNo=0;%total number of the selected channel
    handles.AnaData.SelTwoChn=[];%the channel number in raw data
    
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    %initial the data used for analysis
    handles.AnaData.SelThreeNo=0;%total number of the selected channel
    handles.AnaData.SelThreeChn=[];%the channel number in raw data
    
    % initial the data relative the raw data
    if getdefaultsetting(fig,handles)==0
        restoresetting(fig,handles);
    end
    
%//////////////////////////////////////////////////////////////////////////////////
    guidata(fig, handles);        

	if nargout > 0
		varargout{1} = fig;
	end

elseif ischar(varargin{1}) % INVOKE NAMED SUBFUNCTION OR CALLBACK

	try
		if (nargout)
			[varargout{1:nargout}] = feval(varargin{:}); % FEVAL switchyard
		else
			feval(varargin{:}); % FEVAL switchyard
		end
	catch
		disp(lasterr);
	end

end


%| ABOUT CALLBACKS:
%| GUIDE automatically appends subfunction prototypes to this file, and 
%| sets objects' callback properties to call them through the FEVAL 
%| switchyard above. This comment describes that mechanism.
%|
%| Each callback subfunction declaration has the following form:
%| <SUBFUNCTION_NAME>(H, EVENTDATA, HANDLES, VARARGIN)
%|
%| The subfunction name is composed using the object's Tag and the 
%| callback type separated by '_', e.g. 'slider2_Callback',
%| 'figure1_CloseRequestFcn', 'axis1_ButtondownFcn'.
%|
%| H is the callback object's handle (obtained using GCBO).
%|
%| EVENTDATA is empty, but reserved for future use.
%|
%| HANDLES is a structure containing handles of components in GUI using
%| tags as fieldnames, e.g. handles.figure1, handles.slider2. This
%| structure is created at GUI startup using GUIHANDLES and stored in
%| the figure's application data using GUIDATA. A copy of the structure
%| is passed to each callback.  You can store additional information in
%| this structure at GUI startup, and you can change the structure
%| during callbacks.  Call guidata(h, handles) after changing your
%| copy to replace the stored original so that subsequent callbacks see
%| the updates. Type "help guihandles" and "help guidata" for more
%| information.
%|
%| VARARGIN contains any extra arguments you have passed to the
%| callback. Specify the extra arguments by editing the callback
%| property in the inspector. By default, GUIDE sets the property to:
%| <MFILENAME>('<SUBFUNCTION_NAME>', gcbo, [], guidata(gcbo))
%| Add any extra arguments after the last argument, before the final
%| closing parenthesis.

%/////Not used Functions START/////Not used Functions START/////Not used Functions START /////Not used Functions START 
%Currently we don'nt use these functions.
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% --------------------------------------------------------------------
function varargout = detrendtypelist_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotconfinterval_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotmulti_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotrawdata_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = sectionno_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = graysurf_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = shadingmode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotmode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = colorbar_Callback(h, eventdata, handles, varargin)

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Currently we don'nt use these functions.
%/////Not used Functions END/////Not used Functions END/////Not used Functions END /////Not used Functions START END


%******Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*Start*
% Select proper signal for analysis
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% --------------------------------------------------------------------
function varargout = rawlistone_Callback(h, eventdata, handles, varargin)

ChnExisted=0;
tmp_i=get(handles.rawlistone,'Value');

for i=1:handles.AnaData.SelOneNo
    if tmp_i==handles.AnaData.SelOneChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addselone,'Enable','off');
else
    set(handles.addselone,'Enable','on');
end

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = sellistone_Callback(h, eventdata, handles, varargin)

set(handles.delselone,'Enable','on');

% --------------------------------------------------------------------
function varargout = addselone_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.rawlistone,'Value');

handles.AnaData.SelOneNo=handles.AnaData.SelOneNo+1;
handles.AnaData.SelOneChn(handles.AnaData.SelOneNo)=get(handles.rawlistone,'Value');
handles.AnaData.SelOneChnname(handles.AnaData.SelOneNo)=handles.FileInfo.chnname(get(handles.rawlistone,'Value'));
tmp_str=getliststr(handles.AnaData.SelOneNo,handles.AnaData.SelOneChnname);
set(handles.sellistone,'String',tmp_str,'Value',1);

%prepare to add next channel data
tmpi=get(handles.rawlistone,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlistone,'Value',tmpi);
guidata(gcbo,handles);
rawlistone_Callback(h, eventdata, handles, varargin);

set(handles.delselone,'Enable','on');

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = delselone_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.sellistone,'Value');
for i=tmp_i:handles.AnaData.SelOneNo-1
    handles.AnaData.SelOneChn(i)=handles.AnaData.SelOneChn(i+1);
    handles.AnaData.SelOneChnname(i)=handles.AnaData.SelOneChnname(i+1);
end

handles.AnaData.SelOneNo=handles.AnaData.SelOneNo-1;
tmp_str=getliststr(handles.AnaData.SelOneNo,handles.AnaData.SelOneChnname);
set(handles.sellistone,'String',tmp_str);

if handles.AnaData.SelOneNo>0
    set(handles.delselone,'Enable','on');
    set(handles.sellistone,'Value',1);
else
    set(handles.delselone,'Enable','off');
end

ChnExisted=0;
tmp_i=get(handles.rawlistone,'Value');

for i=1:handles.AnaData.SelOneNo
    if tmp_i==handles.AnaData.SelOneChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addselone,'Enable','off');
else
    set(handles.addselone,'Enable','on');
end

guidata(gcbo,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function rawlisttwo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rawlisttwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in rawlisttwo.
function rawlisttwo_Callback(hObject, eventdata, handles)
% hObject    handle to rawlisttwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rawlisttwo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rawlisttwo
ChnExisted=0;
tmp_i=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.SelTwoNo
    if tmp_i==handles.AnaData.SelTwoChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addseltwo,'Enable','off');
else
    set(handles.addseltwo,'Enable','on');
end

guidata(gcbo,handles);



% --- Executes during object creation, after setting all properties.
function sellisttwo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sellisttwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in sellisttwo.
function sellisttwo_Callback(hObject, eventdata, handles)
% hObject    handle to sellisttwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sellisttwo contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sellisttwo

set(handles.delseltwo,'Enable','on');
guidata(gcbo,handles);




% --- Executes on button press in addseltwo.
function addseltwo_Callback(hObject, eventdata, handles)
% hObject    handle to addseltwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tmp_i=get(handles.rawlisttwo,'Value');

handles.AnaData.SelTwoNo=handles.AnaData.SelTwoNo+1;
handles.AnaData.SelTwoChn(handles.AnaData.SelTwoNo)=get(handles.rawlisttwo,'Value');
handles.AnaData.SelTwoChnname(handles.AnaData.SelTwoNo)=handles.FileInfo.chnname(get(handles.rawlisttwo,'Value'));
tmp_str=getliststr(handles.AnaData.SelTwoNo,handles.AnaData.SelTwoChnname);
set(handles.sellisttwo,'String',tmp_str,'Value',1);

%prepare to add next channel data
tmpi=get(handles.rawlisttwo,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlisttwo,'Value',tmpi);
guidata(gcbo,handles);


ChnExisted=0;

tmp_i=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.SelTwoNo
    if tmp_i==handles.AnaData.SelTwoChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addseltwo,'Enable','off');
else
    set(handles.addseltwo,'Enable','on');
end

set(handles.delseltwo,'Enable','on');

guidata(gcbo,handles);




% --- Executes on button press in delseltwo.
function delseltwo_Callback(hObject, eventdata, handles)
% hObject    handle to delseltwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


tmp_i=get(handles.sellisttwo,'Value');
for i=tmp_i:handles.AnaData.SelTwoNo-1
    handles.AnaData.SelTwoChn(i)=handles.AnaData.SelTwoChn(i+1);
    handles.AnaData.SelTwoChnname(i)=handles.AnaData.SelTwoChnname(i+1);
end

handles.AnaData.SelTwoNo=handles.AnaData.SelTwoNo-1;
tmp_str=getliststr(handles.AnaData.SelTwoNo,handles.AnaData.SelTwoChnname);
set(handles.sellisttwo,'String',tmp_str);

if handles.AnaData.SelTwoNo>0
    set(handles.delseltwo,'Enable','on');
    set(handles.sellisttwo,'Value',1);
else
    set(handles.delseltwo,'Enable','off');
end

ChnExisted=0;
tmp_i=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.SelTwoNo
    if tmp_i==handles.AnaData.SelTwoChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addseltwo,'Enable','off');
else
    set(handles.addseltwo,'Enable','on');
end

guidata(gcbo,handles);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% --- Executes during object creation, after setting all properties.
function rawlistthree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rawlistthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%%%%%%%%%%%%%%%%%%
% --- Executes on selection change in rawlistthree.
function rawlistthree_Callback(hObject, eventdata, handles)
% hObject    handle to rawlistthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns rawlistthree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from rawlistthree

ChnExisted=0;
tmp_i=get(handles.rawlistthree,'Value');

for i=1:handles.AnaData.SelThreeNo
    if tmp_i==handles.AnaData.SelThreeChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addselthree,'Enable','off');
else
    set(handles.addselthree,'Enable','on');
end

guidata(gcbo,handles);




% --- Executes during object creation, after setting all properties.
function sellistthree_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sellistthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in sellistthree.
function sellistthree_Callback(hObject, eventdata, handles)
% hObject    handle to sellistthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns sellistthree contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sellistthree

set(handles.delselthree,'Enable','on');
guidata(gcbo,handles);


% --- Executes on button press in addselthree.
function addselthree_Callback(hObject, eventdata, handles)
% hObject    handle to addselthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_i=get(handles.rawlistthree,'Value');

handles.AnaData.SelThreeNo=handles.AnaData.SelThreeNo+1;
handles.AnaData.SelThreeChn(handles.AnaData.SelThreeNo)=get(handles.rawlistthree,'Value');
handles.AnaData.SelThreeChnname(handles.AnaData.SelThreeNo)=handles.FileInfo.chnname(get(handles.rawlistthree,'Value'));
tmp_str=getliststr(handles.AnaData.SelThreeNo,handles.AnaData.SelThreeChnname);
set(handles.sellistthree,'String',tmp_str,'Value',1);

%prepare to add next channel data
tmpi=get(handles.rawlistthree,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlistthree,'Value',tmpi);
guidata(gcbo,handles);



ChnExisted=0;
tmp_i=get(handles.rawlistthree,'Value');

for i=1:handles.AnaData.SelThreeNo
    if tmp_i==handles.AnaData.SelThreeChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addselthree,'Enable','off');
else
    set(handles.addselthree,'Enable','on');
end

guidata(gcbo,handles);

set(handles.delselthree,'Enable','on');

guidata(gcbo,handles);

% --- Executes on button press in delselthree.
function delselthree_Callback(hObject, eventdata, handles)
% hObject    handle to delselthree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_i=get(handles.sellistthree,'Value');
for i=tmp_i:handles.AnaData.SelThreeNo-1
    handles.AnaData.SelThreeChn(i)=handles.AnaData.SelThreeChn(i+1);
    handles.AnaData.SelThreeChnname(i)=handles.AnaData.SelThreeChnname(i+1);
end

handles.AnaData.SelThreeNo=handles.AnaData.SelThreeNo-1;
tmp_str=getliststr(handles.AnaData.SelThreeNo,handles.AnaData.SelThreeChnname);
set(handles.sellistthree,'String',tmp_str);

if handles.AnaData.SelThreeNo>0
    set(handles.delselthree,'Enable','on');
    set(handles.sellistthree,'Value',1);
else
    set(handles.delselthree,'Enable','off');
end

ChnExisted=0;
tmp_i=get(handles.rawlistthree,'Value');

for i=1:handles.AnaData.SelThreeNo
    if tmp_i==handles.AnaData.SelThreeChn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addselthree,'Enable','off');
else
    set(handles.addselthree,'Enable','on');
end

guidata(gcbo,handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
% Select proper signal for analysis
%****End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*End*



% =====Setting Start=====Setting Start=====Setting Start=====Setting Start=====Setting Start=====
%Here is the setting relative functions.
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV
% --------------------------------------------------------------------

% --------------------------------------------------------------------


% --------------------------------------------------------------------
function varargout = morder_Callback(h, eventdata, handles, varargin)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_ml=round((endp-stp+1)/5);

tmp_s=get(handles.morder,'String');
tmp_i=str2num(tmp_s);

if tmp_i<1 
    tmp_i=1;
end
if tmp_i>500  
    tmp_i=500;
end
if tmp_i>tmp_ml
    tmp_i=tmp_ml;
end

set(handles.morder,'String',num2str(tmp_i));    

guidata(gcbo,handles);
    
% --------------------------------------------------------------------
function varargout = winlength_Callback(h, eventdata, handles, varargin)
% winlength must < =total length of the analyzied data, and <=FFT length and > overlaplength

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_winlen=round(str2num(tmp_s)*handles.RawData.fs);

if tmp_winlen>endp-stp+1
    tmp_winlen=endp-stp+1;
end

tmp_s=get(handles.overlaplength,'String');
tmp_i=round(str2num(tmp_s)*handles.RawData.fs);
if tmp_winlen<tmp_i+1
    tmp_winlen=tmp_i+1;
end

tmp_s=num2str(tmp_winlen/handles.RawData.fs);
set(handles.winlength,'String',tmp_s);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));

guidata(gcbo,handles);



% --------------------------------------------------------------------
function varargout = fftlength_Callback(h, eventdata, handles, varargin)
% fftlength must < =total length of the analyzied data, and >=winlength

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.fftlength,'String');
tmp_fftlen=str2num(tmp_s);

if tmp_fftlen<8
    tmp_fftlen=8;
end

tmp_s=num2str(tmp_fftlen);

set(handles.fftlength,'String',tmp_s);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = overlaplength_Callback(h, eventdata, handles, varargin)
% overlaplength must < winlength

tmp_s=get(handles.overlaplength,'String');
tmp_overlaplen=round(str2num(tmp_s)*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_i=round(str2num(tmp_s)*handles.RawData.fs);

if tmp_overlaplen>tmp_i-1
    tmp_overlaplen=tmp_i-1;
end

if tmp_overlaplen<0
    tmp_overlaplen=0;
end

tmp_s=num2str(tmp_overlaplen/handles.RawData.fs);
set(handles.overlaplength,'String',tmp_s);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = confinterval_Callback(h, eventdata, handles, varargin)

tmp_s=get(handles.confinterval,'String');
tmp_f=str2num(tmp_s);

if tmp_f<0.0001
    tmp_f=0.0001;
end

if tmp_f>0.99999
    tmp_f=0.99999;
end

tmp_s=num2str(tmp_f);

set(handles.confinterval,'String',tmp_s);

guidata(gcbo,handles);


% --- Executes during object creation, after setting all properties.
function STFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to STFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function STFreq_Callback(hObject, eventdata, handles)
% hObject    handle to STFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of STFreq as text
%        str2double(get(hObject,'String')) returns contents of STFreq as a double

tmps=get(handles.STFreq,'String');
STF=str2num(tmps);

tmps=get(handles.EDFreq,'String');
EDF=str2num(tmps);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

if STF>EDF
    STF=EDF-3/NFFT;
end
set(handles.STFreq,'String',num2str(STF));


% --- Executes during object creation, after setting all properties.
function EDFreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EDFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function EDFreq_Callback(hObject, eventdata, handles)
% hObject    handle to EDFreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EDFreq as text
%        str2double(get(hObject,'String')) returns contents of EDFreq as a double

tmps=get(handles.STFreq,'String');
STF=str2num(tmps);

tmps=get(handles.EDFreq,'String');
EDF=str2num(tmps);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

if EDF<STF
    EDF=STF+3/NFFT;
end
if EDF>handles.RawData.fs/2
    EDF=handles.RawData.fs/2;
end

set(handles.EDFreq,'String',num2str(EDF));



% --------------------------------------------------------------------
function restoresetting(fig,handles)

%initial the plot mode
tmp_s='image|surf|mesh';
set(handles.plotmode,'String',tmp_s,'Value',1);

% initial the setting relative the raw data
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

set(handles.morder,'String','8');
    
%Initial the window length;
tmp_i=500;
if tmp_i>endp-stp+1
    tmp_i=endp-stp+1;
end
set(handles.winlength,'String',num2str(tmp_i/handles.RawData.fs));
 
%Initial the overlap length, is the half of window length
tmp_i=round(tmp_i/2);
set(handles.overlaplength,'String',num2str(tmp_i/handles.RawData.fs));

%Initial the FFT length;
tmp_i=512;    
set(handles.fftlength,'String',num2str(tmp_i));

%Initial the detrending type list
tmp_s='mean|linear|none';
set(handles.detrendtypelist,'String',tmp_s,'Value',1);

%Initial the confidence interval
tmp_f=0.95;
set(handles.confinterval,'String',num2str(tmp_f));

guidata(fig, handles);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));
guidata(fig, handles);

% --------------------------------------------------------------------
function setmark=getdefaultsetting(fig,handles)
%initial the setting by default from file

%initial the plot mode
tmp_s='image|surf|mesh';
set(handles.plotmode,'String',tmp_s,'Value',1);


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

%open the setting filee
fid=fopen('mscausl.inf','rt');
if fid==-1
    setmark=0;
    return;
end

%get the order of the model
tmp_i=round(fscanf(fid,'%d', [1 1]));
if tmp_i>0& tmp_i<500
    tmp_set=tmp_i;
else
    tmp_set=8;
end
set(handles.morder,'String',num2str(tmp_set));

%Initial the window length;
tmp_winlen=fscanf(fid,'%f', [1 1]);
if tmp_winlen>(endp-stp+1)/handles.RawData.fs
    tmp_winlen=(endp-stp+1)/handles.RawData.fs;
end
set(handles.winlength,'String',num2str(tmp_winlen));
 
%Initial the overlap length, is the half of window length
tmp_i=fscanf(fid,'%f', [1 1]);
if tmp_i>tmp_winlen-0.05
    tmp_i=tmp_winlen-0.05;
end    
set(handles.overlaplength,'String',num2str(tmp_i));

%Initial the FFT length;
tmp_i=round(fscanf(fid,'%d', [1 1]));
if tmp_i<tmp_winlen
    tmp_i=tmp_winlen;
end
set(handles.fftlength,'String',num2str(tmp_i));

%Initial the detrending type list
tmp_i=round(fscanf(fid,'%d', [1 1]));
if tmp_i>0&tmp_i<3
    tmp_set=tmp_i;
else
    tmp_set=1;
end
tmp_s='mean|linear|none';
set(handles.detrendtypelist,'String',tmp_s,'Value',tmp_set);

%Initial the confidence interval
tmp_f=fscanf(fid,'%f', [1 1]);
if tmp_f>0.0 &tmp_f<1.0
    tmp_set=tmp_f;
else 
    tmp_set=0.95;
end
set(handles.confinterval,'String',num2str(tmp_f));

tmp_f=fscanf(fid,'%f', [1 1]);
set(handles.STFreq,'String',num2str(tmp_f));

tmp_f=fscanf(fid,'%f', [1 1]);
if tmp_f>handles.RawData.fs/2
    tmp_f=handles.RawData.fs/2;
end
set(handles.EDFreq,'String',num2str(tmp_f));
fclose(fid);

setmark=1;

guidata(fig, handles);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));
guidata(fig, handles);


% --------------------------------------------------------------------
function varargout = savedefault_Callback(h, eventdata, handles, varargin)

fid=fopen('mscausl.inf','wt');
if fid==-1
    return;
end

tmp_s=get(handles.morder,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%d\n',tmp_i);
    
%Initial the window length;
tmp_s=get(handles.winlength,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_i);
 
%Initial the overlap length, is the half of window length
tmp_s=get(handles.overlaplength,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_i);

%Initial the FFT length;
tmp_s=get(handles.fftlength,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%d\n',tmp_i);

%Initial the detrending type list
tmp_i=get(handles.detrendtypelist,'Value');
fprintf(fid,'%d\n',tmp_i);

%Initial the confidence interval
tmp_s=get(handles.confinterval,'String');
tmp_f=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_f);

tmp_s=get(handles.STFreq,'String');
tmp_f=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_f);

tmp_s=get(handles.EDFreq,'String');
tmp_f=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_f);

fclose(fid);

% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)
getdefaultsetting(gcbo,handles);

% --------------------------------------------------------------------
function varargout = restore_Callback(h, eventdata, handles, varargin)
restoresetting(gcbo,handles);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting relative functions.
% =====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====

% --------------------------------------------------------------------
function section_no=getsectionno(handles)
% get the section number of the data
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_winlength=str2num(tmp_s)*handles.RawData.fs-1;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;


%k = fix((NX-NOVERLAP)/(length(WINDOW)-NOVERLAP)) 
%section_no=floor((endp-stp+1-tmp_winlength)/(tmp_winlength-NOVERLAP+1))+1;
section_no = fix((endp-stp+1-NOVERLAP)/(tmp_winlength-NOVERLAP));


% --------------------------------------------------------------------
% --- Executes on button press in GetAIC.
function GetAIC_Callback(hObject, eventdata, handles)
% hObject    handle to GetAIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Mingzhou Ding, et al. Short-window spectral analysis of cortical event-related potentials
% by adaptive multivariate autoregressive modeling:
% data preprocessing, model validation, and variability assessment. Biol. Cybern. 83, 35-45 (2000)

if handles.AnaData.SelOneNo<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmp_s=get(handles.morder,'String');
MORDER=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

Fs=handles.RawData.fs;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

SECDETREND=get(handles.detrendtypelist,'Value');
    
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.STFreq,'String');
STFreq=str2num(tmp_s);
tmp_s=get(handles.EDFreq,'String');
EDFreq=str2num(tmp_s);

handles.ResultData.xtime=[];
NormaliseData=get(handles.NormliseData,'Value');

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end
    
seced=NOVERLAP;
storder=MORDER-10;
if storder<1
    storder=1;
end
edorder=MORDER+20;

for j=1:SECNO
    secst=seced-NOVERLAP+1;
    seced=secst+SECLEN-1;
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
        
    %[pp,cohe,Ixy,Iyx]=pwcausal(xs,Nr,Nl,porder,fs,freq);
    tmp_x=tmp_x';
    [L,N]=size(tmp_x); %L is the number of channels, N is the total points in every channel
    
    Nr=1;
    Nl=N;

    for k=storder:edorder
        [A,Z]=armorf(tmp_x,Nr,Nl,k);  %get the model parameters.   
        AIC(j).C(k-storder+1)=log(det(Z))+2*(L+L*L*k)/N;        
    end    
end

tmpAIC=zeros(edorder-storder+1,SECNO);
tmpf=zeros(edorder-storder+1,1);
for j=1:SECNO
    for k=storder:edorder
        tmpAIC(k-storder+1,j)=AIC(j).C(k-storder+1);
        tmpf(k-storder+1)=tmpf(k-storder+1)+AIC(j).C(k-storder+1);
    end
end
for k=storder:edorder
    tmpf(k-storder+1)=tmpf(k-storder+1)/SECNO;
end

handles.ResultData.AIC=tmpf;


MyFontSize=14;
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

x=([1:SECNO]-0.5)*SECLEN/Fs;
y=[storder:edorder];

figure;
switch tmp_plotmode
    case 1
        image(x,y,tmpAIC,'CDataMapping','scaled'); 
    case 2
        surf(x,y,tmpAIC,'CDataMapping','scaled');            
    case 3
        mesh(x,y,tmpAIC,'CDataMapping','scaled');
end 

if tmp_graymap==get(handles.graysurf,'Max')
    colormap(bone);
end
if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
    Hcolorbar=colorbar('vert');
    set(Hcolorbar,'FontSize',MyFontSize); 
end
set(gca,'FontSize',MyFontSize);    

% plot the averaged result ====begin====
figure;

plot(y',handles.ResultData.AIC);

tmpdata=[y' handles.ResultData.AIC];
save tmpAIC.txt tmpdata -ascii;

guidata(gcbo,handles);



%=========================================================================
% --- Executes on button press in Compute.
function Compute_Callback(hObject, eventdata, handles)
% hObject    handle to Compute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.AnaData.SelOneNo<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmp_s=get(handles.morder,'String');
MORDER=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

Fs=handles.RawData.fs;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

SECDETREND=get(handles.detrendtypelist,'Value');
    
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.STFreq,'String');
STFreq=str2num(tmp_s);
tmp_s=get(handles.EDFreq,'String');
EDFreq=str2num(tmp_s);

handles.ResultData.xtime=[];
NormaliseData=get(handles.NormliseData,'Value');

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

    
seced=NOVERLAP;
for j=1:SECNO
    secst=round(seced-NOVERLAP+1);
    seced=round(secst+SECLEN-1);
    handles.ResultData.x(j)=(seced+secst)/2/Fs;

    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
        
    %[pp,cohe,Ixy,Iyx]=pwcausal(xs,Nr,Nl,porder,fs,freq);
    tmp_x=tmp_x';
    [L,N]=size(tmp_x); %L is the number of channels, N is the total points in every channel
    
    Nr=1;
    Nl=N;

    if(get(handles.msExcludingAR,'value')==get(handles.msExcludingAR,'Max'))
        [A,Z]=armorfNoAR(tmp_x,Nr,Nl,MORDER);  %get the model parameters by force the autoregression to 0.   
    else
        [A,Z]=armorf(tmp_x,Nr,Nl,MORDER);  %get the model parameters.   
    end
    tmpi=([1:MORDER]-1)*ChannelNo;
    for m=1:ChannelNo
        for n=1:ChannelNo
            MARP(m,n).C=A(m,tmpi+n);
        end
    end        
    
    [FTrans FCoeff F]=MARSpec(MARP,Z,MORDER,handles.RawData.fs,NFFT,STFreq,EDFreq);
    handles.ResultData.Sec(j).MARP=MARP;
    handles.ResultData.Sec(j).Z=Z;
    handles.ResultData.Sec(j).FTrans=FTrans;
    handles.ResultData.Sec(j).FCoeff=FCoeff;
    %handles.ResultData.Sec(j).FSpectra=FSpectra;
    %handles.ResultData.Sec(j).FDTF=FDTF;
    %handles.ResultData.Sec(j).FDTFn=FDTFn;
    %handles.ResultData.Sec(j).FCAUS=FCAUS;    
end

handles.ResultData.SECNO=SECNO;

handles.ResultData.fre=F;
handles.ResultData.MORDER=MORDER;
handles.ResultData.ChnNo=ChannelNo;

handles.ResType=1;

set(handles.sectiondisp,'Enable','on');
set(handles.GetARCoef,'Enable','on');
set(handles.GetResidual,'Enable','on');
set(handles.PredErrAutoXorr,'Enable','on');
set(handles.PredErrXCross,'Enable','on');

set(handles.saveresulttypeone,'Enable','on');

set(handles.GetPSD,'Enable','on');

set(handles.GetDTF,'Enable','on');
set(handles.NormDTF,'Enable','on');
set(handles.Coherence,'Enable','on');
set(handles.BiUncGewekeNorm,'Enable','on');
set(handles.BiUncGeweke,'Enable','on');



guidata(gcbo,handles);

% --------------------------------------------------------------------
% --- Executes on button press in GetResidual.
function GetResidual_Callback(hObject, eventdata, handles)
% hObject    handle to GetResidual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msSecNo=round(str2num(get(handles.sectiondisp,'string')));
NormaliseData=get(handles.NormliseData,'Value');
tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);
tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;
SECDETREND=get(handles.detrendtypelist,'Value');

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

if msSecNo==0
    t=[1:(SECLEN-handles.ResultData.MORDER)]/handles.RawData.fs;
    for j=1:ChannelNo
        msResidual(j).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
    end
    
    seced=NOVERLAP;        
    for i=1:handles.ResultData.SECNO
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
        tmp_x=X(secst:seced,:);         

        switch SECDETREND
            case 1 %de-mean
                tmp_x = detrend(tmp_x,'constant');
            case 2 %de-linear
                tmp_x = detrend(tmp_x);
            case 3 %without detrending                        
        end
        tmp_x=tmp_x';
    
        rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
        RawSTD(i).C=var(rawX');
        
        predictX=zeros(size(rawX));
        A=zeros(ChannelNo,handles.ResultData.MORDER);
    
        for n=1:ChannelNo 
            for j=1:handles.ResultData.MORDER
                predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
            end
            for m=1:ChannelNo
                for j=1:handles.ResultData.MORDER
                    A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(i).MARP(m,n).C(j);
                end
            end
            rawX=rawX+A*predictX;
        end        

%        msResidual(i).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
        rawX=rawX';
        for j=1:ChannelNo
            msResidual(j).C(:,i)=rawX(:,j);
            ResidSTD(i).C=mean(rawX.*rawX);
        end
    end
        
    meanRatio=zeros(1,ChannelNo);
    meanRawSTD=zeros(1,ChannelNo);
    meanResidSTD=zeros(1,ChannelNo);
    for j=1:handles.ResultData.SECNO
        meanResidSTD=meanResidSTD+ResidSTD(j).C;
        meanRawSTD=meanRawSTD+RawSTD(j).C;
        meanRatio=meanRatio+1-ResidSTD(j).C./RawSTD(j).C;
    end
    meanResidSTD=meanResidSTD/handles.ResultData.SECNO;
    meanRawSTD=meanRawSTD/handles.ResultData.SECNO;
    meanRatio=meanRatio/handles.ResultData.SECNO;
    
    sprintf('RMS of residual : %6.5f\n',meanResidSTD)
    sprintf('VAR of raw signal : %6.5f\n',meanRawSTD)
    sprintf('The R2 coefficient : %6.5f\n',meanRatio)

    
    figure;
    t=[1:(length(tmp_x)-handles.ResultData.MORDER)]/handles.RawData.fs;

    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        plot(t,msResidual(j).C);
    end    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display one section
    else
    seced=NOVERLAP;
    for j=1:msSecNo
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
    end
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
    tmp_x=tmp_x';
    
    rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
    RawSTD=var(rawX');
    
    predictX=zeros(size(rawX));
    A=zeros(ChannelNo,handles.ResultData.MORDER);
    
    for n=1:ChannelNo 
        for j=1:handles.ResultData.MORDER
            predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
        end
        for m=1:ChannelNo
            for j=1:handles.ResultData.MORDER
                A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(msSecNo).MARP(m,n).C(j);
            end
        end
        rawX=rawX+A*predictX;
    end        

    msResidual=rawX;
    tmpf=msResidual';
    ResidSTD=mean(tmpf.*tmpf);
    
    sprintf('RMS of residual : %6.5f\n',ResidSTD)
    sprintf('VAR of raw signal: %6.5f\n',RawSTD)
    sprintf('The coefficient: %5.3f\n',1-ResidSTD./RawSTD)
    
    figure;
    t=[1:(length(tmp_x)-handles.ResultData.MORDER)]/handles.RawData.fs;

    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        plot(t,msResidual(j,:));
    end    
end


% --- Executes on button press in PredErrAutoXorr.
function PredErrAutoXorr_Callback(hObject, eventdata, handles)
% hObject    handle to PredErrAutoXorr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

msSecNo=round(str2num(get(handles.sectiondisp,'string')));
NormaliseData=get(handles.NormliseData,'Value');
tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);
tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;
SECDETREND=get(handles.detrendtypelist,'Value');

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

if msSecNo==0
    t=[1:(SECLEN-handles.ResultData.MORDER)]/handles.RawData.fs;
    for j=1:ChannelNo
        msResidual(j).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
    end
    
    seced=NOVERLAP;        
    for i=1:handles.ResultData.SECNO
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
        tmp_x=X(secst:seced,:);         

        switch SECDETREND
            case 1 %de-mean
                tmp_x = detrend(tmp_x,'constant');
            case 2 %de-linear
                tmp_x = detrend(tmp_x);
            case 3 %without detrending                        
        end
        tmp_x=tmp_x';
    
        rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
        predictX=zeros(size(rawX));
        A=zeros(ChannelNo,handles.ResultData.MORDER);
    
        for n=1:ChannelNo  
            for j=1:handles.ResultData.MORDER
                predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
            end
            for m=1:ChannelNo
                for j=1:handles.ResultData.MORDER
                    A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(i).MARP(m,n).C(j);
                end
            end
            rawX=rawX+A*predictX;
        end        

%        msResidual(i).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
        rawX=rawX';
        for j=1:ChannelNo
            msResidual(j).C(:,i)=rawX(:,j);
        end
    end
    
    figure;
    tmpdata=[];
    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        C=zeros(length(msResidual(j).C)*2-1,ChannelNo);
        for k=1:handles.ResultData.SECNO
            [tmpf,LAGS]=xcorr(msResidual(j).C(:,k),'unbiased');
            tmpf=tmpf';
            C(:,k)=tmpf(:);
        end
        t=LAGS/handles.RawData.fs;
        plot(t,C);
        tdata=mean(C');
        tmpdata=[tmpdata t' tdata'];        
    end    
    save tmpResAuto.txt tmpdata -ascii;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display one section
    else
    seced=NOVERLAP;
    for j=1:msSecNo
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
    end
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
    tmp_x=tmp_x';
    
    rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
    keepRawX=rawX;
    
    predictX=zeros(size(rawX));
    A=zeros(ChannelNo,handles.ResultData.MORDER);
    
    for n=1:ChannelNo 
        for j=1:handles.ResultData.MORDER
            predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
        end
        for m=1:ChannelNo
            for j=1:handles.ResultData.MORDER
                A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(msSecNo).MARP(m,n).C(j);
            end
        end
        rawX=rawX+A*predictX;
    end        

    msResidual=rawX;
    
    figure;
    clear tmpdata;
    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        [C,LAGS]=xcorr(msResidual(j,:),'unbiased'); %autocorrelation 
        t=LAGS/handles.RawData.fs;
        plot(t,C);
    end    
end

%----------------------------------------------------------------------
% --- Executes on button press in PredErrXCross.
function PredErrXCross_Callback(hObject, eventdata, handles)
% hObject    handle to PredErrXCross (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


msSecNo=round(str2num(get(handles.sectiondisp,'string')));
NormaliseData=get(handles.NormliseData,'Value');
tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);
tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;
SECDETREND=get(handles.detrendtypelist,'Value');

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

if msSecNo==-1 %current it is not used
    t=[1:(SECLEN-handles.ResultData.MORDER)]/handles.RawData.fs;
    for j=1:ChannelNo
        msResidual(j).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
    end
    
    seced=NOVERLAP;        
    for i=1:handles.ResultData.SECNO
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
        tmp_x=X(secst:seced,:);         

        switch SECDETREND
            case 1 %de-mean
                tmp_x = detrend(tmp_x,'constant');
            case 2 %de-linear
                tmp_x = detrend(tmp_x);
            case 3 %without detrending                        
        end
        tmp_x=tmp_x';
    
        rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
        predictX=zeros(size(rawX));
        A=zeros(ChannelNo,handles.ResultData.MORDER);
    
        for n=1:ChannelNo  
            for j=1:handles.ResultData.MORDER
                predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
            end
            for m=1:ChannelNo
                for j=1:handles.ResultData.MORDER
                    A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(i).MARP(m,n).C(j);
                end
            end
            rawX=rawX+A*predictX;
        end        

%        msResidual(i).C=zeros(SECLEN-handles.ResultData.MORDER,handles.ResultData.SECNO);
        rawX=rawX';
        for j=1:ChannelNo
            msResidual(j).C(:,i)=rawX(:,j);
        end
    end
    
    figure;

    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        C=zeros(length(msResidual(j).C)*2-1,ChannelNo);
        for k=1:ChannelNo
            [tmpf,LAGS]=xcorr(msResidual(j).C(:,k),'coeff');
            tmpf=tmpf';
            C(:,k)=tmpf(:);
        end
        t=LAGS/handles.RawData.fs;
        plot(t,C);
    end    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %display one section
    
    seced=NOVERLAP;
    for j=1:msSecNo
        secst=round(seced-NOVERLAP+1);
        seced=round(secst+SECLEN-1);
    end
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
    tmp_x=tmp_x';
    
    rawX=tmp_x(:,(handles.ResultData.MORDER+1):length(tmp_x));
    keepRawX=rawX;
    
    predictX=zeros(size(rawX));
    A=zeros(ChannelNo,handles.ResultData.MORDER);
    
    for n=1:ChannelNo 
        for j=1:handles.ResultData.MORDER
            predictX(j,:)=tmp_x(n,j:(length(tmp_x)-handles.ResultData.MORDER+j-1));
        end
        for m=1:ChannelNo
            for j=1:handles.ResultData.MORDER
                A(m,handles.ResultData.MORDER-j+1)=handles.ResultData.Sec(msSecNo).MARP(m,n).C(j);
            end
        end
        rawX=rawX+A*predictX;
    end        

    msResidual=rawX;
    keepRawX=keepRawX;
    
    figure;
    for j=1:ChannelNo
        subplot(ChannelNo,1,j);
        C=zeros(length(msResidual(j,:))*2-1,handles.AnaData.SelOneNo);

        for k=1:ChannelNo
            [tmpf,LAGS]=xcorr(msResidual(j,:),keepRawX(k,:),'coeff');
            tmpf=tmpf';
            C(:,k)=tmpf(:);
        end        
        t=LAGS/handles.RawData.fs;
        plot(t,C);
    end    
end

% --- Executes during object creation, after setting all properties.
function sectiondisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sectiondisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function sectiondisp_Callback(hObject, eventdata, handles)
% hObject    handle to sectiondisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sectiondisp as text
%        str2double(get(hObject,'String')) returns contents of sectiondisp as a double

tmpf=round(str2num(get(hObject,'String')));
if tmpf<0
    tmpf=0;
end
if tmpf>handles.ResultData.SECNO
    tmpf=handles.ResultData.SECNO;    
end
set(hObject,'String',num2str(tmpf));
guidata(gcbo,handles);



% --------------------------------------------------------------------
function varargout = saveresulttypeone_Callback(h, eventdata, handles, varargin)


% --------------------------------------------------------------------
function varargout = GetARCoef_Callback(h, eventdata, handles, varargin)

for j=1:handles.ResultData.SECNO
    for m=1:handles.ResultData.ChnNo
        for n=1:handles.ResultData.ChnNo
            sprintf('(%d %d)',m,n)
            handles.ResultData.Sec(j).MARP(m,n).C
        end
    end
end


% --------------------------------------------------------------------
function varargout = GetPSD_Callback(h, eventdata, handles, varargin)
%partial direced coherence: a new concept in neural structure
%determination. Biol. Cybern. 84, 463-474 (2001)

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
    tmpphase(k).C=zeros(handles.ResultData.ChnNo);
end

for j=1:SECNO
    DZ=handles.ResultData.Sec(j).Z;
    for k=1: NFFT
        tmpspectra=handles.ResultData.Sec(j).FTrans(k).C*DZ*(handles.ResultData.Sec(j).FTrans(k).C')/handles.RawData.fs/2; 
        FSpectra(k).C=abs(tmpspectra);   
        XPhase(k).C=angle(tmpspectra);   
        
        tmpf(k).C=tmpf(k).C+FSpectra(k).C;
        tmpphase(k).C=tmpphase(k).C+XPhase(k).C;
    end
    handles.ResultData.Sec(j).Phase=XPhase;
    handles.ResultData.Sec(j).FSpectra=FSpectra;
end

for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
    tmpphase(k).C=tmpphase(k).C/SECNO;
end

handles.ResultData.FSpectra=tmpf;
handles.ResultData.Phase=tmpphase;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=log10(handles.ResultData.Sec(n).FSpectra(m).C(i,j));
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
clear tmpdata;
tmpdata=y';
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.FSpectra(m).C(i,j);
        end
        
        plot(y,z);
        tmpdata=[tmpdata z'];
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('Spectra(%d->%d)',j,i);
        title(tmp_s);
    end
end

tmpdata=tmpdata';
tmps=handles.FileInfo.fname;
filename=tmps(1:(length(tmps)-4));
filename=strcat(filename,'-PSD.txt');
file=fopen(filename,'w');
fprintf(file,'%f %f %f %f %f\n',tmpdata);
fclose(file);

% plot the averaged result ====end====

% ****************** plot phase result*******************************

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).Phase(m).C(i,j);
            end
        end
        for n=1:handles.ResultData.SECNO
            z(:,n)=unwrap(z(:,n));
        end
        
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('phase (%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
clear tmpdata;
tmpdata=y';

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.Phase(m).C(i,j);
        end
        z=unwrap(z);
        plot(y,z);
        tmpdata=[tmpdata z'];
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====
save tmpPhase.txt tmpdata -ascii;
guidata(gcbo,handles);


% --------------------------------------------------------------------

% --- Executes on button press in Coherence.
function Coherence_Callback(hObject, eventdata, handles)
% hObject    handle to Coherence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================================================
%
% Mingzhou Ding, et al. Short-window spectral analysis of cortical event-related potentials
% by adaptive multivariate autoregressive modeling:
% data preprocessing, model validation, and variability assessment. Biol. Cybern. 83, 35-45 (2000)
% Anna Korzeniewska et al. Determination of information flow direction among brain structures
% by a modified directed transfer function (dDTF) method
% Journal of Neuroscience Methods 125 (2003) 195-207

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
end

for j=1:SECNO
    %DZ=diag(diag(handles.ResultData.Sec(j).Z));
    DZ=handles.ResultData.Sec(j).Z;
    for k=1: NFFT
        FSpectra(k).C=abs(handles.ResultData.Sec(j).FTrans(k).C*DZ*(handles.ResultData.Sec(j).FTrans(k).C'));   
        tmpM=diag(FSpectra(k).C);
        tmpM1=repmat(tmpM,1,handles.ResultData.ChnNo);
        tmpM2=repmat(tmpM',handles.ResultData.ChnNo,1);
        tmpM=tmpM1.*tmpM2;
        PCOH(k).C=((FSpectra(k).C).^2)./tmpM;

        tmpf(k).C=tmpf(k).C+PCOH(k).C;
    end
    handles.ResultData.Sec(j).PCOH=PCOH;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.PCOH=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).PCOH(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
clear tmpdata;
tmpdata=y';
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.PCOH(m).C(i,j);
        end
        plot(y,z);
        tmpdata=[tmpdata z'];
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====
tmpdata=tmpdata';
tmps=handles.FileInfo.fname;
filename=tmps(1:(length(tmps)-4));
filename=strcat(filename,'-Coh.txt');
file=fopen(filename,'w');
fprintf(file,'%f %f %f %f %f\n',tmpdata);
fclose(file);

guidata(gcbo,handles);



% --------------------------------------------------------------------

% --- Executes on button press in PartialCoherence.
function PartialCoherence_Callback(hObject, eventdata, handles)
% hObject    handle to PartialCoherence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%====================================================
%


tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
end

for j=1:handles.ResultData.ChnNo
    for k=1:handles.ResultData.ChnNo
        jj=1;
        kk=1;
        for m=1:handles.ResultData.ChnNo
            if m~=j
                SubM(j,k).Row(jj)=m;
                jj=jj+1;
            end
            if m~=k
                SubM(j,k).Col(kk)=m;
                kk=kk+1;
            end
        end
    end
end

% MJ Kaminski et al. A new method of the description of the information
% flow in the brain structure. Biol Cybern. 65, 203-210 (1991)
% Anna Korzeniewska et al. Determination of information flow direction among brain structures
% by a modified directed transfer function (dDTF) method
% Journal of Neuroscience Methods 125 (2003) 195-207

for j=1:SECNO
    DZ=handles.ResultData.Sec(j).Z;
    for k=1: NFFT
        FSpectra(k).C=abs(handles.ResultData.Sec(j).FTrans(k).C*DZ*(handles.ResultData.Sec(j).FTrans(k).C'));   
        for m=1:handles.ResultData.ChnNo
            for n=1:handles.ResultData.ChnNo
                tmpfone=det(FSpectra(k).C(SubM(m,n).Row,SubM(m,n).Col));
                tmpftwo=det(FSpectra(k).C(SubM(m,m).Row,SubM(m,m).Col))*det(FSpectra(k).C(SubM(n,n).Row,SubM(n,n).Col));
                PCOH(k).C(m,n)=tmpfone*tmpfone/tmpftwo;
            end
        end
        tmpf(k).C=tmpf(k).C+PCOH(k).C;
    end
    handles.ResultData.Sec(j).PCOH=PCOH;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.PCOH=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).PCOH(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.PCOH(m).C(i,j);
        end
        plot(y,z);
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====

guidata(gcbo,handles);


% --- Executes on button press in partCoherenceTwo.
function partCoherenceTwo_Callback(hObject, eventdata, handles)
% hObject    handle to partCoherenceTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Halliday DM, et al. A framework for the analysis of the mixed time
% series. Prog. Biophys. Molec. Biol. 64(2/3): 237-278. 1995
% J.R. Rosenberg, et al. Identification of patterns of neuronal connectivity partial spectra,
% partial coherence, and neuronal interactions. Journal of Neuroscience Methods 83 (1998) 57-72

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

ChnNNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo;
ChnMNo=handles.AnaData.SelThreeNo;

for k=1: NFFT
    tmpf(k).C=zeros(ChnNNo);
end

SubM.NNRowNo=[1:ChnNNo]';
SubM.NNColNo=[1:ChnNNo];
SubM.NMRowNo=[1:ChnNNo]';
SubM.NMColNo=[ChnNNo+1:ChnNNo+ChnMNo];
SubM.MMRowNo=[ChnNNo+1:ChnNNo+ChnMNo]';
SubM.MMColNo=[ChnNNo+1:ChnNNo+ChnMNo];
SubM.MNRowNo=[ChnNNo+1:ChnNNo+ChnMNo]';
SubM.MNColNo=[1:ChnNNo];

%=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo

for j=1:SECNO
    DZ=handles.ResultData.Sec(j).Z;
    for k=1: NFFT
        FSpectra(k).C=(handles.ResultData.Sec(j).FTrans(k).C*DZ*(handles.ResultData.Sec(j).FTrans(k).C'));  
        %here , the amplitude or the raw cross-spectral is used? 
        
        Fnn=FSpectra(k).C(SubM.NNRowNo,SubM.NNColNo);
        Fnm=FSpectra(k).C(SubM.NMRowNo,SubM.NMColNo);
        Fmm=FSpectra(k).C(SubM.MMRowNo,SubM.MMColNo);
        Fmn=FSpectra(k).C(SubM.MNRowNo,SubM.MNColNo);
        
        CondSpectra=Fnn-Fnm*inv(Fmm)*Fmn;
        
        for m=1:ChnNNo
            for n=1:ChnNNo
                if m~=n
                    PCOH(k).C(m,n)=abs((abs(CondSpectra(m,n)))^2/(CondSpectra(m,m)*CondSpectra(n,n)));
                else
                    PCOH(k).C(m,n)=1;
                end
            end
        end
        tmpf(k).C=tmpf(k).C+PCOH(k).C;
    end
    handles.ResultData.Sec(j).PCOH=PCOH;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.PCOH=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=ChnNNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).PCOH(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.PCOH(m).C(i,j);
        end
        plot(y,z);
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====

guidata(gcbo,handles);



% --- Executes on button press in PartCohVARmodel.
function PartCohVARmodel_Callback(hObject, eventdata, handles)
% hObject    handle to PartCohVARmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

SubM=msGetSubMatrix(handles.ResultData.ChnNo);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
end

for j=1:SECNO
    DZ=handles.ResultData.Sec(j).Z;
    for k=1: NFFT
        FSpectra(k).C=(handles.ResultData.Sec(j).FTrans(k).C*DZ*(handles.ResultData.Sec(j).FTrans(k).C'));  
        %here , the amplitude or the raw cross-spectral is used? 
        for m=1:handles.ResultData.ChnNo
            for n=1:handles.ResultData.ChnNo
                Fnn=FSpectra(k).C(sub2ind(size(FSpectra(k).C),SubM(m,n).NNRowNo,SubM(m,n).NNColNo));
                Fnm=FSpectra(k).C(sub2ind(size(FSpectra(k).C),SubM(m,n).NMRowNo,SubM(m,n).NMColNo));
                Fmm=FSpectra(k).C(sub2ind(size(FSpectra(k).C),SubM(m,n).MMRowNo,SubM(m,n).MMColNo));
                Fmn=FSpectra(k).C(sub2ind(size(FSpectra(k).C),SubM(m,n).MNRowNo,SubM(m,n).MNColNo));
                
                CondSpectra=Fnn-Fnm*inv(Fmm)*Fmn;
                if m~=n
                    PCOH(k).C(m,n)=abs((abs(CondSpectra(1,2)))^2/(CondSpectra(1,1)*CondSpectra(2,2)));
                else
                    PCOH(k).C(m,n)=1;
                end
            end
        end
        tmpf(k).C=tmpf(k).C+PCOH(k).C;
    end
    handles.ResultData.Sec(j).PCOH=PCOH;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.PCOH=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).PCOH(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.PCOH(m).C(i,j);
        end
        plot(y,z);
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = GetDTF_Callback(h, eventdata, handles, varargin)

%====================================================

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
end
for j=1:SECNO
    for k=1: NFFT
        %DZ=repmat(diag(handles.ResultData.Sec(j).Z),1,handles.ResultData.ChnNo);
        FDTF(k).C=abs(handles.ResultData.Sec(j).FTrans(k).C).^2; %transfer function
        tmpf(k).C=tmpf(k).C+FDTF(k).C;
    end
    handles.ResultData.Sec(j).FDTF=FDTF;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.FDTF=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).FDTF(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
tmpdata=y';
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.FDTF(m).C(i,j);
        end
        tmpdata=[tmpdata z'];
        plot(y,z);
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====

[fname,pname]=uiputfile('*.txt','Save result');

if fname==0 
    return;
end

tmpdata=tmpdata';
file=fopen(fname,'w');
fprintf(file,'%f %f %f %f %f\n',tmpdata);
% frequency, 1-1, 2->1, 1->2, 2-2
fclose(file);

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = NormDTF_Callback(h, eventdata, handles, varargin)

%====================================================
MOne=ones(handles.ResultData.ChnNo);
tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);
NFFT=length(handles.ResultData.fre);

for k=1: NFFT
    tmpf(k).C=zeros(handles.ResultData.ChnNo);
end
for j=1:SECNO
    for k=1: NFFT
        FDTF(k).C=abs(handles.ResultData.Sec(j).FTrans(k).C).^2;
        tmpM=FDTF(k).C*MOne;
        FDTFn(k).C=(FDTF(k).C)./tmpM; %direct transfer function
        
        tmpf(k).C=tmpf(k).C+FDTFn(k).C;
    end
    handles.ResultData.Sec(j).FDTFn=FDTFn;
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end

handles.ResultData.FDTFn=tmpf;
%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).FDTFn(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.FDTFn(m).C(i,j);
        end
        plot(y,z);
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====

guidata(gcbo,handles);




% --------------------------------------------------------------------
% --- Executes on button press in BiUncGeweke.
function BiUncGeweke_Callback(hObject, eventdata, handles)
% hObject    handle to BiUncGeweke (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.AnaData.SelOneNo<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmp_s=get(handles.morder,'String');
MORDER=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

Fs=handles.RawData.fs;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

SECDETREND=get(handles.detrendtypelist,'Value');
    
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.STFreq,'String');
STFreq=str2num(tmp_s);
tmp_s=get(handles.EDFreq,'String');
EDFreq=str2num(tmp_s);

handles.ResultData.xtime=[];
NormaliseData=get(handles.NormliseData,'Value');

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

for k=1: NFFT
    tmpf(k).C=zeros(ChannelNo);
end

seced=NOVERLAP;
for j=1:SECNO
    secst=round(seced-NOVERLAP+1);
    seced=round(secst+SECLEN-1);
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
        
    %[pp,cohe,Ixy,Iyx]=pwcausal(xs,Nr,Nl,porder,fs,freq);
    tmp_x=tmp_x';
    [L,N]=size(tmp_x); %L is the number of channels, N is the total points in every channel
    
    Nr=1;
    Nl=N;

    tmpi=([1:MORDER]-1)*2;
    for m=1:ChannelNo
        for n=m+1:ChannelNo
            y(1,:)=tmp_x(m,:);
            y(2,:)=tmp_x(n,:);  
            [A,Z2]=armorf(y,Nr,Nl,MORDER); %get the model parameters for each two pairs.
            eyx=Z2(2,2)-Z2(1,2)^2/Z2(1,1); %corrected covariance
            exy=Z2(1,1)-Z2(2,1)^2/Z2(2,2);
            for p=1:2
                for q=1:2
                    MARP(p,q).C=A(p,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,MORDER,handles.RawData.fs,NFFT,STFreq,EDFreq); 
            for k=1: NFFT
                S2=abs(H2(k).C*Z2*H2(k).C'); 
                Iy2x=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))); %Geweke's original measure
                Fx2y=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
                handles.ResultData.Sec(j).OriGeweke(k).C(m,n)=Fy2x;
                handles.ResultData.Sec(j).OriGeweke(k).C(n,m)=Fx2y;
            end
        end
    end
end

for k=1: NFFT
    for j=1:SECNO
        tmpf(k).C=tmpf(k).C+handles.ResultData.Sec(j).OriGeweke(k).C;
    end
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end
handles.ResultData.OriGeweke=tmpf;

handles.ResultData.SECNO=SECNO;
%handles.ResultData.x=([1:handles.ResultData.SECNO]-0.5)*SECLEN/Fs;
handles.ResultData.fre=F;
handles.ResultData.MORDER=MORDER;
handles.ResultData.ChnNo=ChannelNo;


%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).OriGeweke(m).C(i,j);
            end
        end
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
clear tmpdata;
tmpdata=y';
for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.OriGeweke(m).C(i,j);
        end
        plot(y,z);
        tmpdata=[tmpdata z'];
        
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====
tmpdata=tmpdata';
tmps=handles.FileInfo.fname;
filename=tmps(1:(length(tmps)-4));
filename=strcat(filename,'-Causality.txt');
file=fopen(filename,'w');
fprintf(file,'%f %f %f %f %f\n',tmpdata);
fclose(file);

guidata(gcbo,handles);




% --------------------------------------------------------------------

% --- Executes on button press in BiUncGewekeNorm.
function BiUncGewekeNorm_Callback(hObject, eventdata, handles)
% hObject    handle to BiUncGewekeNorm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to ModifiedGewekeCausality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.AnaData.SelOneNo<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmp_s=get(handles.morder,'String');
MORDER=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
SECLEN=round(str2num(tmp_s)*handles.RawData.fs-1);

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

Fs=handles.RawData.fs;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s)*handles.RawData.fs;

tmp_s=get(handles.sectionno,'String');
SECNO=str2num(tmp_s);

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

SECDETREND=get(handles.detrendtypelist,'Value');
    
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.STFreq,'String');
STFreq=str2num(tmp_s);
tmp_s=get(handles.EDFreq,'String');
EDFreq=str2num(tmp_s);

handles.ResultData.xtime=[];
NormaliseData=get(handles.NormliseData,'Value');

for i=1:handles.AnaData.SelOneNo
    X(:,i)=handles.RawData.data(stp:endp,handles.AnaData.SelOneChn(i));
end
for i=1:handles.AnaData.SelTwoNo
    X(:,i+handles.AnaData.SelOneNo)=handles.RawData.data(stp:endp,handles.AnaData.SelTwoChn(i));
end
for i=1:handles.AnaData.SelThreeNo
    X(:,i+handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo)=handles.RawData.data(stp:endp,handles.AnaData.SelThreeChn(i));
end
ChannelNo=handles.AnaData.SelOneNo+handles.AnaData.SelTwoNo+handles.AnaData.SelThreeNo;

for i=1:ChannelNo
    if NormaliseData==get(handles.NormliseData,'Max')
        X(:,i)=X(:,i)/std(X(:,i));
    end
end

for k=1: NFFT
    tmpf(k).C=zeros(ChannelNo);
end

seced=NOVERLAP;
for j=1:SECNO
    secst=round(seced-NOVERLAP+1);
    seced=round(secst+SECLEN-1);
    tmp_x=X(secst:seced,:);         

    switch SECDETREND
        case 1 %de-mean
            tmp_x = detrend(tmp_x,'constant');
        case 2 %de-linear
            tmp_x = detrend(tmp_x);
        case 3 %without detrending                        
    end
        
    %[pp,cohe,Ixy,Iyx]=pwcausal(xs,Nr,Nl,porder,fs,freq);
    tmp_x=tmp_x';
    [L,N]=size(tmp_x); %L is the number of channels, N is the total points in every channel
    
    Nr=1;
    Nl=N;

    tmpi=([1:MORDER]-1)*2;
    for m=1:ChannelNo
        for n=m+1:ChannelNo
            y(1,:)=tmp_x(m,:);
            y(2,:)=tmp_x(n,:);  
            [A,Z2]=armorf(y,Nr,Nl,MORDER); %get the model parameters for each two pairs.
            eyx=Z2(2,2)-Z2(1,2)^2/Z2(1,1); %corrected covariance
            exy=Z2(1,1)-Z2(2,1)^2/Z2(2,2);
            for p=1:2
                for q=1:2
                    MARP(p,q).C=A(p,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,MORDER,handles.RawData.fs,NFFT,STFreq,EDFreq); 
            for k=1: NFFT
                S2=abs(H2(k).C*Z2*H2(k).C'); 
                Iy2x=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
                handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
                handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
        end
    end
end

for k=1: NFFT
    for j=1:SECNO
        tmpf(k).C=tmpf(k).C+handles.ResultData.Sec(j).CorGeweke(k).C;
    end
end
for k=1: NFFT
    tmpf(k).C=tmpf(k).C/SECNO;
end
handles.ResultData.CorGeweke=tmpf;

handles.ResultData.SECNO=SECNO;
%handles.ResultData.x=([1:handles.ResultData.SECNO]-0.5)*SECLEN/Fs;
handles.ResultData.fre=F;
handles.ResultData.MORDER=MORDER;
handles.ResultData.ChnNo=ChannelNo;


%====================================================

MyFontSize=16;
tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_graymap=get(handles.graysurf,'Value');
tmp_shadingmode=get(handles.shadingmode,'Value');
tmp_colorbar=get(handles.colorbar,'Value');

tmp_plotmode=get(handles.plotmode,'Value');

if get(handles.plotmulti,'Value')==get(handles.plotmulti,'Max')
    tmp_multiplot=1;
else
    tmp_multiplot=0;
end

rowno=handles.ResultData.ChnNo;
colno=rowno;

x=handles.ResultData.x-handles.ResultData.x(1);
y=handles.ResultData.fre;
FN=length(y);

if tmp_multiplot==0
    figure;
end

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            for n=1:handles.ResultData.SECNO
                z(m,n)=handles.ResultData.Sec(n).CorGeweke(m).C(i,j);
            end
        end
        z(1,1)=1.0;
        switch tmp_plotmode
        case 1
            image(x,y,z,'CDataMapping','scaled'); 
        case 2
            surf(x,y,z,'CDataMapping','scaled');            
        case 3
            mesh(x,y,z,'CDataMapping','scaled');
        end 
        
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(bone);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            Hcolorbar=colorbar('vert');
            set(Hcolorbar,'FontSize',MyFontSize); 
        end
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end

% plot the averaged result ====begin====
if tmp_multiplot==0
    figure;
end
clear z;
clear tmpdata;
tmpdata=y';

for i=1:rowno
    for j=1:colno
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*colno+j);
        else 
            figure;
        end
        for m=1:FN
            z(m)=handles.ResultData.CorGeweke(m).C(i,j);
        end
        plot(y,z);
        tmpdata=[tmpdata z'];
        set(gca,'FontSize',MyFontSize);    
        tmp_s=sprintf('(%d->%d)',j,i);
        title(tmp_s);
    end
end
% plot the averaged result ====end====
tmpdata=tmpdata';
tmps=handles.FileInfo.fname;
filename=tmps(1:(length(tmps)-4));
filename=strcat(filename,'-Causality.txt');
file=fopen(filename,'w');
fprintf(file,'%f %f %f %f %f\n',tmpdata);
fclose(file);

guidata(gcbo,handles);






% --- Executes on button press in NormliseData.
function NormliseData_Callback(hObject, eventdata, handles)
% hObject    handle to NormliseData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NormliseData

set(handles.sectiondisp,'Enable','off');
set(handles.PredErrAutoXorr,'Enable','off');

set(handles.saveresulttypeone,'Enable','off');
set(handles.GetPSD,'Enable','off');
set(handles.GetDTF,'Enable','off');
set(handles.NormDTF,'Enable','off');
set(handles.KaminskiCausality,'Enable','off');
set(handles.GetARCoef,'Enable','off');
set(handles.GetResidual,'Enable','off');
set(handles.Coherence,'Enable','off');
set(handles.PartialCoherence,'Enable','off');
set(handles.ModifiedGewekeCausality,'Enable','off');
set(handles.BiUncGewekeNorm,'Enable','off');
set(handles.BiUncGeweke,'Enable','off');
set(handles.partCoherenceTwo,'Enable','off');




