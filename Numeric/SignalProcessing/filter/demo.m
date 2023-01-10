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
lowf=4;
highf=12;
freq=1000;
fz=freq/2;
[b,a]=ellip(6,3,50,highf/500);
sf=filtfilt(b,a,data);
[b,a]=ellip(6,3,50,lowf/500,'high');
sf=filtfilt(b,a,sf);
%filter the data



%writing data to .smr
header.FileChannel=33;
[sf,hout]=SONRealToADC(sf,header);
hout
[freechan]=SONCreateChannel(fid,Chan,sf,hout)
%writing data to .smr


fclose(fid);

