function a=pie3LU(x,colorP,varargin)

b=find(x==0);
x(b)=[];
colorP(b,:)=[];
for i=1:length(x)
    lab{i}=showNum(x(i),0); 
end

if nargin==2
a=pie3(x,zeros(size(x)),lab);
elseif nargin==3
    c=varargin{1};
    c(b)=[];
a=pie3(x,zeros(size(x)),c);
   
else
end
for i=1:length(x)
    set(a((i-1)*4+3),'facecolor',colorP(i,:),'edgecolor','k'); 
    set(a((i-1)*4+2),'facecolor',colorP(i,:),'edgecolor','k','linestyle','none'); 
    set(a((i-1)*4+1),'facecolor',colorP(i,:),'edgecolor','k'); 

end