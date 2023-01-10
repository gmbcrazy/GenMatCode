function varargout = msdrawraw(varargin)
% msdrawraw Application M-file for msdrawraw.fig
%    FIG = msdrawraw launch msdrawraw GUI.
%    msdrawraw('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 08-Apr-2005 16:59:16

if nargin == 0 |nargin == 2 % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    
    %initial the data.
    tmp_struct=varargin{2};
    handles.FileInfo=tmp_struct.FileInfo;
    handles.RawData=tmp_struct.RawData;
%///////////Initial the dialog///////////////////////////////////////////////////e////////////////////
    %initial the listbox:rawlist
    tmp_str=getliststr(handles.RawData.chnno,handles.FileInfo.chnname);
    set(handles.rawlistone,'String',tmp_str,'Value',1);
    set(handles.sellist,'String','');
    
    %initial the pushbutton
    set(handles.addsel,'Enable','on');
    set(handles.delsel,'Enable','off');
    
    %initial the data used for analysis
    handles.AnaData.selno=0;%total number of the selected channel
    handles.AnaData.selfirstchn=[];%the channel number in raw data
    
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


function FontSize_Callback(hObject, eventdata, handles)
% hObject    handle to FontSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FontSize as text
%        str2double(get(hObject,'String')) returns contents of FontSize as a double


% --- Executes during object creation, after setting all properties.
function LineWidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LineWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function LineWidth_Callback(hObject, eventdata, handles)
% hObject    handle to LineWidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LineWidth as text
%        str2double(get(hObject,'String')) returns contents of LineWidth as a double


% --- Executes during object creation, after setting all properties.
function Xmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Xmin_Callback(hObject, eventdata, handles)
% hObject    handle to Xmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmin as text
%        str2double(get(hObject,'String')) returns contents of Xmin as a double


% --- Executes during object creation, after setting all properties.
function Xmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Xmax_Callback(hObject, eventdata, handles)
% hObject    handle to Xmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xmax as text
%        str2double(get(hObject,'String')) returns contents of Xmax as a double


% --- Executes during object creation, after setting all properties.
function Ymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Ymin_Callback(hObject, eventdata, handles)
% hObject    handle to Ymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ymin as text
%        str2double(get(hObject,'String')) returns contents of Ymin as a double


% --- Executes during object creation, after setting all properties.
function Ymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Ymax_Callback(hObject, eventdata, handles)
% hObject    handle to Ymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Ymax as text
%        str2double(get(hObject,'String')) returns contents of Ymax as a double


% --- Executes during object creation, after setting all properties.
function SrcW_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SrcW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SrcW_Callback(hObject, eventdata, handles)
% hObject    handle to SrcW (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SrcW as text
%        str2double(get(hObject,'String')) returns contents of SrcW as a double


% --- Executes during object creation, after setting all properties.
function SrcH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SrcH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SrcH_Callback(hObject, eventdata, handles)
% hObject    handle to SrcH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SrcH as text
%        str2double(get(hObject,'String')) returns contents of SrcH as a double


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

for i=1:handles.AnaData.selno
    if tmp_i==handles.AnaData.selfirstchn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addsel,'Enable','off');
else
    set(handles.addsel,'Enable','on');
end

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = sellist_Callback(h, eventdata, handles, varargin)

set(handles.delsel,'Enable','on');

% --------------------------------------------------------------------
function varargout = addsel_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.rawlistone,'Value');

handles.AnaData.selno=handles.AnaData.selno+1;
handles.AnaData.selfirstchn(handles.AnaData.selno)=get(handles.rawlistone,'Value');
handles.AnaData.selfirstchnname(handles.AnaData.selno)=handles.FileInfo.chnname(get(handles.rawlistone,'Value'));
tmp_str=getliststr(handles.AnaData.selno,handles.AnaData.selfirstchnname);
set(handles.sellist,'String',tmp_str,'Value',1);

%prepare to add next channel data
tmpi=get(handles.rawlistone,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlistone,'Value',tmpi);
guidata(gcbo,handles);
rawlistone_Callback(h, eventdata, handles, varargin);

