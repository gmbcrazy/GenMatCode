function cicular_sigFile=cicular_hilbert(path_name,sig,AD_name,timerange)
[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(path_name);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end




    sigEntityID=[];
    ADEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

        q=strcmp(nsEntityLabel{EntityID},sig);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
        q=strcmp(nsEntityLabel{EntityID},AD_name);      %wave_normalize should be a string like 'AD15theta_normalized_ad_000'%
        if q==1;   
           ADEntityID=EntityID;
        end  
     
     
    end

 
    if isempty(ADEntityID)|isempty(sigEntityID)
       'there is no corresponding sig or wave or wavenormalize in the file'
       path_name
       ns_RESULT = ns_CloseFile(hFile);
     cicular_sigFile.Wave_name=AD_name;
     cicular_sigFile.Sig_name=sig;
     cicular_sigFile.filename=path_name;
     
     cicular_sigFile.Timestamps=[];
     cicular_sigFile.Data=[];
     cicular_sigFile.Spike_origin=[];
     cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

       return;
    end
   
    [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
    [ns_RESULT,nsADEntityInfo]=ns_GetEntityInfo(hFile,ADEntityID);

    StartIndex=1;

    [ns_RESULT,sigTimestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
    
     cicular_sigFile.Wave_name=nsEntityLabel{ADEntityID};
     cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
     cicular_sigFile.filename=path_name;

    
    
    sigTimestamps=sigTimestamps(find(timerange(1)<sigTimestamps&sigTimestamps<timerange(2)));
    cicular_sigFile.Spike_origin=sigTimestamps;

    [ns_RESULT,c,ADData]=ns_GetAnalogData(hFile,ADEntityID,StartIndex,nsADEntityInfo.ItemCount);
    cicular_sigFile.TimeSpan=length(ADData)/1000;
    ADData=ADData;
    
    phase_index(1,:)=floor(1000*sigTimestamps)'+1;
    phase_index(2,:)=phase_index(1,:)+1;
    invalid_index=union(find(phase_index(1,:)<1),find(phase_index(2,:)>length(ADData)));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    

    invalid_index=intersect(find(ADData(phase_index(1,:))==0),find(ADData(phase_index(2,:))==0));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    
    spike_phase=zeros(1,length(sigTimestamps))-10;
    
    special_index=sort(intersect(find(ADData(phase_index(1,:))>2),find(ADData(phase_index(2,:))<-2)));
    Temp_all_index=1:length(sigTimestamps);
    ordinary_index=setdiff(Temp_all_index,special_index);


    ADData=ADData+pi;
    if ~isempty(ordinary_index)
    Temp_a=ADData(phase_index(2,ordinary_index))-ADData(phase_index(1,ordinary_index));
    Temp_b=1000*sigTimestamps(ordinary_index)'-phase_index(1,ordinary_index)+1;
    Temp_c=ADData(phase_index(1,ordinary_index));
    
    spike_phase(ordinary_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    end
    
    if ~isempty(special_index)
    Temp_a=ADData(phase_index(2,special_index))+2*pi-ADData(phase_index(1,special_index));
    Temp_b=1000*sigTimestamps(special_index)'-phase_index(1,special_index)+1;
    Temp_c=ADData(phase_index(1,special_index));
   
    spike_phase(special_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    
    
    
    
       for i=1:length(special_index)
           if spike_phase(special_index(i))>2*pi
              spike_phase(special_index(i))=spike_phase(special_index(i))-2*pi;
           end
       end
   end

   spike_phase=spike_phase-pi;
   cicular_sigFile.Timestamps=sigTimestamps;
   
   if ~isempty(sigTimestamps)
      cicular_sigFile.Data=360*(spike_phase+pi)/2/pi;
  else
      cicular_sigFile.Data=[];
      
  end
   ns_RESULT = ns_CloseFile(hFile);

   
   
   
