function cicular_sigFile=cicular_common_ripple(path_name,sig,AD_name,timerange)

%AD_name should be 'AD42ripple_ad_000'
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
    startEntityID=[];
    overEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

        q=strcmp(nsEntityLabel{EntityID},sig);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
        q=strcmp(nsEntityLabel{EntityID},AD_name);  
        if q==1;   
           ADEntityID=EntityID;
        end  
     
        
        if ~isempty(strfind(AD_name,'hf'));
            temp_name=[AD_name(1:10),'nor_over_hf'];
        else
            temp_name=[AD_name(1:10),'nor_over'];
        end
        q=strcmp(nsEntityLabel{EntityID},temp_name);  
        if q==1;   
           overEntityID=EntityID;
        end  
        
        if ~isempty(strfind(AD_name,'hf'));
            temp_name=[AD_name(1:10),'nor_start_hf'];
        else
            temp_name=[AD_name(1:10),'nor_start'];
        end
        q=strcmp(nsEntityLabel{EntityID},temp_name);  
        if q==1;   
           startEntityID=EntityID;
        end  

    end

 
    if isempty(ADEntityID)|isempty(sigEntityID)|isempty(startEntityID)
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
    [ns_RESULT,nsstartEntityInfo]=ns_GetEntityInfo(hFile,startEntityID);
    [ns_RESULT,nsoverEntityInfo]=ns_GetEntityInfo(hFile,overEntityID);

    StartIndex=1;

    [ns_RESULT,sigTimestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
    [ns_RESULT,startTimestamps]=ns_GetNeuralData(hFile,startEntityID,StartIndex,nsstartEntityInfo.ItemCount);
    [ns_RESULT,overTimestamps]=ns_GetNeuralData(hFile,overEntityID,StartIndex,nsoverEntityInfo.ItemCount);
    [ns_RESULT,ADTimestamps]=ns_GetNeuralData(hFile,ADEntityID,StartIndex,nsADEntityInfo.ItemCount);

     cicular_sigFile.Wave_name=nsEntityLabel{ADEntityID};
     cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
     cicular_sigFile.filename=path_name;
     ns_RESULT = ns_CloseFile(hFile);

     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;sigTimestamps(find(timerange(1,i)<sigTimestamps&sigTimestamps<timerange(2,i)))];
     end
    sigTimestamps=temp_sig;
    clear temp_sig
   
     cicular_sigFile.Spike_origin=sigTimestamps;

       temp_cic=[];
       temp_sig=[];
    for i=1:length(startTimestamps)
          sig_i=sigTimestamps(find(startTimestamps(i)<sigTimestamps&sigTimestamps<overTimestamps(i)));
          cic_i=sig_i;
          temp_sig=[temp_sig;sig_i];
          half1_index=find(sig_i<=ADTimestamps(i));
          if ~isempty(half1_index)
          cic_i(half1_index)=(sig_i(half1_index)-startTimestamps(i)).*180./(ADTimestamps(i)-startTimestamps(i));
      end
          half2_index=find(sig_i>ADTimestamps(i));
          if ~isempty(half2_index)
          cic_i(half2_index)=180+(sig_i(half2_index)-ADTimestamps(i)).*180./(overTimestamps(i)-ADTimestamps(i));
      end
          temp_cic=[temp_cic;cic_i];
    end
    sigTimestamps=temp_sig;
    clear temp_sig
 
        

    

   if ~isempty(sigTimestamps)
      cicular_sigFile.Timestamps=sigTimestamps;
      cicular_sigFile.Data=temp_cic;
  else
      cicular_sigFile.Data=[];
   
  end


   
