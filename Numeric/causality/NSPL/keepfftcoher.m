 function varargout = fftcoher(varargin)
% FFTCOHER Application M-file for fftcoher.fig
%    FIG = FFTCOHER launch fftcoher GUI.
%    FFTCOHER('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 30-Aug-2002 14:29:21

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
    set(handles.rawlisttwo,'String',tmp_str,'Value',1);
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
function varargout = wintypelist_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = detrendtypelist_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = default_Callback(h, eventdata, handles, varargin)
getdefaultsetting(gcbo,handles);
% --------------------------------------------------------------------
function varargout = saveresulttypetwo_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plottypethree_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotconfinterval_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotmulti_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotrawdata_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = plotphase_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = sectionno_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = meantestcheck_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = stdtestcheck_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = normtestcheck_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = autocorrtestcheck_Callback(h, eventdata, handles, varargin)

% --------------------------------------------------------------------
function varargout = ndbymean_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ndbystd_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ndbynorm_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ndbyacf_Callback(h, eventdata, handles, varargin)
% --------------------------------------------------------------------
function varargout = ndbytest_Callback(h, eventdata, handles, varargin)

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
tmp_ione=get(handles.rawlistone,'Value');
tmp_itwo=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.selno
    if tmp_ione==handles.AnaData.selfirstchn(i)&tmp_itwo==handles.AnaData.selsecondchn(i)
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
function varargout = rawlisttwo_Callback(h, eventdata, handles, varargin)

ChnExisted=0;
tmp_ione=get(handles.rawlistone,'Value');
tmp_itwo=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.selno
    if tmp_ione==handles.AnaData.selfirstchn(i)&tmp_itwo==handles.AnaData.selsecondchn(i)
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

handles.AnaData.selno=handles.AnaData.selno+1;
handles.AnaData.selfirstchn(handles.AnaData.selno)=get(handles.rawlistone,'Value');
handles.AnaData.selsecondchn(handles.AnaData.selno)=get(handles.rawlisttwo,'Value');

tmp_s1=handles.FileInfo.chnname(get(handles.rawlistone,'Value'));
tmp_s2=handles.FileInfo.chnname(get(handles.rawlisttwo,'Value'));

tmp_s=strcat(tmp_s1.name,'-');
tmp_s=strcat(tmp_s,tmp_s2.name);
handles.AnaData.selfirstchnname(handles.AnaData.selno).name=tmp_s;
tmp_str=getliststr(handles.AnaData.selno,handles.AnaData.selfirstchnname);
set(handles.sellist,'String',tmp_str,'Value',1);

%prepare to add next channel data
tmpi=get(handles.rawlistone,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlistone,'Value',tmpi);

%prepare to add next channel data
tmpi=get(handles.rawlisttwo,'Value');
tmpi=tmpi+1;
if tmpi>handles.RawData.chnno
    tmpi=handles.RawData.chnno;
end
set(handles.rawlisttwo,'Value',tmpi);
guidata(gcbo,handles);
rawlistone_Callback(h, eventdata, handles, varargin);

set(handles.delsel,'Enable','on');

guidata(gcbo,handles);

% --------------------------------------------------------------------
function varargout = delsel_Callback(h, eventdata, handles, varargin)

tmp_i=get(handles.sellist,'Value');
for i=tmp_i:handles.AnaData.selno-1
    handles.AnaData.selfirstchn(i)=handles.AnaData.selfirstchn(i+1);
    handles.AnaData.selsecondchn(i)=handles.AnaData.selsecondchn(i+1);
    
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
tmp_ione=get(handles.rawlistone,'Value');
tmp_itwo=get(handles.rawlisttwo,'Value');

for i=1:handles.AnaData.selno
    if tmp_ione==handles.AnaData.selfirstchn(i)&tmp_itwo==handles.AnaData.selsecondchn(i)
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
function varargout = winlength_Callback(h, eventdata, handles, varargin)
% winlength must < =total length of the analyzied data, and <=FFT length and > overlaplength

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_winlen=str2num(tmp_s);

if tmp_winlen>endp-stp+1
    tmp_winlen=endp-stp+1;
end

tmp_s=get(handles.fftlength,'String');
tmp_i=str2num(tmp_s);
if tmp_winlen>tmp_i
    tmp_winlen=tmp_i;
end

tmp_s=get(handles.overlaplength,'String');
tmp_i=str2num(tmp_s);
if tmp_winlen<tmp_i+1
    tmp_winlen=tmp_i+1;
end

tmp_s=num2str(tmp_winlen);
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

if tmp_fftlen>endp-stp+1
    tmp_fftlen=endp-stp+1;
end

tmp_s=get(handles.winlength,'String');
tmp_i=str2num(tmp_s);
if tmp_fftlen<tmp_i
    tmp_fftlen=tmp_i;
end

tmp_s=num2str(tmp_fftlen);

set(handles.fftlength,'String',tmp_s);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = overlaplength_Callback(h, eventdata, handles, varargin)
% overlaplength must < winlength

tmp_s=get(handles.overlaplength,'String');
tmp_overlaplen=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
tmp_i=str2num(tmp_s);

if tmp_overlaplen>tmp_i-1
    tmp_overlaplen=tmp_i-1;
end

if tmp_overlaplen<0
    tmp_overlaplen=0;
end

tmp_s=num2str(tmp_overlaplen);
set(handles.overlaplength,'String',tmp_s);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));

