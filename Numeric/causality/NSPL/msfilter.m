function varargout = msfilter(varargin)
% MSFILTER Application M-file for msfilter.fig
%    FIG = MSFILTER launch msfilter GUI.
%    MSFILTER('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.5 17-Dec-2003 11:38:00


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
    handles.fnodeno=0;
    
    handles.BSfreListNo=1;    %the number of the stopped frequency in the list
    handles.BSfre(1)=50;    %the stopped frequency
    set(handles.liststopfre,'string','50');
    set(handles.inputfre,'string','100');
    set(handles.recomAstop,'string','0.0001');
    
    %initial the bandpass filter.
    set(handles.BPHPfreButter,'string','0');
    set(handles.BPLPfreButter,'string',num2str(handles.RawData.fs/2));
    
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
function varargout = saveresulttypetwo_Callback(h, eventdata, handles, varargin)
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

%Nodedefaultsetting(gcbo,handles)
handles.fnodeno=0;

guidata(gcbo, handles);

lphpfredefaultsetting(gcbo,handles)
guidata(gcbo, handles);

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

%Nodedefaultsetting(gcbo,handles);
handles.fnodeno=0;

guidata(gcbo, handles);

lphpfredefaultsetting(gcbo,handles)
guidata(gcbo, handles);

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

%Nodedefaultsetting(gcbo,handles);
handles.fnodeno=0;
guidata(gcbo, handles);

lphpfredefaultsetting(gcbo,handles)
guidata(gcbo, handles);


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
fid=fopen('msfilterset.inf','r');
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


%Initial the max scale;
tmp_max=fscanf(fid,'%d', [1 1]);
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);
x=endp-stp+1;
wname = getwavename(handles);
if tmp_max>wmaxlev(x,wname)
    tmp_max=wmaxlev(x,wname);
end
set(handles.maxscale,'String',num2str(tmp_max));

fclose(fid);

setmark=1;

guidata(fig, handles);

%Nodedefaultsetting(fig,handles);
handles.fnodeno=0;
guidata(fig, handles);

lphpfredefaultsetting(fig,handles)
guidata(fig, handles);

% --------------------------------------------------------------------
function varargout = savedefault_Callback(h, eventdata, handles, varargin)

fid=fopen('msfilterset.inf','wt');
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
fprintf(fid,'%d\n',tmp_i); 

fclose(fid);


% --------------------------------------------------------------------
function varargout = restore_Callback(h, eventdata, handles, varargin)

restoresetting(gcbo,handles);


% --------------------------------------------------------------------
function restoresetting(fig,handles)
% initial the setting relative the raw data


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

guidata(fig, handles);

Nodedefaultsetting(fig,handles);
handles.fnodeno=0;
guidata(fig, handles);

lphpfredefaultsetting(fig,handles)
guidata(fig, handles);

% --------------------------------------------------------------------
function Nodedefaultsetting(fig,handles)

tmp_s=get(handles.maxscale,'String');
maxscale=str2num(tmp_s);

sampfre=handles.RawData.fs;

NodeNo=2^maxscale;

tmp_str='1(0~';
tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo));
tmp_str=strcat(tmp_str,'Hz)');
for i=2:NodeNo
    tmp_str=strcat(tmp_str,'|');
    tmp_str=strcat(tmp_str,num2str(i));
    tmp_str=strcat(tmp_str,'(');
    tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(i-1)));
    tmp_str=strcat(tmp_str,'~');
    tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(i)));
    tmp_str=strcat(tmp_str,'Hz)');
end

set(handles.nodelist,'String',tmp_str,'Value',1);
set(handles.nodefiltered,'String','');

set(handles.psdspectra,'Enable','off');
set(handles.delnode,'Enable','off');
set(handles.addnode,'Enable','off');
set(handles.nodefiltered,'Enable','off');
set(handles.nodelist,'Enable','off');

handles.fnodeno=0;

guidata(fig, handles);


% --------------------------------------------------------------------
function lphpfredefaultsetting(fig,handles)

tmp_s=get(handles.maxscale,'String');
maxscale=str2num(tmp_s);

sampfre=handles.RawData.fs;

hpfre_str='0.000';
lpfre_str=sprintf('%7.3f',sampfre/2/(2^maxscale));;

