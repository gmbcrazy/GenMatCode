function [Power,time]=spectrograms(path_filename,data_name,timerange,bin_width,step,fre_band)
%path_filename should be a string like 'E:\experiment\lab03-04-072005006.nex'%
%timerange=[timestart;timeend]%eg.[122 533;221 466];


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

    dataEntityID=[];

    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   

        q=strcmp(nsEntityLabel{EntityID},data_name);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           dataEntityID=EntityID;
           break
        end  
     
     
    end

    if isempty(dataEntityID)
       'there is no corresponding data in the file'
       filename
       ns_RESULT = ns_CloseFile(hFile);
       Power=-1;
       return;
    end
  
    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,dataEntityID);
    StartIndex=1;

       [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);
       ns_RESULT = ns_CloseFile(hFile);
     step=floor(step*1000);
     bin_width=floor(bin_width*1000);
     wave_highf=fre_band(2);
     wave_lowf=fre_band(1);
    
Power=[];
time=[];
    for i=1:length(timerange(1,:))
        
    
       sf=temp_data(max(ceil(timerange(1,i)*1000),1):min(floor(timerange(2,i)*1000),length(temp_data)));
    
      
       
       shift_num=floor((length(sf)-bin_width)/step);

       temp_time=(0:step:(shift_num-1)*step)/1000+timerange(1,i);



      for jj=1:shift_num
          sta_jj=(jj-1)*step+1;
          fin_jj=sta_jj+bin_width;
          Y_wave=sf(sta_jj:fin_jj);

          temp_Fs=1000;
          temp_NFFT=step;
         [Power_wave,fre_oscillation]=psd(Y_wave,temp_NFFT,temp_Fs,HAMMING(temp_NFFT));
         wave_pow_index=find(wave_lowf<=fre_oscillation&wave_highf>=fre_oscillation);
         Power_temp(jj)=sum(Power_wave(wave_pow_index));
      end
      Power=[Power,Power_temp];
      time=[time,temp_time];
      clear Power_temp sf temp_time
  end
