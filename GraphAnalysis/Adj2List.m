function Edge=Adj2List(Adj)


temp=tril(zeros(size(Adj))-1)+triu(Adj,1);
temp=temp';
temp=temp(:);
temp(temp==-1)=[];
Edge=find(temp>0);       %%%%%%%%%%%%%%%%%%%