for i=1:maxscale
    tmpstr=sprintf('|%7.3f',sampfre/2/(2^(maxscale+1-i)));
    hpfre_str=strcat(hpfre_str,tmpstr);    
    tmpstr=sprintf('|%7.3f',sampfre/(2^(maxscale+1-i)));  
    lpfre_str=strcat(lpfre_str,tmpstr);
end

set(handles.hpfrelist,'String',hpfre_str,'Value',1);
set(handles.lpfrelist,'String',lpfre_str,'Value',maxscale+1);

guidata(fig, handles);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting relative functions.
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




%========================BAND PASS USING DWT=======================BEGIN
%========================BAND PASS USING DWT=======================BEGIN
%========================BAND PASS USING DWT=======================BEGIN
% --------------------------------------------------------------------
function varargout = BPDWT_Callback(h, eventdata, handles, varargin)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

wname = getwavename(handles);

tmp_s=get(handles.maxscale,'String');
tmp_maxscale=floor(str2num(tmp_s));

hpsetting=get(handles.hpfrelist,'Value');
lpsetting=get(handles.lpfrelist,'Value');

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

N=[];
tmpi=tmp_maxscale+1-lpsetting;
if tmpi>0
    N=[N [1:tmpi]];
end

tmpi=tmp_maxscale+3-hpsetting;
if tmpi<=tmp_maxscale
    N=[N [tmpi:tmp_maxscale]];
end

if isempty(N) & hpsetting==1
    return;
end

for i=1:handles.RawData.chnno
    selmark=0;
    for j=1:handles.AnaData.selno
        if i==handles.AnaData.selfirstchn(j)
            selmark=j;
        end
    end
    if selmark==0
        handles.ResultData.coef(:,i)=handles.RawData.data(stp:endp,i);
    else        
        data=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(selmark));
        [C,L]=wavedec(data,tmp_maxscale,wname);           

        if ~isempty(N)
            C=wthcoef('d',C,L,N);%the detials are set to zeros in [stlevel:endlevel] levels.
        end
        if hpsetting>1
            C=wthcoef('a',C,L);%the approximates are set to zeros.
        else
            
        end
        synres=wrcoef('a',C,L,wname,0);
        handles.ResultData.coef(:,i)=synres(:);    
    end
end

handles.ResultData.xtime=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
handles.ResultData.scale=[1:tmp_maxscale];
handles.ResultData.maxscale=tmp_maxscale;
handles.ResultData.wname=wname;

set(handles.saveBPDWT,'Enable','on');

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = saveBPDWT_Callback(h, eventdata, handles, varargin)


tmp_title='Save the Filtering analysis of data';

tmp_filename=handles.FileInfo.fname;
tmp_filename=strcat(tmp_filename,'-BPDWT.txt');

   
%get the file name and directory name of the data file by menu item : File Open
[fname,pname]=uiputfile(tmp_filename,tmp_title);

if fname==0
    return;
end
    
%get the full name of the data file
tmp_fullname=strcat(pname,fname);

tmp_format='%';
for i=1:handles.RawData.chnno-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');

%open this file to write data
tmp_fid=fopen(tmp_fullname,'wt');

fprintf(tmp_fid,'%5.3f %d 0 0\n',handles.RawData.fs, handles.RawData.chnno);

tmp_data=handles.ResultData.coef;
tmp_data=tmp_data';
fprintf(tmp_fid,tmp_format,tmp_data);
fclose(tmp_fid);


% --------------------------------------------------------------------
function varargout = hpfrelist_Callback(h, eventdata, handles, varargin)

hpsetting=get(handles.hpfrelist,'Value');
lpsetting=get(handles.lpfrelist,'Value');

if hpsetting>=lpsetting
    hpsetting=lpsetting;
    set(handles.hpfrelist,'Value',hpsetting);
end

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = lpfrelist_Callback(h, eventdata, handles, varargin)


hpsetting=get(handles.hpfrelist,'Value');
lpsetting=get(handles.lpfrelist,'Value');

if lpsetting<=hpsetting
    lpsetting=hpsetting;
    set(handles.lpfrelist,'Value',lpsetting);
end

guidata(gcbo,handles);


%========================BAND PASS USING DWT=======================END
%========================BAND PASS USING DWT=======================END
%========================BAND PASS USING DWT=======================END


