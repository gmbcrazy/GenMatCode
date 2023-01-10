function varargout = cic_interface(varargin)
% CIC_INTERFACE Application M-file for cic_interface.fig
%    FIG = CIC_INTERFACE launch cic_interface GUI.
%    CIC_INTERFACE('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 04-Jun-2006 21:02:55

if nargin == 0  % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Use system color scheme for figure:
	set(fig,'Color',get(0,'defaultUicontrolBackgroundColor'));

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
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



% --------------------------------------------------------------------
function varargout = File_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = open_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
[fname,pname]=uigetfile('*.nex','select the plx-file');
FNAMEO=fname;
PNAMEO=pname;





% --------------------------------------------------------------------
function varargout = save_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
[newfile,newpath]=uiputfile('1.temp','Save file');







% --------------------------------------------------------------------
function varargout = Library_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
t=get(handles.Library,'value');
nsLibrary=get(handles.Library,'String');
nsLibrary=nsLibrary{t};


[ns_RESULT]=ns_SetLibrary(nsLibrary);

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile([PNAMEO,FNAMEO]);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end




% --------------------------------------------------------------------
function varargout = waveType_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
sigEntityID=[];
for EntityID=1:nsFileInfo.EntityCount;
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
    nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

end













% --------------------------------------------------------------------
function varargout = sig_Callback(h, eventdata, handles, varargin)

global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
sigEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
    nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
end



for i=1:nsFileInfo.EntityCount
      q=findstr(nsEntityLabel{i},'scsig');
     if ~isempty(q);   
           sigEntityID=[sigEntityID,i];
     end 
end



for i=1:length(sigEntityID)
t{i}=nsEntityLabel{sigEntityID(i)};
end


set(handles.sig,'String',t);








% --------------------------------------------------------------------
function varargout = wave_Callback(h, eventdata, handles, varargin)

global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
waveEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
    nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
end



pp=get(handles.waveType,'value');
p=get(handles.waveType,'String');




if strcmp(p{pp},'theta')
   for i=1:nsFileInfo.EntityCount
       q=findstr(nsEntityLabel{i},'theta_maxts');
       if ~isempty(q);   
           waveEntityID=[waveEntityID,i];
        end 
    end
elseif strcmp(p{pp},'ripple')
    for i=1:nsFileInfo.EntityCount
       q=findstr(nsEntityLabel{i},'ripplenor_maxts');
       if ~isempty(q);   
           waveEntityID=[waveEntityID,i];
        end 
    end
elseif strcmp(p{pp},'gamma')
    for i=1:nsFileInfo.EntityCount
       q=findstr(nsEntityLabel{i},'gamma_maxts');
       if ~isempty(q);   
           waveEntityID=[waveEntityID,i];
        end 
    end
else
    'something wrong'
end

    
    

for i=1:length(waveEntityID)
t{i}=nsEntityLabel{waveEntityID(i)};
end


set(handles.wave,'String',t);



% --------------------------------------------------------------------
function varargout = wave_normalize_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
normalizeEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
    nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
end

pp=get(handles.waveType,'value');
p=get(handles.waveType,'String');




if strcmp(p{pp},'theta')
   for i=1:nsFileInfo.EntityCount
       q=findstr(nsEntityLabel{i},'theta_normalized');
       if ~isempty(q);   
           normalizeEntityID=[normalizeEntityID,i];
        end 
    end
elseif strcmp(p{pp},'ripple')
    for i=1:nsFileInfo.EntityCount
       q=findstr(nsEntityLabel{i},'ripple_normalized_ad_000');
       if ~isempty(q);   
           normalizeEntityID=[normalizeEntityID,i];
        end 
    end
elseif strcmp(p{pp},'gamma')
    'the program of gamma normalize is not compeleted'
else
    'something wrong'
end

for i=1:length(normalizeEntityID)
t{i}=nsEntityLabel{normalizeEntityID(i)};
end


set(handles.wave_normalize,'String',t);








% --------------------------------------------------------------------
function varargout = run_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath
sig_n=get(handles.sig,'value');
sig=get(handles.sig,'String');
sig=sig{sig_n};

wave_n=get(handles.wave,'value');
wave=get(handles.wave,'String');
wave=wave{wave_n};

wave_normalize_n=get(handles.wave_normalize,'value');
wave_normalize=get(handles.wave_normalize,'String');
wave_normalize=wave_normalize{wave_normalize_n};

range=[1,floor(nsFileInfo.TimeSpan-1)];

Data=cicular_human(nsLibrary,[PNAMEO FNAMEO],range,sig,wave,wave_normalize,range);





% --------------------------------------------------------------------
function varargout = interval_length_Callback(h, eventdata, handles, varargin)


function varargout = save1_Callback(h, eventdata, handles, varargin)
global FNAMEO PNAMEO nsLibrary nsEntityInfo hFile nsFileInfo Data newfile newpath

pp=get(handles.waveType,'value');
p=get(handles.waveType,'String');




if strcmp(p{pp},'theta')

   a=get(handles.interval_length,'String');
   a=str2num(a);

   sig_n=get(handles.sig,'value');
   sig=get(handles.sig,'String');
   sig=sig{sig_n};

   newpath(length(newpath))=[];
   length(Data.Data);
   length(Data.Timestamps);
   cicular_write(Data.Data,Data.Timestamps,a,newpath,sig);
end
   currentpath=cd;

   cd(newpath);

sig_n=get(handles.sig,'value');
sig=get(handles.sig,'String');
sig=sig{sig_n};
save(sig,'Data');

cd(currentpath);