guidata(gcbo,handles);


% --------------------------------------------------------------------
function varargout = confinterval_Callback(h, eventdata, handles, varargin)

tmp_s=get(handles.confinterval,'String');
tmp_f=str2num(tmp_s);

if tmp_f<0.90
    tmp_f=0.90;
end

if abs(tmp_f-0.90)<abs(tmp_f-0.95)
    tmp_f=0.90;
else
    tmp_f=0.95;
end

if abs(tmp_f-0.95)<abs(tmp_f-0.99)
    tmp_f=0.95;
else
    tmp_f=0.99;
end

if tmp_f>0.99
    tmp_f=0.99;
end

tmp_s=num2str(tmp_f);

set(handles.confinterval,'String',tmp_s);

guidata(gcbo,handles);


% --------------------------------------------------------------------
function restoresetting(fig,handles)
% initial the setting relative the raw data
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

%Initial the window type selection list, here we use four types windows.
tmp_s='Hann window|Hamming window|Bartlett window|Rectangular window';
set(handles.wintypelist,'String',tmp_s,'Value',1);
    
%Initial the window length;
tmp_i=64;
if tmp_i>endp-stp+1
    tmp_i=endp-stp+1;
end
set(handles.winlength,'String',num2str(tmp_i));
 
%Initial the overlap length, is the half of window length
tmp_i=round(tmp_i/2);
set(handles.overlaplength,'String',num2str(tmp_i));

%Initial the FFT length;
tmp_i=64;    
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

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

%open the setting file
fid=fopen('fftcoset.inf','r');
if fid==-1
    setmark=0;
    return;
end

tmp_i=round(fscanf(fid,'%d', [1 1]));
if tmp_i>0& tmp_i<5
    tmp_set=tmp_i;
else
    tmp_set=1;
end
%Initial the window type selection list, here we use four types windows.
tmp_s='Hann window|Hamming window|Bartlett window|Rectangular window';
set(handles.wintypelist,'String',tmp_s,'Value',tmp_set);
    
%Initial the window length;
tmp_winlen=round(fscanf(fid,'%d', [1 1]));
if tmp_winlen<32
    tmp_winlen=32;
end
if tmp_winlen>endp-stp+1
    tmp_winlen=endp-stp+1;
end
set(handles.winlength,'String',num2str(tmp_winlen));
 
%Initial the overlap length, is the half of window length
tmp_i=round(fscanf(fid,'%d', [1 1]));
if tmp_i>tmp_winlen-1
    tmp_i=tmp_winlen-1;
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
fclose(fid);

setmark=1;

guidata(fig, handles);

tmp_secno=getsectionno(handles);
set(handles.sectionno,'String',num2str(tmp_secno));

guidata(fig, handles);


% --------------------------------------------------------------------
function varargout = savedefault_Callback(h, eventdata, handles, varargin)

fid=fopen('fftcoset.inf','wt');
if fid==-1
    return;
end

tmp_i=get(handles.wintypelist,'Value');
fprintf(fid,'%d\n',tmp_i);
    
%Initial the window length;
tmp_s=get(handles.winlength,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%d\n',tmp_i);
 
%Initial the overlap length, is the half of window length
tmp_s=get(handles.overlaplength,'String');
tmp_i=str2num(tmp_s);
fprintf(fid,'%d\n',tmp_i);

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

fclose(fid);


% --------------------------------------------------------------------
function varargout = restore_Callback(h, eventdata, handles, varargin)
restoresetting(gcbo,handles);

%^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
%||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
%Here is the setting relative functions.
% =====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====Setting End=====


% --------------------------------------------------------------------
function Nd=getNd(handles)
% get the disjoint-section number of the data
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_winlength=str2num(tmp_s);

Nd=floor((endp-stp+1)/tmp_winlength);

% --------------------------------------------------------------------
function section_no=getsectionno(handles)
% get the overlapped section number of the data
stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_s=get(handles.winlength,'String');
tmp_winlength=str2num(tmp_s);

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s);

section_no=floor((endp-stp+1-tmp_winlength)/(tmp_winlength-NOVERLAP+1))+1;


% --------------------------------------------------------------------
function [E, Pc]=GetPc(Nd,Pi,Coh)
%Nd: number of the disjoint segment
%Pi: independence probability, 0.95, 0.99
%Coh: the Coherence value
%obtain the probability Pc, see my paper
%Carter G Clifford. Coherence and time delay estimation. Proceedings of the IEEE, 75(2), 1987
%Carter G Clifford. Estimation of the magnitude-square function via overlapped FFT. IEEE Trans. Audio and Electroacoustics. vol AU-21, No 4, 1973.
%Carter GC. Receiver operating characteristics for a linearly thresholded coherence estimation detector. IEEE Transactions on Acoustics, Speech and Signal Processing ASSP-27, 90-94. 1977.
%Scannell EH and Carter GC. Confidence bounds for magnitude-squared coherence estimates. IEEE Transactions on Acoustics, Speech and Signal Processing ASSP-26[5], 475-477. 1978. 

