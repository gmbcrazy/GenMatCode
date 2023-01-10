function cicular_AD_needFile=cicular_ADvsTheta(path_name,AD_need,AD_name,timerange)


%AD_need refers to the contiune data like 'AD27gamma_ad_000'
%AD_name refers to the reference phase_data,like 'AD27theta_phase_ad_000'

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

        q=strcmp(nsEntityLabel{EntityID},AD_need);              %AD_need should be a string like 'scsig041ats'%
        if q==1;   
           AD_needEntityID=EntityID;
        end  
     
        q=strcmp(nsEntityLabel{EntityID},AD_name);      %wave_normalize should be a string like 'AD15delta_ad_000'%
        if q==1;   
           ADEntityID=EntityID;
        end  
     
     
    end

 
    if isempty(ADEntityID)|isempty(AD_needEntityID)
       'there is no corresponding AD_need or wave or wavenormalize in the file'
       path_name
       ns_RESULT = ns_CloseFile(hFile);
     cicular_AD_needFile.Wave_name=AD_name;
     cicular_AD_needFile.AD_need_name=AD_need;
     cicular_AD_needFile.filename=path_name;
     
     cicular_AD_needFile.Timestamps=[];
     cicular_AD_needFile.Data=[];
     cicular_AD_needFile.Spike_origin=[];
     cicular_AD_needFile.TimeSpan=nsFileInfo.TimeSpan;

       return;
    end
   
    [ns_RESULT,nsAD_needEntityInfo]=ns_GetEntityInfo(hFile,AD_needEntityID);
    [ns_RESULT,nsADEntityInfo]=ns_GetEntityInfo(hFile,ADEntityID);

    StartIndex=1;    
    cicular_AD_needFile.Wave_name=nsEntityLabel{ADEntityID};
    cicular_AD_needFile.AD_need_name=nsEntityLabel{AD_needEntityID};
    cicular_AD_needFile.filename=path_name;

    [ns_RESULT,c,ADData]=ns_GetAnalogData(hFile,ADEntityID,StartIndex,nsADEntityInfo.ItemCount);
    [ns_RESULT,c,AD_needData]=ns_GetAnalogData(hFile,AD_needEntityID,StartIndex,nsAD_needEntityInfo.ItemCount);

   cicular_AD_needFile.Timestamps=0:0.001:(length(AD_needData)-1)/1000;

    ns_RESULT = ns_CloseFile(hFile);
    
    cicular_AD_needFile.TimeSpan=length(ADData)/1000;
    analytic_sf=hilbert(smooth(ADData,3));
    phase_sf=angle(analytic_sf);
    phase_sf=smooth(phase_sf);
    cicular_AD_needFile.Data=abs(AD_needData);

    
   if ~isempty(AD_needData)
      cicular_AD_needFile.Theta_phase=360*(phase_sf+pi)/2/pi;
  else
      cicular_AD_needFile.Theta_phase=[];
   
  end


   
