function Edge=Adj2WeightList(Adj,th)

if isempty(Adj)
   Edge=[];
   return;
end
ii=1;
Edge=[];
for i=1:size(Adj,1)
    for j=(i):(size(Adj,1))
        if (abs(Adj(i,j))>th)
           Edge(ii,:)=[i,j,Adj(i,j)];
           ii=ii+1;
        end
    end
end