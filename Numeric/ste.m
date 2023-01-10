function s=ste(data)
%%%%%%%for computing stardard error
% [m,n]=size(data);
% m=sum(~isnan(data));
% s=nanstd(data);
% s=s./m.^0.5;
data(isinf(sum(data,2)),:)=[];

m=sum(~isnan(data));
y = nanstd(data);
s=y./m.^0.5;
