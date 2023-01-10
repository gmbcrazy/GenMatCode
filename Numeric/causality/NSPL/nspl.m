function varargout = nspl(varargin)
% NSPL Application M-file for nspl.fig
%    FIG = NSPL launch nspl GUI.
%    NSPL('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 07-Apr-2005 16:14:50


if nargin == 0  % LAUNCH GUI

    clear;
    clc;
    
	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    
    handles.RawData.sttime=0;
    handles.RawData.endtime=0;
    handles.RawData.fs=0;
    handles.msEventNo=0;
    
	guidata(fig, handles);

    %    initdraw(fig,handles);


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

% --- Executes during object creation, after setting all properties.
function CordX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CordX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function CordX_Callback(hObject, eventdata, handles)
% hObject    handle to CordX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CordX as text
%        str2double(get(hObject,'String')) returns contents of CordX as a double


% --- Executes during object creation, after setting all properties.
function CordY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CordY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function CordY_Callback(hObject, eventdata, handles)
% hObject    handle to CordY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CordY as text
%        str2double(get(hObject,'String')) returns contents of CordY as a double



%?????????????????????????????????????????????????????????
%When we add a new button of a algorithm, two place need change:
%first is the function of nsplfileopen_Callback(), to initial the button
%second is OnOrOffControl();
%?????????????????????????????????????????????????????????

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


function OnOrOffControl(handles,status)
%Controls are on or off relative to the selected channel
%status==1, on; status==0, off

%set(handles.yscroll,'Enable',status);
%set(handles.yajust,'Enable',status);
%set(handles.basic,'Enable',status);
%set(handles.fftsp,'Enable',status);

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = drawallchn_Callback(h, eventdata, handles, varargin)
% This button controls to draw all signal or to draw none
% The changes dependent on it include: FileInfo.drawstatus,FileInfo.drawchnno,drawonechn(toggle button)
% and the 'String' property in the conrol selchn.
%also change the enable property of yscroll, and yajust

tmp_i=get(handles.drawallchn,'Value');

 %buttton is pressed, all is off
if tmp_i==get(handles.drawallchn,'Max')
    set(handles.drawallchn,'String','Off');
    for i=1:handles.RawData.chnno
        handles.FileInfo.drawstatus(i)=0;
    end
%This function is used to get the string for the control selchn's 'String' Property.
    strforchnsel=getstr(handles);
    set(handles.selchn,'String',strforchnsel);
   
    handles.FileInfo.drawchnno=0;
    set(handles.drawonechn,'Value',get(handles.drawonechn,'Max'));
    set(handles.drawonechn,'String','Off');

    OnOrOffControl(handles,'off');
end

% the button is not pressed, then all is on
if tmp_i==get(handles.drawallchn,'Min')
    set(handles.drawallchn,'String','On');
    for i=1:handles.RawData.chnno
        handles.FileInfo.drawstatus(i)=1;
    end
%This function is used to get the string for the control selchn's 'String' Property.
    strforchnsel=getstr(handles);
    set(handles.selchn,'String',strforchnsel);

    handles.FileInfo.drawchnno=handles.RawData.chnno;
    set(handles.drawonechn,'Value',get(handles.drawonechn,'Min'));
    set(handles.drawonechn,'String','On');
    
    OnOrOffControl(handles,'on');
end

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);


% --------------------------------------------------------------------
function varargout = selchn_Callback(h, eventdata, handles, varargin)
%Used to select a channel for adjusting
%will affect the control drawonechn, RawData.selchannel. 
%also change the enable property of yscroll, and yajust

tmp_i=get(handles.selchn,'Value');
handles.RawData.selchannel=tmp_i;
if handles.FileInfo.drawstatus(tmp_i)==1
    set(handles.drawonechn,'Value',get(handles.drawonechn,'Min'));
    set(handles.drawonechn,'String','On');

    OnOrOffControl(handles,'on');
    set(handles.yscroll,'Value',handles.FileInfo.yscrollv(tmp_i));
    set(handles.yajust,'Value',handles.FileInfo.yajustv(tmp_i));
else
    set(handles.drawonechn,'Value',get(handles.drawonechn,'Max'));
    set(handles.drawonechn,'String','Off');
    
    OnOrOffControl(handles,'off');

    set(handles.yscroll,'Value',handles.FileInfo.yscrollv(tmp_i));
    set(handles.yajust,'Value',handles.FileInfo.yajustv(tmp_i));
end

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);


guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = drawonechn_Callback(h, eventdata, handles, varargin)
%Used to decide whether to draw the selected channel or not on the screen
%will affect FileInfo.drawstatus, and the 'String' property of control selchn.
%FileInfo.drawchnno
%also change the enable property of yscroll, and yajust

tmp_i=get(handles.drawonechn,'Value');
if tmp_i==get(handles.drawonechn,'Min')
    set(handles.drawonechn,'String','On');
    %the selected channel will be drawn on the screen
    handles.FileInfo.drawstatus(handles.RawData.selchannel)=1;    
    handles.FileInfo.drawchnno=handles.FileInfo.drawchnno+1;
    
    OnOrOffControl(handles,'on');
end
if tmp_i==get(handles.drawonechn,'Max')
    set(handles.drawonechn,'String','Off');
    %the selected channel will not be drawn on the screen
    handles.FileInfo.drawstatus(handles.RawData.selchannel)=0;
    handles.FileInfo.drawchnno=handles.FileInfo.drawchnno-1;

    OnOrOffControl(handles,'off');
end

%This function is used to get the string for the control selchn's 'String' Property.
strforchnsel=getstr(handles);
set(handles.selchn,'String',strforchnsel);

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);



% --------------------------------------------------------------------
function varargout = selchninfo_Callback(h, eventdata, handles, varargin)

tmp_s=handles.FileInfo.info(handles.RawData.selchannel);
chninfo(1,tmp_s);


% --------------------------------------------------------------------
function varargout = sttime_Callback(h, eventdata, handles, varargin)
%Used for decide the start time of selected data section
%Will change the value of seltime and selpoint
tmp_s=get(handles.sttime,'String');
tmp_f=str2num(tmp_s);
if tmp_f<1.0/handles.RawData.fs
    tmp_f=1.0/handles.RawData.fs;
end
if tmp_f>handles.RawData.endtime
    tmp_f=handles.RawData.endtime;
end
handles.RawData.sttime=tmp_f;

%This is the method to caculation the selected points, it should be consistent in all of the software.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_selpoint=endp-stp+1;

if tmp_selpoint<0
    tmp_selpoint=0;
end
tmp_seltime=tmp_selpoint/handles.RawData.fs;

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
tmp_s=num2str(tmp_f);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);


guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = endtime_Callback(h, eventdata, handles, varargin)
%Used for decide the end time of selected data section
%Will change the value of seltime and selpoint

tmp_s=get(handles.endtime,'String');
tmp_f=str2num(tmp_s);
if tmp_f<handles.RawData.sttime
    tmp_f=handles.RawData.sttime;
end
if tmp_f>handles.RawData.totaltime
    tmp_f=handles.RawData.totaltime;
end
handles.RawData.endtime=tmp_f;

%This is the method to caculation the selected points, it should be consistent in all of the software.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_selpoint=endp-stp+1;
if tmp_selpoint<0
    tmp_selpoint=0;
end
tmp_seltime=tmp_selpoint/handles.RawData.fs;

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
tmp_s=num2str(tmp_f);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);


guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);

% --------------------------------------------------------------------
function varargout = seltime_Callback(h, eventdata, handles, varargin)
%used for decide the duration of the selected data section
%the select data is from sttime(RawData.sttime) to sttime(Rawdata.sttime)+seltime
%will change the values of endtime(Rawdata.endtime) and selpoint

tmp_s=get(handles.seltime,'String');
tmp_f=str2num(tmp_s);

if tmp_f+handles.RawData.sttime>handles.RawData.totaltime
    tmp_f=handles.RawData.totaltime-handles.RawData.sttime;
end

handles.RawData.endtime=handles.RawData.sttime+tmp_f;

%This is the method to caculation the selected points, it should be consistent in all of the software.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_selpoint=endp-stp+1;
if tmp_selpoint<0
    tmp_selpoint=0;
end
tmp_seltime=tmp_selpoint/handles.RawData.fs;

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);


guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);


% --------------------------------------------------------------------
function varargout = selpoint_Callback(h, eventdata, handles, varargin)
%used for decide the points of the selected data section
%the select data is from sttime(RawData.sttime) to sttime(Rawdata.sttime)+selpoint/fs
%will change the values of endtime(Rawdata.endtime) and seltime

tmp_s=get(handles.selpoint,'String');
tmp_selpoint=str2num(tmp_s);
tmp_f=tmp_selpoint/handles.RawData.fs;

if tmp_f+handles.RawData.sttime>handles.RawData.totaltime
    tmp_f=handles.RawData.totaltime-handles.RawData.sttime;
    handles.RawData.endtime=handles.RawData.sttime+tmp_f;
    stp=round(handles.RawData.sttime*handles.RawData.fs);
    endp=round(handles.RawData.endtime*handles.RawData.fs);
    tmp_selpoint=endp-stp+1;
    if tmp_selpoint<0
        tmp_selpoint=0;
    end
end

handles.RawData.endtime=handles.RawData.sttime+tmp_f;
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_selpoint=endp-stp+1;

%Because the value of the controls: sttime, seltime, selpoint has changed, they should be updated.
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);



% --------------------------------------------------------------------
function varargout = xscroll_Callback(h, eventdata, handles, varargin)
%Used for scroll the signal along x axis.
%The value of this slider is from 0.0 to 100.0 and step is 0.01;
%This slider decide the start time to plot on screen, 
%the start time is percent value of the slider of the total time
%It will change FileInfo.drawstx.

%change handles.FileInfo.drawstx
tmp_f=get(handles.xscroll,'Value');
handles.FileInfo.drawstx=tmp_f*handles.RawData.totaltime/100;

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);


% --------------------------------------------------------------------
function varargout = xajust_Callback(h, eventdata, handles, varargin)
%Used for ajust the shrink or expand the signal along x axis.
%The value of this slider is from 1.0 to 10.0 and step is 0.01;
%This slider decide the times of x axis, 
%It will change FileInfo.drawdx.
%fileInfo.drawdx=handles.totaltime/xajust(value);

%change handles.FileInfo.drawdx
handles.FileInfo.drawdx=handles.RawData.totaltime/get(handles.xajust,'Value');

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);



% --------------------------------------------------------------------
function varargout = yscroll_Callback(h, eventdata, handles, varargin)
%Used for scroll the signal along y axis.
%The value of this slider is from 0.0 to 100.0 and step is 0.01;
%This slider decide the y min value in y axis to plot on screen, 
%range from RawData.minv(n) to RawData.maxv(n) is defined as percent 100
%It will change FileInfo.drawsty(n) 

%change handles.FileInfo.drawstx
tmp_f=get(handles.yscroll,'Value');
tmp_i=handles.RawData.selchannel;

handles.FileInfo.yscrollv(tmp_i)=tmp_f;

tmp_m=(handles.RawData.maxv(tmp_i)+handles.RawData.minv(tmp_i))/2;
tmp_yadj=10^(handles.FileInfo.yajustv(tmp_i)-2);

handles.FileInfo.drawsty(tmp_i)=tmp_m-(handles.RawData.maxv(tmp_i)-handles.RawData.minv(tmp_i))*tmp_yadj*(tmp_f/100);

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);


% --------------------------------------------------------------------
function varargout = yajust_Callback(h, eventdata, handles, varargin)
%Used for ajust the shrink or expand the signal along y axis.
%The value of this slider is from 1.0 to 10.0 and step is 0.01;
%It will change FileInfo.drawdy(n).

tmp_f=get(handles.yajust,'Value');
tmp_i=handles.RawData.selchannel;
handles.FileInfo.yajustv(tmp_i)=tmp_f;

tmp_yadj=10^(handles.FileInfo.yajustv(tmp_i)-2);
handles.FileInfo.drawdy(tmp_i)=(handles.RawData.maxv(tmp_i)-handles.RawData.minv(tmp_i))/tmp_yadj;

tmp_yscr=get(handles.yscroll,'Value');

tmp_m=(handles.RawData.maxv(tmp_i)+handles.RawData.minv(tmp_i))/2;
handles.FileInfo.drawsty(tmp_i)=tmp_m-(handles.RawData.maxv(tmp_i)-handles.RawData.minv(tmp_i))*tmp_yadj*(tmp_yscr/100);

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);


% --------------------------------------------------------------------
function varargout = File_Callback(h, eventdata, handles, varargin)


% --- Executes on button press in Measure.
function Measure_Callback(hObject, eventdata, handles)
% hObject    handle to Measure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[x,y]=ginput(2);
set(handles.CordX,'string',num2str(x(1)));
set(handles.CordY,'string',num2str(y(1)));

if x(1)<x(2)
    tmpst=x(1);
    tmped=x(2);
else
    tmped=x(1);
    tmpst=x(2);
end

if tmpst<1.0/handles.RawData.fs
    tmpst=1.0/handles.RawData.fs;
end

if tmped>handles.RawData.totaltime
    tmped=handles.RawData.totaltime;
end

handles.RawData.sttime=tmpst;
handles.RawData.endtime=tmped;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

%hh = gca;
%hhh=get(hh,'Children');
%h=get(hh,'Children');

%x=get(h,'XData');
%y=get(h,'YData');
%x=x{3};
%y=y{3};
%x=x';
%y=y';

tmp_i=handles.RawData.selchannel;

tmpm=mean(handles.RawData.data(stp:endp,tmp_i));
tmpv=std(handles.RawData.data(stp:endp,tmp_i));

tmpms=sprintf('%6.3e',tmpm);
tmpvs=sprintf('%6.3e',tmpv);
set(handles.CordX,'string',tmpms);
set(handles.CordY,'string',tmpvs);

guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function Marker_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function Marker_Callback(hObject, eventdata, handles)
% hObject    handle to Marker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Marker as text
%        str2double(get(hObject,'String')) returns contents of Marker as a double


% --- Executes on button press in AddMeasureToFile.
function AddMeasureToFile_Callback(hObject, eventdata, handles)
% hObject    handle to AddMeasureToFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tmpMean=get(handles.CordX,'string');
tmpSTD=get(handles.CordY,'string');
tmpMarker=get(handles.Marker,'string');
tmpFileName=get(handles.ResFileName,'string');

tmp_fid=fopen(tmpFileName,'a');
fprintf(tmp_fid,'%s %s %s\n',tmpMarker,tmpMean,tmpSTD);
fclose(tmp_fid);