Coh=Coh';
L=length(Coh);
E=1-(1-Pi)^(1/(Nd-1));% independence threshould

Fhy=ones(Nd-1,L);%hypergeometric function: 2F1
for i=0:Nd-2
    Tk=ones(1,L);
    for k=1:i
        Tk=(k-1-i)*(k-Nd)*E*Coh.*Tk/k/k;
        Fhy(i+1,:)=Fhy(i+1,:)+Tk(1,:);
    end
end

Pc=zeros(1,L);
for i=1:Nd-1
    Pc=Pc+((1-E)./(1-E*Coh)).^(i-1).*Fhy(i,:);
end

Pc=E*Pc.*(((1-Coh)./(1-E*Coh)).^Nd);
Pc=1-Pc;%%Carter GC. Coherence and time delay estimation. Proceedings of the IEEE 75[2], 244. 1987. 

% --------------------------------------------------------------------
function [conflower,confupper]=getconfinterval(handles,Nd,P,Chnn,DataLength)

i=round(P*100);
fname=sprintf('conf%d.dat',i);

fp=fopen(fname,'r');
if fp==-1
    'Cannot Open the Confidence Library!'
    return;
end

stsite=(Nd-5)*10000;

conflower=zeros(DataLength,1);
confupper=zeros(DataLength,1);
for i=1:DataLength
    tmp_f=handles.ResultData.cohxy(i,Chnn);
    tmp_i=floor(tmp_f*10000);
    if tmp_i>10000
        tmp_i=10000;
    end
    site=(stsite+tmp_i)*8*2;
    fseek(fp,site,'bof');
    tmp_f=fread(fp,[1,2],'double');
    conflower(i)=tmp_f(1);
    confupper(i)=tmp_f(2);
end


% --------------------------------------------------------------------
function varargout = startanalysis_Callback(h, eventdata, handles, varargin)

if handles.AnaData.selno<1
    msgbox('Please select one signal for analysis at least!','No signal is selected');
    return;
end

tmp_s=get(handles.fftlength,'String');
NFFT=str2num(tmp_s);

Fs=handles.RawData.fs;

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s);

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

tmp_i=get(handles.detrendtypelist,'Value');
switch tmp_i
case 1
    DFLAG='mean';
case 2
    DFLAG='linear';
case 3
    DFLAG='none';
end
    
%here we use four types windows.if add more windows, please initial it. 
%tmp_s='Hann window|Hamming window|Bartlett window|Rectangular window';
tmp_s=get(handles.winlength,'String');
tmp_winlength=str2num(tmp_s);

tmp_i=get(handles.wintypelist,'Value');
switch tmp_i
case 1
    w=window(@hann,tmp_winlength);
case 2
    w=window(@hamming,tmp_winlength);
case 3
    w=window(@bartlett,tmp_winlength);
case 4
    w=window(@rectwin,tmp_winlength);
end

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_i=floor(NFFT/2)+1;
handles.ResultData.fre=zeros(tmp_i,1);
handles.ResultData.cohxy=zeros(tmp_i,handles.AnaData.selno);
handles.ResultData.cohxylower=zeros(tmp_i,handles.AnaData.selno);
handles.ResultData.cohxyupper=zeros(tmp_i,handles.AnaData.selno);
handles.ResultData.phase=zeros(tmp_i,handles.AnaData.selno);
handles.ResultData.Pc=zeros(tmp_i,handles.AnaData.selno);
Nd=getNd(handles);

for i=1:handles.AnaData.selno
    X=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
    Y=handles.RawData.data(stp:endp,handles.AnaData.selsecondchn(i));

    [Cxy,  F] = cohere(X,Y,NFFT,Fs,w,NOVERLAP,DFLAG);
    [Pxy, Pxyc, F] = csd(X,Y,NFFT,Fs,w,NOVERLAP,P, DFLAG);
    
    handles.ResultData.cohxy(:,i)=Cxy(:);
    %here we compute the independence threshold and detection probability for coherence.
    [E, Pc]=GetPc(Nd,P,Cxy);
    handles.ResultData.indep_line=E;
    handles.ResultData.Pc(:,i)=Pc(:);
    
    [conflower,confupper]=getconfinterval(handles,Nd,P,i,tmp_i);
    handles.ResultData.cohxylower(:,i)=conflower(:);
    handles.ResultData.cohxyupper(:,i)=confupper(:);
      
    tmp_f=angle(Pxy);
    factor=2; %relative the 95% confidence interval.
    handles.ResultData.phase(:,i)=tmp_f(:);
    epsilon_p=sqrt((1-Cxy)./Cxy)/sqrt(2*Nd);
    handles.ResultData.phaselower(:,i)=tmp_f(:)-factor*epsilon_p;
    handles.ResultData.phaseupper(:,i)=tmp_f(:)+factor*epsilon_p;  