%========================BAND STOP USING WAVELET PACKET=======================BEGIN
%========================BAND STOP USING WAVELET PACKET=======================BEGIN
%========================BAND STOP USING WAVELET PACKET=======================BEGIN

%--------------------------------------------------------------------
function varargout = nodelist_Callback(h, eventdata, handles, varargin)

ChnExisted=0;
tmp_i=get(handles.nodelist,'Value');

for i=1:handles.fnodeno
    if tmp_i==handles.fnodelist(i)
        ChnExisted=1;%current selected data has existed in the list of the data for analysis 
    end
end

if ChnExisted==1
    set(handles.addnode,'Enable','off');
else
    set(handles.addnode,'Enable','on');
end
set(handles.delnode,'Enable','off');

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = nodefiltered_Callback(h, eventdata, handles, varargin)

set(handles.addnode,'Enable','off');
set(handles.delnode,'Enable','on');

% --------------------------------------------------------------------
function liststr = getfilterednodelist(fig, h, handles)

tmp_s=get(handles.maxscale,'String');
maxscale=str2num(tmp_s);

sampfre=handles.RawData.fs;
NodeNo=2^maxscale;

tmp_str='';
if handles.fnodeno > 0 
    tmp_str=strcat(tmp_str,num2str(handles.fnodelist(1)));
    tmp_str=strcat(tmp_str,'(');
    tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(handles.fnodelist(1)-1)));
    tmp_str=strcat(tmp_str,'~');
    tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(handles.fnodelist(1))));
    tmp_str=strcat(tmp_str,'Hz)');
    for i=2:handles.fnodeno
        tmp_str=strcat(tmp_str,'|');
        tmp_str=strcat(tmp_str,num2str(handles.fnodelist(i)));
        tmp_str=strcat(tmp_str,'(');
        tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(handles.fnodelist(i)-1)));
        tmp_str=strcat(tmp_str,'~');
        tmp_str=strcat(tmp_str,num2str(sampfre/2/NodeNo*(handles.fnodelist(i))));
        tmp_str=strcat(tmp_str,'Hz)');
    end
end

set(handles.nodefiltered,'String',tmp_str,'Value',1);
guidata(fig,handles);

listsrt=tmp_str;

% --------------------------------------------------------------------
function varargout = addnode_Callback(h, eventdata, handles, varargin)

handles.fnodeno=handles.fnodeno+1;
handles.fnodelist(handles.fnodeno)=get(handles.nodelist,'Value');
guidata(gcbo,handles);

getfilterednodelist(gcbo,h, handles);


%off the add button
set(handles.addnode,'Enable','off');
set(handles.delnode,'Enable','on');

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = delnode_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.nodefiltered,'Value');    

for i=tmp_i:handles.fnodeno-1   
    handles.fnodelist(i)=handles.fnodelist(i+1);
end    
handles.fnodeno=handles.fnodeno-1;


guidata(gcbo,handles);

getfilterednodelist(gcbo,h, handles);

%off the add button
set(handles.addnode,'Enable','off');
if handles.fnodeno == 0
    set(handles.delnode,'Enable','off');
else
    set(handles.delnode,'Enable','on');
end
guidata(gcbo,handles);



% --------------------------------------------------------------------
function varargout = psdspectra_Callback(h, eventdata, handles, varargin)

%determine the data used for decomposing
SelChanNo=get(handles.sellist,'value');

NodeNo=2^handles.ResultData.maxscale;
SortFre(1)=0;
for i=1:handles.ResultData.maxscale
    tmpi=2^i;
    tmpi2=tmpi/2;
    for j=1:tmpi/2
        SortFre(j+tmpi2)=tmpi-1-SortFre(j);
    end
end

tmpi=zeros(NodeNo,1);
for i=1:NodeNo
    tmpi(SortFre(i)+1)=i-1;
end
SortFre=tmpi;

tmpi=get(handles.nodelist,'value');
NodeNoForPSD=SortFre(tmpi);

%Compute the reconstruction at node [handles.ResultData.maxscale,NodeNoForPSD] of Channel; SelChanNo
MRAAtNode = wprcoef(handles.ResultData.coef(SelChanNo).C,handles.ResultData.coef(SelChanNo).L,[handles.ResultData.maxscale,NodeNoForPSD]);

