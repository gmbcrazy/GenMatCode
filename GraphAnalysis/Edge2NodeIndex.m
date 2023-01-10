function [AdjMat,Node]=Edge2NodeIndex(NodeNum,EdgeWeight)

% NodeNum=5
%%%%%%%EdgeWeight is a vector of length NodeNum*(NodeNum-1)/2
ColM=repmat(1:NodeNum,NodeNum,1);
RowM=repmat([1:NodeNum]',1,NodeNum);

ColN=[];
RowN=[];
ii=1;
for i=1:NodeNum
    for j=(i+1):NodeNum
        ColN(ii)=ColM(i,j);
        RowN(ii)=RowM(i,j);
        ii=ii+1;
    end
end

EdgeIndex=find(EdgeWeight~=0);
ColN=ColN(EdgeIndex);
RowN=RowN(EdgeIndex);

AdjMat=zeros(NodeNum,NodeNum);
for i=1:length(ColN)
    AdjMat(RowN(i),ColN(i))=EdgeWeight(EdgeIndex(i));
end

AdjMat=AdjMat+AdjMat';
Node=[RowN;ColN]';
Node((RowN-ColN)>0,:)=[];




