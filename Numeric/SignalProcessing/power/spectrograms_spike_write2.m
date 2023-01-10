function spectrograms_spike_write2(path_filename,write_path,data_name,interval,step)
%path_filename should be a string like 'E:\experiment\lab03-04-072005006.nex'%
%timerange=[timestart;timeend]%eg.[122 533;221 466];
[n, ts] = nex_ts(path_filename,data_name);

[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

  
[ns_RESULT,hFile]=ns_OpenFile(path_filename);

[ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
ns_RESULT = ns_CloseFile(hFile);

isi=diff(ts);
data(1,:)=ts(1:(length(ts)-1));
data(2,:)=isi;
sf=zeros(1,floor((nsFileInfo.TimeSpan-interval)/step))-10;
for i=1:floor((nsFileInfo.TimeSpan-interval)/step);
    temp_s=(i-1)*step;
    temp_o=temp_s+interval;
    temp_data=data(2,find(data(1,:)>=temp_s&data(1,:)<temp_o));
    if ~isempty(temp_data)
        sf(i)=length(find(temp_data>0.02&temp_data<0.05))/length(temp_data);
    end
end


baseline=max(mean(sf)-1.2*std(sf),0);
mark_theta=zeros(1,floor((nsFileInfo.TimeSpan-interval)/step));
mark_theta(find(sf<baseline&sf>=0))=1;

     mark_theta=[0,mark_theta,0];
     power_start=(find(diff(mark_theta)==1)-1)*step;
     power_over=(find(diff(mark_theta)==-1)-1)*step;

invalid_index=find(power_over-power_start<4*step);
power_start(invalid_index)=[];
power_over(invalid_index)=[];

rectify_index=find(isi>0.04&isi<0.2);
rectify_ts=ts(rectify_index+1);
rectify_ts_before=ts(rectify_index);

min_ts=min(rectify_ts);max_ts=max(rectify_ts);
for i=1:length(power_start)
    if power_start(i)<max_ts&power_over(i)>min_ts
        
       temp_s=min(find(power_start(i)-rectify_ts<=0));
       change_time=(rectify_ts(temp_s)+rectify_ts_before(temp_s))/2;
%        if abs(change_time)<4*step
          power_start(i)=change_time;
%       end
%       
       temp_o=max(find(power_over(i)-rectify_ts>=0));
       change_time=(rectify_ts(temp_o)+rectify_ts_before(temp_o))/2;
%        if abs(change_time)<4*step
          power_over(i)=change_time;
%       end    
      
  end
    
end

temp_length=length(power_over)-1;
lag=power_start(2:(temp_length+1))-power_over(1:temp_length);
invalid_index=find(lag<4*step);
power_start(invalid_index+1)=[];
power_over(invalid_index)=[];



invalid_index=find(power_over-power_start<4*step);
power_start(invalid_index)=[];
power_over(invalid_index)=[];

ExtractedX=sf;
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
Nlx_header1{14,1}=[' -SamplingFrequency	',num2str(1/step)];
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

Timestamps=1000*step/2:(1000*step*512):((NumRecs-1)*512*1000*step+1000*step/2);
NumValSamples= ones(1,NumRecs)*512;
SampleFrequency=ones(1,NumRecs)/step;
Mat2NlxCSC([write_path '\' data_name 'theta_ratio.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps*1000,SampleFrequency,NumValSamples,Samples,Nlx_header1);
clear ExtractedX

%


     Timestamps_start=1000000.0*power_start;
     Timestamps_over=1000000.0*power_over;
     
if isempty(Timestamps_start)
    return
    
end
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
                Mat2NlxTS([write_path '\' data_name 'theta_start.nts'], 0, 1, 1, NumRecs, FieldSelection, Timestamps_start,Nlx_header1);  
                Mat2NlxTS([write_path '\' data_name 'theta_over.nts'], 0, 1, 1, NumRecs, FieldSelection, Timestamps_over,Nlx_header1);  
      

