function PeriodMarkPlot(TimeRange,MarkY,Color)

hold on;
if ~isempty(TimeRange)
for i=1:size(TimeRange,2)
    plot(TimeRange(:,i),[MarkY MarkY],'color',Color); 
end

end