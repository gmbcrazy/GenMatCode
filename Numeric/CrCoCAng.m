function [R,P,RMerge,PMerge]=CrCoCAng(Data1,Data2)
%%%%
%%%%assump Data2 must be angle data in radius with equal/lower sampling rate than Data1
f1=1/mean(diff(Data1(1).Time));
f2=1/mean(diff(Data2(1).Time));

DownR=round(f1/f2);
%%%%
%%%%assump Data2 must be angle data in radius with equal/lower sampling rate than Data1
DataMerge1=[];
DataMerge2=[];

for i=1:length(Data1)

if DownR~=1
   Data1(i).Data = downsample(Data1(i).Data,DownR);
end

l=min(length(Data1(i).Data),length(Data2(i).Data));
% [CrrTemp,Lag]=xcorr(Data1(i).Data(1:l),Data1(i).Data(1:l),maxLag);
% Crr(i,:)=CrrTemp(:)';
temp1=Data1(i).Data(1:l);
temp2=Data2(i).Data(1:l);
% [tempR tempP]=corrcoef(temp1(:),temp2(:));

[R(i) P(i)] = circ_corrcl(temp2,temp1);


% figure;
% plot(zscore(temp1));
% hold on;
% plot(zscore(temp2),'r');

DataMerge1=[DataMerge1;temp1(:)];
DataMerge2=[DataMerge2;temp2(:)];

end

[RMerge PMerge] = circ_corrcl(DataMerge2,DataMerge1);


% RMerge=RMerge(1,2);
% PMerge=PMerge(1,2);
% 
% 