end

handles.ResultData.fre=F;

set(handles.saveresulttypeone,'Enable','on');
set(handles.saveresulttypetwo,'Enable','on');
set(handles.plottypeone,'Enable','on');
set(handles.plottypetwo,'Enable','on');
set(handles.plottypethree,'Enable','on');

guidata(gcbo,handles);


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
tmp_plotphase=get(handles.plotphase,'Value');
tmp_plotconf=get(handles.plotconfinterval,'Value');

colno=1;
rowno=handles.AnaData.selno;
no_perchn=1;

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

%%plot in one plot........................................................
if tmp_multiplot==get(handles.plotmulti,'Min')
    figure('Position',pos);
    
    if tmp_plotrawdata==get(handles.plotrawdata,'Max')
        rowno=rowno+2*handles.AnaData.selno;
        no_perchn=no_perchn+2;
    end
    if tmp_plotphase==get(handles.plotphase,'Max')
        rowno=rowno+handles.AnaData.selno;
        no_perchn=no_perchn+1;        
    end

    for i=1:handles.AnaData.selno
        %with raw data
        if tmp_plotrawdata==get(handles.plotrawdata,'Max')
            clear x;
            clear y;
            
            % draw raw data
            x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            subplot(rowno,1,(i-1)*no_perchn+1);
            x=x';
            y=y';
            plot(x,y,'k');
            tmp_s='the raw data of ';
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));

            
            y=handles.RawData.data(stp:endp,handles.AnaData.selsecondchn(i));
            subplot(rowno,1,(i-1)*no_perchn+2);
            x=x';
            y=y';
            plot(x,y,'k');
            tmp_s='the raw data of ';
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selsecondchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));
            
            clear x;
            clear y;

            % draw result coherence
            x=handles.ResultData.fre;
            subplot(rowno,1,(i-1)*no_perchn+3);
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                y=handles.ResultData.cohxy(:,i);
                x=x';
                y=y';
                plot(x,y,'k');
                
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            else% with confidence interval
                y(:,1)=handles.ResultData.cohxylower(:,i);
                y(:,2)=handles.ResultData.cohxy(:,i);
                y(:,3)=handles.ResultData.cohxyupper(:,i);                
                tmp_i=size(x);
                indep_stx=[0 x(tmp_i(1))];
                indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
                Pc=handles.ResultData.Pc(:,i);
                sig_sty=[P P];
                plot(x,y(:,1),'g--',x, y(:,2),'k-',x,y(:,3),'g--',x,Pc,'r:',indep_stx,indep_sty,indep_stx,sig_sty);
               
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            end
            
            % draw result phase
            if tmp_plotphase==get(handles.plotphase,'Max')% phase
                if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                    y=handles.ResultData.phase(:,i);
                else% with confidence interval
                    y(:,1)=handles.ResultData.phaselower(:,i);
                    y(:,2)=handles.ResultData.phase(:,i);
                    y(:,3)=handles.ResultData.phaseupper(:,i);                
                end
                subplot(rowno,1,(i-1)*no_perchn+4);
                plot(x,y,'k');
                tmp_s='the phase of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            end
        %without raw data
        else
            clear x;
            clear y;

            % draw result coherence
            subplot(rowno,1,(i-1)*no_perchn+1);
            x=handles.ResultData.fre;
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                y=handles.ResultData.cohxy(:,i);
                plot(x,y);
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            else% with confidence interval
                y(:,1)=handles.ResultData.cohxylower(:,i);
                y(:,2)=handles.ResultData.cohxy(:,i);
                y(:,3)=handles.ResultData.cohxyupper(:,i);                
                tmp_i=size(x);
                indep_stx=[0 x(tmp_i(1))];
                indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
                Pc=handles.ResultData.Pc(:,i);
                sig_sty=[P P];
                plot(x,y(:,1),'g--',x, y(:,2),'k-',x,y(:,3),'g--',x,Pc,'r:',indep_stx,indep_sty,indep_stx,sig_sty);

                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            end
            
            % draw result phase
            if tmp_plotphase==get(handles.plotphase,'Max')% phase
                if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                    y=handles.ResultData.phase(:,i);
                else% with confidence interval
                    y(:,1)=handles.ResultData.phaselower(:,i);
                    y(:,2)=handles.ResultData.phase(:,i);
                    y(:,3)=handles.ResultData.phaseupper(:,i);                
                end
                subplot(rowno,1,(i-1)*no_perchn+2);
                plot(x,y);
                tmp_s='the phase of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
            end
        end
    end
