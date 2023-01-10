function m=histPlotLU(data,DisX,color,alpha,varargin)

% % % % color='b';

if nargin==5
LineStyle=varargin{1};
LineWidth=1;

elseif nargin==6
LineStyle=varargin{1};
LineWidth=varargin{2};
else
    LineStyle='none';
    LineWidth=1;
end

%%%%%%%%%%%%%%Number of Bin
if length(DisX)==1
   NumBin=DisX;
   [~,DisX]=discretize(data,NumBin);
   
end
%%%%%%%%%%%%%%Number of Bin

m=histc(data,DisX);
[x,y]=stairs(DisX,m);
% a=area(x,y,'facecolor',color,'LineWidth',LineWidth,'linecolor',color);
a=area(x,y,'facecolor',color,'facealpha',alpha,'edgecolor',color,'LineWidth',LineWidth,'LineStyle',LineStyle);

% set(get(a,'children'),'facealpha',alpha);
% a;