MRAAtNode=MRAAtNode';
[pxx,f]=psd(MRAAtNode,length(MRAAtNode),handles.RawData.fs);
figure;
plot(f,pxx);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = saveBSWP_Callback(h, eventdata, handles, varargin)

tmp_title='Save the filtered data';

tmp_filename=handles.FileInfo.fname;
tmp_filename=strcat(tmp_filename,'-BPF.txt');

   
%get the file name and directory name of the data file by menu item : File Open
[fname,pname]=uiputfile(tmp_filename,tmp_title);

if fname==0
    return;
end
    
%get the full name of the data file
tmp_fullname=strcat(pname,fname);

tmp_format='%';
for i=1:handles.RawData.chnno-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');

%open this file to write data
tmp_fid=fopen(tmp_fullname,'wt');

fprintf(tmp_fid,'%5.3f %d 0 0\n',handles.RawData.fs, handles.RawData.chnno);

tmp_data=handles.ResultData.coef;
tmp_data=tmp_data';
fprintf(tmp_fid,tmp_format,tmp_data);
fclose(tmp_fid);


% --------------------------------------------------------------------
function varargout = decWP_Callback(h, eventdata, handles, varargin)

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
    [T,D]=wpdec(data,tmp_maxscale,wname,'shannon');
    handles.ResultData.coef(i).T=T;
    handles.ResultData.coef(i).D=D;
end
set(handles.psdspectra,'Enable','on');
set(handles.delnode,'Enable','on');
set(handles.addnode,'Enable','on');
set(handles.nodefiltered,'Enable','on');
set(handles.nodelist,'Enable','on');

set(handles.fbandstop,'Enable','on');
set(handles.fwparr,'Enable','on');

guidata(gcbo,handles);


% --------------------------------------------------------------------
%band stop filter, clear the selected band
function varargout = fbandstop_Callback(h, eventdata, handles, varargin)

if handles.fnodeno<1
    msgbox('Please select one node for filtering out!','No node is selected');
    return;
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

NodeNo=2^handles.ResultData.maxscale;
SortFre(1)=0;
for i=1:handles.ResultData.maxscale
    tmpi=2^i;
    tmpi2=tmpi/2;
    for j=1:tmpi/2
        SortFre(j+tmpi2)=tmpi-1-SortFre(j);
    end
end

tmpi=zeros(NodeNo,1);
for i=1:NodeNo
    tmpi(SortFre(i)+1)=i-1;
end
SortFre=tmpi;

for i=1:handles.RawData.chnno
    selmark=0;
    for j=1:handles.AnaData.selno
        if i==handles.AnaData.selfirstchn(j)
            selmark=j;
        end
    end
    if selmark==0
        rescoef(:,i)=handles.RawData.data(stp:endp,i);
    else        
        t=handles.ResultData.coef(selmark).T;
        d=handles.ResultData.coef(selmark).D;
        
        for j=1:handles.fnodeno
            nodej=SortFre(handles.fnodelist(j));
            cfs=wdatamgr('read_cfs',d,t,[handles.ResultData.maxscale,nodej]);    
            ncfs=zeros(size(cfs));
            d=wdatamgr('write_cfs',d,t,[handles.ResultData.maxscale,nodej],ncfs);
        end
        recdata=wprec(t,d);
        rescoef(:,i)=recdata(:);
    end        
end

handles.ResultData.coef=rescoef;

set(handles.saveBSWP,'enable','on');
guidata(gcbo,handles);


%========================BAND STOP USING WAVELET PACKET=======================END
%========================BAND STOP USING WAVELET PACKET=======================END
%========================BAND STOP USING WAVELET PACKET=======================END


%========================BAND STOP USING BUTTERWORTH FILTER=======================BEGIN
%========================BAND STOP USING BUTTERWORTH FILTER=======================BEGIN
%========================BAND STOP USING BUTTERWORTH FILTER=======================BEGIN
% --------------------------------------------------------------------
function varargout = inputfre_Callback(h, eventdata, handles, varargin)

set(handles.delstopfre,'enable','off');
set(handles.addstopfre,'enable','on');


% --------------------------------------------------------------------
function varargout = addstopfre_Callback(h, eventdata, handles, varargin)
  
tmps=get(handles.inputfre,'string');
tmpf=str2num(tmps);
if isempty(tmpf)
    msgbox('Wrong input','Wrong input');
    return;
end

