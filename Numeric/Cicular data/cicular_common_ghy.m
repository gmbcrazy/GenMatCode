function cicular_sigFile=cicular_common_ghy(path_name,TS_sig,AD_name,timerange)


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




    ADEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

        q=strcmp(nsEntityLabel{EntityID},AD_name);      %wave_normalize should be a string like 'AD15delta_ad_000'%
        if q==1;   
           ADEntityID=EntityID;
        end  
        
     
    end

 
    if isempty(ADEntityID)
       'there is no corresponding sig or wave or wavenormalize in the file'
       path_name
       ns_RESULT = ns_CloseFile(hFile);
     cicular_sigFile.Wave_name=AD_name;
     cicular_sigFile.filename=path_name;
     
     cicular_sigFile.Timestamps=[];
     cicular_sigFile.Data=[];
     cicular_sigFile.Spike_origin=[];
     cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;
%      cicular_sigFile.RefTimestamps=[];

       return;
    end
    StartIndex=1;

    [ns_RESULT,nsADEntityInfo]=ns_GetEntityInfo(hFile,ADEntityID);
    sigTimestamps=TS_sig;
     
    
    
     cicular_sigFile.Wave_name=nsEntityLabel{ADEntityID};
     cicular_sigFile.filename=path_name;

     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;sigTimestamps(find(timerange(1,i)<sigTimestamps&sigTimestamps<timerange(2,i)))];
     end
    sigTimestamps=temp_sig;
    
    clear temp_sig

    cicular_sigFile.Spike_origin=sigTimestamps;

    [ns_RESULT,c,ADData]=ns_GetAnalogData(hFile,ADEntityID,StartIndex,nsADEntityInfo.ItemCount);
    ns_RESULT = ns_CloseFile(hFile);
    
    cicular_sigFile.TimeSpan=length(ADData)/1000;
    analytic_sf=hilbert(smooth(ADData,3));
    phase_sf=angle(analytic_sf);

    
    phase_index(1,:)=floor(1000*sigTimestamps)'+1;
    phase_index(2,:)=phase_index(1,:)+1;
    invalid_index=union(find(phase_index(1,:)<1),find(phase_index(2,:)>length(phase_sf)));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    
    
    invalid_index=find(abs((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:))))<0.000001);
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];

    spike_phase=zeros(1,length(sigTimestamps))-10;
    
    special_index=sort(find((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:)))>0));
    Temp_all_index=1:length(sigTimestamps);
    ordinary_index=setdiff(Temp_all_index,special_index);


    phase_sf=phase_sf+pi;
    if ~isempty(ordinary_index)
    Temp_a=phase_sf(phase_index(2,ordinary_index))-phase_sf(phase_index(1,ordinary_index));
    Temp_b=1000*sigTimestamps(ordinary_index)'-phase_index(1,ordinary_index)+1;
    Temp_c=phase_sf(phase_index(1,ordinary_index));
    
    spike_phase(ordinary_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    end
    
    if ~isempty(special_index)
    Temp_a=phase_sf(phase_index(2,special_index))+2*pi-phase_sf(phase_index(1,special_index));
    Temp_b=1000*sigTimestamps(special_index)'-phase_index(1,special_index)+1;
    Temp_c=phase_sf(phase_index(1,special_index));
   
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


   
