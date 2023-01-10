function spectrograms_wave_write(path_filename,write_path,data_name,timerange,bin_width,fre_band)
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
   

        q=strcmp(nsEntityLabel{EntityID},data_name);              %sig should be a string like 'AD35_ad_000'%
        if q==1;   
           dataEntityID=EntityID;
           break
        end  
     
     
    end

    if isempty(dataEntityID)
       'there is no corresponding data in the file'
       path_filename
       ns_RESULT = ns_CloseFile(hFile);
       Power=-1;
       return;
    end
  
    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,dataEntityID);
    StartIndex=1;

       [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);
       ns_RESULT = ns_CloseFile(hFile);
    wave=[];

    if bin_width==0.001
       temp_data=temp_data(max(timerange(1,1)*1000+1,1):min(timerange(2,1)*1000+1,length(temp_data)));    
       temp_wave=temp_data;
    else
        temp_bin_width=1000*bin_width;
       for j=1:floor(diff(timerange(:,1)/bin_width))
           temp_s=(j-1)*temp_bin_width+1;
           temp_e=j*temp_bin_width;
           temp_wave(j)=mean(temp_data(temp_s:temp_e));
       end
   end
       clear temp_s temp_e temp_bin_width ;
      sf=temp_wave; 
      clear temp_wave
      lowf=fre_band(1);
      highf=fre_band(2);
      freq=1/bin_width;
      fz=freq/2;
      [b,a]=ellip(6,3,50,highf/fz);

      sf=filtfilt(b,a,sf);
      [b,a]=ellip(6,3,50,lowf/fz,'high');

      sf=filtfilt(b,a,sf);
   
       
       
       
       
ExtractedX=sf';
max_sf=max(abs(sf));
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
Mat2NlxCSC([write_path '\' data_name num2str(fre_band') '.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps*1000,SampleFrequency,NumValSamples,Samples,Nlx_header1);

%




interval=floor(10/fre_band(1)/bin_width);




step=floor(interval/20);
shift_num=floor((length(sf)-interval)/step)-1;

mark_theta=zeros(1,shift_num);
for jj=1:shift_num
    sta_jj=(jj-1)*step+1;
    fin_jj=sta_jj+interval-1;
    Y_RMS=sf(sta_jj:fin_jj)';

    Power_RMS(jj)=(mean(Y_RMS*Y_RMS'))^0.5;
    
end


    
 
  
      ExtractedY=Power_RMS;
      max_sf=max(abs(Power_RMS));
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
Nlx_header1{14,1}=[' -SamplingFrequency' num2str(step*bin_width)];
Nlx_header1{15,1}=[' -ADBitVolts	',num2str(ADbitvolts)];
Nlx_header1{16,1}=' -ADMaxValue	32767';
Nlx_header1{17,1}=' ';

FieldSelection=[1 0 1 1 1 1];


ExtractedY =[ExtractedY, zeros(1,(floor(length(ExtractedY)/512)+1)*512-length(ExtractedY))];
ExtractedY = reshape(ExtractedY,512,length(ExtractedY)/512);
ExtractedY=round(ExtractedY*0.001/ADbitvolts);

Samples=ExtractedY;
ExtractMode=1;
AppendFile=0;
NumRecs=length(ExtractedY(1,:));
ModeArray=1;

Timestamps=1000*bin_width*interval/2:(1000*bin_width*step*512):((NumRecs-1)*512*1000*bin_width*step+1000*bin_width*interval/2);
NumValSamples= ones(1,NumRecs)*512;
SampleFrequency=ones(1,NumRecs)/bin_width/step;

      Mat2NlxCSC([write_path '\' data_name num2str(fre_band') '_RMS.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps*1000,SampleFrequency,NumValSamples,Samples,Nlx_header1);


      
      
           base_line=mean(Power_RMS)+1.5*std(Power_RMS);
     power_mark=zeros(length(Power_RMS),1);
     power_mark(find(Power_RMS>base_line))=1;
     power_mark=[0;power_mark;0];
     power_start=(find(diff(power_mark)==1)-1)*step*bin_width+bin_width*interval/2;
     power_over=(find(diff(power_mark)==-1)-1)*step*bin_width+bin_width*interval/2;
     
     
     Timestamps_start=1000000.0*power_start;
     Timestamps_over=1000000.0*power_over;

    NumRecs=length(Timestamps_over);


Nlx_header1{1,1}='######## Neuralynx Data File Header';
Nlx_header1{2,1}='## File Name:  ';
Nlx_header1{3,1}='## Time Opened: (m/d/y):  ';
Nlx_header1{4,1}='-CheetahRev 3.0.6 ';
Nlx_header1{5,1}='-NLX_Base_Class_Name	 ';
Nlx_header1{6,1}='-NLX_Base_Class_Type	CscAcqEnt ';
Nlx_header1{7,1}='-RecordSize  ';
Nlx_header1{8,1}=' -ADChannel	    ',;
Nlx_header1{9,1}=' -ADGain		    ';
Nlx_header1{10,1}=' -AmpGain	    ';
Nlx_header1{11,1}=' -AmpLowCut	    ';
Nlx_header1{12,1}=' -AmpHiCut	    ';
Nlx_header1{13,1}=' -SubSamplingInterleave     ';
Nlx_header1{14,1}=' -SamplingFrequency	   ';
Nlx_header1{15,1}=[' -ADBitVolts	'];
Nlx_header1{16,1}=' -ADMaxValue	32767';
Nlx_header1{17,1}=' -AlignmentPt ';
Nlx_header1{18,1}='	-ThreshVal	';
Nlx_header1{19,1}=' ';

                FieldSelection=[1 1];
                Mat2NlxTS([write_path '\' data_name num2str(fre_band') '_power_start.nts'], 0, 1, 1, NumRecs, FieldSelection, Timestamps_start',Nlx_header1);  
                Mat2NlxTS([write_path '\' data_name num2str(fre_band') '_power_over.nts'], 0, 1, 1, NumRecs, FieldSelection, Timestamps_over',Nlx_header1);  
