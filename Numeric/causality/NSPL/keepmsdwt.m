function varargout = msdwt(varargin)
% MSDWT Application M-file for msdwt.fig
%    FIG = MSDWT launch msdwt GUI.
%    MSDWT('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 11-Nov-2002 17:16:51

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
function varargout = plottypethree_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotmulti_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotrawdata_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = graysurf_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = shadingmode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = colorbar_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotmode_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = totalfre_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = partfre_Callback(h, eventdata, handles, varargin)
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
function varargout = maxscale_Callback(h, eventdata, handles, varargin)

tmp_s=get(handles.maxscale,'String');
tmp_maxscale=str2num(tmp_s);

tmp_maxscale=floor(tmp_maxscale);

if tmp_maxscale<1
    tmp_maxscale=1;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
wname = getwavename(handles);
if tmp_maxscale>wmaxlev(x,wname)
    tmp_maxscale=wmaxlev(x,wname);
end

set(handles.maxscale,'String',num2str(tmp_maxscale));

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = wavetype_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.wavetype,'Value');
tmp_s=get(handles.wavetype,'String');
tmp_s=tmp_s(tmp_i,:);
wavepara_str=get_para_sel_wave(handles,tmp_s);

if isempty(wavepara_str)
    set(handles.wavepara,'Enable','off');
else
    set(handles.wavepara,'Enable','on');
    set(handles.wavepara,'String',wavepara_str,'Value',1);
end

guidata(gcbo,handles);

tmp_s=get(handles.maxscale,'String');
tmp_maxscale=str2num(tmp_s);
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
wname = getwavename(handles);
if tmp_maxscale>wmaxlev(x,wname)
    tmp_maxscale=wmaxlev(x,wname);
end
set(handles.maxscale,'String',num2str(tmp_maxscale));

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = wavepara_Callback(h, eventdata, handles, varargin)

tmp_s=get(handles.maxscale,'String');
tmp_maxscale=str2num(tmp_s);
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
wname = getwavename(handles);
if tmp_maxscale>wmaxlev(x,wname)
    tmp_maxscale=wmaxlev(x,wname);
end
set(handles.maxscale,'String',num2str(tmp_maxscale));

guidata(gcbo,handles);

% --------------------------------------------------------------------
function wavepara_str=get_para_sel_wave(handles,sel_wave_str)
%Get the parameters list string of the selected wavelet.

wavepara_str='';

%Note: each item must have the same char, here is 4, if is shorter, then space is padded at the end
switch sel_wave_str
case 'db  '
    for i=1:44
        wavepara_str=strcat(wavepara_str,num2str(i));
        wavepara_str=strcat(wavepara_str,'|');
    end
    wavepara_str=strcat(wavepara_str,num2str(45));
case 'sym '
    for i=2:14
        wavepara_str=strcat(wavepara_str,num2str(i));
        wavepara_str=strcat(wavepara_str,'|');
    end
    wavepara_str=strcat(wavepara_str,num2str(15));
case 'coif'   
    for i=1:4
        wavepara_str=strcat(wavepara_str,num2str(i));
        wavepara_str=strcat(wavepara_str,'|');
    end
    wavepara_str=strcat(wavepara_str,num2str(5));
case 'bior'
    wavepara_str=strcat(wavepara_str,'1.1');
    wavepara_str=strcat(wavepara_str,'|1.3');
    wavepara_str=strcat(wavepara_str,'|1.5');
    wavepara_str=strcat(wavepara_str,'|2.2');
    wavepara_str=strcat(wavepara_str,'|2.4');
    wavepara_str=strcat(wavepara_str,'|2.6');
    wavepara_str=strcat(wavepara_str,'|2.8');
    wavepara_str=strcat(wavepara_str,'|3.1');
    wavepara_str=strcat(wavepara_str,'|3.3');
    wavepara_str=strcat(wavepara_str,'|3.5');
    wavepara_str=strcat(wavepara_str,'|3.7');
    wavepara_str=strcat(wavepara_str,'|3.9');
    wavepara_str=strcat(wavepara_str,'|4.4');
    wavepara_str=strcat(wavepara_str,'|5.5');
    wavepara_str=strcat(wavepara_str,'|6.8');   