set(handles.delsel,'Enable','on');

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = delsel_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.sellist,'Value');
for i=tmp_i:handles.AnaData.selno-1
    handles.AnaData.selfirstchn(i)=handles.AnaData.selfirstchn(i+1);
    handles.AnaData.selfirstchnname(i)=handles.AnaData.selfirstchnname(i+1);
end

handles.AnaData.selno=handles.AnaData.selno-1;
tmp_str=getliststr(handles.AnaData.selno,handles.AnaData.selfirstchnname);
set(handles.sellist,'String',tmp_str);

if handles.AnaData.selno>0
    set(handles.delsel,'Enable','on');
    set(handles.sellist,'Value',1);
else
    set(handles.delsel,'Enable','off');
end

ChnExisted=0;
tmp_i=get(handles.rawlistone,'Value');

for i=1:handles.AnaData.selno
    if tmp_i==handles.AnaData.selfirstchn(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addsel,'Enable','off');
else
    set(handles.addsel,'Enable','on');
end

guidata(gcbo,handles);

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
function varargout = default_Callback(h, eventdata, handles, varargin)

getdefaultsetting(gcbo,handles);


% --------------------------------------------------------------------
function setmark=getdefaultsetting(fig,handles)
%initial the setting by default from file

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);


%open the setting file
fid=fopen('msdrawraw.inf','r');
if fid==-1
    setmark=0;
    % restoresetting(gcbo,handles);
    return;
end

tmpd=fscanf(fid,'%d\n',[1 1]);
set(handles.FontSize,'string',num2str(tmpd));
tmpd=fscanf(fid,'%d\n',[1 1]);
set(handles.LineWidth,'string',num2str(tmpd));
tmpd=fscanf(fid,'%f\n',[1 1]);
set(handles.Xmin,'string',num2str(tmpd));
tmpd=fscanf(fid,'%f\n',[1 1]);
set(handles.Xmax,'string',num2str(tmpd));
tmpd=fscanf(fid,'%f\n',[1 1]);
set(handles.Ymin,'string',num2str(tmpd));
tmpd=fscanf(fid,'%f\n',[1 1]);
set(handles.Ymax,'string',num2str(tmpd));
tmpd=fscanf(fid,'%d\n',[1 1]);
set(handles.SrcW,'string',num2str(tmpd));
tmpd=fscanf(fid,'%d\n',[1 1]);
set(handles.SrcH,'string',num2str(tmpd));

set(handles.tickXLable,'value',get(handles.tickXLable,'Max'));
set(handles.tickXAxis,'value',get(handles.tickXAxis,'Max'));
set(handles.tickYLable,'value',get(handles.tickYLable,'Max'));
set(handles.tickYAxis,'value',get(handles.tickYAxis,'Max'));
set(handles.tickUpRightAxis,'value',get(handles.tickUpRightAxis,'Min'));


setmark=1;

guidata(fig, handles);


% --------------------------------------------------------------------
function varargout = savedefault_Callback(h, eventdata, handles, varargin)

fid=fopen('msdrawraw.inf','wt');
if fid==-1
    return;
end

tmps=get(handles.FontSize,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.LineWidth,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.Xmin,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.Xmax,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.Ymin,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.Ymax,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.SrcW,'string');
fprintf(fid,'%s\n',tmps);
tmps=get(handles.SrcH,'string');
fprintf(fid,'%s\n',tmps);

fclose(fid);


% --------------------------------------------------------------------
function varargout = restore_Callback(h, eventdata, handles, varargin)

restoresetting(gcbo,handles);


% --------------------------------------------------------------------
function restoresetting(fig,handles)
% initial the setting relative the raw data

set(handles.FontSize,'string','16');
set(handles.LineWidth,'string','1');
set(handles.Xmin,'string','0');
set(handles.Xmax,'string','1');
set(handles.Ymin,'string','-1');
set(handles.Ymax,'string','1');
set(handles.SrcW,'string','1024');
set(handles.SrcH,'string','768');

