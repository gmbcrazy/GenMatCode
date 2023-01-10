function [Ts,Index]=TsInTimerange(Ts,Timerange)

Index=[];
for i=1:size(Timerange,2)
    IndexTemp=find(Timerange(1,i)<=Ts&Ts<=Timerange(2,i));
    Index=[Index;IndexTemp(:)];    
end

Ts=Ts(Index);