case 'rbio'
    seltype_str='rbio';
    wavepara_str=strcat(wavepara_str,'1.1');
    wavepara_str=strcat(wavepara_str,'|1.3');
    wavepara_str=strcat(wavepara_str,'|1.5');
    wavepara_str=strcat(wavepara_str,'|2.2');
    wavepara_str=strcat(wavepara_str,'|2.4');
    wavepara_str=strcat(wavepara_str,'|2.6');
    wavepara_str=strcat(wavepara_str,'|2.8');
    wavepara_str=strcat(wavepara_str,'|3.1');
    wavepara_str=strcat(wavepara_str,'|3.3');
    wavepara_str=strcat(wavepara_str,'|3.5');
    wavepara_str=strcat(wavepara_str,'|3.7');
    wavepara_str=strcat(wavepara_str,'|3.9');
    wavepara_str=strcat(wavepara_str,'|4.4');
    wavepara_str=strcat(wavepara_str,'|5.5');
    wavepara_str=strcat(wavepara_str,'|6.8');   
end

% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)

getdefaultsetting(gcbo,handles);


% --------------------------------------------------------------------
function setmark=getdefaultsetting(fig,handles)
%initial the setting by default from file

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);


%open the setting file
fid=fopen('msdwtset.inf','r');
if fid==-1
    setmark=0;
    % restoresetting(gcbo,handles);
    return;
end

%initial the parameters relative some wavelet
tmp_wavetype=round(fscanf(fid,'%d', [1 1]));
tmp_para=round(fscanf(fid,'%d', [1 1]));

%Initial the wavelet type selection list, here we use four types windows.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%the sort is tmp_s='haar|db|sym|coif|bior|rbio|meyr|dmey';
%if add new wavelet please be careful
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tmp_s='haar|db|sym|coif|bior|rbio|meyr|dmey';
set(handles.wavetype,'String',tmp_s,'Value',tmp_wavetype);

guidata(fig, handles);

if tmp_wavetype<1| tmp_wavetype>8
    tmp_wavetype=1;
else
    tmp_s=get(handles.wavetype,'String');
    tmp_s=tmp_s(tmp_wavetype,:);
    wavepara_str=get_para_sel_wave(handles,tmp_s);
    if isempty(wavepara_str)
        set(handles.wavepara,'Enable','off');
    else
        set(handles.wavepara,'Enable','on');
        set(handles.wavepara,'String',wavepara_str);
        set(handles.wavepara,'Value',tmp_para);
    end
end

guidata(fig, handles);

%initial the plot mode
tmp_s='curve|image|surf|mesh';
set(handles.plotmode,'String',tmp_s,'Value',1);

%Initial the max scale;
tmp_max=fscanf(fid,'%f', [1 1]);
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
wname = getwavename(handles);
if tmp_max>wmaxlev(x,wname)
    tmp_max=wmaxlev(x,wname);
end
set(handles.maxscale,'String',num2str(tmp_max));

%Initial the running window length;
tmp_max=fscanf(fid,'%f', [1 1]);
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=floor((endp-stp+1)/2);
if tmp_max>x
    tmp_max=x;
end    
set(handles.runwinlen,'String',num2str(tmp_max));

fclose(fid);

setmark=1;

guidata(fig, handles);


% --------------------------------------------------------------------
function varargout = savedefault_Callback(h, eventdata, handles, varargin)

fid=fopen('msdwtset.inf','wt');
if fid==-1
    return;
end

%initial the wavelet type
tmp_i=get(handles.wavetype,'Value');
fprintf(fid,'%d\n',tmp_i);
    
%initial the wavelet parameter
tmp_s=get(handles.wavepara,'Enable');
if strcmp(tmp_s,'on')
    tmp_i=get(handles.wavepara,'Value');
else 
    tmp_i=0;
end
fprintf(fid,'%d\n',tmp_i);

%Initial the max scale;
tmp_s=get(handles.maxscale,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_i); 