guidata(fig, handles);



%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting relative functions.
% =====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====



% --------------------------------------------------------------------
function varargout = PlotWithOneFormat_Callback(h, eventdata, handles, varargin)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
rowno=handles.AnaData.selno;

pos(1)=0;
pos(2)=0;
tmps=get(handles.SrcW,'string');
pos(3)=str2num(tmps);
tmps=get(handles.SrcH,'string');
pos(4)=str2num(tmps);
figure('Position',pos);

x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
for i=1:rowno
    y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
    subplot(rowno,1,i);
    plot(x,y,'k');

    %C:/MATLAB6p5/help/techdoc/infotool/hgprop/instruct.html
    tmps=get(handles.FontSize,'string');
    set(gca,'FontSize',str2num(tmps));
    
    tmps=get(handles.LineWidth,'string');
    set(get(gca,'Children'),'LineWidth',str2num(tmps)); 

    tmps=get(handles.Xmin,'string');
    tmpf(1)=str2num(tmps);
    tmps=get(handles.Xmax,'string');
    tmpf(2)=str2num(tmps);
    set(gca,'XLim',tmpf);
  
    tmps=get(handles.Ymin,'string');
    tmpf(1)=str2num(tmps);
    tmps=get(handles.Ymax,'string');
    tmpf(2)=str2num(tmps);
    set(gca,'YLim',tmpf); 
    
%    if i<rowno
%        set(gca,'xticklabel','');
%    end
    
    if get(handles.tickXLable,'value')==get(handles.tickXLable,'Min')
        set(gca,'xticklabel','');
    end
    if get(handles.tickXAxis,'value')==get(handles.tickXAxis,'Min')
        set(gca,'xtick',[]);
        set(gca,'xminortick','off');
        set(gca,'xcolor','white');
    end
    if get(handles.tickYLable,'value')==get(handles.tickYLable,'Min')
        set(gca,'yticklabel','');
    end
    if get(handles.tickYAxis,'value')==get(handles.tickYAxis,'Min')
        set(gca,'ytick',[]);
        set(gca,'yminortick','off');
        set(gca,'ycolor','white');
    end
    
    if get(handles.tickUpRightAxis,'value')==get(handles.tickUpRightAxis,'Min')
        box off;
    end
    set(gca,'Color','none');
end

guidata(gcbo,handles);


% --------------------------------------------------------------------
% --- Executes on button press in VariedFormat.
function VariedFormat_Callback(hObject, eventdata, handles)
% hObject    handle to VariedFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
rowno=handles.AnaData.selno;

pos(1)=0;
pos(2)=0;
tmps=get(handles.SrcW,'string');
pos(3)=str2num(tmps);
tmps=get(handles.SrcH,'string');
pos(4)=str2num(tmps);
figure('Position',pos);

x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
for i=1:rowno
    y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
    subplot(rowno,1,i);
    plot(x,y,'k');

    %C:/MATLAB6p5/help/techdoc/infotool/hgprop/instruct.html
    tmps=get(handles.FontSize,'string');
    set(gca,'FontSize',str2num(tmps));
    
    tmps=get(handles.LineWidth,'string');
    set(get(gca,'Children'),'LineWidth',str2num(tmps)); 

    tmps=get(handles.Xmin,'string');
    tmpf(1)=str2num(tmps);
    tmps=get(handles.Xmax,'string');
    tmpf(2)=str2num(tmps);
    set(gca,'XLim',tmpf);
  
    tmpf(1)=min(y);
    tmpf(2)=max(y);
    set(gca,'YLim',tmpf); 
    
    if get(handles.tickXLable,'value')==get(handles.tickXLable,'Min')
        set(gca,'xticklabel','');
    end
    if get(handles.tickXAxis,'value')==get(handles.tickXAxis,'Min')
        set(gca,'xtick',[]);
        set(gca,'xminortick','off');
        set(gca,'xcolor','white');
    end
    if get(handles.tickYLable,'value')==get(handles.tickYLable,'Min')
        set(gca,'yticklabel','');
    end
    if get(handles.tickYAxis,'value')==get(handles.tickYAxis,'Min')
        set(gca,'ytick',[]);
        set(gca,'yminortick','off');
        set(gca,'ycolor','white');
    end
    if get(handles.tickUpRightAxis,'value')==get(handles.tickUpRightAxis,'Min')
        box off;
    end
    set(gca,'Color','none');
