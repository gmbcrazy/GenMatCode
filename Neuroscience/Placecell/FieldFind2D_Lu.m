function Cell=FieldFind2D_Lu(mapO,RateTH,thNum)

%%%%%%map0: Firing Map
%%%%%%Firing Rate threshold of Place Field was selected thRateRatio*PeakFiringRate
%%%%%%Place field was defined as >thNum of pixel with firing rate>thRateRatio*PeakFiringRate
map=mapO;
PeakRate=max(max(map));

sigMap=zeros(size(map));

% RateTH=PeakRate*thRateRatio;
sigMap(map>=RateTH)=1;

[m,n]=size(map);

sigCheck=1:n;
[index1,index2]=find(map==PeakRate);
index1=index1;
index2=index2;
StepMap=sigMap;

pixalM=1;
SigAll1=index1(:);
SigAll2=index2(:);
FieldNum=0;
Cell(1).IndX=[];
Cell(1).IndY=[];

while sum(sum(StepMap))>0
    for i=1:length(index1)
    StepMap(index1(i),index2(i))=0;
    end
    cal=[];
    cal1=[];
    cal2=[];
    tempMap=zeros(size(map));
    for i=1:length(index1)
        tcal1=[index1(i)-1 index1(i)+1 index1(i) index1(i)];
        tcal2=[index2(i) index2(i) index2(i)-1 index2(i)+1];
%           tcal1=[index1(i)-1 index1(i)-1 index1(i)-1 index1(i) index1(i) index1(i)+1 index1(i)+1 index1(i)+1];
%           tcal2=[index2(i)-1 index2(i) index2(i)+1 index2(i)-1 index2(i)+1 index2(i)-1 index2(i) index2(i)+1];

        invalid=union(find(tcal1<1|tcal1>m),find(tcal2<1|tcal2>n));
        
        tcal1(invalid)=[];
        tcal2(invalid)=[];
        cal1=[cal1;tcal1(:)];
        cal2=[cal2;tcal2(:)];
%         sigMap(cal1,cal2).*
    end
    if ~isempty(cal1)
    for i=1:length(cal1)
        tempMap(cal1(i),cal2(i))=1;
    end
    end
    
    for i=1:length(index1)
    tempMap(index1(i),index2(i))=0;
    end
    
    checkMap=tempMap.*StepMap;
    pixalM=pixalM+nansum(nansum(checkMap));

    [index1,index2]=find(checkMap==1);
    if ~isempty(index1)
        SigAll1=[SigAll1;index1(:)];
        SigAll2=[SigAll2;index2(:)];
        for i=1:length(index1)
            StepMap(index1(i),index2(i))=0;
        end
        if sum(sum(StepMap))==0
           if pixalM>=thNum
           FieldNum=FieldNum+1;
           Cell(FieldNum).IndX=SigAll1;
           Cell(FieldNum).IndY=SigAll2;
           end

        end
    else
        if pixalM>=thNum
           FieldNum=FieldNum+1;
           Cell(FieldNum).IndX=SigAll1;
           Cell(FieldNum).IndY=SigAll2;
        end
        map(find(StepMap==0))=0;
        PeakRate=max(max(map));
        [index1 index2]=find(map==PeakRate);
        pixalM=length(index1);
        SigAll1=index1;
        SigAll2=index2;
      

    end
        
    
end


for i=1:length(Cell)
    Rate=[];
    if ~isempty(Cell(i).IndX)
        for j=1:length(Cell(i).IndX)
            Rate(j)=mapO(Cell(i).IndX(j),Cell(i).IndY(j));
        end
        [Cell(i).PeakR,P]=max(Rate);
%         Cell(i).PeakI=[Cell(i).IndX(P) Cell(i).IndY(P)];
        Cell(i).PeakIX=Cell(i).IndX(P);
        Cell(i).PeakIY=Cell(i).IndY(P);
    else
        Cell(i).PeakR=[];
%         Cell(i).PeakI=[Cell(i).IndX(P) Cell(i).IndY(P)];
        Cell(i).PeakIX=[];
        Cell(i).PeakIY=[];
  

    end
end