%plot multi plots.    
else
    for i=1:handles.AnaData.selno
        %with raw data
        if tmp_plotrawdata==get(handles.plotrawdata,'Max')
            clear x;
            clear y;
            
            % draw raw data
            x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            figure('Name',handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));

            
            y=handles.RawData.data(stp:endp,handles.AnaData.selsecondchn(i));
            figure('Name',handles.FileInfo.chnname(handles.AnaData.selsecondchn(i)).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
        
        clear x;
        clear y;
        
        % draw result coherence
        x=handles.ResultData.fre;
        figure('Name',handles.AnaData.selfirstchnname(i).name,'Position',pos);
        if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
            y=handles.ResultData.cohxy(:,i);
            plot(x,y);
        else% with confidence interval
            y(:,1)=handles.ResultData.cohxylower(:,i);
            y(:,2)=handles.ResultData.cohxy(:,i);
            y(:,3)=handles.ResultData.cohxyupper(:,i);                
            tmp_i=size(x);
            indep_stx=[0 x(tmp_i(1))];
            indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
                        
            sig_sty=[P P];
            plot(x,y(:,1),'g--',x, y(:,2),'k-',x,y(:,3),'g--',x,Pc,'r:',indep_stx,indep_sty,indep_stx,sig_sty);
        end
        set(gca,'FontSize',figsetting(1));
            
        % draw result phase
        if tmp_plotphase==get(handles.plotphase,'Max')% phase
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                y=handles.ResultData.phase(:,i);
            else% with confidence interval
                y(:,1)=handles.ResultData.phaselower(:,i);
                y(:,2)=handles.ResultData.phase(:,i);
                y(:,3)=handles.ResultData.phaseupper(:,i);                
            end
            figure('Name',handles.AnaData.selfirstchnname(i).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
    end
end

% --------------------------------------------------------------------
function varargout = plottypetwo_Callback(h, eventdata, handles, varargin)
%no the coherence variance 95% confidence interval

fid=fopen('msfigset.inf','r');
if fid==-1
    figsetting(1)=14;
    figsetting(2)=700;
    figsetting(3)=500;
    figsetting(4)=1;
end
figsetting=fscanf(fid,'%d\n');
fclose(fid);
pos=[0 0 figsetting(2) figsetting(3)];

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

tmp_multiplot=get(handles.plotmulti,'Value');
tmp_plotrawdata=get(handles.plotrawdata,'Value');
tmp_plotphase=get(handles.plotphase,'Value');
tmp_plotconf=get(handles.plotconfinterval,'Value');

colno=1;
rowno=handles.AnaData.selno;
no_perchn=1;

tmp_s=get(handles.confinterval,'String');
P=str2num(tmp_s);

%%plot in one plot........................................................
if tmp_multiplot==get(handles.plotmulti,'Min')
    figure('Position',pos);
    if tmp_plotrawdata==get(handles.plotrawdata,'Max')
        rowno=rowno+2*handles.AnaData.selno;
        no_perchn=no_perchn+2;
    end
    if tmp_plotphase==get(handles.plotphase,'Max')
        rowno=rowno+handles.AnaData.selno;
        no_perchn=no_perchn+1;        
    end

    for i=1:handles.AnaData.selno
        %with raw data
        if tmp_plotrawdata==get(handles.plotrawdata,'Max')
            clear x;
            clear y;
            
            % draw raw data
            x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            subplot(rowno,1,(i-1)*no_perchn+1);
            x=x';
            y=y';
            plot(x,y,'k');
            tmp_s='the raw data of ';
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));
            set(get(gca,'Children'),'LineWidth',figsetting(4)); 

            
            y=handles.RawData.data(stp:endp,handles.AnaData.selsecondchn(i));
            subplot(rowno,1,(i-1)*no_perchn+2);
            x=x';
            y=y';
            plot(x,y);
            tmp_s='the raw data of ';
            tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.AnaData.selsecondchn(i)).name);
            title(tmp_s);
            set(gca,'FontSize',figsetting(1));
            set(get(gca,'Children'),'LineWidth',figsetting(4)); 
            
            clear x;
            clear y;

            % draw result coherence
            x=handles.ResultData.fre;
            y=handles.ResultData.cohxy(:,i);
            x=x';
            y=y';
            subplot(rowno,1,(i-1)*no_perchn+3);
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                plot(x,y,'k');
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                %title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                set(get(gca,'Children'),'LineWidth',figsetting(4));
            else% with confidence interval
                tmp_i=size(x);
                indep_stx=[0 x(tmp_i(1))];
                indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
                Pc=handles.ResultData.Pc(:,i);
                Pc=Pc';
                sig_sty=[P P];
                plot(x,y,'k-',x,Pc,'k-',indep_stx,indep_sty,'k:',indep_stx,sig_sty,'k:');

                
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                %title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                h=get(gca,'Children');
                set(h(4),'LineWidth',3); 
            end
            
            % draw result phase
            if tmp_plotphase==get(handles.plotphase,'Max')% phase
                if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                    y=handles.ResultData.phase(:,i);
                else% with confidence interval
                    y=handles.ResultData.phase(:,i);
                end
                subplot(rowno,1,(i-1)*no_perchn+4);
                plot(x,y,'k');
                tmp_s='the phase of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                set(get(gca,'Children'),'LineWidth',figsetting(4)); 
            end
        %without raw data
        else
            clear x;
            clear y;

            % draw result coherence
            subplot(rowno,1,(i-1)*no_perchn+1);
            x=handles.ResultData.fre;
            y=handles.ResultData.cohxy(:,i);
            x=x';
            y=y';
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval                
                plot(x,y,'k');
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
%                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                set(get(gca,'Children'),'LineWidth',figsetting(4)); 
            else% with confidence interval
                tmp_i=size(x);
                indep_stx=[0 x(tmp_i(1))];
                indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
                Pc=handles.ResultData.Pc(:,i);
                Pc=Pc';
                sig_sty=[P P];
                plot(x,y,'k-',x,Pc,'k-',indep_stx,indep_sty,'k:',indep_stx,sig_sty,'k:');               
               
                tmp_s='the coherence of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
                %title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                h=get(gca,'Children');
                set(h(4),'LineWidth',3); 
            end
            
            % draw result phase
            if tmp_plotphase==get(handles.plotphase,'Max')% phase
                if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                    y=handles.ResultData.phase(:,i);
                else% with confidence interval
                    y=handles.ResultData.phase(:,i);
                end
                subplot(rowno,1,(i-1)*no_perchn+2);
                plot(x,y,'k');
                tmp_s='the phase of ';
                tmp_s=strcat(tmp_s,handles.AnaData.selfirstchnname(i).name);
