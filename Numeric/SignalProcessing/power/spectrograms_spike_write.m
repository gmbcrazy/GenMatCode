function [Power,time]=spectrograms_spike_write(path_filename,data_name,timerange,bin_width,step,fre_band)
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
    step_or=step;
     step=floor(step/bin_width);
     
Power=[];
time=[];

    for i=1:length(timerange(1,:))
       sig_temp=sig(find(sig>=timerange(1,i)&sig<=timerange(2,i)));
       sig_temp=[sig_temp;timerange(:,i)];
       [sf,temp]=hist(sig_temp,floor(diff(timerange(:,i)/bin_width)));
       sf(1)=sf(1)-1;sf(length(sf))=sf(length(sf))-1;
       sf=smooth(sf,5);
    
      
       
       shift_num=floor(length(sf)-step);

       temp_time=(0:bin_width:(shift_num-1)*bin_width)+timerange(1,i);
      

     for jj=1:shift_num
          sta_jj=jj;
%           sta_jj=(jj-1)*step+1;

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
  
  Power=smooth(Power,7);
  
  
  
  ExtractedX=Power';
max_sf=max(abs(Power));
ADbitvolts=0.001*max_sf/32767;

Nlx_header1{1,1}='######## Neuralynx Data File Header';
Nlx_header1{2,1}='## File Name:  ';
Nlx_header1{3,1}='## Time Opened: (m/d/y):  ';
Nlx_header1{4,1}='-CheetahRev 3.0.6 ';
Nlx_header1{5,1}='-NLX_Base_Class_Name	 ';
Nlx_header1{6,1}='-NLX_Base_Class_Type	CscAcqEnt ';
Nlx_header1{7,1}='-RecordSize  2088 ';
Nlx_header1{8,1}=' -ADChannel	 ',;
Nlx_header1{9,1}=' -ADGain		1 ';
Nlx_header1{10,1}=' -AmpGain	5000 ';
Nlx_header1{11,1}=' -AmpLowCut	1 ';
Nlx_header1{12,1}=' -AmpHiCut	50 ';
Nlx_header1{13,1}=' -SubSamplingInterleave 1';
Nlx_header1{14,1}=[' -SamplingFrequency	',num2str(1/bin_width)];
Nlx_header1{15,1}=[' -ADBitVolts	',num2str(ADbitvolts)];
Nlx_header1{16,1}=' -ADMaxValue	32767';
Nlx_header1{17,1}=' ';

FieldSelection=[1 0 1 1 1 1];


ExtractedX =[ExtractedX, zeros(1,(floor(length(ExtractedX)/512)+1)*512-length(ExtractedX))];
ExtractedX = reshape(ExtractedX,512,length(ExtractedX)/512);
ExtractedX=round(ExtractedX*0.001/ADbitvolts);

Samples=ExtractedX;
ExtractMode=1;
AppendFile=0;
NumRecs=length(ExtractedX(1,:));
ModeArray=1;

Timestamps=1000*bin_width/2:(1000*bin_width*512):((NumRecs-1)*512*1000*bin_width+1000*bin_width/2);
NumValSamples= ones(1,NumRecs)*512;
SampleFrequency=ones(1,NumRecs)/bin_width;
Mat2NlxCSC(['E:\brust theta\lab02\xk128\final_two_days' '\' data_name,'1.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps*1000,SampleFrequency,NumValSamples,Samples,Nlx_header1);

  
  
  
