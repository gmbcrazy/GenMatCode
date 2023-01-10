function liststr=getliststr(chnno,chnname)
%This function is used to get the string for the control selchn's 'String' Property.
tmp_s='';
for i=1:chnno-1
    tmp_s=strcat(tmp_s,chnname(i).name);
    tmp_s=strcat(tmp_s,'|');
end
if chnno>0
    tmp_s=strcat(tmp_s,chnname(chnno).name);
end
liststr=tmp_s;