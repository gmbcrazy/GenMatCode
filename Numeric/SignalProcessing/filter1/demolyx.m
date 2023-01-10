clear all
Filename='E:\my program\UPMC\filter\Test.smr';
fid=fopen(Filename);


%reading data 
[Head]=SONFileHeader(fid);
[ChanList]=SONChanList(fid);
Chan=6;
[TChannel]= SONChannelInfo(fid,Chan)
[dataO,header]=SONGetChannel(fid, Chan,'seconds');
header
[data,h]=SONADCToDouble(dataO,header);
clear dataO
%reading data 


%filter the data
% lowf=4;
% highf=12;
% freq=1000;
% fz=freq/2;
% [b,a]=ellip(6,3,50,highf/500);
% sf=filtfilt(b,a,data);
% [b,a]=ellip(6,3,50,lowf/500,'high');
% sf=filtfilt(b,a,sf);
%filter the data




sf=data';
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
[Size,len_signal]=size(ExtractedX)
% ExtractedX(:,len_signal)=[];

[Size,len_signal]=size(ExtractedX);

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


% Mat2NlxCSC('E:\my program\UPMC\filter\Test1.ncs', 0, 1, 1, [1 1 1 1 1 1], Timestamps,ChannelNumbers, SampleFrequency, NumValSamples,Samples, Header);

Mat2NlxCSC('E:\my program\UPMC\filter\Test1.ncs', 0, 1, 1, [1 0 1 1 1 1], Timestamps, SampleFrequency, NumValSamples,Samples,Nlx_header1);







fclose(fid);

