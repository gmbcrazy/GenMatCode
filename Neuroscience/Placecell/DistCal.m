function Dist=DistCal(TempX,TempY,threshold,samplingRate)

%input threshold is the speed threshold by cm/s
threshold=threshold/samplingRate;
DistAll=sqrt((diff(TempX).^2+diff(TempY).^2));

% for i=1:(length(TempX)-1)
% DistAll(i)=sqrt((TempX(i+1)-TempX(i))^2+(TempY(i+1)-TempY(i))^2);
% end
DistAll(DistAll<threshold)=0;
Dist=sum(DistAll);