tmp_s=get(handles.runwinlen,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%f\n',tmp_i); 

fclose(fid);


% --------------------------------------------------------------------
function varargout = restore_Callback(h, eventdata, handles, varargin)

restoresetting(gcbo,handles);


% --------------------------------------------------------------------
function restoresetting(fig,handles)
% initial the setting relative the raw data

%initial the plot mode
tmp_s='curve|image|surf|mesh';
set(handles.plotmode,'String',tmp_s,'Value',1);


%Initial the wavelet type selection list, here we use four types windows.
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%the sort is tmp_s='haar|db|sym|coif|bior|rbio|meyr|dmey';
%if add new wavelet please be careful
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
tmp_s='haar|db|sym|coif|bior|rbio|meyr|dmey';
set(handles.wavetype,'String',tmp_s,'Value',1);

set(handles.wavepara,'Enable','off');
    
%Initial the max scale;

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
tmp_max=wmaxlev(x,'haar')
set(handles.maxscale,'String',num2str(tmp_max));

set(handles.runwinlen,'String',num2str(floor(x/2)));

guidata(fig, handles);


%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting relative functions.
% =====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====




% =====Setting Start=====Setting Start=====Setting Start=====Setting Start=====Setting Start=====
%Here is the setting of plot.
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV

% --------------------------------------------------------------------
function varargout = freadd_Callback(h, eventdata, handles, varargin)

tmp_size=size(handles.ResultData.scale);
tmp_fmin=handles.ResultData.scale(1);
tmp_fmax=handles.ResultData.scale(tmp_size(2));

tmp_s=get(handles.totalfre,'String');
tmp_fre=str2num(tmp_s);
tmp_fre=floor(tmp_fre);

if tmp_fre<tmp_fmax & tmp_fre>tmp_fmin
    existed=0;
    for i=1:handles.ResultData.PlotSomeFreNo
        if tmp_fre==handles.ResultData.PlotSomeFre(i)
            existed=1;
        end
    end
    
    if existed==0
        handles.ResultData.PlotSomeFreNo=handles.ResultData.PlotSomeFreNo+1;
        handles.ResultData.PlotSomeFre(handles.ResultData.PlotSomeFreNo)=tmp_fre;

        tmp_s='';
        for i=1:handles.ResultData.PlotSomeFreNo-1
            tmp_f=handles.ResultData.scale(handles.ResultData.PlotSomeFre(i));
            tmp_s=strcat(tmp_s,num2str(tmp_f));
            tmp_s=strcat(tmp_s,'|');
        end
        tmp_f=handles.ResultData.scale(handles.ResultData.PlotSomeFre(handles.ResultData.PlotSomeFreNo));
        tmp_s=strcat(tmp_s,num2str(tmp_f));
        set(handles.partfre,'String',tmp_s);    
    end

    guidata(gcbo,handles);
end

% --------------------------------------------------------------------
function varargout = fredel_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.partfre,'Value');

if handles.ResultData.PlotSomeFreNo>0
    for i=tmp_i:handles.ResultData.PlotSomeFreNo-1
        handles.ResultData.PlotSomeFre(i)=handles.ResultData.PlotSomeFre(i+1);
    end

    handles.ResultData.PlotSomeFreNo=handles.ResultData.PlotSomeFreNo-1;
        
    tmp_s='';
    for i=1:handles.ResultData.PlotSomeFreNo-1
        tmp_f=handles.ResultData.scale(handles.ResultData.PlotSomeFre(i));
        tmp_s=strcat(tmp_s,num2str(tmp_f));
        tmp_s=strcat(tmp_s,'|');
    end
    
    if handles.ResultData.PlotSomeFreNo>0
        tmp_f=handles.ResultData.scale(handles.ResultData.PlotSomeFre(handles.ResultData.PlotSomeFreNo));
        tmp_s=strcat(tmp_s,num2str(tmp_f));
    end
    
    set(handles.partfre,'String',tmp_s,'Value',1);    
   
    guidata(gcbo,handles);
end


% --------------------------------------------------------------------
function varargout = somefreplot_Callback(h, eventdata, handles, varargin)

tmp_i=get(h,'Value');
if tmp_i==get(h,'Min')
    set(handles.totalfre,'Enable','off');
    set(handles.partfre,'Enable','off');    
    set(handles.freadd,'Enable','off');    
    set(handles.fredel,'Enable','off');    
else
    set(handles.totalfre,'Enable','on');
    set(handles.partfre,'Enable','on');    
    set(handles.freadd,'Enable','on');    
    set(handles.fredel,'Enable','on');    
end    

% --------------------------------------------------------------------
function varargout = detorapp_Callback(h, eventdata, handles, varargin)

status=get(handles.detorapp,'Value');
if status==get(handles.detorapp,'Min')
    set(handles.detorapp,'String','Detail');    
else
    set(handles.detorapp,'String','Approximate');
end
guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = coeformra_Callback(h, eventdata, handles, varargin)

status=get(handles.coeformra,'Value');
if status==get(handles.coeformra,'Min')
    set(handles.coeformra,'String','Coefficient');    
else
    set(handles.coeformra,'String','MRA');
end
guidata(gcbo,handles);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting of plot.
% =====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====


% --------------------------------------------------------------------
function varargout = waveinformation_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.wavetype,'Value');
tmp_s=get(handles.wavetype,'String');
tmp_name=tmp_s(tmp_i,:);
waveinfo(tmp_name);

% --------------------------------------------------------------------
function wname = getwavename(handles)

tmp_i=get(handles.wavetype,'Value');
tmp_s=get(handles.wavetype,'String');
wname=tmp_s(tmp_i,:);

