function [loops,ValidIndex]=adj2loop(adjmatrix,varargin)

% imagesc(abs(adjmatrix))
tic
% InValidIndex=find(nansum(sign(adjmatrix))<=1);
ValidIndex=find(nansum(abs(sign(adjmatrix)))>1);

% adjmatrix(InValidIndex,:)=0;
% adjmatrix(:,InValidIndex)=0;
adjmatrixO=adjmatrix;
adjmatrix=adjmatrix(ValidIndex,ValidIndex);

if nargin==2
   MaxNum=varargin{1};
   IndexAll=nchoosek(1:size(adjmatrix,1),MaxNum);
%    if size(IndexAll,1)<=100000
   parfor i=1:size(IndexAll,1)
       temp=adjmatrix(IndexAll(i,:),IndexAll(i,:));
       
       [i1,i2,~]=find(abs(temp)>0);

       Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
ShowEdge=[];
for ii=1:length(Valid)
    ShowEdge(ii,:)=[IndexAll(i,i1(ii)) IndexAll(i,i2(ii))];
%     EdgeC(ii)=1;
end

       net = edge_list2net(ShowEdge);
       loops{i}=LoopsFind(net);

   
   end
else
           [i1,i2,~]=find(abs(adjmatrix)>0);

       Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
ShowEdge=[];
for ii=1:length(Valid)
    ShowEdge(ii,:)=[i1(ii) i2(ii)];
%     EdgeC(ii)=1;
end

  net = edge_list2net(ShowEdge);
 loops=LoopsFind(net);

   
   
end
toc

if iscell(loops)
   loopsOutput(1).loop=1;
   for i=1:length(loops)
       if ~isempty(loops{i})
           if ~isempty(loops{i}(1).loop)
           loopsOutput=[loopsOutput loops{i}];
           end
       end
   end
   loops=loopsOutput(2:end); clear loopsOutput;
end
