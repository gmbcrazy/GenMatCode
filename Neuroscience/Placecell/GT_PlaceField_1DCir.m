function Cell=GT_PlaceField_1DCir(mapO,thRateRatio,thNum,PeakRthRatio)
%%%%Calcualted place fields circular linear track;
%%%%Input: mapO, spatial map;
%%%%Input: thRateRatio, 0.2 refers to 20%GlobalPeak is the threahold of place filed border.
%%%%Input: thNum, minimal number of continous bins >= thRateRatio 

%%%%%%%%Might not very useful
%%%%Input: PeakRthRatio, Peak rate within each field must be higher than PeakRthRatio*GlobalPeak
%%%%%%%%Might not very useful



PeakR=max(mapO);
SigMap=mapO>=(PeakR*thRateRatio);
% SigMap(1)=1;SigMap(end)=1;
CC = bwconncomp(SigMap);

PeakRth=PeakRthRatio*PeakR;


MergeI=[];
%%%%%Find fields with 0 degree bin and 360 degree bin, merge them
for i=1:CC.NumObjects
    I=find(CC.PixelIdxList{i}==1|CC.PixelIdxList{i}==length(mapO));
    if ~isempty(I)
    MergeI=[MergeI;i];
    end
end
%%%%%Find fields with 0 degree bin and 360 degree bin, merge them



IdxListAll=1:CC.NumObjects;
SingleIdx=setdiff(IdxListAll,MergeI);

if ~isempty(MergeI)
for i=1:length(MergeI)
    if i==1
       Cell(1).PeakIX=CC.PixelIdxList{MergeI(i)}; 
    else
       Cell(1).PeakIX=[Cell(1).PeakIX;CC.PixelIdxList{MergeI(i)}]; 
    end
    
end
Cell(1).PeakIY=zeros(size(Cell(1).PeakIX))+1;
Cell(1).PeakR=max(mapO(Cell(1).PeakIX));
end

for i=1:length(SingleIdx)
    
% %     if exist('Cell')
% %         
% %        Cell(end+1).PeakIX=CC.PixelIdxList{SingleIdx(i)};
    if (~exist('Cell'))&&i==1
       Cell(1).PeakIX=CC.PixelIdxList{SingleIdx(i)}; 
    else
       Cell(end+1).PeakIX=CC.PixelIdxList{SingleIdx(i)};
    end

    
    Cell(end).PeakIY=zeros(size(Cell(end).PeakIX))+1;
    Cell(end).PeakR=max(mapO(Cell(end).PeakIX));
end

for i=1:length(Cell)
    NumPix(i)=length(Cell(i).PeakIX);
    PeakR(i)=Cell(i).PeakR;
end
Cell(NumPix<thNum|PeakR<PeakRth)=[];



function Cell2=MergeField(Cell2,mapO2)

for i=1:length(Cell2)
    for j=(i+1):length(Cell2)
        if isempty(intersect(Cell2(i).PeakIX,Cell2(j).PeakIX))
           Cell2(i).PeakIX=union(Cell2(i).PeakIX,Cell2(j).PeakIX);
           Cell2(i).PeakIY=eros(size(Cell2(end).PeakIX))+1;
           Cell2(i).PeakR=max(mapO2(Cell2(i).PeakIX));
           Cell2(j)=[];
           Cell2=MergeField(Cell2,mapO2);
           break
        end
    end
end