tmp_s=get(handles.wavepara,'Enable');
if strcmp(tmp_s,'on')
    tmp_i=get(handles.wavepara,'Value');
    tmp_s=get(handles.wavepara,'String');
    tmp_para=tmp_s(tmp_i,:);
    wname=strcat(wname,tmp_para);
end

% --------------------------------------------------------------------
function varargout = startanalysis_Callback(h, eventdata, handles, varargin)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

wname = getwavename(handles);

tmp_s=get(handles.maxscale,'String');
tmp_maxscale=floor(str2num(tmp_s));

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

handles.ResultData.xtime=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
handles.ResultData.scale=[1:tmp_maxscale];
handles.ResultData.maxscale=tmp_maxscale;
handles.ResultData.wname=wname;

for i=1:handles.AnaData.selno
    data=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
    [C,L]=wavedec(data,tmp_maxscale,wname);
    handles.ResultData.coef(i).C=C;
    handles.ResultData.coef(i).L=L;
end

set(handles.saveresulttypeone,'Enable','on');
set(handles.saveresulttypetwo,'Enable','on');
set(handles.plottypeone,'Enable','on');
set(handles.plottypetwo,'Enable','on');
set(handles.plottypethree,'Enable','on');

set(handles.somefreplot,'Enable','on');
set(handles.VarSpectra,'Enable','on');
set(handles.partfre,'String','');


handles.ResultData.PlotSomeFreNo=0;

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = runwinlen_Callback(h, eventdata, handles, varargin)

tmp_s=get(handles.runwinlen,'String');
tmp_max=str2num(tmp_s);

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=floor((endp-stp+1)/2);
if tmp_max>x
    tmp_max=x;
end    
set(handles.runwinlen,'String',num2str(tmp_max));


%---------------------------------------------------------------------------
function [RC,xRC,yRC]=dwtvariance(handles,chnno)
% Calculate the wavelet variance
RC=[];

tmp_s=get(handles.runwinlen,'string');
winlen=str2num(tmp_s);
winlen=ceil(winlen);
halfwinlen=ceil(winlen/2);
%Get the length of the running windows.

%get the variance from coefficients
%dt=detcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,1);

%get the variance from MRA
dt = wrcoef('d',handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,1); 

dt=dt.*dt;
Maxlength=length(dt);

RC=zeros(handles.ResultData.maxscale,Maxlength);
clear tmpf;
tmpf=zeros(1,Maxlength);

tmpi=2*halfwinlen+1;
for i=1:Maxlength
    st=i-halfwinlen;
    if st<1
        st=1;
    end
    ed=i+halfwinlen;
    if ed>Maxlength
        ed=Maxlength;
    end
    clear tmpv;
    tmpv=dt(st:ed);
    RC(1,i)=mean(tmpv);
end

for j=2:handles.ResultData.maxscale
    
    %get the variance from coefficients
    %dt=detcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,j);

    %get the variance from MRA
    dt = wrcoef('d',handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,j); 

    dt=dt.*dt;
%    datalength=length(dt);
%    interval=Maxlength/datalength;
    tmpi=2^j;

    clear tmpf;
    tmpf=zeros(1,Maxlength);
    
%    winlen=floor(winlen/2); % don't shrink the window length
    if winlen <2
        sprintf('The winlen is too small at scale:%d !!!!!!!',j)
    end
    
    halfwinlen=ceil(winlen/2);

    for i=1+halfwinlen:Maxlength-halfwinlen
        st=i-halfwinlen;
        ed=i+halfwinlen;
%        clear tmpv;
        tmpv=dt(st:ed);
        RC(j,i)=mean(tmpv);
    end    
end
ttime=max(handles.ResultData.xtime)-min(handles.ResultData.xtime);
xRC=[1:Maxlength]*ttime/(Maxlength-1);
yRC=[1:handles.ResultData.maxscale];

%---------------------------------------------------------------------------

%---------------------------------------------------------------------------
function [DWTspec]=dwtspectra(handles,chnno)
% Calculate the unbiased wavelet variance spectra.
wavelen=length(wfilters(handles.ResultData.wname));

for j=1:handles.ResultData.maxscale
%    dt=detcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,j);            
    dt = wrcoef('d',handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,j); 
 
    dt=dt.*dt;
    datalength=length(dt);
    
    tmpi=2^j;
    stp=floor(((wavelen-2)*(1-1/tmpi))/2);
    endp=datalength-stp;

    if endp<stp+1
        endp=stp+1;
    end
    
    %the data points used for calculate the spectra
    %sprintf('the data points used to calculate the spectra in scale %d=%d',j,endp-stp+1)
    tmpv=dt(stp:endp);
    DWTspec(j)=mean(tmpv);
