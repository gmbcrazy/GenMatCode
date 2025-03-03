function [Power,time]=spectrograms_spike(path_filename,data_name,timerange,bin_width,step,fre_band)
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

    [ns_RESULT,sig]=ns_GetNeuralData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);
    ns_RESULT = ns_CloseFile(hFile);
     wave_highf=fre_band(2);
     wave_lowf=fre_band(1);
     cut_lowf=1/step;     
    
     step=floor(step/bin_width);
     
Power=[];
time=[];

    for i=1:length(timerange(1,:))
       sig_temp=sig(find(sig>=timerange(1,i)&sig<=timerange(2,i)));
       sig_temp=[sig_temp;timerange(:,i)];
       [sf,temp]=hist(sig_temp,floor(diff(timerange(:,i)/bin_width)));
       sf(1)=sf(1)-1;sf(length(sf))=sf(length(sf))-1;
       sf=smooth(sf,5);
    
      
       
       shift_num=floor(length(sf)/step)-1;

       temp_time=(0:step*bin_width:(shift_num-1)*step*bin_width)+timerange(1,i);
      

     for jj=1:shift_num
          sta_jj=(jj-1)*step+1;
          fin_jj=sta_jj+step;
          Y_wave=sf(sta_jj:fin_jj);

          temp_Fs=1/bin_width;
          temp_NFFT=step;
         [Power_wave,fre_oscillation]=psd(Y_wave,temp_NFFT,temp_Fs);
         Power_wave(find(fre_oscillation<=cut_lowf))=[];
         fre_oscillation(find(fre_oscillation<=cut_lowf))=[];
%          [Power_wave,fre_oscillation]=psd(Y_wave,temp_NFFT,temp_Fs,HAMMING(temp_NFFT));
% plot(fre_oscillation,Power_wave);

         wave_pow_index=find(wave_lowf<=fre_oscillation&wave_highf>=fre_oscillation);
%          Power_temp(jj)=sum(Power_wave(wave_pow_index))/sum(Power_wave);
                  Power_temp(jj)=sum(Power_wave(wave_pow_index));

      end
      Power=[Power,Power_temp];
      time=[time,temp_time];
      clear Power_temp sf temp_time
  end
