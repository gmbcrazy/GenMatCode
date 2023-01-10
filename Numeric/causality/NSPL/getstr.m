function strforchnsel=getstr(handles)
%This function is used to get the string for the control selchn's 'String' Property.
tmp_s='';
for i=1:handles.RawData.chnno-1
    tmp_s=strcat(tmp_s,handles.FileInfo.chnname(i).name);
    if handles.FileInfo.drawstatus(i)==1
        tmp_s=strcat(tmp_s,'-On');
    else
        tmp_s=strcat(tmp_s,'-Off');
    end    
    tmp_s=strcat(tmp_s,'|');
end
tmp_s=strcat(tmp_s,handles.FileInfo.chnname(handles.RawData.chnno).name);
if handles.FileInfo.drawstatus(handles.RawData.chnno)==1
    tmp_s=strcat(tmp_s,'-On');
else
    tmp_s=strcat(tmp_s,'-Off');
end    

strforchnsel=tmp_s;