function varargout=GT_rateMap(SpikeTs,PosX,PosY,PosT,RangeX,RangeY,p)

%%%%%%%%Calculate rateMap for place cell analysis, linear Track.

[x,y,t]=SpeedThreshold(PosX,PosY,PosT,p.lowSpeedThreshold, p.highSpeedThreshold);
[spkx,spky,~,SpikeTsNeed] = spikePos(SpikeTs,x,y,t);
Xstart=RangeX(1);
Xend=RangeX(2);
Ystart=RangeY(1);
Yend=RangeY(2);
[aMap, ~, aRowAxis, aColAxis, timeMap,spikeMap] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
posPDF=timeMap./nansum(nansum(timeMap));

SpikeData=[SpikeTsNeed(:) spkx(:),spky(:)];

if nargout==1
   varargout{1}=aMap;
elseif nargout==2
   varargout{1}=aMap;
   varargout{2}=aRowAxis;
elseif nargout==4
   varargout{1}=aMap;
   varargout{2}=aRowAxis;
   varargout{3}=aColAxis;
   varargout{4}=posPDF;
elseif nargout==5
       
   varargout{1}=aMap;
   varargout{2}=aRowAxis;
   varargout{3}=aColAxis;
   varargout{4}=posPDF;
   varargout{5}=SpikeData;
elseif nargout==6
       
   varargout{1}=aMap;
   varargout{2}=aRowAxis;
   varargout{3}=aColAxis;
   varargout{4}=posPDF;
   varargout{5}=SpikeData;
   varargout{6}=spikeMap;

else

end
