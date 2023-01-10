function ThU=manhattanPlot(DataStr,ColorS,Th,ReOrder)

for i=1:length(DataStr)
%     DataStr(i).Value(DataStr(i).Value<ThPlot)=[];
    Num(i)=length(DataStr(i).Value);
    ThU(i)=length(find(DataStr(i).Value>=Th));
end

if ReOrder==1
    [~,Index]=sort(ThU);
    DataPlot=DataStr(Index);
    Num=Num(Index);
else
    Index=1:length(ThU);
    DataPlot=DataStr;
end


for i=1:length(DataPlot)
    Xvalue=((1:Num(i))-1)/Num(i)+i-1;
    plot(Xvalue,DataPlot(i).Value,'linestyle','none','marker','.','markersize',5,'color',ColorS(mod(i,size(ColorS,1))+1,:)); 
hold on;
    

end

set(gca,'xlim',[0 length(DataPlot)],'xtick',[]);