end
%---------------------------------------------------------------------------


%---------------------------------------------------------------------------
function [RC,xRC,yRC]=coef2matrix(handles,chnno)
%    ////////////////Convert the data for image plot//////////////////////

if get(handles.detorapp,'Value')==get(handles.detorapp,'Min')
    DetOrAppV=0;
    DetOrAppStr='d';
else
    DetOrAppV=1;
    DetOrAppStr='a';    
end
RC=[];

if get(handles.coeformra,'Value')==get(handles.coeformra,'Min') %coefficient
    if DetOrAppV==0
        dt=detcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,1);            
    else
        dt=appcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,1);
    end
    Maxlength=length(dt);
    RC=zeros(handles.ResultData.maxscale,Maxlength);
    dt=dt';
    RC(1,:)=dt(1,:);

    for j=2:handles.ResultData.maxscale
        if DetOrAppV==0
            dt=detcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,j);            
        else
            dt=appcoef(handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,j);
        end
        datalength=length(dt);
        interval=Maxlength/datalength;
        for k=1:Maxlength
            datasite=floor(k/interval);
            if datasite<1
                datasite=1;
            end
            if datasite>datalength
                datasite=datelngth;
            end
            RC(j,k)=dt(datasite);
        end
    end
    ttime=max(handles.ResultData.xtime)-min(handles.ResultData.xtime);
    xRC=[1:Maxlength]*ttime/(Maxlength-1);
    yRC=[1:handles.ResultData.maxscale];
else   % MRA
    RC=[];
    for j=1:handles.ResultData.maxscale
        dt = wrcoef(DetOrAppStr,handles.ResultData.coef(chnno).C,handles.ResultData.coef(chnno).L,handles.ResultData.wname,j); 
        RC=[RC dt];
    end
    RC=RC';
    Maxlength=length(dt);
    ttime=max(handles.ResultData.xtime)-min(handles.ResultData.xtime);
    xRC=[1:Maxlength]*ttime/(Maxlength-1);
    yRC=[1:handles.ResultData.maxscale];
end


%    ////////////////Convert the data for image plot//////////////////////


% --------------------------------------------------------------------
function varargout = plottypeone_Callback(h, eventdata, handles, varargin)

fid=fopen('msfigset.inf','r');
if fid==-1
    figsetting(1)=14;
    figsetting(2)=700;
    figsetting(3)=500;
end
figsetting=fscanf(fid,'%d\n');
fclose(fid);
pos=[0 0 figsetting(2) figsetting(3)];


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

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

if tmp_plotmode==1%draw curve, many subplot
    rowno=handles.AnaData.selno*handles.ResultData.maxscale;
    rowstep=handles.ResultData.maxscale;
else
    rowno=handles.AnaData.selno;
    rowstep=1;
end
    
if get(handles.plotrawdata,'Value')==get(handles.plotrawdata,'Max')%draw raw data
    rowno=rowno+handles.AnaData.selno;
    rowstep=rowstep+1;
    rowst=2;
    tmp_plotrawdata=1;
else
    rowst=1;
    tmp_plotrawdata=0;
end
        
colno=1;

clear x;
clear y;
if tmp_multiplot==0
    figure('Position',pos);