%                title(tmp_s);
                set(gca,'FontSize',figsetting(1));
                set(get(gca,'Children'),'LineWidth',figsetting(4)); 
            end
        end
    end
%plot multi plots.    
else
    for i=1:handles.AnaData.selno
        %with raw data
        if tmp_plotrawdata==get(handles.plotrawdata,'Max')
            clear x;
            clear y;
            
            % draw raw data
            x=handles.RawData.xaxisv(stp:endp)-handles.RawData.xaxisv(stp);
            y=handles.RawData.data(stp:endp,handles.AnaData.selfirstchn(i));
            figure('Name',handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));

            
            y=handles.RawData.data(stp:endp,handles.AnaData.selsecondchn(i));
            figure('Name',handles.FileInfo.chnname(handles.AnaData.selsecondchn(i)).name,'Position',pos);
            plot(x,y);
            set(gca,'FontSize',figsetting(1));
        end
        
        clear x;
        clear y;
        
        % draw result coherence
        x=handles.ResultData.fre;
        figure('Name',handles.AnaData.selfirstchnname(i).name,'Position',pos);
        if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
            y=handles.ResultData.cohxy(:,i);
            plot(x,y,'k');
            set(gca,'FontSize',figsetting(1));
        else% with confidence interval
            y=handles.ResultData.cohxy(:,i);
            tmp_i=size(x);
            indep_stx=[0 x(tmp_i(1))];
            indep_sty=[handles.ResultData.indep_line handles.ResultData.indep_line];
            Pc=handles.ResultData.Pc(:,i);            
            sig_sty=[P P];
            
            plot(x,y,'k-',x,Pc,'k-',indep_stx,indep_sty,'k:',indep_stx,sig_sty,'k:');
                set(gca,'FontSize',figsetting(1));
                h=get(gca,'Children');
                set(h(4),'LineWidth',3); 
        end
        
            
        % draw result phase
        if tmp_plotphase==get(handles.plotphase,'Max')% phase
            if tmp_plotconf==get(handles.plotconfinterval,'Min')%no confidence interval
                y=handles.ResultData.phase(:,i);
            else% with confidence interval
                y=handles.ResultData.phase(:,i);
            end
            figure('Name',handles.AnaData.selfirstchnname(i).name,'Position',pos);
            plot(x,y,'k-');
            set(gca,'FontSize',figsetting(1));
        end
    end
end



% --------------------------------------------------------------------
function varargout = saveresulttypeone_Callback(h, eventdata, handles, varargin)
        
for i=1:handles.AnaData.selno
    y(:,1)=handles.ResultData.fre(:);
    y(:,2)=handles.ResultData.cohxy(:,i);
    y(:,3)=handles.ResultData.cohxylower(:,i);
    y(:,4)=handles.ResultData.cohxyupper(:,i);                
    y(:,5)=handles.ResultData.Pc(:,i);
    y(:,6)=handles.ResultData.indep_line*ones(length(handles.ResultData.fre(:)),1);
    y(:,7)=handles.ResultData.phase(:,i);
    y(:,8)=handles.ResultData.phaselower(:,i);
    y(:,9)=handles.ResultData.phaseupper(:,i);

    tmp_title='Save the Coherence analysis of data:';
    tmp_title=strcat(tmp_title,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);

    tmp_filename=handles.FileInfo.fname;
    tmp_filename=strcat(tmp_filename,'-');    
    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selfirstchn(i)).name);    
    tmp_filename=strcat(tmp_filename,'-');    
    tmp_filename=strcat(tmp_filename,handles.FileInfo.chnname(handles.AnaData.selsecondchn(i)).name);    
    tmp_filename=strcat(tmp_filename,'-Coh.txt');

    %get the file name and directory name of the data file by menu item : Fiel Open
    [fname,pname]=uiputfile(tmp_filename,tmp_title);

    if fname==0
        return;
    end
    
    %get the full name of the data file
    tmp_fullname=strcat(pname,fname);
    
    fid=fopen(tmp_fullname,'wt');
    y=y';
    fprintf(fid,'%f %f %f %f %f %f %f %f %f\n',y);
    fclose(fid);
   
