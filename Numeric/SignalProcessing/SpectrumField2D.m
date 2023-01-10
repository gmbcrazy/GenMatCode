function [Cell,B,PeakPower,PeakI,FreGravity,TimeGravity]=SpectrumField2D(map,sigMap,thNum,varargin)

%%%%%%map: Spectrum Created by Wavelet or FFT
%%%%%%sigMap: SignificanceMap or Significance vector
%%%%%%when sigMap is n*m matrix, the same as map, sigMap should be binary.
%%%%%%0 indicate not significant and 1 indicate significant

%%%%%%if sigMap is a n vector, then it's a threshold such that SigficanceMap would be created by
%%%%%%whether map(:,i)>=sigMap for any i.
%%%%%%Significant power field defined as >=thNum(1) <=thNum(2)of pixels map.

tic

[m,n]=size(map);
if nargin==3
   Fre=1:m;
   Time=1:n;
else
   Fre=varargin{1};
   Time=varargin{2};
end

Fre=Fre(:);
Time=Time(:);
[m1,n1]=size(sigMap);
if m*n~=m1*n1
   sigTh=repmat(sigMap(:),1,n);
   sigMap=(map-sigTh)>=0;
end


[B,N]=bwlabel(sigMap,4);
Cell=struct([]);
Count=0;
if N==0
    B=zeros(size(map));
    PeakPower=[];
    PeakI=[];
    FreGravity=[];
    TimeGravity=[];
   return 
end
% PeakPower=[];
% PeakI=[];
for i=1:N
    Temp=B==i;
    if sum(sum(Temp))>=thNum(1)
       Count=Count+1;
       [I1,I2,~]=find(Temp);
       Cell(Count).Index=[I1(:) I2(:)];
       TempValue=zeros(size(I1));
       for j=1:length(I1)                           
           TempValue(j)=map(I1(j),I2(j));
       end       
       [Cell(Count).Peak,I3]=max(TempValue);
       Cell(Count).PeakI=Cell(Count).Index(I3,:);
       PeakPower(Count)=Cell(Count).Peak;
       PeakI(Count,:)=Cell(Count).PeakI;
       
       Weight=TempValue/sum(TempValue);
       FreGravity(Count,:)=sum(Fre(I1).*Weight);
       TimeGravity(Count,:)=sum(Time(I2).*Weight);

    else
       B(B==i)=0;
    end
end

if sum(sum(B))==0
    B=zeros(size(map));
    PeakPower=[];
    PeakI=[];
    FreGravity=[];
    TimeGravity=[];
end
toc
