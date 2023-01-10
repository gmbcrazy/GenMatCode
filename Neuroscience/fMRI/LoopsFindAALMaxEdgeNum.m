function loops=LoopsFindAALMaxEdgeNum(Data,P,MaxLoopsLength)

load(Data);
sig=sign(Z_wei);

if isfield(P,'correction')
  switch P.correction
      case 'fdr'
          pth=Thfdr_Pmatrix(pval_meta,P.pth);
      case 'bf'
          l=size(sig,1);
          pth=P.pth/l/(l-1)*2;
  end
else
  pth=P.pth;
end

sig(pval_meta>pth)=0;
Index1=find(nansum(abs(sig))==1);
sig(Index1,:)=0;
sig(:,Index1)=0;
load('Z:\Users\LuZhang\AAL\LuAAL.mat')
% % [LobleID,Index]=sort(LobleID);
% % LobleName=LobleName(Index);
% % RegionName=RegionName(Index);
% % sig=sig(Index,Index);

% % imagesc(abs(sig))
edgeNum=MaxLoopsLength;
[loops,ValidSigIndex]=adj2loop(sig,edgeNum);
tic
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
toc

for i=1:length(loops)
    NumEdge(i)=length(loops(i).loop);
end
[SortNumEdge,SortI]=sort(NumEdge);
loops=loops(SortI);
NumEdge=SortNumEdge;
'checking repeated loop...'
tic
icheck=(min(NumEdge)<MaxLoopsLength);
while icheck~=0&&icheck<length(loops)
      status = compare_loop(loops(icheck).loop,loops((icheck+1):end));
      if status==1
         IndexLoop=setdiff(1:length(loops),icheck);
         loops=loops(IndexLoop);
         NumEdge=NumEdge(IndexLoop);
      elseif status==0
         icheck=icheck+1;
      else
      end
      
      if NumEdge(icheck)>=MaxLoopsLength
         break
      end
end
toc
if length(loops)>1
if compare_loop(loops(end).loop,loops((i:end-1)))
   loops=loops(1:(end-1));
end
end
for i=1:length(loops)
    loops(i).loop=ValidSigIndex(loops(i).loop);
end