end


% --------------------------------------------------------------------
function [RunTestPr]= MeanRunTest(Data, WinLength,SecNo)
%run test on a sequence of some statistics, such as a sequence of mean, std, Kolmogorov-Smirnov test
%get the parameters: r,a, b, L

for i=1:SecNo
    st=(i-1)*WinLength+1;
    ed=i*WinLength;
    sec_data=Data(st:ed);
    StaData(i)=mean(sec_data);
end

L=SecNo;
%medianV=median(StaData);
medianV=mean(StaData);

if StaData(1)<medianV 
    a=0;
    b=1;
    LastSignMark=0;%signmark=0 means last sign is a minus.
else
    a=1;
    b=0;
    LastSignMark=1;%signmark=1 means last sign is a plus.
end

r=1;
for i=2:L
    if StaData(i)<medianV
        b=b+1;
        CurSignMark=0;
    else
        a=a+1;
        CurSignMark=1;
    end
    
    if CurSignMark~=LastSignMark
        r=r+1;
    end
    LastSignMark=CurSignMark;
end

mur=2*a*b/L+1;
sigmar=sqrt(2*a*b*(2*a*b-a-b)/(L*L*(L-1)));

if L<50
    if abs(r-mur)<0.5
        Z=0;
    end
    if r-mur>=0.5
        Z=(r-mur-0.5)/sigmar;
    end
    if r-mur<=-0.5
        Z=(r-mur+0.5)/sigmar;
    end
else
    Z=(r-mur)/sigmar;    
end

RunTestPr=normcdf(Z,0,1);
if RunTestPr<0.5
    RunTestPr=RunTestPr*2;
else
    RunTestPr=(1.0-RunTestPr)*2;
end

%statistic test in Sugimoto's paper
%Pr=zeros(1,r);
%for i=2:2:r
%    k=round(i/2);
%    Pr(i)=2*nchoosek(a-1,k-1)*nchoosek(b-1,k-1)/nchoosek(L,a);
%end
%for i=3:2:r
%    k=round((i-1)/2);
%    Pr(i)=(nchoosek(a-1,k)*nchoosek(b-1,k-1)+nchoosek(a-1,k-1)*nchoosek(b-1,k))/nchoosek(L,a);
%end
%RunTestPr=0.0;
%for i=1:r
%    RunTestPr=RunTestPr+Pr(i);
%end


% --------------------------------------------------------------------
function [RunTestPr]= StdRunTest(Data, WinLength,SecNo)
%run test on a sequence of some statistics, such as a sequence of mean, std, Kolmogorov-Smirnov test
%get the parameters: r,a, b, L

for i=1:SecNo
    st=(i-1)*WinLength+1;
    ed=i*WinLength;
    sec_data=Data(st:ed);
    StaData(i)=std(sec_data);
end

L=SecNo;
%medianV=median(StaData);
medianV=mean(StaData);

if StaData(1)<medianV 
    a=0;
    b=1;
    LastSignMark=0;%signmark=0 means last sign is a minus.
else
    a=1;
    b=0;
    LastSignMark=1;%signmark=1 means last sign is a plus.
end

r=1;
for i=2:L
    if StaData(i)<medianV
        b=b+1;
        CurSignMark=0;
    else
        a=a+1;
        CurSignMark=1;
    end
    
    if CurSignMark~=LastSignMark
        r=r+1;
    end
    LastSignMark=CurSignMark;
end

mur=2*a*b/L+1;
sigmar=sqrt(2*a*b*(2*a*b-a-b)/(L*L*(L-1)));

if L<50
    if abs(r-mur)<0.5
        Z=0;
    end
    if r-mur>=0.5
        Z=(r-mur-0.5)/sigmar;
    end
    if r-mur<=-0.5
        Z=(r-mur+0.5)/sigmar;
    end
else
    Z=(r-mur)/sigmar;    
end

RunTestPr=normcdf(Z,0,1);
if RunTestPr<0.5
    RunTestPr=RunTestPr*2;
else
    RunTestPr=(1.0-RunTestPr)*2;
end
%statistic test in Sugimoto's paper
%Pr=zeros(1,r);
%for i=2:2:r
%    k=round(i/2);
%    Pr(i)=2*nchoosek(a-1,k-1)*nchoosek(b-1,k-1)/nchoosek(L,a);
%end
%for i=3:2:r
%    k=round((i-1)/2);
%    Pr(i)=(nchoosek(a-1,k)*nchoosek(b-1,k-1)+nchoosek(a-1,k-1)*nchoosek(b-1,k))/nchoosek(L,a);
%end
%RunTestPr=0.0;
%for i=1:r
%    RunTestPr=RunTestPr+Pr(i);
%end

