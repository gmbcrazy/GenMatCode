function RunTrial=RunDistDect(Trace,InFieldIndex,SpikeInd,DurationTh)

%%%%%%%%%%%Check the if Track inside of Field
%%%%%%%%%%%Track(:,1) is x coorrdinate, Track(:,2) is y coorrdinate;



InFieldIndex=[0;InFieldIndex(:);0];

Start=find(diff(InFieldIndex)==1);
Over=find(diff(InFieldIndex)==-1)-1;

Duration=Over-Start+1;
NonRun=find(Duration<DurationTh);

Start(NonRun)=[];
Over(NonRun)=[];

if isempty(Start)
   RunTrial=[];
   return
end

for i=1:length(Start)
    RunIndex=Start(i):Over(i);
    RunIndex=RunIndex(:);
    RunTrace=Trace(RunIndex,:);
    RunDist=sqrt(diff(RunTrace(:,1)).^2+diff(RunTrace(:,2)).^2);
    RunDist=[0;RunDist(:)];
    RunDist=cumsum(RunDist);
% %     /sum(RunDist);
    [TempIndex TSIndex TempIndex2]=intersect(SpikeInd(:),RunIndex);
    
    RunTrial(i).Trace=RunTrace;
    RunTrial(i).Dist=RunDist;
    
    RunTrial(i).TSIndex=TSIndex;
    RunTrial(i).SpikeDist=RunDist(TempIndex2);

end


