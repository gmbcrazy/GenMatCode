function Cau=CauAnalysisTrialNex(fileName,Chan,CausalityParameter,AnalysisP)

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
ExploreS=[0;TSStim(1:(end-1))+ArtificialDelay];

ExploreO=ExploreO(:)';
ExploreS=ExploreS(:)';

AnalysisPeriod=[ExploreS;ExploreO];

for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},AnalysisPeriod);
end
% 

Cau=cau_NexTrialData(Data{1},Data{2},CausalityParameter);
% Cau=causality_DiTrial(Data,CausalityParameter);
% figure;plot(Cau.F,Cau.F1to2,'r');hold on;plot(Cau.F,Cau.F2to1);
% set(gca,'xlim',[0 50]);
 
Cau.Explore=Explore;
Cau.RewardType=RewardType;
Cau.Dist=Dist;
Cau.NormDist=NormDist;
Cau.TSStim=TSStim;


% [Cxy,F,ValidIndex,Coh]=coh_NaviSmr(Data{1},Data{2},psdParameter);
% 
% Output.Psd=power;
% Output.PsdIndex=ValidIndexPower;
% Output.F=f;
% 
% Output.Coh=Cxy;
% Output.FCoh=F;
% Output.CohIndex=ValidIndexCoh;







