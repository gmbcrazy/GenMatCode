function hpol = polarmy_new(theta,rho,line_style,rmaxx,rtick,step_degree,Param)
%POLAR Polar coordinate plot.
% POLAR(THETA, RHO) makes a plot using polar coordinates of
% the angle THETA, in radians, versus the radius RHO.
% POLAR(THETA,RHO,S) uses the linestyle specified in string S.
% See PLOT for a description of legal linestyles.
%
% See also PLOT, LOGLOG, SEMILOGX, SEMILOGY.

% Copyright 1984-2002 The MathWorks, Inc. 
% $Revision: 5.22 $ $Date: 2002/04/08 21:44:28 $

if nargin < 1
error('Requires 2 or 3 input arguments.')
elseif nargin == 2 
if isstr(rho)
line_style = rho;
rho = theta;
[mr,nr] = size(rho);
if mr == 1
theta = 1:nr;
else
th = (1:mr)';
theta = th(:,ones(1,nr));
end
else
line_style = 'auto';
end
elseif nargin == 1
line_style = 'auto';
rho = theta;
[mr,nr] = size(rho);
if mr == 1
theta = 1:nr;
else
th = (1:mr)';
theta = th(:,ones(1,nr));
end
end
if isstr(theta) | isstr(rho)
error('Input arguments must be numeric.');
end
if ~isequal(size(theta),size(rho))
error('THETA and RHO must be the same size.');
end

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');
ls = get(cax,'gridlinestyle');
ls = '-';

% Hold on to current Text defaults, reset them to the
% Axes' font attributes so tick marks use them.
fAngle = get(cax, 'DefaultTextFontAngle');
fName = get(cax, 'DefaultTextFontName');
fSize = get(cax, 'DefaultTextFontSize');
fWeight = get(cax, 'DefaultTextFontWeight');
fUnits = get(cax, 'DefaultTextUnits');
set(cax, 'DefaultTextFontAngle', get(cax, 'FontAngle'), ...
'DefaultTextFontName', get(cax, 'FontName'), ...
'DefaultTextFontSize', get(cax, 'FontSize'), ...
'DefaultTextFontWeight', get(cax, 'FontWeight'), ...
'DefaultTextUnits','data')

% only do grids if hold is off
if ~hold_state

% make a radial grid
hold on;
maxrho = max(abs(rho(:)));
hhh=plot([-maxrho -maxrho maxrho maxrho],[-maxrho maxrho maxrho -maxrho]);
set(gca,'dataaspectratio',[1 1 1],'plotboxaspectratiomode','auto')
v = [get(cax,'xlim') get(cax,'ylim')];
ticks = sum(get(cax,'ytick')>=0);
delete(hhh);
% check radial limits and ticks
rmin = 0; rmax = v(4); rticks = max(ticks-1,2);
if rticks > 5 % see if we can reduce the number
if rem(rticks,2) == 0
rticks = rticks/2;
elseif rem(rticks,3) == 0
rticks = rticks/3;
end
end
%///////////////////////////////////////////////////
% attention I added these lines 
% rtick and rmax are new function inputs
rticks=rtick*2;
rmax=rmaxx;
rmin=-rmax;
rmin=0;

%//////////////////////////////////////////////////

% define a circle
th = 0:pi/50:2*pi;
xunit = cos(th);
yunit = sin(th);
% now really force points on x/y axes to lie on them exactly
inds = 1:(length(th)-1)/4:length(th);
xunit(inds(2:2:4)) = zeros(2,1);
yunit(inds(1:2:5)) = zeros(3,1);
% plot background if necessary
if ~isstr(get(cax,'color')),
patch('xdata',xunit*rmax,'ydata',yunit*rmax, ...
'edgecolor',tc,'facecolor',get(gca,'color'),...
'handlevisibility','off');
end

% draw radial circles
c82 = cos(82*pi/180);
s82 = sin(82*pi/180);
rinc = (rmax-rmin)/rticks;
for i=(rmin+rinc):rinc:rmax
hhh = plot(xunit*i,yunit*i,ls,'color',tc,'linewidth',0.3,'handlevisibility','off');
text((i+rinc/20)*c82,(i+rinc/20)*s82, ...
[' ' num2str(i)],'verticalalignment','bottom','handlevisibility','off')
end
set(hhh,'linestyle','-') % Make outer circle solid

% plot spokes
th = (1:6)*2*pi/12;

th=[step_degree:step_degree:360]/180*pi;


cst = cos(th); snt = sin(th);
cs = [cst*rmax; cst*rmax*19/20];
sn = [snt*rmax; snt*rmax*19/20];
plot(cs,sn,ls,'color',tc,'linewidth',0.3,'handlevisibility','off')

% annotate spokes in degrees
rt = 1.1*rmax;

text(rt*cos(pi/4),rt*sin(pi/4),num2str(rmax))

% for i = 1:length(th)
% text(rt*cst(i),rt*snt(i),int2str(i*30),...
% 'horizontalalignment','center',...
% 'handlevisibility','off');
% if i == length(th)
% loc = int2str(0);
% else
% loc = int2str(180+i*30);
% end
% text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center','handlevisibility','off')
% end

% set view to 2-D
view(2);
% set axis limits
axis(rmax*[-1 1 -1.15 1.15]);
end

% Reset defaults.
set(cax, 'DefaultTextFontAngle', fAngle ,'DefaultTextFontName', fName ,'DefaultTextFontSize', fSize,'DefaultTextFontWeight', fWeight,'DefaultTextUnits',fUnits );

% transform data to Cartesian coordinates.
xx = rho.*cos(theta);
yy = rho.*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
q = plot(xx,yy);
else
q = plot(xx,yy,line_style);
end
if nargout > 0
hpol = q;
end
if ~hold_state
set(gca,'dataaspectratio',[1 1 1]), axis off; set(cax,'NextPlot',next);
end
set(get(gca,'xlabel'),'visible','on')
set(get(gca,'ylabel'),'visible','on') 