% --- Executes during object creation, after setting all properties.
function ResFileName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function ResFileName_Callback(hObject, eventdata, handles)
% hObject    handle to ResFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResFileName as text
%        str2double(get(hObject,'String')) returns contents of ResFileName as a double




% --------------------------------------------------------------------
function varargout = nsplfileopen_Callback(h, eventdata, handles, varargin)

tmp_fullname='';
tmp_fid='';
tmp_chnno='';
tmp_fs='';
tmp_f='';
tmp_s='';

%get the file name and directory name of the data file by menu item : Fiel Open
[fname,pname]=uigetfile('*.txt','Open the data file');

if fname==0 
    return;
end
%get the full name of the data file
tmp_fullname=strcat(pname,fname);
%open this file to read data
tmp_fid=fopen(tmp_fullname);

tmp_chnno=0;
tmp_fs=fscanf(tmp_fid,'%f', [1 1]);
tmp_f=tmp_fs;

tmp_i=fscanf(tmp_fid,'%d', [1 1]);
tmp_chnno=tmp_i;


tmp_i=fscanf(tmp_fid,'%d', [1 1]);
tmp_type=tmp_i;
tmp_i=fscanf(tmp_fid,'%d', [1 1]);

%read data
tmp_format='%';
for i=1:tmp_chnno-1
    tmp_format=strcat(tmp_format,'f %');
end
tmp_format=strcat(tmp_format,'f\n');

handles.RawData.data=fscanf(tmp_fid,tmp_format,[tmp_chnno inf]);
handles.RawData.data=handles.RawData.data';
fclose(tmp_fid);

if tmp_type==1
    if tmp_fs==0
        tmp_fs=1;
        handles.RawData.data=handles.RawData.data(:,1:tmp_chnno);
    else
        if tmp_fs==-1
            tmpi=length(handles.RawData.data(:,1));
            tmp_fs=1/mean(handles.RawData.data(2:tmpi,1)-handles.RawData.data(1:tmpi-1,1));
            handles.RawData.data=handles.RawData.data(:,2:tmp_chnno);
            tmp_chnno=tmp_chnno-1;
        else
            x=handles.RawData.data(:,1);
            tmp_i=round((x(length(x))-x(1))*tmp_fs);
            xx=([1:tmp_i]-1)/tmp_fs+x(1);
            xx=xx';
            tmp_data=zeros(tmp_i,tmp_chnno);
            for i=2:tmp_chnno
                y=handles.RawData.data(:,i);
                yy = spline(x,y,xx);
                tmp_data(:,i-1)=yy(:);
            end
            handles.RawData.data=tmp_data;
            tmp_chnno=tmp_chnno-1;
        end
    end
end

% define the data structures of RawData
handles.RawData.minv=min(handles.RawData.data);

handles.RawData.maxv=max(handles.RawData.data);
handles.RawData.meanv=mean(handles.RawData.data);
% sampling frequency
handles.RawData.fs=tmp_fs;
% the number of the channels
handles.RawData.chnno=tmp_chnno;
% the number of points in each channel
tmp_i=size(handles.RawData.data);
handles.RawData.totalpoint=tmp_i(1);
% the total time of the signal
handles.RawData.totaltime=tmp_i(1)/tmp_fs;
% x axis value
handles.RawData.xaxisv=[1:tmp_i(1)]/tmp_fs;
%start time of selected data duration
handles.RawData.sttime=1.0/handles.RawData.fs;
%end time of selected data duration
handles.RawData.endtime=1.0/handles.RawData.fs;
%channel of selected data
handles.RawData.selchannel=1;

% define the data structures of FileInfo
% file directory name
handles.FileInfo.pname=pname;
% file name
handles.FileInfo.fname=fname;
% The start time of the signal drawn on screen, used to set the x axis minimum
handles.FileInfo.drawstx=0.0;
% The duration time of the signal drawn on screen, used to set the x axis maximum
handles.FileInfo.drawdx=handles.RawData.totaltime;
% The start site of the signal drawn on screen, used to set the y axis minimum
% The end site of the signal drawn on screen, used to set the y axis maximum
% The name of each channel
handles.FileInfo.drawchnno=handles.RawData.chnno;

for i=1:handles.RawData.chnno
    handles.FileInfo.drawsty(i)=handles.RawData.minv(i);
    handles.FileInfo.drawdy(i)=(handles.RawData.maxv(i)-handles.RawData.minv(i));

    tmp_s='';
    tmp_s=strcat(tmp_s,'channel ');
    tmp_s=strcat(tmp_s,num2str(i));
    handles.FileInfo.chnname(i).name=tmp_s;
    
    tmp_s='';
    tmp_s=strcat(tmp_s,'sampling frequency is ');
    tmp_s=strcat(tmp_s,num2str(handles.RawData.fs));
    tmp_s=strcat(tmp_s,'. Total time is ');
    tmp_s=strcat(tmp_s,num2str(handles.RawData.totaltime));
    
    handles.FileInfo.info(i).info=tmp_s;
    handles.FileInfo.drawstatus(i)=1;
    handles.FileInfo.yscrollv(i)=50.0;
    handles.FileInfo.yajustv(i)=2.0;
end
% the number of the channels drawn on the screen, in this initial status, all are ploted on the screen.


%initail the other options relative to the data in this figure

%Enable the controls can be controled
set(handles.drawallchn,'Enable','on');
set(handles.selchn,'Enable','on');
set(handles.drawonechn,'Enable','on');
set(handles.selchninfo,'Enable','on');
set(handles.sttime,'Enable','on');
set(handles.endtime,'Enable','on');
set(handles.seltime,'Enable','on');
set(handles.selpoint,'Enable','on');
set(handles.plotsel,'Enable','on');
set(handles.xscroll,'Enable','on');
set(handles.xajust,'Enable','on');
set(handles.yscroll,'Enable','on');
set(handles.yajust,'Enable','on');
set(handles.Measure,'Enable','on');
set(handles.msEventSelection,'Enable','on');
set(handles.msEventTypeOne,'Enable','on');
set(handles.msEventTypeTwo,'Enable','on');
set(handles.msEventTypeThree,'Enable','on');
set(handles.msEventThMaxMinEvent,'Enable','on');
set(handles.msEventCheck,'Enable','on');
set(handles.msClearData,'Enable','on');
set(handles.msInterpolation,'Enable','on');



%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%the following is the buttons for different methods.


%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

%initial the unicontrol: selchn
%This function is used to get the string for the control selchn's 'String' Property.
strforchnsel=getstr(handles);
set(handles.selchn,'String',strforchnsel);
set(handles.selchn,'Value',handles.RawData.selchannel);

%initial the unicntrol relative to selection
set(handles.sttime,'String',num2str(handles.RawData.sttime));
set(handles.endtime,'String',num2str(handles.RawData.endtime));
set(handles.seltime,'String',num2str(0.0));
set(handles.selpoint,'String',num2str(0));

%initial the scroll and ajust in x and y axises.
set(handles.xscroll,'min',0.0,'max',99.999,'SliderStep',[0.01 0.1],'Value',0.0);
set(handles.xajust,'min',1.0,'max',100.0,'SliderStep',[0.01 0.1],'Value',1.0);

set(handles.yscroll,'min',0.0,'max',99.999,'SliderStep',[0.0001 0.01],'Value',50.0);
set(handles.yajust,'min',0.0,'max',4.0,'SliderStep',[0.001 0.01],'Value',2.0);

