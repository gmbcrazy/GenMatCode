function causality=causality_file(path_filename,Data_name,source_index,result_index,m,timerange)


[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(path_filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end



DataEntityID=zeros(1,length(Data_name));

for i=1:length(Data_name)

    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
     
        q=strcmp(nsEntityLabel{EntityID},Data_name(i).Name);      
        if q==1;   
           DataEntityID(i)=EntityID;
        end  
     
     
    end
    
end


spikewf=exp(-(0:0.001:0.15)/0.002);
all_data=[];
for i=1:length(Data_name)
    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,DataEntityID(i));

    StartIndex=1;
    temp_timerange(1)=ceil(timerange(1)/0.001);
    temp_timerange(2)=floor(timerange(2)/0.001);

    if nsdataEntityInfo.EntityType==4    %%%%%%%%%%data is timestamps type
       [ns_RESULT,temp_data]=ns_GetNeuralData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
       temp_data=temp_data(find(temp_data>temp_timerange(1)/1000&temp_data<temp_timerange(2)/1000));
       temp_data=round(temp_data*1000);
       temp_train=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
       for j=1:length(temp_data)
           temp_spike=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
           temp_spike((temp_data(j)-temp_timerange(1)+1):(temp_data(j)+length(spikewf)-temp_timerange(1)))=spikewf;
           temp_train=temp_train+temp_spike;
       end
       temp_train=temp_train(1:(temp_timerange(2)-temp_timerange(1)+1))'+1;
       
   elseif nsdataEntityInfo.EntityType==2 %%%%%%%%%%data is continuous type
       [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
       temp_train=temp_data(temp_timerange(1):temp_timerange(2));
   else
       'datatype shoud be timestamps or continuous'
       return
   end 
   
   all_data=[all_data,temp_train];
   clear temp_train temp_data temp_spike

    
end
ns_RESULT = ns_CloseFile(hFile);
all_data=all_data';

causality=causality_compute(all_data,source_index,result_index,m);