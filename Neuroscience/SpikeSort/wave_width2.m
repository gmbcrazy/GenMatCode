function [wave_width,wave_std]=wave_width2(filename,timerange,wave,num_electrod,index_electrod,valid_stardard,wave_num)
%neuroLibrary should be a string like 'NeuroExplorerNeuroShareLibrary.dll'%
%filename should be a string like 'lab03-04-072005006.nex'%
%the wave must very beautiful or else the result would not be accurate%
%num_electrod should be 4 or 2,which is the number of electrod%
%index_electrod could be 1,2,3,4 if num_electrod is 4,which is the channel need to use to get data to compute%
%first we compute the mean of width of wave then cut the data whose width is more than valid_stard*mean,then recompute mean%
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

waveEntityID=[];



 
 
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
   nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

end

for EntityID=1:nsFileInfo.EntityCount
     q=strcmp(nsEntityLabel{EntityID},wave);           
     if q==1;   
        waveEntityID=EntityID;
     end  
end
     
     
     
if isempty(waveEntityID)
    'there is no corresponding  wave or in the file'
    filename
   
   return;
end


[ns_RESULT,nsSegmentInfo]=ns_GetSegmentInfo(hFile,waveEntityID);
duration=1*1000/nsSegmentInfo.SampleRate;
[ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,waveEntityID);
[ns_RESULT,Timestamp,Data,SampleCount,UnitID]=ns_GetSegmentData(hFile,waveEntityID,1:nsEntityInfo.ItemCount);

width_index=[];
indexneed=find(timerange(1)<=Timestamp&Timestamp<=timerange(2));
num_per_electrod=nsSegmentInfo.MinSampleCount/num_electrod;
indexneed=indexneed(1:(min(length(indexneed),wave_num)));

for i=1:num_electrod
Dataneed{i}=Data(((i-1)*num_per_electrod+1):(i*num_per_electrod),indexneed);
end



for i=1:length(indexneed)
%         figure(1);
        width_index(i)=wave_width1(Dataneed{index_electrod}(:,i));
%         plot(Dataneed{index_electrod}(:,i));hold on
end


%  title([wave,'   time range',num2str(timerange(1)),' to ',num2str(timerange(2)),' in second'])
 wave_width=mean(duration*width_index);
 wave_std=std(duration*width_index);
 valid=find(abs(duration*width_index-wave_width)<valid_stardard*wave_std);
 invalid=find(abs(duration*width_index-wave_width)>=valid_stardard*wave_std);
 wave_width=mean(duration*width_index(valid));
 wave_std=std(duration*width_index(valid));

% 
%  for i=1:length(invalid)
%       figure(2);
%      plot(Dataneed{index_electrod}(:,invalid));hold on
%  end
%  figure(2);title('wave of invalid');
ns_RESULT = ns_CloseFile(hFile);