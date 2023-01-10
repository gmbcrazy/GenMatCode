function hh=rose_bar(vector_r,rmaxx,rtick,step_degree)


num_bin=length(vector_r);



x = (0:(num_bin-1))*pi*2/num_bin+pi/num_bin;
  
edges = sort(rem([(x(2:end)+x(1:end-1))/2 (x(end)+x(1)+2*pi)/2],2*pi));
edges = [edges edges(1)+2*pi];

[m,n] = size(vector_r');
mm = 4*num_bin;
r = zeros(mm,1);
r(2:4:mm,:) = vector_r';
r(3:4:mm,:) = vector_r';

zz = edges;
t = zeros(mm,1);
t(2:4:mm) = zz(1:m);
t(3:4:mm) = zz(2:m+1);


h = polarmy(t,r,'k',rmaxx,rtick,step_degree);
% set(h,'color',color)
% mmpolar(t,r,'Rlim',[0 1]);
hold on;
set(gca,'linewidth',0.2)

[a,b] = pol2cart(t,r);  % convert histogram line to polar coordinates
A = reshape(a,4,num_bin);    % reshape 80-element x vector into 20 columns
B = reshape(b,4,num_bin);    % reshape 80-element y vector into 20 columns
hh=patch(A,B,'r');      % plot 20 patches based on the columns of A and B

% set(hh,'edgecolor',color,'facealpha',0.3,'linewidth',2)
% hold on;
% h = polar(t,r);
