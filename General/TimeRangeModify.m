function Data=TimeRangeModify(Timerange,InvalidRange)

%Input Timerange is the analysis period. InvalidRange refers to the period
%needs to be excluded.
%Output Data is Timerange-InvalidRange.

Data=[];
for i=1:length(Timerange(1,:))
    Intervali=IndividualRange(Timerange(:,i),InvalidRange);
    if ~isempty(Intervali)
    Data=[Data Intervali];
    end
end

Data(:,find((Data(2,:)-Data(1,:))<=0))=[];



function IntervalC=IndividualRange(Interval,InvalidRange)

Temp=Interval;

ValidIndex=intersect(find(InvalidRange(1,:)<Interval(2)),find(InvalidRange(2,:)>Interval(1)));

if isempty(ValidIndex)
   IntervalC=Interval;
   return
else
   InvalidRange=InvalidRange(:,ValidIndex);
%    IntervalC=IndividualRange(Interval,InvalidRange);
end



if InvalidRange(1,1)<Temp(1)
   Temp(1)=InvalidRange(2,1);
   InvalidRange(:,1)=[];
   if isempty(InvalidRange)
      IntervalC=Temp;
      return
   end
end


if InvalidRange(2,end)>Temp(2)
   Temp(2)=InvalidRange(1,end);
   InvalidRange(:,end)=[];
   if isempty(InvalidRange)
      IntervalC=Temp;
      return
   end
end

Temp1=[Temp(1) InvalidRange(2,:)];
Temp2=[InvalidRange(1,:) Temp(2)];

IntervalC=[Temp1;Temp2];