end

guidata(gcbo,handles);


% --- Executes on button press in tickXLable.
function tickXLable_Callback(hObject, eventdata, handles)
% hObject    handle to tickXLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickXLable


% --- Executes on button press in tickXAxis.
function tickXAxis_Callback(hObject, eventdata, handles)
% hObject    handle to tickXAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickXAxis


% --- Executes on button press in tickYLable.
function tickYLable_Callback(hObject, eventdata, handles)
% hObject    handle to tickYLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickYLable


% --- Executes on button press in tickYAxis.
function tickYAxis_Callback(hObject, eventdata, handles)
% hObject    handle to tickYAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickYAxis


% --- Executes on button press in tickUpRightAxis.
function tickUpRightAxis_Callback(hObject, eventdata, handles)
% hObject    handle to tickUpRightAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickUpRightAxis


% --- Executes on button press in tickLastXAxis.
function tickLastXAxis_Callback(hObject, eventdata, handles)
% hObject    handle to tickLastXAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickLastXAxis


% --- Executes on button press in tickLastXLable.
function tickLastXLable_Callback(hObject, eventdata, handles)
% hObject    handle to tickLastXLable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of tickLastXLable


% --- Executes on button press in msDrawXYFormat.
function msDrawXYFormat_Callback(hObject, eventdata, handles)
% hObject    handle to msDrawXYFormat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.AnaData.selno<2
    msgbox('Please select two signals for analysis at least!','No signal is selected');
    return;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
rowno=handles.AnaData.selno;

pos(1)=0;
pos(2)=0;
tmps=get(handles.SrcW,'string');
pos(3)=str2num(tmps);
tmps=get(handles.SrcH,'string');
pos(4)=str2num(tmps);
figure('Position',pos);

x=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(1));
y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(2));

plot(x,y,'k');

    

guidata(gcbo,handles);


% --- Executes on button press in msMultiTracePlot.
function msMultiTracePlot_Callback(hObject, eventdata, handles)
% hObject    handle to msMultiTracePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
rowno=handles.AnaData.selno;

pos(1)=0;
pos(2)=0;
tmps=get(handles.SrcW,'string');
pos(3)=str2num(tmps);
tmps=get(handles.SrcH,'string');
pos(4)=str2num(tmps);
figure('Position',pos);

plotdata=[];
x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
x=x';
for i=1:rowno
    y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
    plotdata=[plotdata y];
end
    plot(x,plotdata);

    %C:/MATLAB6p5/help/techdoc/infotool/hgprop/instruct.html
    tmps=get(handles.FontSize,'string');
    set(gca,'FontSize',str2num(tmps));
    
    tmps=get(handles.LineWidth,'string');
    set(get(gca,'Children'),'LineWidth',str2num(tmps)); 

    if get(handles.tickXLable,'value')==get(handles.tickXLable,'Min')
        set(gca,'xticklabel','');
    end
    if get(handles.tickXAxis,'value')==get(handles.tickXAxis,'Min')
        set(gca,'xtick',[]);
        set(gca,'xminortick','off');
        set(gca,'xcolor','white');
    end
    if get(handles.tickYLable,'value')==get(handles.tickYLable,'Min')
        set(gca,'yticklabel','');
    end
    if get(handles.tickYAxis,'value')==get(handles.tickYAxis,'Min')
        set(gca,'ytick',[]);
        set(gca,'yminortick','off');
        set(gca,'ycolor','white');
    end
    if get(handles.tickUpRightAxis,'value')==get(handles.tickUpRightAxis,'Min')
        box off;
    end
    set(gca,'Color','none');

guidata(gcbo,handles);