guidata(gcbo,handles);
plotraw(h, eventdata, handles, varargin);






% --------------------------------------------------------------------
function ExportDataToFile_Callback(hObject, eventdata, handles)
% hObject    handle to ExportDataToFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msexport(1,handles);
end


% --------------------------------------------------------------------
function MergeFiles_Callback(hObject, eventdata, handles)
% hObject    handle to MergeFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mergef(1,handles);



% --------------------------------------------------------------------
function BasicDescription_Callback(hObject, eventdata, handles)
% hObject    handle to BasicDescription (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    basdescp(1,handles);
end

% --------------------------------------------------------------------
function Filtering_Callback(hObject, eventdata, handles)
% hObject    handle to Filtering (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msfilter(1,handles);
end

% --------------------------------------------------------------------
function RectifyData_Callback(hObject, eventdata, handles)
% hObject    handle to RectifyData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msrectify(1,handles);
end

% --------------------------------------------------------------------
function SpectraAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to SpectraAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TFanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to TFanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function periodical_Callback(hObject, eventdata, handles)
% hObject    handle to periodical (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    fftsp(1,handles);
end


% --------------------------------------------------------------------
function Crossspectra_Callback(hObject, eventdata, handles)
% hObject    handle to Crossspectra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    fftcsd(1,handles);
end


% --------------------------------------------------------------------
function autoregressive_Callback(hObject, eventdata, handles)
% hObject    handle to autoregressive (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msarpsd(1,handles);
end



% --------------------------------------------------------------------
function STFT_Callback(hObject, eventdata, handles)
% hObject    handle to STFT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msstft(1,handles);
end



% --------------------------------------------------------------------
function TVAR_Callback(hObject, eventdata, handles)
% hObject    handle to TVAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    mstvar(1,handles);
end

% --------------------------------------------------------------------
function DWT_Callback(hObject, eventdata, handles)
% hObject    handle to DWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msdwt(1,handles);
end


% --------------------------------------------------------------------
function CWT_Callback(hObject, eventdata, handles)
% hObject    handle to CWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    mscwt(1,handles);
end


% --------------------------------------------------------------------
function MODWT_Callback(hObject, eventdata, handles)
% hObject    handle to MODWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msmodwt(1,handles);
end

% --------------------------------------------------------------------
function waveletpacket_Callback(hObject, eventdata, handles)
% hObject    handle to waveletpacket (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    mswp(1,handles);
end

% --------------------------------------------------------------------
function phasedifference_Callback(hObject, eventdata, handles)
% hObject    handle to phasedifference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    xyhilbert(1,handles);
end


% --------------------------------------------------------------------
function CrossCorrelation_Callback(hObject, eventdata, handles)
% hObject    handle to CrossCorrelation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    timecorr(1,handles);
end

% --------------------------------------------------------------------
function Coherence_Callback(hObject, eventdata, handles)
% hObject    handle to Coherence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    fftcoher(1,handles);
end

% --------------------------------------------------------------------
function CorrelationbyDWT_Callback(hObject, eventdata, handles)
% hObject    handle to CorrelationbyDWT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msCRdwt(1,handles);
end


% --------------------------------------------------------------------

% --- Executes on button press in avestimulation.
function avestimulation_Callback(hObject, eventdata, handles)
% hObject    handle to avestimulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msstmave(1,handles);
end

% --------------------------------------------------------------------
function varargout = OpenFileBtn_Callback(h, eventdata, handles, varargin)

nsplfileopen_Callback(h, eventdata, handles, varargin);



% --------------------------------------------------------------------
function varargout = dwtlphpfilterbutton_Callback(h, eventdata, handles, varargin)
% be sure initial it after open data.

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    dwtbpf(1,handles);
end

% --------------------------------------------------------------------
function varargout = plotsel_Callback(h, eventdata, handles, varargin)

% be sure initial it after open data.

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msdrawraw(1,handles);
end

% --------------------------------------------------------------------

function Correlation_Callback(hObject, eventdata, handles)
% hObject    handle to EMGLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------

function PreProcessing_Callback(hObject, eventdata, handles)
% hObject    handle to EMGLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function EMGLab_Callback(hObject, eventdata, handles)
% hObject    handle to EMGLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FindPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to FindPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    EMGPeaks(1,handles);
end

% --------------------------------------------------------------------
function ImportMarkerFile_Callback(hObject, eventdata, handles)
% hObject    handle to ImportMarkerFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function GetEnvolope_Callback(hObject, eventdata, handles)
% hObject    handle to GetEnvolope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msgetenv(1,handles);
end


% --------------------------------------------------------------------
function GeneralTFR_Callback(hObject, eventdata, handles)
% hObject    handle to GeneralTFR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    mstfr(1,handles);
end


% --------------------------------------------------------------------
function INSTFREQ_Callback(hObject, eventdata, handles)
% hObject    handle to INSTFREQ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msinstfr(1,handles);
end


% --------------------------------------------------------------------
function DWTFilter_Callback(hObject, eventdata, handles)
% hObject    handle to DWTFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msdwtfilt(1,handles);
end


% --------------------------------------------------------------------
function EvokedPotential_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function RemoveArtifact_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msStimEvo(1,handles);
end


% --------------------------------------------------------------------
function Tools_Callback(hObject, eventdata, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function msDifferentiate_Callback(hObject, eventdata, handles)
% hObject    handle to msDifferentiate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.RawData.chnno=handles.RawData.chnno+1;
i=handles.RawData.chnno;

%five point diffrential equation.
x=handles.RawData.data(:,handles.RawData.selchannel);

vx=zeros(size(x));

n=length(x);
d1=x(1:n-4);
d2=x(2:n-3);
d4=x(4:n-1);
d5=x(5:n);
vx(3:n-2)=(d1-8*d2+8*d4-d5)/12*handles.RawData.fs;
handles.RawData.data(:,i)=vx(:);

handles.RawData.maxv(i)=max(handles.RawData.data(:,i));
handles.RawData.minv(i)=min(handles.RawData.data(:,i));
handles.RawData.meanv(i)=mean(handles.RawData.data(:,i));

handles.FileInfo.drawsty(i)=handles.RawData.minv(i);
handles.FileInfo.drawdy(i)=(handles.RawData.maxv(i)-handles.RawData.minv(i));

tmp_s='DIFF of Ch';   
tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.RawData.selchannel).name);
handles.FileInfo.chnname(i).name=tmp_s;
        
handles.FileInfo.info(i).info=tmp_s;    
handles.FileInfo.drawstatus(i)=1;
handles.FileInfo.yscrollv(i)=50.0;
handles.FileInfo.yajustv(i)=2.0;

handles.FileInfo.drawchnno=handles.RawData.chnno;
guidata(gcbo,handles);

strforchnsel=getstr(handles);
set(handles.selchn,'String',strforchnsel);
set(handles.selchn,'Value',handles.RawData.selchannel);

guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);


% --------------------------------------------------------------------
function VARCausality_Callback(hObject, eventdata, handles)
% hObject    handle to MARCausality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    mscausal(1,handles);
end

% --------------------------------------------------------------------
function MARCausality_Callback(hObject, eventdata, handles)
% hObject    handle to MARCausality (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msMARCau(1,handles);
end

% --------------------------------------------------------------------
function PartialCoherence_Callback(hObject, eventdata, handles)
% hObject    handle to PartialCoherence (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msPartCoh(1,handles);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Eye movement analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Begin %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function EyeLab_Callback(hObject, eventdata, handles)
% hObject    handle to EyeLab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Recalibrate_Callback(hObject, eventdata, handles)
% hObject    handle to Recalibrate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEyeReCal(1,handles);
end


% --------------------------------------------------------------------
function TargetPos_Callback(hObject, eventdata, handles)
% hObject    handle to TargetPos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%five point diffrential equation.
x=handles.RawData.data(:,handles.RawData.selchannel);

vx=zeros(size(x));
n=length(x);

PlanSpeed=10;   %  10 degrees/sec.
UpMark=0;
DownMark=0;
tmpNo=0;
tmpT=0;
for i=1:n;
    if x(i)>2&UpMark==0
        if DownMark==1
            tmpNo=tmpNo+1;
            if tmpNo>1
                tmpT=tmpT+stp;
            end
        end

        UpMark=1;
        DownMark=0;
        stp=0;
    end
    if x(i)<-2&DownMark==0
        if UpMark==1
            tmpNo=tmpNo+1;
            if tmpNo>1
                tmpT=tmpT+stp;
            end
        end
        
        UpMark=0;
        DownMark=1;
        stp=0;
    end
    if UpMark==1|DownMark==1
        if UpMark==1
            stp=stp+1;
        end
        if DownMark==1
            stp=stp+1;
        end
    end    
end

PlanSpeed=30/(tmpT/(tmpNo-1)/handles.RawData.fs);

UpMark=0;
DownMark=0;

for i=1:n;
    if x(i)>2&UpMark==0
        UpMark=1;
        DownMark=0;
        stp=0;
    end
    if x(i)<-2&DownMark==0
        UpMark=0;
        DownMark=1;
        stp=0;
    end
    if UpMark==1|DownMark==1
        if UpMark==1
            y(i)=stp*PlanSpeed/handles.RawData.fs-15;
            stp=stp+1;
        end
        if DownMark==1
            y(i)=-stp*PlanSpeed/handles.RawData.fs+15;
            stp=stp+1;
        end
    else
        y(i)=0;
    end    
end

handles.RawData.chnno=handles.RawData.chnno+1;
i=handles.RawData.chnno;

handles.RawData.data(:,i)=y(:);

handles.RawData.maxv(i)=max(handles.RawData.data(:,i));
handles.RawData.minv(i)=min(handles.RawData.data(:,i));
handles.RawData.meanv(i)=mean(handles.RawData.data(:,i));

handles.FileInfo.drawsty(i)=handles.RawData.minv(i);
handles.FileInfo.drawdy(i)=(handles.RawData.maxv(i)-handles.RawData.minv(i));

tmp_s='Pos of Ch';   
tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.RawData.selchannel).name);
handles.FileInfo.chnname(i).name=tmp_s;
        
handles.FileInfo.info(i).info=tmp_s;    
handles.FileInfo.drawstatus(i)=1;
handles.FileInfo.yscrollv(i)=50.0;
handles.FileInfo.yajustv(i)=2.0;

handles.FileInfo.drawchnno=handles.RawData.chnno;
guidata(gcbo,handles);

strforchnsel=getstr(handles);
set(handles.selchn,'String',strforchnsel);
set(handles.selchn,'Value',handles.RawData.selchannel);

guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);


% --------------------------------------------------------------------
function Fixation_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEyeFix(1,handles);
end


% --------------------------------------------------------------------
function Saccade_Callback(hObject, eventdata, handles)
% hObject    handle to Saccade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEyeSac(1,handles);
end


% --------------------------------------------------------------------
function SmoothPursuit_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothPursuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEyePursuit(1,handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Eye movement analysis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Nonlinear Dynamics%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Nonlinear Dynamics%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function Nonlinear_Callback(hObject, eventdata, handles)
% hObject    handle to Nonlinear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ApEn_Callback(hObject, eventdata, handles)
% hObject    handle to ApEn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);


if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msNLApen(1,handles);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Nonlinear Dynamics%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Nonlinear Dynamics%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function ICALab_Callback(hObject, eventdata, handles)
% hObject    handle to ICALab (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function FastICA_Callback(hObject, eventdata, handles)
% hObject    handle to FastICA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);


if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msFastICA(1,handles);
end


% --------------------------------------------------------------------
function DrawingLAB_Callback(hObject, eventdata, handles)
% hObject    handle to DrawingLAB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function DrawingAnalysis_Callback(hObject, eventdata, handles)
% hObject    handle to DrawingAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    spdraw(1,handles);


% --------------------------------------------------------------------
function PursuitApEn_Callback(hObject, eventdata, handles)
% hObject    handle to PursuitApEn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);


if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEyeApen(1,handles);
end


% --------------------------------------------------------------------
function msExtractEvents_Callback(hObject, eventdata, handles)
% hObject    handle to msExtractEvents (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msEventExtraction(1,handles);
end


% --------------------------------------------------------------------
function msManipulate_Callback(hObject, eventdata, handles)
% hObject    handle to msManipulate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msManipulate(1,handles);
end


% --------------------------------------------------------------------
function msERPWaveform_Callback(hObject, eventdata, handles)
% hObject    handle to msERPWaveform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msERPWaveform(1,handles);
end


% --- Executes during object creation, after setting all properties.
function sttime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sttime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function endtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes during object creation, after setting all properties.
function seltime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to seltime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --------------------------------------------------------------------


function TrackingLab_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function msMenuConvertData_Callback(hObject, eventdata, handles)
% hObject    handle to msConvertData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[fname,pname]=uigetfile('*.txt','Open the data file');
if fname==0 
    return;
end
filename=strcat(pname,fname);

f=fopen(filename);

r=fread(f,16,'short');  		% skip filename
nchannels=fread(f,1,'short');	% number of channels
r=fread(f,5,'short');  			%skip a bit
nsamples=fread(f,1,'short');	% number of data points/channel
r=fread(f,5,'short');  			%skip a bit
fs=fread(f,1,'float');	% sample rate (millisec)
fs=1000/fs;
r=fread(f,4,'short');  			%skip a bit
i=fread(f,1,'char');	       	% should always be Integer
if i~='I',
 error('Wrong Tsar format found');
end
r=fread(f,2,'short');  	%skip a bit more
% now try to read the data
data=fread(f,[1,inf],'short');
% now split this up into channels
data=reshape(data,length(data)/nchannels,nchannels);
m=size(data,1);
% now find the end of record bytes
k=(1:floor(m/260))*260-1;
k=[k k+1 k+2 k+3];	%4 bytes between records
k=[1 2 k m-2 m-1 m];	%2 bytes at start, 3 at end
data(k,:)=[];
data(:,1)=data(:,1)*3.0;



fclose(f);

DataNo=length(data);

MidMark=0;
EdMark=0;
StSite=0;
MidSite=0;
EdSite=0;
ResData=[];
res=zeros(length(data),5);
i=1;
while(i<DataNo)
    i=i+1;
    if data(i,1)<-3000&MidMark==0
        MidMark=1;
        MidSite=i;
        i=i+50;
    end
    
    if data(i,1)<-3000&MidMark==1&EdMark==0
        EdMark=1;
        EdSite=i-2;
        StSite=MidSite-(EdSite-MidSite)+2;
        tmpf=data(StSite:EdSite,2);
        tmpf=detrend(tmpf);
        res(StSite:EdSite,4)=tmpf(:,1);
        
        tmpf=tmpf';
        ResData=[ResData tmpf];
        i=i+5;
    end
    if data(i,1)<-3000&EdMark==1
        i=i+50;
        MidMark=0;
        EdMark=0;
        StSite=0;
        MidSite=0;
        EdSite=0;
    end
        
end
ResData=ResData';

res(:,1:2)=data(:,1:2);
res(:,3)=data(:,2)-data(:,1);
res(1:length(ResData),5)=ResData(:,1);

[fname,pname]=uiputfile('*.txt','Save the converted data into file');
if fname==0 
    return;
end
filename=strcat(pname,fname);

fp=fopen(filename,'wt');
fprintf(fp,'%f 5 0 0\',fs);
fprintf(fp,'%f %f %f %f %f\n',res');
% target, movement, difference between target and movement, movement
% detrended linearly, combined movemented traces.
fclose(fp);


% --------------------------------------------------------------------
function msMenuTraPSD_Callback(hObject, eventdata, handles)
% hObject    handle to msMenuTraPSD (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
stp=1;
endp=round(handles.RawData.endtime*handles.RawData.fs);
endp=handles.RawData.totalpoint;

if stp<1 |endp-stp<2
    msgbox('Please properly select the data!','data selection');
else
    msTraPSD(1,handles);
end


% --- Executes during object creation, after setting all properties.
function msEventThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventThreshold as text
%        str2double(get(hObject,'String')) returns contents of msEventThreshold as a double




% --- Executes during object creation, after setting all properties.
function msEventFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



% --- Executes during object creation, after setting all properties.
function msEventDurationLower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventDurationLower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventDurationLower_Callback(hObject, eventdata, handles)
% hObject    handle to msEventDurationLower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventDurationLower as text
%        str2double(get(hObject,'String')) returns contents of msEventDurationLower as a double


% --- Executes during object creation, after setting all properties.
function msEventDurationUpper_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventDurationUpper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventDurationUpper_Callback(hObject, eventdata, handles)
% hObject    handle to msEventDurationUpper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventDurationUpper as text
%        str2double(get(hObject,'String')) returns contents of msEventDurationUpper as a double

function msEventFilename_Callback(hObject, eventdata, handles)
% hObject    handle to msEventFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventFilename as text
%        str2double(get(hObject,'String')) returns contents of msEventFilename as a double


% --- Executes on button press in msEventSelection.
function msEventSelection_Callback(hObject, eventdata, handles)
% hObject    handle to msEventSelection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,y]=ginput(2);
set(handles.CordX,'string',num2str(x(1)));
set(handles.CordY,'string',num2str(y(1)));

if x(1)<x(2)
    tmpst=x(1);
    tmped=x(2);
else
    tmped=x(1);
    tmpst=x(2);
end

if tmpst<1.0/handles.RawData.fs
    tmpst=1.0/handles.RawData.fs;
end

if tmped>handles.RawData.totaltime
    tmped=handles.RawData.totaltime;
end

stp=round(tmpst*handles.RawData.fs);
endp=round(tmped*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_chn=handles.RawData.selchannel;
tmp_threshold=str2num(get(handles.msEventThreshold,'string'));
tmp_max=max(handles.RawData.data(stp:endp,tmp_chn));
tmp_threshold=tmp_threshold*tmp_max;

EventStp=stp;
EventEdp=endp;

tmp_maxsite=stp-1+round(mean(find(handles.RawData.data(stp:endp,tmp_chn)==max(handles.RawData.data(stp:endp,tmp_chn)))));

for i=stp:tmp_maxsite
    if handles.RawData.data(i,tmp_chn)>tmp_threshold
        EventStp=i;
        break;
    end
end

for i=endp:-1:tmp_maxsite
    if handles.RawData.data(i,tmp_chn)>tmp_threshold
        EventEdp=i;
        break;
    end
end

EventStTime=(EventStp)/handles.RawData.fs;
EventEdTime=(EventEdp)/handles.RawData.fs;

%update the selected data segment
handles.RawData.sttime=EventStTime;
handles.RawData.endtime=EventEdTime;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);


% --- Executes on button press in msEventAdd.
function msEventAdd_Callback(hObject, eventdata, handles)
% hObject    handle to msEventAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.msEventNo=handles.msEventNo+1;

msLower=str2num(get(handles.msEventDurationLower,'string'));
msUpper=str2num(get(handles.msEventDurationUpper,'string'));


handles.msEventReactionTime(handles.msEventNo,1)=handles.RawData.sttime;
handles.msEventReactionTime(handles.msEventNo,2)=handles.RawData.endtime;
handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.endtime-handles.RawData.sttime;
tmp_EventDuration=handles.RawData.endtime-handles.RawData.sttime;

if tmp_EventDuration<=msLower
    handles.msEventSeriesPattern(handles.msEventNo,1)=1;
    handles.msEventSeriesPattern(handles.msEventNo,2)=1;
    handles.msEventSeriesPattern(handles.msEventNo,3)=1;
end   
    
if tmp_EventDuration>msLower & tmp_EventDuration<=msUpper
    handles.msEventSeriesPattern(handles.msEventNo,1)=1;
    handles.msEventSeriesPattern(handles.msEventNo,2)=3;
    handles.msEventSeriesPattern(handles.msEventNo,3)=2;
end
    
if tmp_EventDuration>msUpper
    handles.msEventSeriesPattern(handles.msEventNo,1)=1;
    handles.msEventSeriesPattern(handles.msEventNo,2)=2;
    handles.msEventSeriesPattern(handles.msEventNo,3)=3;
end


guidata(gcbo,handles);


% --- Executes on button press in msEventClear.
function msEventClear_Callback(hObject, eventdata, handles)
% hObject    handle to msEventClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.msEventNo=0;
handles.msEventReactionTime=[];
handles.msEventSeriesPattern=[];

guidata(gcbo,handles);

% --- Executes on button press in msEventSavefile.
function msEventSavefile_Callback(hObject, eventdata, handles)
% hObject    handle to msEventSavefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.msEventNo<1
    return;
end

tmpFileName=get(handles.msEventFilename,'string');
tmp_fid=fopen(tmpFileName,'w');
fprintf(tmp_fid,'2 %d\n',handles.msEventNo);
fprintf(tmp_fid,'%f %f %f\n',handles.msEventReactionTime');
fprintf(tmp_fid,'%d %d %d\n',handles.msEventSeriesPattern');
fclose(tmp_fid);

%msTaskType: 1:self-paced click; 2: externally cued click; 3: go/no go

%tmpStr(1).msStr='L Go(S)-L Go(R)';
%tmpStr(2).msStr='L Go(S)-R Go(R)';
%tmpStr(3).msStr='L Go(S)-No Go(R)';

%msStimulusType:  1: left go (5ms full amplitude);  2 left no go;(5ms half amplitude)
                 %3: right go (10ms full amplitude) 4: right no go;(10ms half amplitude)
                 %The response is before the pulse (up edge, the pulse is up direction). 

%L Go (stim): response- L Go(1), R Go(2), No Go(3),
%L No Go (stim): response- L Go(4), R Go(5), No Go(6),
%R Go (stim): response- L Go(7), R Go(8), No Go(9),
%R No Go (stim): response- L Go(10), R Go(11), No Go(12),

% type 1: 1 1 1
% type 2: 1 3 2
% type 1: 1 2 3


% --- Executes on button press in msEventMaxOrMin.
function msEventMaxOrMin_Callback(hObject, eventdata, handles)
% hObject    handle to msEventMaxOrMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of msEventMaxOrMin


function msEventTimeOffset_Callback(hObject, eventdata, handles)
% hObject    handle to msEventTimeOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventTimeOffset as text
%        str2double(get(hObject,'String')) returns contents of msEventTimeOffset as a double

% --- Executes during object creation, after setting all properties.
function msEventTimeOffset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventTimeOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in msEventTypeOne.
function msEventTypeOne_Callback(hObject, eventdata, handles)
% hObject    handle to msEventTypeOne (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.msEventMaxOrMin,'value')==get(handles.msEventMaxOrMin,'max')
    tmp_EventMaxOrMin=1;
else
    tmp_EventMaxOrMin=0;
end
EventTimeOffset=str2num(get(handles.msEventTimeOffset,'string'));

tmp_chn=handles.RawData.selchannel;

[x,y]=ginput(2);
set(handles.CordX,'string',num2str(x(1)));
set(handles.CordY,'string',num2str(y(1)));

if x(1)<x(2)
    tmpst=x(1);
    tmped=x(2);
else
    tmped=x(1);
    tmpst=x(2);
end

if tmpst<1.0/handles.RawData.fs
    tmpst=1.0/handles.RawData.fs;
end

if tmped>handles.RawData.totaltime
    tmped=handles.RawData.totaltime;
end

stp=round(tmpst*handles.RawData.fs);
endp=round(tmped*handles.RawData.fs);

if tmp_EventMaxOrMin==1
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==max(handles.RawData.data(stp:endp,tmp_chn))));
else
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==min(handles.RawData.data(stp:endp,tmp_chn))));
end

EventP=EventP+stp-1;
EventT=EventP/handles.RawData.fs;

handles.msEventNo=handles.msEventNo+1;

handles.msEventReactionTime(handles.msEventNo,1)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,2)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.data(EventP,tmp_chn);
    
handles.msEventSeriesPattern(handles.msEventNo,1)=1;
handles.msEventSeriesPattern(handles.msEventNo,2)=1;
handles.msEventSeriesPattern(handles.msEventNo,3)=1;

handles.RawData.sttime=EventT;
handles.RawData.endtime=EventT;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

guidata(gcbo,handles);

plotraw(hObject, eventdata, handles);


% --- Executes on button press in msEventTypeTwo.
function msEventTypeTwo_Callback(hObject, eventdata, handles)
% hObject    handle to msEventTypeTwo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.msEventMaxOrMin,'value')==get(handles.msEventMaxOrMin,'max')
    tmp_EventMaxOrMin=1;
