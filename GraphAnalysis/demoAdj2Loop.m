% load( SavePathmetaResultPvalue.mat')
clear all
PathSave='Y:\LuZhang\Sch\PaperUse\Fig1_SigEdge\';
Path='Y:\LuZhang\Sch\MetaEarlyPhaseVSLatePhase\AALall\Onset0.0-1200.0\\';

siteNum=5;
Data=[Path 'site' num2str(siteNum) 'metaResult.mat'];
P.pth=0.001/116/115*2;
P.label=1;
P.PlotAll=0;
% 
load(Data);


sig=sign(Z_wei);
pth=P.pth;
sig(pval_meta>pth)=0;
Index1=find(nansum(abs(sig))==1);
sig(Index1,:)=0;
sig(:,Index1)=0;
load('Z:\Users\LuZhang\AAL\LuAAL.mat')
[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
RegionName=RegionName(Index);
sig=sig(Index,Index);

imagesc(abs(sig))
num_est_loops=20;
edgeNum=4;
[loops,ValidIndex]=adj2loop(sig,edgeNum);
if iscell(loops)
   iloop=1;
   loopsOutput.loop=[];
   for i=1:length(loops)
       if ~isempty(loops{i})
           if ~loops{i}(1).loop
           loopsOutput(iloop).loop=loops{i};
           iloop=iloop+1;
           end
       end
   end
   loops=loopsOutput; clear loopsOutput;
end