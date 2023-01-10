function [Crr,Lag,R,P,RMerge,PMerge]=CrCoCC(Data1,Data2,maxLag)
%%%%
%%%%assump Data2 has equal or higher sampling rate than Data1
f1=1/mean(diff(Data1(1).Time));
f2=1/mean(diff(Data2(1).Time));


if f1<f2
   datatemp=Data1;
   Data1=Data2;
   Data2=datatemp;
f1=1/mean(diff(Data1(1).Time));
f2=1/mean(diff(Data2(1).Time));
   
end
DownR=round(f1/f2);
%%%%
%%%%assump Data2 has equal or higher sampling rate than Data1
DataMerge1=[];
DataMerge2=[];

for i=1:length(Data1)

if DownR~=1
   Data1(i).Data = downsample(Data1(i).Data,DownR);
end

l=min(length(Data1(i).Data),length(Data2(i).Data));
[CrrTemp,Lag]=xcorr(Data1(i).Data(1:l),Data1(i).Data(1:l),maxLag);
Crr(i,:)=CrrTemp(:)';
temp1=Data1(i).Data(1:l);
temp2=Data2(i).Data(1:l);
[tempR tempP]=corrcoef(temp1(:),temp2(:));

R(i)=tempR(1,2);
P(i)=tempP(1,2);

% figure;
% plot(zscore(temp1));
% hold on;
% plot(zscore(temp2),'r');

DataMerge1=[DataMerge1;temp1(:)];
DataMerge2=[DataMerge2;temp2(:)];

end


[RMerge,PMerge]=corrcoef(DataMerge1,DataMerge2);

RMerge=RMerge(1,2);
PMerge=PMerge(1,2);

Lag=Lag/f2;




