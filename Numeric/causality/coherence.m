function Cxy=coherence(data,Ref,step,com_num,bin_width)
data=zscore(data);
step_over=floor(length(data)/step)-1;

Cxy=[];
for i=1:step_over
    temp_s=(i-1)*step+1;
    temp_o=temp_s+step-1;
    [Cxy_temp,f] = cohere(data(temp_s:temp_o),Ref(temp_s:temp_o),com_num,1/bin_width);
% ns_RESULT = ns_CloseFile(hFile);
    Cxy=[Cxy;Cxy_temp'];

end

imagesc(Cxy);