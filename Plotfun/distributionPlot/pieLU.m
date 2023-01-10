function a=pieLU(x,colorP,varargin)

b=find(x==0);
x(b)=[];
colorP(b,:)=[];

if nargin==3
lab=varargin{1};
lab(b)=[];
else
for i=1:length(x)
    lab{i}=showNum(x(i),0); 
end
end
if nargin==2
a=pie(x,zeros(size(x)),lab);
elseif nargin==3
%     c=varargin{1};
%     c(b)=[];
    a=pie(x,lab);
   
else
end
for i=1:length(x)
    set(a(i*2-1),'facecolor',colorP(i,:),'edgecolor','none'); 
end
set(get(gca,'parent'),'color','w');