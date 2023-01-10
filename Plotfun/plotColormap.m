function plotColormap(x,y,varargin)


if nargin==3
   c=varargin{1};
%    c=colormap(c)
else
   c=colormap;
end


colorNum=length(y(:,1));
colorStep=floor(length(c(:,1))/colorNum);
for i=1:colorNum
    colorC=1+colorStep*(i-1);
    plot(x,y(i,:),'color',c(colorC,:));hold on
    
end

