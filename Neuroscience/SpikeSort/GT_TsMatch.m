function [Overlap,Non1,Non2]=GT_TsMatch(TS1,TS2,varargin)

%%%%%%%Lu Zhang 10/27/2017
%%%%%%%compute how much do two spike trains(TS1 and TS2) matched in time
%%%%%%%abs(t1-t2)< Th  <=> spike t1 matched spike t2

%%%%%%%Overlap, Num. of overlaped spikes 
%%%%%%%Non1, Non2  <=> Num. of non-overlaped spikes in TS1 and TS2 respectively  

if nargin<3
   Th=0.0001;
else
   Th=varargin{1};
end

if length(TS1)>length(TS2)
   [Overlap,Non2,Non1]=GT_TsMatch(TS2,TS1,Th);
   return
end
    
I1=0;
TS2Temp=TS2;
for i=1:length(TS1)
    [a]=find(abs(TS1(i)-TS2Temp)<Th);
    if isempty(a)
    else
       I1=I1+1;
       TS2Temp(1:a)=[];
    end
end

Overlap=I1;
Non1=length(TS1)-I1;
Non2=length(TS2)-I1;



