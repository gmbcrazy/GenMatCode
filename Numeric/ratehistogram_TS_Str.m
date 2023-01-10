function y=ratehistogram_TS_Str(data,timerange,bin_width)

%%%%%%%%a structure output is created for multiple time period
%%%%%%%%y(i).Data is the histogram in timerange(:,i);

%%%%%%%if step is 

% timerange=timerange/1000;
% bin_width=bin_width/1000;
% step=step/1000;
for i=1:size(timerange,2)
[y(i).Data,y(i).Time]=ratehistogram_TS(data,timerange(:,i),bin_width);
end