if tmpf<2 | tmpf> handles.RawData.fs-2
    msgbox('Wrong input','Wrong input');
    return;
end

handles.BSfreListNo=handles.BSfreListNo+1; 
handles.BSfre(handles.BSfreListNo)=tmpf; 

tmps='';
for i=1:handles.BSfreListNo-1
    tmps=strcat(tmps,num2str(handles.BSfre(i)));
    tmps=strcat(tmps,'|');
end

if handles.BSfreListNo>0
    tmps=strcat(tmps,num2str(handles.BSfre(handles.BSfreListNo)));
end

set(handles.liststopfre,'string',tmps);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = delstopfre_Callback(h, eventdata, handles, varargin)


tmpi=get(handles.liststopfre,'value');

for i=tmpi:handles.BSfreListNo-1
    handles.BSfre(i)=handles.BSfre(i+1);
end

handles.BSfreListNo=handles.BSfreListNo-1; 

tmps='';
for i=1:handles.BSfreListNo-1
    tmps=strcat(tmps,num2str(handles.BSfre(i)));
    tmps=strcat(tmps,'|');
end

if handles.BSfreListNo>0
    tmps=strcat(tmps,num2str(handles.BSfre(handles.BSfreListNo)));
else
    set(handles.delstopfre,'enable','off');
end

set(handles.liststopfre,'string',tmps,'value',1);

guidata(gcbo,handles);



% --------------------------------------------------------------------
function varargout = liststopfre_Callback(h, eventdata, handles, varargin)

set(handles.delstopfre,'enable','on');
set(handles.addstopfre,'enable','off');


% --------------------------------------------------------------------
function varargout = BSbutterFilter_Callback(h, eventdata, handles, varargin)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

if handles.BSfreListNo<1
    msgbox('Input the filtered frequency','Wrong input');
    return;
end

%compute the filter parameters

tmps=get(handles.recomAstop,'string');
Rs = str2num(tmps);
Rp = Rs/10;

tmps=get(handles.bandwidthset,'string');
ds = str2num(tmps)/2;
dp = ds+1;

for i=1:handles.BSfreListNo
    fre=handles.BSfre(i);
    Wp(i,:)=[fre-dp fre+dp]/handles.RawData.fs*2;
    Ws(i,:)=[fre-ds fre+ds]/handles.RawData.fs*2;
end

%filter the selected data using the filter coefficients

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_i=endp-stp+1;
rescoef=zeros(tmp_i,handles.RawData.chnno);
for i=1:handles.RawData.chnno
    selmark=0;
    for j=1:handles.AnaData.selno
        if i==handles.AnaData.selfirstchn(j)
            selmark=j;
        end
    end
    if selmark==0
        rescoef(:,i)=handles.RawData.data(stp:endp,i);
    else
        
        X=handles.RawData.data(stp:endp,i);
        for j=1:handles.BSfreListNo
            [N, Wn] = buttord(Wp(j,:), Ws(j,:), Rp, Rs);
            [B,A] = BUTTER(N,Wn,'stop');
            X=filtfilt(B,A,X);
        end
        rescoef(:,i)=X(:);
    end        
end

handles.ResultData.coef=rescoef;

set(handles.saveBSbutter,'enable','on');

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = saveBSbutter_Callback(h, eventdata, handles, varargin)

tmp_title='Save the filtered data';

tmp_filename=handles.FileInfo.fname;
tmp_filename=strcat(tmp_filename,'-BSButter.txt');

   
%get the file name and directory name of the data file by menu item : File Open
[fname,pname]=uiputfile(tmp_filename,tmp_title);

if fname==0
    return;
end
    
%get the full name of the data file
tmp_fullname=strcat(pname,fname);

tmp_format='%';
for i=1:handles.RawData.chnno-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');

%open this file to write data
tmp_fid=fopen(tmp_fullname,'wt');

fprintf(tmp_fid,'%5.3f %d 0 0\n',handles.RawData.fs, handles.RawData.chnno);

tmp_data=handles.ResultData.coef;
tmp_data=tmp_data';
fprintf(tmp_fid,tmp_format,tmp_data);
fclose(tmp_fid);




% --------------------------------------------------------------------
function varargout = bandwidthset_Callback(h, eventdata, handles, varargin)

tmps=get(handles.bandwidthset,'string');
Rs = str2num(tmps);
if Rs<0.2
    Rs=0.2;
