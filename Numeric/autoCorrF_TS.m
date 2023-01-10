function [c,lag]=autoCorrF_TS(reference,Timerange,range,bin_width)


Valid=[];
for i=1:length(Timerange(1,:))
    Valid=[Valid;find(reference>=(Timerange(1,i))&reference<=(Timerange(2,i)))];
end

reference=reference(Valid);

y=crosscoreelograms1(reference,reference,range);

y=[y;range(1)+bin_width/2];
y=[y;range(2)-bin_width/2];

y(abs(y)<bin_width/2)=[];

[m,field]=hist(y,floor(diff(range)/bin_width));
m(1)=m(1)-1;
m(length(m))=m(length(m))-1;
num_count=m;
c=num_count/length(reference);
lag=field;