end
for i=1:handles.AnaData.selno
    [RC,xRC,yRC]=coef2matrix(handles,i);%convert the result to relevant expressed result.
    
    if tmp_multiplot==0
        if tmp_plotrawdata==1%plot raw data
            x=handles.ResultData.xtime;
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            subplot(rowno,colno,(i-1)*rowstep+1);
            plot(x,y,'k');
            set(gca,'FontSize',figsetting(1));    
            tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
            title(tmp_s);
        end


        if tmp_plotmode~=1
            subplot(rowno,colno,(i-1)*rowstep+rowst);
        end

        switch tmp_plotmode
        case 1%curve
        for j=1:handles.ResultData.maxscale
            subplot(rowno,colno,(i-1)*rowstep+rowst+j-1);
            dt=RC(j,:);
            plot(xRC,dt);
            set(gca,'FontSize',figsetting(1)); 
        end

        case 2%image
            image(xRC,yRC,RC,'CDataMapping','scaled');
        case 3%surf
          surf(xRC,yRC,RC,'CDataMapping','scaled');
        case 4%mesh
           mesh(xRC,yRC,RC,'CDataMapping','scaled');
        end      
    
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(gray);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            HColorBar=colorbar('vert');
            set(HColorBar,'FontSize',figsetting(1));    
        end
        set(gca,'FontSize',figsetting(1));    
        tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
    else %plot multi figures
        if tmp_plotrawdata==1%plot raw data
            x=handles.ResultData.xtime;
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            figure('Position',pos);
            plot(x,y,'k');
            set(gca,'FontSize',figsetting(1));    
            tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
            title(tmp_s);
        end
   
        switch tmp_plotmode
        case 1%curve
        for j=1:handles.ResultData.maxscale
            dt=RC(j,:);
            figure('Position',pos);
            plot(xRC,dt,'k');
            set(gca,'FontSize',figsetting(1)); 
        end

        case 2%image
            figure('Position',pos);
            image(xRC,yRC,RC,'CDataMapping','scaled');
        case 3%surf
            figure('Position',pos);
            surf(xRC,yRC,RC,'CDataMapping','scaled');
        case 4%mesh
            figure('Position',pos);
            mesh(xRC,yRC,RC,'CDataMapping','scaled');
        end      
    
        if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
            shading interp;
        else 
            shading flat;
        end            
        if tmp_graymap==get(handles.graysurf,'Max')
            colormap(gray);
        end
        if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
            HColorBar=colorbar('vert');
            set(HColorBar,'FontSize',figsetting(1));    
        end
        set(gca,'FontSize',figsetting(1));    
        tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;    
    end
end
        

%plot some component in another figure
if get(handles.somefreplot,'Value')==get(handles.somefreplot,'Max')
    clear x;
    clear y;
    if tmp_multiplot==0
        figure('Position',pos);
    end
    
    if get(handles.plotrawdata,'Value')==get(handles.plotrawdata,'Max')%draw raw data
        rowno=handles.AnaData.selno*(handles.ResultData.PlotSomeFreNo+1);
        rowstep=handles.ResultData.PlotSomeFreNo+1;
        rowst=1;
        tmp_plotrawdata=1;
    else
        rowno=handles.AnaData.selno*handles.ResultData.PlotSomeFreNo;
        rowstep=handles.ResultData.PlotSomeFreNo;
        rowst=0;
        tmp_plotrawdata=0;
    end
    x=handles.ResultData.xtime;             

    for i=1:handles.AnaData.selno
        [RC,xRC,yRC]=coef2matrix(handles);%convert the result to relevant expressed result.
        
        if tmp_plotrawdata==1%plot raw data
            if tmp_multiplot==0
                subplot(rowno,colno,(i-1)*rowstep+1);
            else 
                figure;
            end
            x=handles.ResultData.xtime;
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
            tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
            title(tmp_s);
        end

        if tmp_multiplot==1
            figure('Position',pos);
        end

        for j=1:handles.ResultData.PlotSomeFreNo
            if tmp_multiplot==1
                subplot(handles.ResultData.PlotSomeFreNo,colno,j);
            else
                subplot(rowno,colno,(i-1)*rowstep+rowst+j);
            end

            tmp_i=handles.ResultData.PlotSomeFre(j);
            dt=RC(tmp_i,:);
            plot(xRC,dt,'k');

            tmp_s=num2str(handles.ResultData.scale(handles.ResultData.PlotSomeFre(j)));
            tmp_s=strcat(tmp_s,'--');
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));
        end
    end
end

%the averaged power plot-wavelet variance
% --------------------------------------------------------------------
function varargout = plottypetwo_Callback(h, eventdata, handles, varargin)

fid=fopen('msfigset.inf','r');
if fid==-1
    figsetting(1)=14;
    figsetting(2)=700;
    figsetting(3)=500;
end
figsetting=fscanf(fid,'%d\n');
fclose(fid);
pos=[0 0 figsetting(2) figsetting(3)];


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

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

if tmp_plotmode==1%draw curve, many subplot
    rowno=handles.AnaData.selno*handles.ResultData.maxscale;
    rowstep=handles.ResultData.maxscale;
else
    rowno=handles.AnaData.selno;
    rowstep=1;
end
    
if get(handles.plotrawdata,'Value')==get(handles.plotrawdata,'Max')%draw raw data
    rowno=rowno+handles.AnaData.selno;
    rowstep=rowstep+1;
    rowst=2;
    tmp_plotrawdata=1;
else
    rowst=1;
    tmp_plotrawdata=0;
end
        
colno=1;

clear x;
clear y;
if tmp_multiplot==0
    figure('Position',pos);
end