else
    tmp_EventMaxOrMin=0;
end
EventTimeOffset=str2num(get(handles.msEventTimeOffset,'string'));

tmp_chn=handles.RawData.selchannel;
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if tmp_EventMaxOrMin==1
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==max(handles.RawData.data(stp:endp,tmp_chn))));
else
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==min(handles.RawData.data(stp:endp,tmp_chn))));
end

EventP=EventP+stp-1;
EventT=EventP/handles.RawData.fs;

handles.msEventNo=handles.msEventNo+1;

handles.msEventReactionTime(handles.msEventNo,1)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,2)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.data(EventP,tmp_chn);
    
handles.msEventSeriesPattern(handles.msEventNo,1)=1;
handles.msEventSeriesPattern(handles.msEventNo,2)=3;
handles.msEventSeriesPattern(handles.msEventNo,3)=2;

handles.RawData.sttime=EventT;
handles.RawData.endtime=EventT;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

guidata(gcbo,handles);

plotraw(hObject, eventdata, handles);


% --- Executes on button press in msEventTypeThree.
function msEventTypeThree_Callback(hObject, eventdata, handles)
% hObject    handle to msEventTypeThree (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


if get(handles.msEventMaxOrMin,'value')==get(handles.msEventMaxOrMin,'max')
    tmp_EventMaxOrMin=1;
else
    tmp_EventMaxOrMin=0;
end
EventTimeOffset=str2num(get(handles.msEventTimeOffset,'string'));

tmp_chn=handles.RawData.selchannel;
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

if tmp_EventMaxOrMin==1
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==max(handles.RawData.data(stp:endp,tmp_chn))));
else
    EventP=min(find(handles.RawData.data(stp:endp,tmp_chn)==min(handles.RawData.data(stp:endp,tmp_chn))));
