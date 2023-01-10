function y=cicular_transfer(data,interval);
y=data;
if ~isempty(data);
m=find((data./interval)~=0);
y(m)=floor(data(m)./interval)+1;
n=linspace(1,length(data),length(data));
mm=setdiff(n,m);
y(mm)=floor(data(mm)./interval);
else
    y=[];
end