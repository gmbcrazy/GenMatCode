function varargout = basdescp(varargin)
%the basic description of the selected raw data section
% BASDESCP Application M-file for basdescp.fig
%    FIG = BASDESCP launch basdescp GUI.
%    BASDESCP('callback_name', ...) invoke the named callback.

% Last Modified by GUIDE v2.0 22-Jul-2002 13:33:22

if nargin == 0 |nargin == 2 % LAUNCH GUI

	fig = openfig(mfilename,'reuse');

	% Generate a structure of handles to pass to callbacks, and store it. 
	handles = guihandles(fig);
    
    %initial the data.
    tmp_struct=varargin{2};
    handles.FileInfo=tmp_struct.FileInfo;
    handles.RawData=tmp_struct.RawData;
    
    stp=round(handles.RawData.sttime*handles.RawData.fs);
    endp=round(handles.RawData.endtime*handles.RawData.fs);
    
    tmp_data=handles.RawData.data(stp:endp,handles.RawData.selchannel);

    handles.Result.time=handles.RawData.endtime-handles.RawData.sttime;
    handles.Result.minv=min(tmp_data);
    handles.Result.maxv=max(tmp_data);
    handles.Result.meanv=mean(tmp_data);
    handles.Result.stdv=std(tmp_data);
    
    set(handles.meanv,'String',num2str(handles.Result.meanv));
    set(handles.stdv,'String',num2str(handles.Result.stdv));
    set(handles.minv,'String',num2str(handles.Result.minv));
    set(handles.maxv,'String',num2str(handles.Result.maxv));
    
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
function varargout = meanv_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = stdv_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = minv_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = maxv_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = recmean_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = recsd_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = aveampdm_Callback(h, eventdata, handles, varargin)




% --------------------------------------------------------------------
function varargout = sddm_Callback(h, eventdata, handles, varargin)

