function [Explore TSStim]=File2PathTrial(filename,p,timerange,varargin)

% filename='F:\Lu Data\Mouse014\ldl\LDL no object\22072013\sorted\NaviReward-M14-220713001-f.nex';
%Vth is the speed threhold for calculating the navigation distance
%Explore is struct involves the XY coordinate of trace of each navigation
%RewardType(i) refers to the type of navigation(value 1 refers to navigation, 2 refers to forage)
%Dist(i) refers to the type of navigation(value 1 refers to navigation, 2 refers to forage) of ith trial 
%Dist(i) refers to the exploartion distance of ith trial 
%NormDist(i) refers to the exploartion distance of ith trial 

%Disth is the threshold of Normalized distance for sepereate the direct and indirect navigation, pi/2 is suggested value. 
if nargin==3
ArtificialDelay=0.4;   %every exploration starts from 1s later after last reward(First Stim)
elseif nargin==4
ArtificialDelay=varargin{1};   %every exploration starts from 1s later after last reward(First Stim)  
else
  
end


[NumStim, nm, nl, TSStim, names, NaviType] = nex_marker2(filename, 'FirstStim');
TSStim=TSStim(:);
Invalid=find(TSStim<0);
Invalid=unique(Invalid);
NaviType(Invalid)=[];
TSStim(Invalid)=[];


Temp=[];
TSRaw=TSStim;
for i=1:length(timerange(1,:))
    Temp=[Temp;find(TSStim>=timerange(1,i)&TSStim<=timerange(2,i))];
end
TSStim=TSStim(Temp);
NaviType=NaviType(Temp);
NumStim=length(TSStim);


TSStim=TSStim(find(str2num(NaviType)==3|str2num(NaviType)==1));
NumStim=length(TSStim);


% StimStr=readNexAll(filename,TrialTS);
if NumStim<=1
    Explore=[];
    TSStim=[];
    return
end


for i=1:length(timerange(1,:))
    TSStim(find(TSStim<timerange(1,i)|TSStim>timerange(2,i)))=[];
end
NumStim=length(TSStim);

[adfreq, n, ZTsS, fn, Zone] = nex_cont2(filename, 'Zone');
[adfreq, n, XTsS, fn, Xpos] = nex_cont2(filename, 'PosXSmooth');
[adfreq, n, YTsS, fn, Ypos] = nex_cont2(filename, 'PosYSmooth');
% sampleP=1/adfreq;
Zone3th=10;
Zone5th=8;

Zone=round(Zone);

Zone4index=find(Zone==4);
% Zone2X=mean(Track(i).X(Zone2));

Zone4Ymean=mean(Ypos(Zone4index));
Zone4Ymean=67;


Zone3index=find(Zone==3);
Zone5index=find(Zone==5);
Zone2index=find(Zone==2);
% 
if ~isempty(Zone3index)
Zone3Y=Ypos(Zone3index);
temp=Zone3Y-Zone4Ymean;
SouthIndex=find(temp>Zone3th);
% SouthIndex=setdiff(1:length(temp),NorthIndex);
Zone(Zone3index(SouthIndex))=-Zone(Zone3index(SouthIndex));
end

if ~isempty(Zone5index)
Zone5Y=Ypos(Zone5index);
temp=Zone5Y-Zone4Ymean;
NorthIndex=find(temp<-Zone5th);
SouthIndex=setdiff(1:length(temp),NorthIndex);
Zone(Zone5index(SouthIndex))=-Zone(Zone5index(SouthIndex));
end









TempTS=TSStim-XTsS;
Index=round(TempTS.*adfreq);
Index(Index==0)=[];
Index=[1;Index(:)];


ArtificialDelayI=adfreq*ArtificialDelay;
RewardDelay=1;
RewardDelayI=adfreq*RewardDelay;

RewardType=zeros(NumStim-1,1);
MinDist=zeros(NumStim-1,1);

i=1;
while i<NumStim

       s=Index(i)+ArtificialDelayI;
       o=Index(i+1);
   o=max([s o]);
   s=min([s n]);
   o=min([o n]);

   Explore(i).X=Xpos(s:o);
   Explore(i).Y=Ypos(s:o);
   Explore(i).Zone=Zone(s:o);

%    Dist(i)=DistCal(Explore(i).X,Explore(i).Y,p.lowSpeedThreshold,adfreq);
 i=i+1;
end

% Dist=Dist(:);





