end

EventP=EventP+stp-1;
EventT=EventP/handles.RawData.fs;

handles.msEventNo=handles.msEventNo+1;

handles.msEventReactionTime(handles.msEventNo,1)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,2)=EventT+EventTimeOffset;
handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.data(EventP,tmp_chn);
    
handles.msEventSeriesPattern(handles.msEventNo,1)=1;
handles.msEventSeriesPattern(handles.msEventNo,2)=2;
handles.msEventSeriesPattern(handles.msEventNo,3)=3;

handles.RawData.sttime=EventT;
handles.RawData.endtime=EventT;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

guidata(gcbo,handles);

plotraw(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function msEventThMaxMinThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventThMaxMinThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventThMaxMinThreshold as text
%        str2double(get(hObject,'String')) returns contents of msEventThMaxMinThreshold as a double


% --- Executes on button press in msEventThMaxMinMaxMin.
function msEventThMaxMinMaxMin_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinMaxMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of msEventThMaxMinMaxMin


% --- Executes on button press in msEventThMaxMinEvent.
function msEventThMaxMinEvent_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinEvent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.msEventThMaxMinMaxMin,'value')==get(handles.msEventThMaxMinMaxMin,'max')
    tmp_EventMaxOrMin=1;
else
    tmp_EventMaxOrMin=0;