end
tmps=num2str(Rs);
set(handles.bandwidthset,'string',tmps);



% --------------------------------------------------------------------
function varargout = recomAstop_Callback(h, eventdata, handles, varargin)

tmps=get(handles.recomAstop,'string');
Rs = str2num(tmps);
if Rs<1.0e-6
    Rs=1.0e-6;
end
tmps=num2str(Rs);
set(handles.recomAstop,'string',tmps);



% --------------------------------------------------------------------
function varargout = TestFilter_Callback(h, eventdata, handles, varargin)


dp=2;
ds=0.5;

tmps=get(handles.recomAstop,'string');
Rs = str2num(tmps);
Rp = Rs/10;

tmpi=get(handles.liststopfre,'value');
fre=handles.BSfre(tmpi);
Wp=[fre-dp fre+dp]/handles.RawData.fs*2;
Ws=[fre-ds fre+ds]/handles.RawData.fs*2;

[N, Wn] = buttord(Wp, Ws, Rp, Rs);

tmps=num2str(N)
set(handles.recomOrder,'string',tmps);

guidata(gcbo,handles);


%========================BAND STOP USING BUTTERWORTH FILTER=======================END
%========================BAND STOP USING BUTTERWORTH FILTER=======================END
%========================BAND STOP USING BUTTERWORTH FILTER=======================END



%========================BAND PASS USING BUTTERWORTH FILTER=======================BEGIN
%========================BAND PASS USING BUTTERWORTH FILTER=======================BEGIN
%========================BAND PASS USING BUTTERWORTH FILTER=======================BEGIN

% --------------------------------------------------------------------
function varargout = BPHPfreButter_Callback(h, eventdata, handles, varargin)

tmps=get(handles.BPLPfreButter,'string');
tmpLPf=str2num(tmps);

tmps=get(handles.BPHPfreButter,'string');
tmpHPf=str2num(tmps);

if tmpHPf<0
    tmpHPf=0;
end

if tmpHPf>tmpLPf
    tmpHPf=0;
end

tmps=num2str(tmpHPf);
set(handles.BPHPfreButter,'string',tmps);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = BPLPfreButter_Callback(h, eventdata, handles, varargin)

tmps=get(handles.BPLPfreButter,'string');
tmpLPf=str2num(tmps);

tmps=get(handles.BPHPfreButter,'string');
tmpHPf=str2num(tmps);

if tmpLPf<tmpHPf
    tmpHPf=handles.RawData.fs/2;
end

if tmpLPf>handles.RawData.fs/2
    tmpLPf=handles.RawData.fs/2;
end

tmps=num2str(tmpLPf);
set(handles.BPLPfreButter,'string',tmps);

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = BPbutter_Callback(h, eventdata, handles, varargin)

tmps=get(handles.BPLPfreButter,'string');
tmpLPf=str2num(tmps);

tmps=get(handles.BPHPfreButter,'string');
tmpHPf=str2num(tmps);

filtertype=0;
if tmpHPf<1.0e-4 & abs(tmpLPf-handles.RawData.fs/2)>1.0e-4
    filtertype=1;%low pass filter
end

if tmpHPf>1.0e-4 & abs(tmpLPf-handles.RawData.fs/2)<1.0e-4
    filtertype=2;%high pass filter
end

if tmpHPf>1.0e-4 & abs(tmpLPf-handles.RawData.fs/2)>1.0e-4
    filtertype=3;%band pass filter
end

Rp = 2;
Rs = 10;
R=0.5;

switch filtertype
case 0 %no filtering
case 1 %low pass filter
    Wp=(tmpLPf-2)/handles.RawData.fs*2;
    Ws=tmpLPf/handles.RawData.fs*2;

    [N, Wn] = CHEB1ORD(Wp, Ws, Rp, Rs);
    [B,A] = CHEBY1(N,R,Wn);
    
case 2 %high pass filter
    Wp=(tmpHPf+2)/handles.RawData.fs*2;
    Ws=tmpHPf/handles.RawData.fs*2;

    [N, Wn] = CHEB1ORD(Wp, Ws, Rp, Rs);
    [B,A] = CHEBY1(N,R,Wn,'high');
    
