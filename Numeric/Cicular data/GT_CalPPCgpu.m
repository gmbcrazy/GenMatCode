function [ppc2,varargout]=GT_CalPPCgpu(UnitTrial,NphaseParam)

%%%%2019, Lu Zhang
%%%%%%according to formula 4.3 in Martin Vinck etc's work: J Comput Neurosci (2012) 33?53-75

%%%%%UnitTrial is struct variable, UnitTrial(i) is the ith trial data.
%%%%%UnitTrial(i).Phase is phase data in matrix, cols for phase with different
%%%%%frequency, rows for spikes.
%%%%%NphaseParam is the Num. of frequency band, should equal to size(UnitTrial(i).Phase,2);
%%%%%Using empty matrix if there is no phase data in a specific trial

%%%%%If there are three bands (theta, beta, gamma), UnitTrial(i).Phase=[-0.1 0.3 0.2;-0.3 0.2 0.8]; is an example show
%%%%%there are two spikes in trial i. The 1st spike phase is -0.1 0.3 0.2 for the three band respectively, while
%%%the 2nd spike phase is -0.3 0.2 0.8 for the three band.


%%%ppc2 is the pairwise phase consistentcy across trial values, a vector
%%%with NphaseParam length.
%%%%varargout{1}=nonNanCount;   Number of non-nan spikes.
%%%%varargout{2}=TScount;       Number of spikes in all trials.


%%%%%%
% % PhaseData=[];
% % TrialID=[];
% tic

if length(gpuDevice)>=1
else
   [ppc2,varargout]=GT_CalPPC(UnitTrial,NphaseParam);
end


Ntrial=length(UnitTrial);
TScount=0;
for iTrial=1:Ntrial
    TScount=TScount+size(UnitTrial(iTrial).Phase,1);
end

for iTrial=1:Ntrial

if ~isempty(UnitTrial(iTrial).Phase)
   Nphase=size(UnitTrial(iTrial).Phase,2);
   break
end
end
if ~exist('Nphase')
   Nphase=NphaseParam;
   ppc2=zeros(1,Nphase)+nan;
   
if nargout==2
varargout{1}=0;
elseif nargout==3
varargout{1}=0;
varargout{2}=0;
    
end

   return;
end

for iP=1:Nphase
TrialID=[];
PhaseData=[];

for iTrial=1:Ntrial
    if ~isempty(UnitTrial(iTrial).Phase)
    PhaseData=[PhaseData;UnitTrial(iTrial).Phase(:,iP)];
    TrialID=[TrialID;zeros(size(UnitTrial(iTrial).Phase,1),1)+iTrial];
    end
end


N=length(PhaseData);
RealImaData=[cos(PhaseData) sin(PhaseData)];
RealImaDataG=gpuArray(RealImaData);

DotSum=0;
SubSum=nan;
nonNanCount=0;
for iTrial=1:length(UnitTrial)
    I1=find(TrialID==iTrial);
    I2=find(TrialID~=iTrial);
    if isempty(I1)||isempty(I2)
       continue
    end
% %     R1=repmat(RealImaData(I1,1),1,length(I2));
% %     R2=repmat(RealImaData(I1,2),1,length(I2));
% % 
% %     SubSum=nansum(R1*RealImaData(I2,1)+R2*RealImaData(I2,2))/length(I1)/length(I2);
    R1=repmat(RealImaDataG(I1,1),1,length(I2));
%     R1G=gpuArray(R1);
    t1=R1*RealImaDataG(I2,1);
    clear R1;
    R2=repmat(RealImaDataG(I1,2),1,length(I2));
    t2=R2*RealImaDataG(I2,2);
    clear R2
    SubSum=nansum(t1+t2)/length(I1)/length(I2);
    nonNanCount=nonNanCount+1;
    DotSum=DotSum+SubSum;
      
    
    
end
if nonNanCount>=1
ppc2(iP)=DotSum/Ntrial/(Ntrial-1);
else
ppc2(iP)=nan; 
end
end

% if isgpuarray(ppc2)
   ppc2=gather(ppc2);
% end


if nargout==2
varargout{1}=nonNanCount;
elseif nargout==3
varargout{1}=nonNanCount;
varargout{2}=TScount;

else
    
end
% toc