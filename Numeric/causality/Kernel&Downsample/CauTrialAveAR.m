function Cau=CauTrialAveAR(fileName,Chan,CausalityParameter,AnalysisP)


% Causality are computed based on averaged AR model with different trial length;

% fileName=[NexFile{3}.General num2str(NexFile{3}.Individual(2)) '-f.nex'];
% psdParameter.Fs=1000;
% psdParameter.window=512;
% psdParameter.noverlap=400;
% psdParameter.nfft=1024;
% Chan{1}.Name='HippCh6AD';
% Chan{2}.Name='CereCh11AD';
psd_p=AnalysisP.psd_p;
csd_p=AnalysisP.csd_p;
Vth=AnalysisP.Vth;          %speed threshold to compute distance of traces
run_th=AnalysisP.run_th;    %speed threshold to define running period    
time_th=AnalysisP.time_th;  %time threshold to define running period 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%speed >run_th continously for >time_th is
%%%%%%%%%%%%%%%%%%%%%%%%%%%%considered as running period
ArtificialDelay=AnalysisP.ArtificialDelay;%%%%%%%%%%% LFP data immediatelly after reward was excluded in psd analysis
NaviDelay=AnalysisP.NaviDelay; %%%%%%% 1s delay for goal-directed navigation
AnalysisDuration=AnalysisP.AnalysisDuration;%%%%length of data included in LFP analysis


[Explore RewardType Dist NormDist TSStim]=NaviCheckNex(fileName,Vth);
[~,StimTSALL]=nex_ts(fileName,'StimTs');
Index=find(diff(StimTSALL)>0.5);
Index=[1;Index(:)];
StimTSAll=StimTSALL(Index);

Cau.Explore=Explore;
Cau.RewardType=RewardType;
Cau.Dist=Dist;
Cau.NormDist=NormDist;
Cau.TSStim=TSStim;

% DirectIndex=find(NormDist<=pi/2&RewardType==1);
% InDirectIndex=find(NormDist>pi/2&RewardType==1);
% ForageIndex=find(RewardType==2);
% NaviIndex=find(RewardType==1);
% 
% Output.DiIndex=DirectIndex;
% Output.ForeIndex=ForageIndex;
% Output.NaviIndex=NaviIndex;

clear ExploreS ExploreO

TSStim=TSStim(:);
ExploreO=TSStim;
ExploreS=[0;TSStim(1:(end-1))];
occurNum=0;
for i=1:length(ExploreO)
    [~,i1]=min(abs(ExploreO(i)-StimTSAll));
    temp2=StimTSAll(max(i1-1,1));
    
    if i>1
    if temp2>(ExploreS(i)+2)
       ExploreS(i)=temp2;
       occurNum=occurNum+1;
    end
    end
end
['occur' num2str(occurNum)];
clear tt temp2
tt=find(ExploreS>0);
ExploreS(tt)=ExploreS(tt)+ArtificialDelay;

ExploreO=ExploreO(:)';
ExploreS=ExploreS(:)';

AnalysisPeriod=[ExploreS;ExploreO];

for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},AnalysisPeriod);
end
% 
AllIndex=1:length(RewardType);
NaviIndex=find(RewardType==1);
ForeIndex=find(RewardType==2);
DiIndex=intersect(find(NormDist<=(pi/2)),NaviIndex);
InDiIndex=intersect(find(NormDist>(pi/2)),NaviIndex);


TempData=DataPrepared(Data,AllIndex);
Cau.All=causality_DiTrial(TempData,CausalityParameter);

TempData=DataPrepared(Data,NaviIndex);
Cau.Navi=causality_DiTrial(TempData,CausalityParameter);

TempData=DataPrepared(Data,ForeIndex);
Cau.Fore=causality_DiTrial(TempData,CausalityParameter);

TempData=DataPrepared(Data,DiIndex);
Cau.DiNavi=causality_DiTrial(TempData,CausalityParameter);

TempData=DataPrepared(Data,InDiIndex);
Cau.InDiNavi=causality_DiTrial(TempData,CausalityParameter);

 
Cau.Explore=Explore;
Cau.RewardType=RewardType;
Cau.Dist=Dist;
Cau.NormDist=NormDist;
Cau.TSStim=TSStim;


function [OutputData]=DataPrepared(InputData,InputIndex)

OutputData=InputData;
for j=1:length(OutputData)
   Output{j}=[];
   for i=1:length(InputIndex)
       OutputData{j}(i).Data=InputData{j}(InputIndex(i)).Data;
   end
end


function DataD=DataInitialize(InputData)

for j=1:length(InputData)
   DataD{j}=[];
   for i=1:length(InputData{j})
       if isempty(InputData{j}(i).Data)
       else
       DataD{j}(i).Data=zscore(detrend(InputData{j}(i).Data));
       end
   end
end







