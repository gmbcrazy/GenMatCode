function [RawSize,PerSize,Pns,pPerm]=SigFC_Behavior_NS(Data1,Data2,Coverate,NodeNum,ShuffleNum,PthList)


%%%extracting pth corretions based on network based statistics
% EdgeNum=NodeNum*(NodeNum-1)/2;
for i=1:ShuffleNum
    ShuffleIndex=randperm(size(Data2,1));
    Data2Shuffle(:,i)=Data2(ShuffleIndex);

end
   [~,FCBp]=partialcorr(Data1,Data2,[Coverate],'type','pearson','rows','pairwise');
 for i=1:ShuffleNum
     for j=1:size(Coverate,2)
         TempShuffle=randperm(size(Data2,1));
         CoverateTemp(:,j)=Coverate(TempShuffle,j);
     end

     [~,pPerm(:,i)]=partialcorr(Data1,Data2Shuffle(:,i),[CoverateTemp],'type','pearson','rows','pairwise');

 end
for j=1:length(PthList)
   [pMat,~]=Edge2NodeIndex(NodeNum,FCBp);
   AdjMat=zeros(NodeNum,NodeNum);
   AdjMat(pMat<=PthList(j))=1;
   [~,comp_sizes] = get_components(AdjMat);
   RawSize(j,1)=max(comp_sizes);
   
   clear pMat AdjMat
   for i=1:size(pPerm,2)
       [pMat,~]=Edge2NodeIndex(NodeNum,pPerm(:,i));
       AdjMat=zeros(NodeNum,NodeNum);
       AdjMat(pMat<=PthList(j))=1;
       [~,comp_sizes] = get_components(AdjMat);
       if isempty(comp_sizes)
          comp_sizes=0; 
       end
       PerSize(j,i)=max(comp_sizes);
   end
   Pns(j)=sum(RawSize(j,1)<=PerSize(j,:))/ShuffleNum;
end





