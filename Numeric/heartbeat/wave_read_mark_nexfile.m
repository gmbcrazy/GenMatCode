function wave_read_mark_nexfile(path,file,new_file_name,ADname,distance_th,raw_data_th)
%%%%path should be like  'd:\abc'
%%%%file should be like  'lab01-asdb.nex'
%%%%new_file_name should be like  'mice'
%%%%ADname should be like  'AD49'


path_file=[path '\' file];
[adfreq, n, ts, fn, wave_o]=nex_cont(path_file,ADname);
wave_o=wave_o';
% lowf=20;
% highf=100;
% [filterAD,filtwts] = eegfilt(wave_o',1000,lowf,highf,0,200,0);
% wave=zscore(filterAD);
wave=zscore(wave_o);

wave_o=wave_o';
wave=wave';

diff_data=diff(wave);  

temp_p_p=find(diff_data<-0.6);



for i=1:length(temp_p_p)
    temp_q=temp_p_p(i);
    temp_point=temp_q;
    while temp_point>0
          if diff_data(temp_point)>0
              temp_point=temp_point+1;
          else
              break
          end
      end
      temp_s=max(1,temp_point-8);
      temp_e=min(temp_point+8,length(wave));
     [temp_data,point_p(i)]=max(wave(temp_s:temp_e));
     clear temp_s temp_e
     point_p(i)=temp_point-9+point_p(i);
        clear temp_point
end
point_p=unique(point_p);

point_p=point_p(find(wave(point_p)>2));
point_p(find(wave_o(point_p)<raw_data_th))=[];


temp_p=point_p;clear point_p

    
temp_q=0;
for i=1:length(temp_p)
    if temp_p(i)>temp_q+30
    temp_q=temp_p(i);
    temp_point=temp_q;
      temp_s=max(1,temp_point-8);
      temp_e=min(temp_point+8,length(wave));
     [temp_data,point(i)]=max(wave(temp_s:temp_e));
     clear temp_s temp_e
     
     point(i)=temp_point-9+point(i);
     temp_q=temp_p(i);

 else
     point(i)=-10;
   end

end

point(find(point<0))=[];


% point(find(wave(point-5)>0.8))=[];

length_wave=length(wave);
wave_form=zeros(length(point),10);
for i=1:length(point)
      temp1=point(i)-4;
      temp2=point(i)+5;
      if  temp1<=0
          wave_form(i,(11-temp2):10)=wave(1:temp2);
      elseif temp2>length_wave
          wave_form(i,1:(length_wave-temp1+1))=wave(temp1:length_wave);
      else
          wave_form(i,:)=wave(temp1:temp2);
      end
end
wave_form=zscore(wave_form);
ave_waveform=mean(wave_form);
for i=1:length(point)
    distance(i)=norm(wave_form(i,:)-ave_waveform);
end
distance=zscore(distance);
point=point(find(abs(distance)<distance_th));




% wave_s=wave(point+1)-wave(point);
% wave_e=wave(point-1)-wave(point);
% point(union(find(wave_s<0),find(wave_e<0)))=[];





sf=wave_o;
clear wave diff_data

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
Nlx_header1{14,1}=' -SamplingFrequency	1000';
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
Nlx_header{14}=' -SamplingFrequency	1000';
Timestamps=0:1000*512:((NumRecs-1)*512*1000);
NumValSamples= ones(1,NumRecs)*512;
SampleFrequency=ones(1,NumRecs)*1000;
Mat2NlxCSC([path  '\' new_file_name '_AD.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps,ones(1,NumRecs)*1000,NumValSamples,Samples,Nlx_header1);
% 
% ExtractedX=temp_sf;
% ExtractedX =[ExtractedX, zeros(1,(floor(length(ExtractedX)/512)+1)*512-length(ExtractedX))];
% ExtractedX = reshape(ExtractedX,512,length(ExtractedX)/512);
% ExtractedX=round(ExtractedX*0.001/ADbitvolts);
% 
% Samples=ExtractedX;
% ExtractMode=1;
% AppendFile=0;
% NumRecs=length(ExtractedX(1,:));
% ModeArray=1;
% Nlx_header{14}=' -SamplingFrequency	1000';
% Timestamps=0:1000*512:((NumRecs-1)*512*1000);
% NumValSamples= ones(1,NumRecs)*512;
% SampleFrequency=ones(1,NumRecs)*1000;
% Mat2NlxCSC([path '\heart_AD_filter.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps,ones(1,NumRecs)*1000,NumValSamples,Samples,Nlx_header1);
% 
% 


            if ~isempty(point)
            TimeStamps=1000.0*(point-1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%point is the point-th time point of AD-type variable,but the time points should be point-1
           
            NumRecs=length(TimeStamps);
             
		    s=[path '\' new_file_name '_ts.nts'];
%             FieldSelection=[1 0 ];
%     
%             Mat2NlxST([outdir '\' names(p1(ii),1:4) 'theta_maxts_f.nts'], 0, 1, 1, NumRecs, FieldSelection, TimeStamps);
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
                Mat2NlxTS(s, 0, 1, 1, NumRecs, FieldSelection, TimeStamps,Nlx_header1);  

        end
