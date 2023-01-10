function [c,lag]=crossCorrF_TS(x,reference,Timerange,range,bin_width)


MaxLag=ceil(max(abs(range))/bin_width);


[y,time]=ratehistogram_TS(x,Timerange,bin_width);

[ref,time]=ratehistogram_TS(reference,Timerange,bin_width);

[c,lag]=xcorr(y(:),ref(:),MaxLag);

c=c/sum(ref);
lag=lag*bin_width;
c=c(:)';
