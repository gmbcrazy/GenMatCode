function cicular_sigFile=cicular_final_wave(neuroLibrary,filename,timerange,waveType,sig_needed_index,wave_needed_index,wave_normalize_index,wave_normalize,normalize_range)
%neuroLibrary should be a string like 'NeuroExplorerNeuroShareLibrary.dll'%
%filename should be a string like 'lab03-04-072005006.nex'%
%timerange=[timestart,timeend]%
%sig_needed_index is a vector.For example,if sig_needed_index=[2,4,5],it means we want to deal with the 2th,4th,5th sig%
%wave_needed_index is a vector.For example,if wave_needed_index=[2,4,5],it means we want to deal with the 2th,4th,5th wave%
%waveType should be a string like 'theta_maxts'%
%wave_normalize should be a string like 'theta_normalize'%
[ns_RESULT]=ns_SetLibrary(neuroLibrary);

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end

sigEntityID=[];
waveEntityID=[];
waveNormlizedEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
   nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   q=findstr(nsEntityLabel{EntityID},waveType);             %waveType should be a string like 'theta_maxts'%      
     if ~isempty(q);   
         waveEntityID=[waveEntityID,EntityID];
     end  

   q=findstr(nsEntityLabel{EntityID},'sig');
     if ~isempty(q);   
        sigEntityID=[sigEntityID,EntityID];
     end  
     
   q=findstr(nsEntityLabel{EntityID},wave_normalize);      %theta_normalize should be a string like 'theta_normalize'%
     if ~isempty(q);   
        waveNormlizedEntityID=[waveNormlizedEntityID,EntityID];
     end  
     
     
 end
 

 
[ns_RESULT,nswaveEntityInfo]=ns_GetEntityInfo(hFile,waveEntityID);
[ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
[ns_RESULT,nswaveNormalizeEntityInfo]=ns_GetEntityInfo(hFile,waveNormlizedEntityID);

StartIndex=1;
sizewaveData=length(waveEntityID);
sizeSigData=length(sigEntityID);
sizewaveNormalizeData=length(waveNormlizedEntityID);
for i=1:sizewaveData
[ns_RESULT,wave(i).Timestamps]=ns_GetNeuralData(hFile,waveEntityID(i),StartIndex,nswaveEntityInfo(i).ItemCount);
wave(i).ItemCount=nswaveEntityInfo(i).ItemCount;
wave(i).Interval=diff(wave(i).Timestamps);
end

for i=1:sizeSigData
[ns_RESULT,sig(i).Timestamps]=ns_GetNeuralData(hFile,sigEntityID(i),StartIndex,nssigEntityInfo(i).ItemCount);
sig(i).ItemCount=nssigEntityInfo(i).ItemCount;
sig(i).Interval=diff(sig(i).Timestamps);
end


for i=1:sizewaveNormalizeData
[ns_RESULT,c,waveNormalizeData(i).Vol]=ns_GetAnalogData(hFile,waveNormlizedEntityID(i),StartIndex,nswaveNormalizeEntityInfo(i).ItemCount);
waveNormalizeData(i).ItemCount=nswaveNormalizeEntityInfo(i).ItemCount;
end


if strcmp(wave_normalize,'theta_normalize')


   for i=1:length(wave_needed_index)
       for j=1:length(sig_needed_index)
            for z=1:length(wave_normalize_index)
                t=((i-1)*length(sig_needed_index)+j-1)*length(wave_normalize_index)+z;
                wave_n=wave(wave_needed_index(i)).Timestamps;
                sig_n=sig(sig_needed_index(j)).Timestamps;
                [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                [cicular_sigFile(t).Data,cicular_sigFile(t).Timestamps]=cicular_num(wave_new,sig_new,waveNormalizeData(wave_normalize_index(z)).Vol,normalize_range);
                cicular_sigFile(t).Wave_name=nsEntityLabel{waveEntityID(wave_needed_index(i))};
                cicular_sigFile(t).Sig_name=nsEntityLabel{sigEntityID(sig_needed_index(j))};
                cicular_sigFile(t).Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID(wave_normalize_index(z))};
            
            end
       end
   end
  
   
   
elseif strcmp(wave_normalize,'ripple_normalize')
        for i=1:length(wave_needed_index)
            for j=1:length(sig_needed_index)
                for z=1:length(wave_normalize_index)
                    t=((i-1)*length(sig_needed_index)+j-1)*length(wave_normalize_index)+z;
                    wave_n=wave(wave_needed_index(i)).Timestamps;
                    sig_n=sig(sig_needed_index(j)).Timestamps;
                    [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                    [cicular_sigFile(t).Data,cicular_sigFile(t).Timestamps,cicular_sigFile(t).rippleindex]=cicular_num_ripple(wave_new,sig_new,waveNormalizeData(wave_normalize_index(z)).Vol,normalize_range);
                    cicular_sigFile(t).Wave_name=nsEntityLabel{waveEntityID(wave_needed_index(i))};
                    cicular_sigFile(t).Sig_name=nsEntityLabel{sigEntityID(sig_needed_index(j))};
                    cicular_sigFile(t).Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID(wave_normalize_index(z))};
            
                end
            end
        end  
else
    cicular_sigFile=[];
end

 ns_RESULT = ns_CloseFile(hFile);