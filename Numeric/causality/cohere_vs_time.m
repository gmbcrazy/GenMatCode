function [Cxy,f,time]=cohere_vs_time(filename,data_name,Refname,timerange,window_length,step) 
%%%crosscorrelation function
[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end


bin_width=0.001;

    dataEntityID=[];
    RefEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   

        q=strcmp(nsEntityLabel{EntityID},data_name);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           dataEntityID=EntityID;
        end  
        
     
        q=strcmp(nsEntityLabel{EntityID},Refname);    %Refname should be a string like 'AD25'%
        if q==1;   
           RefEntityID=EntityID;
        end  
     
     
    end
    
        if isempty(dataEntityID)|isempty(RefEntityID)
            Cxy=[];
            f=[];
            time=[];
            return
        end

    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,dataEntityID);
    [ns_RESULT,nsRefEntityInfo]=ns_GetEntityInfo(hFile,RefEntityID);

    StartIndex=1;
    
    if nsdataEntityInfo.EntityType==4    %%%%%%%%%%data is timestamps type
       [ns_RESULT,data]=ns_GetNeuralData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);
   elseif nsdataEntityInfo.EntityType==2 %%%%%%%%%%data is continuous type
       [ns_RESULT,c,data]=ns_GetAnalogData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);

   else
       'datatype shoud be timestamps or continuous'
   end 
    
timerange(1)=ceil(timerange(1)/0.001)/1000;
timerange(2)=floor(timerange(2)/0.001)/1000;
data_temp=[];



    num_bin=floor((timerange(2)-timerange(1))/bin_width);
    if nsdataEntityInfo.EntityType==4
      
      data_temp1=data(find(data<=timerange(2)&data>=timerange(1)));
      data_temp1=[data_temp1;(timerange(1)+0.5*bin_width);(timerange(2)-0.5*bin_width)];
      [data_temp2,temp_n]=hist(data_temp1,num_bin);
      data_temp2(1)=data_temp2(1)-1;
      data_temp2(length(data_temp2))=data_temp2(length(data_temp2))-1;
      data_temp=[data_temp,data_temp2];
      clear data_temp1 data_temp2 temp_n;
  elseif nsdataEntityInfo.EntityType==2

           temp1=floor(timerange(1)*1000)+1;
           temp2=min(temp1+num_bin-1,length(data));
           data_temp=data(temp1:temp2);
       
       else
           
           
       end
data=data_temp;
clear data_temp;
    




Ref_temp=[];

    StartIndex=1;
    
    if nsRefEntityInfo.EntityType==4    %%%%%%%%%%Ref is timestamps type
       [ns_RESULT,Ref]=ns_GetNeuralData(hFile,RefEntityID,StartIndex,nsRefEntityInfo.ItemCount);
   elseif nsRefEntityInfo.EntityType==2 %%%%%%%%%%Ref is continuous type
       [ns_RESULT,c,Ref]=ns_GetAnalogData(hFile,RefEntityID,StartIndex,nsRefEntityInfo.ItemCount);

   else
       'Reftype shoud be timestamps or continuous'
   end 

    num_bin=floor((timerange(2)-timerange(1))/bin_width);
    if nsRefEntityInfo.EntityType==4
      
      data_temp1=Ref(find(Ref<=timerange(2)&Ref>=timerange(1)));
      Ref_temp1=[Ref_temp1;(timerange(1)+0.5*bin_width);(timerange(2)-0.5*bin_width)];
      [Ref_temp2,temp_n]=hist(Ref_temp1,num_bin);
      Ref_temp2(1)=Ref_temp2(1)-1;
      Ref_temp2(length(Ref_temp2))=Ref_temp2(length(Ref_temp2))-1;
      Ref_temp=[Ref_temp,Ref_temp2];
  elseif nsRefEntityInfo.EntityType==2

           temp1=floor(timerange(1)*1000)+1;
           temp2=min(temp1+num_bin-1,length(Ref));
           Ref_temp=Ref(temp1:temp2);
       
       else
           
           
       end
Ref=Ref_temp;

temp_length=min(length(Ref),length(data));
Ref=Ref(1:temp_length);
data=data(1:temp_length);
data=zscore(data);




% [Cxy,f] = cohere(data,Ref,2048,1/bin_width,'linear');
% 
% figure;plot(f,Cxy);
ns_RESULT = ns_CloseFile(hFile);

move_num=floor((length(data)/1000-window_length)/step);
window_length=floor(window_length*1000);
step=floor(step*1000);
tic
for i=1:move_num
    temp1=(i-1)*step+1;
    temp2=temp1+window_length-1;
    data1=data(temp1:temp2);
    data2=Ref(temp1:temp2);
    [Cxy(:,i),f]=cohere(data1,data2,64,1000,64);
    
end
window_length=window_length/1000;
step=step/1000;
time=window_length/2+timerange(1):step:step*(move_num-1)+window_length/2+timerange(1);
toc
    