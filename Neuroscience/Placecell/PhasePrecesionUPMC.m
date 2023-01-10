function RunTrial=PhasePrecesionUPMC(rawData,CellField,AxisData,PhaseData,DistTh,NumTh,DurationTh)


aColAxis=AxisData(:,1);
aRowAxis=AxisData(:,2);
Trace=rawData.Trace;

%%%%%%%%%%%Check the if Track inside of Field
%%%%%%%%%%%Track(:,1) is x coorrdinate, Track(:,2) is y coorrdinate;

SpikeInd=rawData.spkInd;
SpikePos=rawData.TSpos;

if length(CellField.Normfield)==0
   RunTrial.Phase=[];
   RunTrial.Pos=[];
   return
end
for ifd=1:length(CellField.Normfield)
    clear Start Over NonRun RunDist RunIndex

TempI=[];
TempD=[];

InFieldIndex=InfieldCheck(rawData.Trace, CellField.Normfield{ifd},DistTh,NumTh);

PeakPosition=CellField.NormPeakP(ifd,:);


InFieldIndex=[0;InFieldIndex(:);0];

l=size(rawData.Trace,1);
Start=max(1,find(diff(InFieldIndex)==1)-1);           %%%%%%%%%%the last position before entry of the field
Over=min(l,find(diff(InFieldIndex)==-1)-1+1);         %%%%%%%%%%the first position after exit of the field

Duration=Over-Start+1;
NonRun=find(Duration<DurationTh);

Start(NonRun)=[];
Over(NonRun)=[];

if isempty(Start)
   RunTrial=[];
   continue
end

for i=1:length(Start)
    RunIndex=Start(i):Over(i);
    RunIndex=RunIndex(:);
    RunTrace=Trace(RunIndex,:);    
    
    OptimalVector=[RunTrace(:,1)-PeakPosition(1) RunTrace(:,1)-PeakPosition(2)];
%     DisPeak=sqrt(OptimalVector(:,1).^2+OptimalVector(:,2).^2);
    
    
    
    SpeedVector=[diff(Trace);Trace(end,:)-Trace(end-1,:)];
    SpeedVector=SpeedVector(RunIndex,:);
    
    DisAll=cumsum(sqrt(SpeedVector(:,1).^2+SpeedVector(:,2).^2));
    DistTrace=DisAll/DisAll(end);

%     [~,IndexMin]=min(DisPeak);
%     
%     b=cumsum(SpeedVector(1:IndexMin));
%     c=SpeedVector(1);
%     DistNeg=(b-b(end))/(b(end)-c);
%     
%     
%     b=cumsum(SpeedVector(IndexMin:end));
%     c=SpeedVector(IndexMin);
%     DistPos=(b-b(end))/(b(end)-c);
%     DistPos(1)=[];
    
% %     DistTrace=[DistNeg(:);DistPos(:)];
% % DistTrace=cumsum(Speed);
    
% %     [ThetaO,~]=cart2pol(OptimalVector(:,1),OptimalVector(:,2));
% %     [ThetaR,~]=cart2pol(SpeedVector(:,1),SpeedVector(:,2));
% %     symTrace=sign(cos(ThetaO-ThetaR));

% %     RunDist=sqrt(diff(RunTrace(:,1)).^2+diff(RunTrace(:,2)).^2);
% %     RunDist=[0;RunDist(:)];
% %     RunDist=cumsum(RunDist);
% %     /sum(RunDist);
    [TempIndex,TSIndex,TempIndex2]=intersect(SpikeInd(:),RunIndex);
    
    SamplePeriod=0.04;
    SpeedTemp=sqrt(SpeedVector(:,1).^2+SpeedVector(:,2).^2)/SamplePeriod;
    
    
    
    if isempty(TSIndex)
       continue
    end
    
    
    
    SpikePosLin=DistTrace(TempIndex2);
    SpikeSpeed=SpeedTemp(TempIndex2);
    
        Valid=find(SpikeSpeed>=0.03);    %%%%%spikes fired when speed>0.03m/s is considered

        if length(Valid)<1
           continue
           clear rateTemp i1 i2 SpikePosLin symTrace RunIndex RunTrace TempIndex TempIndex2 TSIndex
        end
%     SpikePosLin=SpikePos(TSIndex,:);
    
        
%     for j=1:size(SpikePosLin,1)
%     [~,i1]=min(abs(SpikePosLin(j,1)-aColAxis));
%     [~,i2]=min(abs(SpikePosLin(j,2)-aRowAxis));
%     rateTemp(j)=aMap(i2,i1)/CellField.PeakRate(ifd);
%        
%        
%     end
    
%     SpikePosLin=rateTemp(:).*symTrace(TempIndex2);
    
% % %     TempRunTrial(i).Trace=RunTrace;
% % %     TempRunTrial(i).TSIndex=TSIndex;
% % %     TempRunTrial(i).SpikeDist=SpikePos;
    
    TempI=[TempI;TSIndex(Valid)];
    TempD=[TempD;SpikePosLin(Valid)];

    clear rateTemp i1 i2 SpikePosLin symTrace RunIndex RunTrace TempIndex TempIndex2 TSIndex
end
RunTrial(ifd).Phase=PhaseData(TempI);

RunTrial(ifd).Phase=RunTrial(ifd).Phase(:);

RunTrial(ifd).Pos=TempD(:);

clear TempD TempI

end