for i=1:handles.AnaData.selno
    [RC,xRC,yRC]=dwtvariance(handles,i);%convert the result to relevant expressed result.
    
    if tmp_plotrawdata==1%plot raw data
        x=handles.ResultData.xtime;
        y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
        if tmp_multiplot==0
            subplot(rowno,colno,(i-1)*rowstep+1);
        else            
            if tmp_plotmode==1
                figure('Position',pos);
                subplot(rowno,colno,(i-1)*rowstep+1);
            else
                figure('Position',pos);
            end
        end
        plot(x,y);
        set(gca,'FontSize',figsetting(1));    
        tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
        title(tmp_s);
    end

    if tmp_multiplot==0
        if tmp_plotmode~=1
            subplot(rowno,colno,(i-1)*rowstep+rowst);
        end
    else 
        if tmp_plotmode~=1
            figure('Position',pos);
        end
    end

    switch tmp_plotmode
    case 1%curve
    for j=1:handles.ResultData.maxscale
        subplot(rowno,colno,(i-1)*rowstep+rowst+j-1);
        dt=RC(j,:);
        plot(xRC,dt);
        set(gca,'FontSize',figsetting(1)); 
    end

    case 2%image
        image(xRC,yRC,RC,'CDataMapping','scaled');
    case 3%surf
        surf(xRC,yRC,RC,'CDataMapping','scaled');
    case 4%mesh
        mesh(xRC,yRC,RC,'CDataMapping','scaled');
    end      
    
    if tmp_shadingmode==get(handles.shadingmode,'Max')% use the shding interp mode.
        shading interp;
    else 
        shading flat;
    end            
    if tmp_graymap==get(handles.graysurf,'Max')
        colormap(gray);
    end
    if tmp_colorbar==get(handles.colorbar,'Max')% draw color bar
        HColorBar=colorbar('vert');
        set(HColorBar,'FontSize',figsetting(1));    
    end
    set(gca,'FontSize',figsetting(1));    
    tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
%    title(tmp_s);
end
        
%plot some component in another figure
if get(handles.somefreplot,'Value')==get(handles.somefreplot,'Max')
    clear x;
    clear y;
    if tmp_multiplot==0
        figure('Position',pos);
    end
    
    if get(handles.plotrawdata,'Value')==get(handles.plotrawdata,'Max')%draw raw data
        rowno=handles.AnaData.selno*(handles.ResultData.PlotSomeFreNo+1);
        rowstep=handles.ResultData.PlotSomeFreNo+1;
        rowst=1;
        tmp_plotrawdata=1;
    else
        rowno=handles.AnaData.selno*handles.ResultData.PlotSomeFreNo;
        rowstep=handles.ResultData.PlotSomeFreNo;
        rowst=0;
        tmp_plotrawdata=0;
    end
    x=handles.ResultData.xtime;             

    for i=1:handles.AnaData.selno
        [RC,xRC,yRC]=dwtvariance(handles,i);
        
        if tmp_plotrawdata==1%plot raw data
            if tmp_multiplot==0
                subplot(rowno,colno,(i-1)*rowstep+1);
            else 
                figure('Position',pos);
            end
            x=handles.ResultData.xtime;
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
            tmp_s=handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name;
            title(tmp_s);
        end

        if tmp_multiplot==1
            figure('Position',pos);
        end

        for j=1:handles.ResultData.PlotSomeFreNo
            if tmp_multiplot==1
                subplot(handles.ResultData.PlotSomeFreNo,colno,j);
            else
                subplot(rowno,colno,(i-1)*rowstep+rowst+j);
            end

            tmp_i=handles.ResultData.PlotSomeFre(j);
            dt=RC(tmp_i,:);
            plot(xRC,dt);

            tmp_s=num2str(handles.ResultData.scale(handles.ResultData.PlotSomeFre(j)));
            tmp_s=strcat(tmp_s,'--');
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));
        end
    end
end

% --------------------------------------------------------------------
%calcualte the unbiased spectra based on wavelet variance analysis
function varargout = VarSpectra_Callback(h, eventdata, handles, varargin)
fid=fopen('msfigset.inf','r');
if fid==-1
    figsetting(1)=14;
    figsetting(2)=700;
    figsetting(3)=500;
end
figsetting=fscanf(fid,'%d\n');
fclose(fid);
pos=[0 0 figsetting(2) figsetting(3)];


stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

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

if tmp_plotmode==1%draw curve, many subplot
    rowno=handles.AnaData.selno*handles.ResultData.maxscale;
    rowstep=handles.ResultData.maxscale;
else
    rowno=handles.AnaData.selno;
    rowstep=1;
end
    
if get(handles.plotrawdata,'Value')==get(handles.plotrawdata,'Max')%draw raw data
    rowno=rowno+handles.AnaData.selno;
    rowstep=rowstep+1;
    rowst=2;
    tmp_plotrawdata=1;