end
if get(handles.msForBackWinType,'value')==get(handles.msForBackWinType,'max')
    tmp_ForBackWinType=1;
else
    tmp_ForBackWinType=0;
end
if get(handles.msUpDownTh,'value')==get(handles.msUpDownTh,'max')
    tmp_UpDownTh=1;
else
    tmp_UpDownTh=0;
end


EventTimeOffset=str2num(get(handles.msEventTimeOffset,'string'));
EventThMaxMinThreshold=str2num(get(handles.msEventThMaxMinThreshold,'string'));
EventThMaxMinWinLen=round(str2num(get(handles.msEventThMaxMinWinLen,'string'))*handles.RawData.fs);
EventThMaxMinSkip=round(str2num(get(handles.msEventThMaxMinSkip,'string'))*handles.RawData.fs);

tmp_chn=handles.RawData.selchannel;

[x,y]=ginput(2);
set(handles.CordX,'string',num2str(x(1)));
set(handles.CordY,'string',num2str(y(1)));

if x(1)<x(2)
    tmpst=x(1);
    tmped=x(2);
else
    tmped=x(1);
    tmpst=x(2);
end

if tmpst<1.0/handles.RawData.fs
    tmpst=1.0/handles.RawData.fs;
end

if tmped>handles.RawData.totaltime
    tmped=handles.RawData.totaltime;
end

stp=round(tmpst*handles.RawData.fs);
endp=round(tmped*handles.RawData.fs);

%EventThMaxMinThreshold=str2num(get(handles.msEventThMaxMinThreshold,'string'));
%EventThMaxMinWinLen=round(str2num(get(handles.msEventThMaxMinWinLen,'string'))*handles.RawData.fs);
%EventThMaxMinSkip=round(str2num(get(handles.msEventThMaxMinSkip,'string'))*handles.RawData.fs);