% --------------------------------------------------------------------
function [SkewTestPr, KurtTestPr] = NormalityTest(Data, WinLength, SecNo)
%Data: tested data
%WinLength: the data points of each segment
%SecNo: the number of the data segments
%P: significant probability of test
%ChnName: a name for the data
%Fisher's normality test

%Pr > 0.95, means the distribution is normal.

%Run test for mean and variance
%Sugimoto H,et al. Stationarity and normality test for biomedical data. Computer Programs in Biomedicine 7[4], 293-304. 1977. 
SkewV=zeros(1,SecNo);%Fisher's normality test
KurtV=zeros(1,SecNo);%Fisher's normality test
SkewTestPr=ones(1,SecNo);
KurtTestPr=ones(1,SecNo);

N=WinLength;
StdSkew=sqrt(6*N*(N-1)/((N-2)*(N+1)*(N+3)));
StdKurt=sqrt(24*N*(N-1)*(N-1)/((N-3)*(N-2)*(N+3)*(N+5)));

sec_data=zeros(1,WinLength);

for i=1:SecNo
    st=(i-1)*WinLength+1;
    ed=i*WinLength;
    sec_data=Data(st:ed);

    SkewV(i)=skewness(sec_data,0);
    
    TestPr=normcdf(SkewV(i)/StdSkew,0,1);
    if TestPr<0.5
        TestPr=TestPr*2;
    else
        TestPr=(1.0-TestPr)*2;
    end
    SkewTestPr(i)=TestPr;
    
    KurtV(i)=kurtosis(sec_data,0);
    
    TestPr=normcdf(KurtV(i)/StdKurt,0,1);
    if TestPr<0.5
        TestPr=TestPr*2;
    else
        TestPr=(1.0-TestPr)*2;
    end
    KurtTestPr(i)=TestPr;
end

% --------------------------------------------------------------------
function [ACTestResP] = AutoCorrTest(Data, WinLength, SecNo)

P=0.95;
stdnorm=2/(WinLength-3);
ACTestResP=zeros(1,SecNo);


% --------------------------------------------------------------------
function varargout = stationarytest_Callback(h, eventdata, handles, varargin)

%Sugimoto H,et al. Stationarity and normality test for biomedical data. Computer Programs in Biomedicine 7[4], 293-304. 1977. 

tmp_s=get(handles.overlaplength,'String');
NOVERLAP=str2num(tmp_s);

tmp_s=get(handles.winlength,'String');
WinLength=str2num(tmp_s);

stp=round(handles.RawData.sttime*handles.RawData.fs);
endp=round(handles.RawData.endtime*handles.RawData.fs);

section_no=floor((endp-stp+1-WinLength)/(WinLength-NOVERLAP))+1;
%section_no: the number of the overlapped segments

DataLength=WinLength*section_no;
figsetting(1)=12;

%Convert the overlapped data to non-overlapped data.
for j=1:handles.AnaData.selno
    st=1-(WinLength-NOVERLAP);
    Data=handles.RawData.data(:,handles.AnaData.selfirstchn(j));
    ReData=zeros(DataLength,1);
    
    for i=1:section_no
        Rest=(i-1)*WinLength+1;
        Reed=i*WinLength;
        st=st+(WinLength-NOVERLAP);
        ed=st+WinLength-1;
        ReData(Rest:Reed)=Data(st:ed);
        MeanV(i)=mean(Data(st:ed));
        StdV(i)=std(Data(st:ed));
    end
    
    [MeanRunTestPr]= MeanRunTest(ReData, WinLength,section_no);
    [StdRunTestPr]= StdRunTest(ReData, WinLength,section_no);
    %Fisher's normality test
    [SkewTestPr, KurtTestPr] = NormalityTest(ReData, WinLength, section_no);
    
    figure;
    x=[1:section_no];
    
    subplot(4,1,1);
    plot(x, MeanV);
    title_s=sprintf('Mean Run Test of Channel %d, the Pr=%f',j,MeanRunTestPr);
    title(title_s);
    set(gca,'FontSize',figsetting(1));
    
    subplot(4,1,2);
    plot(x, StdV);
    title_s=sprintf('Standard Deviation Run Test of Channel %d, the Pr=%f',j,StdRunTestPr);
    title(title_s);
    set(gca,'FontSize',figsetting(1));
    
    subplot(4,1,3);
    plot(x, SkewTestPr, x, KurtTestPr);
    title_s=sprintf('Normality Test of Channel %d',j);
    title(title_s);
    set(gca,'FontSize',figsetting(1));
    
    %[ACTestResP] = AutoCorrTest(ReData, WinLength, section_no);
    %subplot(4,1,4);
    %plot(x, ACTestResP);
    %title_s=sprintf('Autocorrelation stationary Test of Channel %d',j);
    %title(title_s);
    %set(gca,'FontSize',figsetting(1));
end






