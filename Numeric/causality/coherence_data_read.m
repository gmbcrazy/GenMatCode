function [data,data_shuffle,Ref]=coherence_data_read(filename,data_name,Refname,timerange,bin_width) 
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
            C=[];
            lag=[];
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
    
timerange(1,:)=ceil(timerange(1,:)/0.001)/1000;
timerange(2,:)=floor(timerange(2,:)/0.001)/1000;
data_temp=[];

%timerange(1,:) is the start time of the normlize data of wave,timerange(2,:) is the end time of the normlize data of wave%
% data(find(data>timerange(2,length(timerange(2,:)))&data<timerange(1,1)))=[];
% if length(timerange(1,:))>1
%    for i=1:(length(timerange(1,:))-1)
%        data(find(data>timerange(2,i)&data<timerange(1,i+1)))=[];
%    end
% end
    for shuffle_num=1:10
        data_shuffle(shuffle_num).data=[];
    end


for i=1:length(timerange(1,:))
    num_bin(i)=floor((timerange(2,i)-timerange(1,i))/bin_width);
    if nsdataEntityInfo.EntityType==4
      
      data_temp1=data(find(data<=timerange(2,i)&data>=timerange(1,i)));
      isi_original1=diff(data_temp1);
      
      for shuffle_num=1:10
          shuffle_times=unidrnd(length(isi_original1),1,floor(1.5*length(isi_original1)));

          isi_temp1=isi_original1;
          for j=1:length(shuffle_times)
              if j>length(isi_original1)
                 j_temp=j-length(isi_original1);
             else
                j_temp=j;
             end
              m=isi_temp1(j_temp);
              isi_temp1(j_temp)=isi_temp1(shuffle_times(j));
              isi_temp1(shuffle_times(j))=m;
          end
          spike_shuffle_temp=data_temp1(1)+cumsum([0;isi_temp1]);
          spike_shuffle_temp=[spike_shuffle_temp;(timerange(1,i)+0.5*bin_width);(timerange(2,i)-0.5*bin_width)];
          [data_shuffle1(shuffle_num).data,temp_n]=hist(spike_shuffle_temp,num_bin(i));
          data_shuffle1(shuffle_num).data(1)=data_shuffle1(shuffle_num).data(1)-1;
          data_shuffle1(shuffle_num).data(length(data_shuffle1(shuffle_num).data))=data_shuffle1(shuffle_num).data(length(data_shuffle1(shuffle_num).data))-1;
          data_shuffle(shuffle_num).data=[data_shuffle(shuffle_num).data,data_shuffle1(shuffle_num).data];
          clear shuffle_times;
    end
      

      
      data_temp1=[data_temp1;(timerange(1,i)+0.5*bin_width);(timerange(2,i)-0.5*bin_width)];
      [data_temp2,temp_n]=hist(data_temp1,num_bin(i));
      data_temp2(1)=data_temp2(1)-1;
      data_temp2(length(data_temp2))=data_temp2(length(data_temp2))-1;
      data_temp=[data_temp,data_temp2];
      
      
      
      
  elseif nsdataEntityInfo.EntityType==2
        for j=1:num_bin(i)
           temp1=floor(timerange(1,i)*1000)+floor((j-1)*bin_width*1000)+1;
           temp2=temp1+bin_width*1000-1;
           data_temp=[data_temp,mean(data(temp1:temp2))];
       end
       
       else
           
           
       end

    
end


data=data_temp;
clear data_temp1 data_temp2





Ref_temp=[];

    StartIndex=1;
    
    if nsRefEntityInfo.EntityType==4    %%%%%%%%%%Ref is timestamps type
       [ns_RESULT,Ref]=ns_GetNeuralData(hFile,RefEntityID,StartIndex,nsRefEntityInfo.ItemCount);
   elseif nsRefEntityInfo.EntityType==2 %%%%%%%%%%Ref is continuous type
       [ns_RESULT,c,Ref]=ns_GetAnalogData(hFile,RefEntityID,StartIndex,nsRefEntityInfo.ItemCount);

   else
       'Reftype shoud be timestamps or continuous'
   end 





for i=1:length(timerange(1,:))
    num_bin(i)=floor((timerange(2,i)-timerange(1,i))/bin_width);
    if nsRefEntityInfo.EntityType==4
      
      Ref_temp1=Ref(find(Ref<=timerange(2,i)&Ref>=timerange(1,i)));
      
      Ref_temp1=[Ref_temp1;(timerange(1,i)+0.5*bin_width);(timerange(2,i)-0.5*bin_width)];
      [Ref_temp2,temp_n]=hist(Ref_temp1,num_bin(i));
      Ref_temp2(1)=Ref_temp2(1)-1;
      Ref_temp2(length(Ref_temp2))=Ref_temp2(length(Ref_temp2))-1;
      Ref_temp=[Ref_temp,Ref_temp2];
      
      
      
      
  elseif nsRefEntityInfo.EntityType==2
        for j=1:num_bin(i)
            if bin_width==1
                Ref_temp=Ref((timerange(1,i)*1000+1):(timerange(2,i)*1000+1));

            else
           temp1=floor(timerange(1,i)*1000)+floor((j-1)*bin_width*1000)+1;
           temp2=temp1+bin_width*1000-1;
           Ref_temp=[Ref_temp,mean(Ref(temp1:temp2))];
           end
       
       end
       
       else
           
           
       end

    
end


Ref=Ref_temp;
% [Cxy,f] = cohere(data,Ref,2048,1/bin_width,'linear');
% 
% figure;plot(f,Cxy);
ns_RESULT = ns_CloseFile(hFile);