i=stp;
while i<endp    
    tmp_data=handles.RawData.data(i,tmp_chn);
    if tmp_EventMaxOrMin==1
        if tmp_UpDownTh==1
            msMark=tmp_data>EventThMaxMinThreshold;
        else
            msMark=tmp_data<EventThMaxMinThreshold;
        end
        if msMark
            if tmp_ForBackWinType==1
                tmp_site=i+EventThMaxMinWinLen;
                if tmp_site>endp
                    tmp_site=endp;
                end
                EventP=min(find(handles.RawData.data(i:tmp_site,tmp_chn)==max(handles.RawData.data(i:tmp_site,tmp_chn))));
                EventP=EventP+i-1;
            else
                tmp_site=i-EventThMaxMinWinLen;
                if tmp_site<1
                    tmp_site=1;
                end
                EventP=min(find(handles.RawData.data(tmp_site:i,tmp_chn)==max(handles.RawData.data(tmp_site:i,tmp_chn))));
                EventP=EventP+tmp_site-1;                
            end
                
            EventT=EventP/handles.RawData.fs;
            handles.msEventNo=handles.msEventNo+1;

            handles.msEventReactionTime(handles.msEventNo,1)=EventT+EventTimeOffset;
            handles.msEventReactionTime(handles.msEventNo,2)=EventT+EventTimeOffset;
            handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.data(EventP,tmp_chn);
            handles.msEventSeriesPattern(handles.msEventNo,1)=1;
            handles.msEventSeriesPattern(handles.msEventNo,2)=1;
            handles.msEventSeriesPattern(handles.msEventNo,3)=1;   
            
            i=EventP+EventThMaxMinSkip;
        end
    else
        if tmp_UpDownTh==1
            msMark=tmp_data>EventThMaxMinThreshold;
        else
            msMark=tmp_data<EventThMaxMinThreshold;
        end
        if msMark
            if tmp_ForBackWinType==1
                tmp_site=i+EventThMaxMinWinLen;
                if tmp_site>endp
                    tmp_site=endp;
                end
                EventP=min(find(handles.RawData.data(i:tmp_site,tmp_chn)==min(handles.RawData.data(i:tmp_site,tmp_chn))));
                EventP=EventP+i-1;
            else
                tmp_site=i-EventThMaxMinWinLen;
                if tmp_site<1
                    tmp_site=1;
                end
                EventP=min(find(handles.RawData.data(tmp_site:i,tmp_chn)==min(handles.RawData.data(tmp_site:i,tmp_chn))));
                EventP=EventP+tmp_site-1;                 
            end

            EventT=EventP/handles.RawData.fs;
            handles.msEventNo=handles.msEventNo+1;

            handles.msEventReactionTime(handles.msEventNo,1)=EventT+EventTimeOffset;
            handles.msEventReactionTime(handles.msEventNo,2)=EventT+EventTimeOffset;
            handles.msEventReactionTime(handles.msEventNo,3)=handles.RawData.data(EventP,tmp_chn);;
            handles.msEventSeriesPattern(handles.msEventNo,1)=1;
            handles.msEventSeriesPattern(handles.msEventNo,2)=1;
            handles.msEventSeriesPattern(handles.msEventNo,3)=1;   
            
            i=EventP+EventThMaxMinSkip;
        end
    end
    i=i+1;
end

guidata(gcbo,handles);

handles.RawData.sttime=stp/handles.RawData.fs;
handles.RawData.endtime=endp/handles.RawData.fs;

tmp_selpoint=endp-stp+1;
tmp_seltime=tmp_selpoint/handles.RawData.fs;

tmp_s=num2str(handles.RawData.sttime);
set(handles.sttime,'String',tmp_s);
tmp_s=num2str(handles.RawData.endtime);
set(handles.endtime,'String',tmp_s);
tmp_s=num2str(tmp_selpoint);
set(handles.selpoint,'String',tmp_s);
tmp_s=num2str(tmp_seltime);
set(handles.seltime,'String',tmp_s);

guidata(gcbo,handles);

plotraw(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function msEventThMaxMinWinLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinWinLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventThMaxMinWinLen_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinWinLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventThMaxMinWinLen as text
%        str2double(get(hObject,'String')) returns contents of msEventThMaxMinWinLen as a double


% --- Executes during object creation, after setting all properties.
function msEventThMaxMinSkip_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinSkip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msEventThMaxMinSkip_Callback(hObject, eventdata, handles)
% hObject    handle to msEventThMaxMinSkip (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msEventThMaxMinSkip as text
%        str2double(get(hObject,'String')) returns contents of msEventThMaxMinSkip as a double


% --- Executes on button press in msEventCheck.
function msEventCheck_Callback(hObject, eventdata, handles)
% hObject    handle to msEventCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
data=handles.RawData.data(stp:endp,handles.RawData.selchannel);

handles.msData=data;
handles.msFs=handles.RawData.fs;
handles.msTaskType=1;
%handles.msEventNo=msEventNo;
%handles.msEventReactionTime=msEventReactionTime;
%handles.msEventSeriesPattern=msEventSeriesPattern;

guidata(gcbo,handles);

msCheckEvent(1,handles);

guidata(gcbo,handles);


% --- Executes on button press in msClearData.
function msClearData_Callback(hObject, eventdata, handles)
% hObject    handle to msClearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
handles.RawData.data(stp:endp,handles.RawData.selchannel)=0;
guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);
guidata(gcbo,handles);


% --- Executes on button press in msForBackWinType.
function msForBackWinType_Callback(hObject, eventdata, handles)
% hObject    handle to msForBackWinType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of msForBackWinType


% --- Executes on button press in msUpDownTh.
function msUpDownTh_Callback(hObject, eventdata, handles)
% hObject    handle to msUpDownTh (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of msUpDownTh


% --- Executes during object creation, after setting all properties.
function msInterpWin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to msInterpWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function msInterpWin_Callback(hObject, eventdata, handles)
% hObject    handle to msInterpWin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of msInterpWin as text
%        str2double(get(hObject,'String')) returns contents of msInterpWin as a double


% --- Executes on button press in msInterpolation.
function msInterpolation_Callback(hObject, eventdata, handles)
% hObject    handle to msInterpolation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
msInterpWin=str2num(get(handles.msInterpWin,'string'));

if endp-stp<3
    msgbox('Please select more data!','data selection');
    return;
end

if handles.RawData.sttime<msInterpWin
    msgbox('Data prior to current selection is not enough!','data selection');
    return;
end
if handles.RawData.endtime>handles.RawData.totaltime-msInterpWin
    msgbox('Data after current selection is not enough!','data selection');
    return;
end

msstp=round((handles.RawData.sttime-msInterpWin)*handles.RawData.fs);
msendp=round((handles.RawData.endtime+msInterpWin)*handles.RawData.fs);

if msstp<1
    msstp=1;
end
if msendp>round(handles.RawData.totaltime*handles.RawData.fs)
    msendp=round(handles.RawData.totaltime*handles.RawData.fs);
end

x=[msstp:stp];
tmp=[endp:msendp];
x=[x tmp];
y=handles.RawData.data(x,handles.RawData.selchannel);
xx=[stp+1:endp-1];

yy = spline(x,y,xx);

handles.RawData.data(xx,handles.RawData.selchannel)=yy;
guidata(gcbo,handles);
plotraw(hObject, eventdata, handles);
guidata(gcbo,handles);