case 3 %band pass filter
    Wp(1)=(tmpHPf+2)/handles.RawData.fs*2;
    Wp(2)=(tmpLPf-2)/handles.RawData.fs*2;
    Ws(1)=tmpHPf/handles.RawData.fs*2; 
    Ws(2)=tmpLPf/handles.RawData.fs*2;

    [N, Wn] = CHEB1ORD(Wp, Ws, Rp, Rs);    
    [B,A] = CHEBY1(N,R,Wn);
    
end

%filter the selected data using the filter coefficients
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_i=endp-stp+1;
rescoef=zeros(tmp_i,handles.RawData.chnno);
for i=1:handles.RawData.chnno
    selmark=0;
    for j=1:handles.AnaData.selno
        if i==handles.AnaData.selfirstchn(j)
            selmark=j;
        end
    end
    if selmark==0
        rescoef(:,i)=handles.RawData.data(stp:endp,i);
    else        
        X=handles.RawData.data(stp:endp,i);
        X=filtfilt(B,A,X);
        rescoef(:,i)=X(:);
    end        
end

handles.ResultData.coef=rescoef;

set(handles.saveBPbutter,'enable','on');

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = saveBPbutter_Callback(h, eventdata, handles, varargin)

tmp_title='Save the filtered data';

tmp_filename=handles.FileInfo.fname;
tmp_filename=strcat(tmp_filename,'-BPButter.txt');

   
%get the file name and directory name of the data file by menu item : File Open
[fname,pname]=uiputfile(tmp_filename,tmp_title);

if fname==0
    return;
end
    
%get the full name of the data file
tmp_fullname=strcat(pname,fname);

tmp_format='%';
for i=1:handles.RawData.chnno-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');

%open this file to write data
tmp_fid=fopen(tmp_fullname,'wt');

fprintf(tmp_fid,'%5.3f %d 0 0\n',handles.RawData.fs, handles.RawData.chnno);

tmp_data=handles.ResultData.coef;
tmp_data=tmp_data';
fprintf(tmp_fid,tmp_format,tmp_data);
fclose(tmp_fid);

%========================BAND PASS USING BUTTERWORTH FILTER=======================END
%========================BAND PASS USING BUTTERWORTH FILTER=======================END
%========================BAND PASS USING BUTTERWORTH FILTER=======================END


% --- Executes on button press in msSmoothFilt.
function msSmoothFilt_Callback(hObject, eventdata, handles)
% hObject    handle to msSmoothFilt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmps=get(handles.SmoothDPV,'string');
msSmoothDP=str2num(tmps);

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_i=endp-stp+1;
rescoef=zeros(tmp_i,handles.RawData.chnno);
for i=1:handles.RawData.chnno
    selmark=0;
    for j=1:handles.AnaData.selno
        if i==handles.AnaData.selfirstchn(j)
            selmark=j;
        end
    end
    if selmark==0
        rescoef(:,i)=handles.RawData.data(stp:endp,i);
    else   
        for k=stp+msSmoothDP:endp-msSmoothDP
            rescoef(k-stp+1,i)=mean(handles.RawData.data(k-msSmoothDP:k+msSmoothDP,i));
        end
    end        
end

tmp_title='Save the filtered data';

tmp_filename=handles.FileInfo.fname;
tmp_filename=strcat(tmp_filename,'-BPButter.txt');

   
%get the file name and directory name of the data file by menu item : File Open
[fname,pname]=uiputfile(tmp_filename,tmp_title);

if fname==0
    return;
end
    
%get the full name of the data file
tmp_fullname=strcat(pname,fname);

tmp_format='%';
for i=1:handles.RawData.chnno-1
    tmp_format=strcat(tmp_format,'6.3e %');
end
tmp_format=strcat(tmp_format,'6.3e\n');

%open this file to write data
tmp_fid=fopen(tmp_fullname,'wt');

fprintf(tmp_fid,'%5.3f %d 0 0\n',handles.RawData.fs, handles.RawData.chnno);

tmp_data=rescoef;
tmp_data=tmp_data';
fprintf(tmp_fid,tmp_format,tmp_data);
fclose(tmp_fid);



% --- Executes during object creation, after setting all properties.
function SmoothDPV_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SmoothDPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function SmoothDPV_Callback(hObject, eventdata, handles)
% hObject    handle to SmoothDPV (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SmoothDPV as text
%        str2double(get(hObject,'String')) returns contents of SmoothDPV as a double


