function wave_read_mark1(path,file)
%%%%%%%%%demo
%wave_read_mark('D:\my program\heartbeat\test.nex');
%%%%%%%%%demo
path_file=[path,'\',file];
[nvar, names, types] = nex_info(path_file);
p1=find(types==5);

[adfreq, n, ts, fn, d] = nex_cont(path_file, names(p1,:));

if length(fn)>1
add_number=diff(ts)*adfreq-fn(1:(length(fn)-1));
end

for i=1:length(fn)
    if i==1
    fn_original{i}=d(1:fn(1));
    else
        fn_start=sum(fn(1:(i-1)))+1;
        fn_over=sum(fn(1:i));
    fn_original{i}=d(fn_start:fn_over);
end
end

fn_new=fn_original{1};

if length(fn)>1
for i=1:(length(fn)-1)
    fn_new=[fn_new,(fn_original{i}(1))*ones(1,round(add_number(i))),fn_original{i+1}];

    
end
end

n=length(fn_new);
wave=fn_new;




theta_lowf=4;
theta_highf=15;
freq=1000;
fz=freq/2;


[b,a]=ellip(6,3,50,theta_highf/500);

temp_sf=filtfilt(b,a,wave);
[b,a]=ellip(6,3,50,theta_lowf/500,'high');

temp_sf=filtfilt(b,a,temp_sf);% theta-based filter

temp_p=intersect((find(diff(temp_sf)>=0)+1),find(diff(temp_sf)<=0));







diff_data=diff(wave);     

for i=1:length(temp_p)
    temp_q=temp_p(i);
    temp_point=temp_q;
    while temp_point>0
          if diff_data(temp_point)>0
              temp_point=temp_point-1;
          else
              break
          end
      end
      temp_s=max(1,temp_point-15);
      temp_e=min(temp_point+35,length(wave));
     [temp_data,point(i)]=min(wave(temp_s:temp_e));
     clear temp_s temp_e
     point(i)=temp_point-16+point(i);
        
end
length_wave=length(wave);
wave_form=zeros(length(point),16);
for i=1:length(point)
      temp1=point(i)-10;
      temp2=point(i)+5;
      if  temp1<=0
          wave_form(i,(17-temp2):16)=wave(1:temp2);
      elseif temp2>length_wave
          wave_form(i,1:(length_wave+temp1-1))=wave(temp1:length_wave);
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
point=point(find(abs(distance)<2.2));

% point(find(wave(point)>0.01))=[];
% wave_s=wave(point+1)-wave(point);
% wave_e=wave(point-1)-wave(point);
% point(union(find(wave_s<0),find(wave_e<0)))=[];





sf=wave;
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
Mat2NlxCSC([path '\heart_AD.Ncs'],AppendFile,ExtractMode,1,NumRecs,FieldSelection,Timestamps,ones(1,NumRecs)*1000,NumValSamples,Samples,Nlx_header1);
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




            if ~isempty(point)
            TimeStamps=1000.0*(point-1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%point is the point-th time point of AD-type variable,but the time points should be point-1
           
            NumRecs=length(TimeStamps);
             
		    s=[path '\heart_AD_' 'ts.nts'];
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