else
    rowst=1;
    tmp_plotrawdata=0;
end
        
colno=1;

clear x;
clear y;
if tmp_multiplot==0
%    figure;
end


%%plot in one plot........................................................
if tmp_multiplot==get(handles.plotmulti,'Min')
    figure('Position',pos);
    rowno=handles.AnaData.selno;
    
    if tmp_plotrawdata==get(handles.plotrawdata,'Min')
        %no raw data
        colno=1;
        clear x;
        clear y;

        for i=1:rowno
            DWTspec=dwtspectra(handles,i);
            %back door
            tmpf=DWTspec';
%            save DWTspec.txt tmpf -ascii;
            %back door
            y=DWTspec;
            x=[1:length(y)];
            subplot(rowno,colno,i);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
    else        
        % with raw data
        clear x;
        clear y;
        colno=2;

        %plot raw data
        x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);        
        for i=1:rowno
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            subplot(rowno,colno,i*colno-1);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
        
        %plot spectral result
        clear x;
        clear y;
        for i=1:rowno
            DWTspec=dwtspectra(handles,i);
            y=DWTspec;
            x=[1:length(y)];
            subplot(rowno,colno,i*colno);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
    end
%%plot multi plots................................................. 
else
    rowno=handles.AnaData.selno;
    if tmp_plotrawdata==get(handles.plotrawdata,'Max')
        % with raw data
        clear x;
        clear y;

        %plot raw data
        x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);        
        for i=1:rowno
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            figure('Name',handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
    end
       
    %plot spectral result
    clear x;
    clear y;
    for i=1:rowno
        DWTspec=dwtspectra(handles,i);
        y=DWTspec;
        x=[1:length(y)];
        figure('Name',handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name,'Position',pos);
        plot(x,y);
        set(gca,'FontSize',figsetting(1));
    end
end

res=[x y];
save DWTSpectraRes.txt res -ascii;

% --------------------------------------------------------------------
function varargout = saveresulttypeone_Callback(h, eventdata, handles, varargin)
   

tmp_format='%';
for i=1:handles.ResultData.maxscale-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');
    
for i=1:handles.AnaData.selno
    
    tmp_title='Save the DWT decomposition of data:';
    tmp_title=strcat(tmp_title,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);

    tmp_filename=handles.FileInfo.fname;
    tmp_filename=strcat(tmp_filename,'-');    
    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);    
    tmp_filename=strcat(tmp_filename,'-DWT.txt');

    %get the file name and directory name of the data file by menu item : Fiel Open
    [fname,pname]=uiputfile(tmp_filename,tmp_title);
    
    if fname==0
        return;
    end
    
    %get the full name of the data file
    tmp_fullname=strcat(pname,fname);

    [RC,xRC,yRC]=coef2matrix(handles,i);

    fid=fopen(tmp_fullname,'wt');
    fprintf(fid,'%f %d 0 0\n',handles.RawData.fs,handles.ResultData.maxscale);
    fprintf(fid,tmp_format,RC);
    fclose(fid);    
%    tmp_filename='save DWT-';
%    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
%    tmp_filename=strcat(tmp_filename,'.txt RC -ASCII;');
%    eval(tmp_filename);
    
end


% --------------------------------------------------------------------
% save variance analysis result
function varargout = saveresulttypetwo_Callback(h, eventdata, handles, varargin)

tmp_format='%';
for i=1:handles.ResultData.maxscale-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');
    
for i=1:handles.AnaData.selno
    tmp_title='Save the DWT variance analysis of data:';
    tmp_title=strcat(tmp_title,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);

    tmp_filename=handles.FileInfo.fname;
    tmp_filename=strcat(tmp_filename,'-');    
    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);    
    tmp_filename=strcat(tmp_filename,'-DWTVAR.txt');

    %get the file name and directory name of the data file by menu item : Fiel Open
    [fname,pname]=uiputfile(tmp_filename,tmp_title);

    if fname==0
        return;
    end
    
    %get the full name of the data file
    tmp_fullname=strcat(pname,fname);

    [RC,xRC,yRC]=dwtvariance(handles,i);%convert the result to relevant expressed result.

    fid=fopen(tmp_fullname,'wt');
    fprintf(fid,'%f %d 0 0\n',handles.RawData.fs,handles.ResultData.maxscale);
    fprintf(fid,tmp_format,RC);
    fclose(fid);    
%    tmp_filename='save DWT-';
%    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
%    tmp_filename=strcat(tmp_filename,'.txt RC -ASCII;');
%    eval(tmp_filename);
    
end
