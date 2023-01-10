function histPlotLUData(data,DisX,color,alpha,varargin)

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



[x,y]=stairs(DisX,data);

% a=area(x,y,'facecolor',color,'LineWidth',LineWidth,'linecolor',color);
a=area(x,y,'facecolor',color,'edgecolor',color,'LineWidth',LineWidth,'LineStyle',LineStyle,'FaceAlpha',alpha);

% set(get(a,'children'),'facealpha',alpha);
% a;
