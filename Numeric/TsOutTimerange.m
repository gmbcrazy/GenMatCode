function [Ts,Index]=TsOutTimerange(Ts,Timerange)

InvalidIndex=[];
for i=1:size(Timerange,2)
    IndexTemp=find(Timerange(1,i)<=Ts&Ts<=Timerange(2,i));
    InvalidIndex=[InvalidIndex;IndexTemp(:)];    
end

Index=1:length(Ts);
Index=setdiff(Index,InvalidIndex);

Ts=Ts(Index);