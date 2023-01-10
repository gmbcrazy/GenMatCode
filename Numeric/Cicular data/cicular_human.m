function cicular_sigFile=cicular_human(filename,timerange,sig,wave,wave_normalize,normalize_range)
%neuroLibrary should be a string like 'NeuroExplorerNeuroShareLibrary.dll'%
%filename should be a string like 'lab03-04-072005006.nex'%
%timerange=[timestart,timeend]%
%wave_normalize should be a string like 'AD15theta_normalized_ad_000'%
%wave should be a string like 'AD15theta_maxts'%
%sig should be a string like 'scsig041ats'%

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



if  (~isempty(wave_normalize))&(~isempty(normalize_range))%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%we don't have to rule out the data excluded in the normalize wave

    sigEntityID=[];
    waveEntityID=[];
    waveNormlizedEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   
        q=strcmp(nsEntityLabel{EntityID},wave);             %wave should be a string like 'AD15theta_maxts'%   
        if q==1;   
           waveEntityID=EntityID;
        end  

        q=strcmp(nsEntityLabel{EntityID},sig);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
        q=strcmp(nsEntityLabel{EntityID},wave_normalize);      %wave_normalize should be a string like 'AD15theta_normalized_ad_000'%
        if q==1;   
           waveNormlizedEntityID=EntityID;
        end  
     
     
    end

 
    if isempty(sigEntityID)|isempty(waveEntityID)|isempty(waveNormlizedEntityID)
       'there is no corresponding sig or wave or wavenormalize in the file'
       filename
       if isempty(sigEntityID)
       cicular_sigFile.Spike_origin=[];
       else
           [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
           StartIndex=1;
          [ns_RESULT,sig.Timestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
          cicular_sigFile.Spike_origin=sig.Timestamps;    
      end

       cicular_sigFile.Data=[];
       cicular_sigFile.Timestamps=[];
       cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;
       if ~isempty(strfind(wave_normalize,'ripple_normalize'))
          cicular_sigFile.rippleindex=[];
       end
       cicular_sigFile.Wave_name=wave;
       cicular_sigFile.Sig_name=sig;
       cicular_sigFile.Wavenormalize_name=wave_normalize;
       cicular_sigFile.filename=filename;
       if ~isempty(strfind(wave_normalize,'ripple_normalize'))
          cicular_sigFile.ripple_start_index=[];
          cicular_sigFile.ripple_end_index=[];
          cicular_sigFile.ripple_count=[];
       end
       ns_RESULT = ns_CloseFile(hFile);
       return;
    end
   
 
 
    [ns_RESULT,nswaveEntityInfo]=ns_GetEntityInfo(hFile,waveEntityID);
    [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
    [ns_RESULT,nswaveNormalizeEntityInfo]=ns_GetEntityInfo(hFile,waveNormlizedEntityID);

    StartIndex=1;


    [ns_RESULT,wave1.Timestamps]=ns_GetNeuralData(hFile,waveEntityID,StartIndex,nswaveEntityInfo.ItemCount);
    wave1.ItemCount=nswaveEntityInfo.ItemCount;
    wave1.Interval=diff(wave1.Timestamps);



    [ns_RESULT,sig.Timestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
    sig.ItemCount=nssigEntityInfo.ItemCount;
    sig.Interval=diff(sig.Timestamps);




    [ns_RESULT,c,waveNormalizeData.Vol]=ns_GetAnalogData(hFile,waveNormlizedEntityID,StartIndex,nswaveNormalizeEntityInfo.ItemCount);
    waveNormalizeData.ItemCount=nswaveNormalizeEntityInfo.ItemCount;



    if ~isempty(strfind(wave,'theta_maxts')) 
                wave_n=wave1.Timestamps;
                sig_n=sig.Timestamps;
                cicular_sigFile.Spike_origin=sig_n;
                [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                [cicular_sigFile.Data,cicular_sigFile.Timestamps]=cicular_num(wave_new,sig_new,waveNormalizeData.Vol,normalize_range);
                cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
                cicular_sigFile.Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID};
                cicular_sigFile.filename=filename;
                cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;
   
   
    elseif ~isempty(strfind(wave,'ripplenor_maxts'))
                    wave_n=wave1.Timestamps;
                    sig_n=sig.Timestamps;
                    cicular_sigFile.Spike_origin=sig_n;
                    [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                    [cicular_sigFile.Data,cicular_sigFile.Timestamps,cicular_sigFile.rippleindex]=cicular_num_ripple1(wave_new,sig_new,waveNormalizeData.Vol,normalize_range);
                    cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                    cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
                    cicular_sigFile.Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID};
                    cicular_sigFile.filename=filename;
                    cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

                    if ~isempty(cicular_sigFile.rippleindex)
                        m=max(cicular_sigFile.rippleindex);
                    else 
                        m=0;
                    end
                    cicular_sigFile.ripple_start_index=[];
                    cicular_sigFile.ripple_end_index=[];
                    cicular_sigFile.ripple_count=[];
 
                    for j=1:m
                        q=find(cicular_sigFile.rippleindex==j);    
                        if ~isempty(q);
                            cicular_sigFile.ripple_start_index=[cicular_sigFile.ripple_start_index;min(q)];
                            cicular_sigFile.ripple_end_index=[cicular_sigFile.ripple_end_index;max(q)];
                            cicular_sigFile.ripple_count=[cicular_sigFile.ripple_count;length(q)];
    
                        end
                    end
                    
                    
                    
    elseif ~isempty(strfind(wave,'gamma_maxts'))
                wave_n=wave1.Timestamps;
                sig_n=sig.Timestamps;
                cicular_sigFile.Spike_origin=sig_n;
                [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                [cicular_sigFile.Data,cicular_sigFile.Timestamps]=cicular_num_gamma(wave_new,sig_new,waveNormalizeData.Vol,normalize_range);
                cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
                cicular_sigFile.Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID};
                cicular_sigFile.filename=filename;
                cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

                
    else
        cicular_sigFile=[];
    end
    
    
elseif isempty(wave_normalize)&isempty(normalize_range)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%we don't have to rule out the data excluded in the normalize wave
 
    sigEntityID=[];
    waveEntityID=[];
    waveNormlizedEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   
        q=strcmp(nsEntityLabel{EntityID},wave);             %wave should be a string like 'AD15theta_maxts'%   
        if q==1;   
           waveEntityID=EntityID;
        end  

        q=strcmp(nsEntityLabel{EntityID},sig);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
    end

 
    if isempty(sigEntityID)|isempty(waveEntityID)
       'there is no corresponding sig or wave in the file'
       filename
       if isempty(sigEntityID)
       cicular_sigFile.Spike_origin=[];
       else
           [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
           StartIndex=1;
          [ns_RESULT,sig.Timestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
          cicular_sigFile.Spike_origin=sig.Timestamps;    
      end
       cicular_sigFile.Data=[];
       cicular_sigFile.Timestamps=[];
       if ~isempty(strfind(wave_normalize,'ripple_normalize'))
          cicular_sigFile.rippleindex=[];
       end
       cicular_sigFile.Wave_name=wave;
       cicular_sigFile.Sig_name=sig;
       cicular_sigFile.Wavenormalize_name=wave_normalize;
       cicular_sigFile.filename=filename;
       cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

       if ~isempty(strfind(wave_normalize,'ripple_normalize'))
          cicular_sigFile.ripple_start_index=[];
          cicular_sigFile.ripple_end_index=[];
          cicular_sigFile.ripple_count=[];
       end
   
       return;
    end
   
 
 
    [ns_RESULT,nswaveEntityInfo]=ns_GetEntityInfo(hFile,waveEntityID);
    [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);

    StartIndex=1;


    [ns_RESULT,wave1.Timestamps]=ns_GetNeuralData(hFile,waveEntityID,StartIndex,nswaveEntityInfo.ItemCount);
    wave1.ItemCount=nswaveEntityInfo.ItemCount;
    wave1.Interval=diff(wave1.Timestamps);



    [ns_RESULT,sig.Timestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
    sig.ItemCount=nssigEntityInfo.ItemCount;
    sig.Interval=diff(sig.Timestamps);


    if ~isempty(strfind(wave,'theta_maxts'))
                wave_n=wave1.Timestamps;
                sig_n=sig.Timestamps;
                cicular_sigFile.Spike_origin=sig_n;
                [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                [cicular_sigFile.Data,cicular_sigFile.Timestamps]=cicular_num(wave_new,sig_new,[],normalize_range);
                cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
                cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

                cicular_sigFile.Wavenormalize_name=[];
                cicular_sigFile.filename=filename;
    elseif ~isempty(strfind(wave,'ripplenor_maxts'))
           'While caculating cic data of according to ripple,normaliszation must be done!!!'     
           
           
           topEntityID=[];
           startEntityID=[];
           overEntityID=[];
           for EntityID=1:nsFileInfo.EntityCount
               [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
               nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   
               q=strcmp(nsEntityLabel{EntityID},wave);             %wave should be a string like 'AD15theta_maxts'%   
              if q==1;   
                 waveEntityID=EntityID;
              end  
     
               q=strcmp(nsEntityLabel{EntityID},[wave(1:13),'_start']);             %wave should be a string like 'AD15theta_maxts'%   
              if q==1;   
                 startEntityID=EntityID;
              end  

               q=strcmp(nsEntityLabel{EntityID},[wave(1:13),'_over']);             %wave should be a string like 'AD15theta_maxts'%   
              if q==1;   
                 overEntityID=EntityID;
              end  

     
           end

           [ns_RESULT,nswaveEntityInfo]=ns_GetEntityInfo(hFile,waveEntityID);
    
           StartIndex=1;
           [ns_RESULT,wave1.Timestamps]=ns_GetNeuralData(hFile,waveEntityID,StartIndex,nswaveEntityInfo.ItemCount);
           wave1.ItemCount=nswaveEntityInfo.ItemCount;
           wave1.Interval=diff(wave1.Timestamps);
    
           [ns_RESULT,start.Timestamps]=ns_GetNeuralData(hFile,startEntityID,StartIndex,nswaveEntityInfo.ItemCount);
           start.ItemCount=nswaveEntityInfo.ItemCount;
           start.Interval=diff(start.Timestamps);

           [ns_RESULT,over.Timestamps]=ns_GetNeuralData(hFile,overEntityID,StartIndex,nswaveEntityInfo.ItemCount);
           over.ItemCount=nswaveEntityInfo.ItemCount;
           over.Interval=diff(over.Timestamps);


                    start_n=start.Timestamps;
                    
                    over_n=over.Timestamps;
           
                    wave_n=wave1.Timestamps;
                    
                    sig_n=sig.Timestamps;
                    
                    cicular_sigFile.Spike_origin=sig_n;
                    cicular_sigFile.Ripple_origin=[start_n,wave_n,over_n];

                    
                    ripple_invalid=find(start_n<timerange(1));
                    ripple_invalid=union(ripple_invalid,find(over_n>timerange(2)));
                    
                    wave_n(ripple_invalid)=[];
                    start_n(ripple_invalid)=[];
                    over_n(ripple_invalid)=[];
                    
                    sig_n(find(sig_n<timerange(1)|sig_n>timerange(2)))=[];
                    

                    [cicular_sigFile.Data,cicular_sigFile.Timestamps,cicular_sigFile.rippleindex]=cicular_num_ripple2(sig_n,wave_n,start_n,over_n) ;
                    cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                    cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
%cicular_sigFile.Wavenormalize_name=nsEntityLabel{waveNormlizedEntityID};
                    cicular_sigFile.filename=filename;
                    if ~isempty(cicular_sigFile.rippleindex)
                        m=max(cicular_sigFile.rippleindex);
                    else 
                        m=0;
                    end
                    cicular_sigFile.ripple_start_index=[];
                    cicular_sigFile.ripple_end_index=[];
                    cicular_sigFile.ripple_count=[];
                    cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;

 
                    for j=1:m
                        q=find(cicular_sigFile.rippleindex==j);    
                        if ~isempty(q);
                            cicular_sigFile.ripple_start_index=[cicular_sigFile.ripple_start_index;min(q)];
                            cicular_sigFile.ripple_end_index=[cicular_sigFile.ripple_end_index;max(q)];
                            cicular_sigFile.ripple_count=[cicular_sigFile.ripple_count;length(q)];
    
                        end
                    end
                    
                    

           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
    elseif  ~isempty(strfind(wave,'gamma_maxts'))     
                wave_n=wave1.Timestamps;
                sig_n=sig.Timestamps;
                cicular_sigFile.Spike_origin=sig_n;
                [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
                [cicular_sigFile.Data,cicular_sigFile.Timestamps]=cicular_num_gamma(wave_new,sig_new,[],normalize_range);
                cicular_sigFile.Wave_name=nsEntityLabel{waveEntityID};
                cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
                cicular_sigFile.Wavenormalize_name=[];
                cicular_sigFile.filename=filename;
                cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;
        
    else
        cicular_sigFile=[];
    end  

end       
ns_RESULT = ns_CloseFile(hFile);



