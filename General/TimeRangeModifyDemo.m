
Timerange=[1 8;6 12];
InvalidRange=[-8 -2 0 2 2.5 5.2 5.9 7 9 11 18;-5 0 1.2 2.3 5.1 5.8 6.1 8 10 13 20];
figure;
for i=1:length(Timerange)
     plot([Timerange(1,i) Timerange(2,i)],[1 1],'b');hold on
end

for i=1:length(InvalidRange)
     plot([InvalidRange(1,i) InvalidRange(2,i)],[2 2],'r');hold on
end
set(gca,'ylim',[-10 10])

Data=TimeRangeModify(Timerange,InvalidRange);

for i=1:length(Data)
     plot([Data(1,i) Data(2,i)],[1.5 1.5],'g');hold on
end
