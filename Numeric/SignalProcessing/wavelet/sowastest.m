clear all
close all
dt=0.001;
t=[0:1000]*0.001;
X=sin(t*2*pi*8)+randn(size(t))*.1;
X=X(:);
t=t(:);







  s0=0.001*2;          %lowest calculated scale in units of the time series
  noctave=7;     %number of octaves
  nvoice=10;     %number of voices per octave
  w0=2*pi;       %time/frequency resolution omega_0, parameter of Morlet Wavelet
  sw=0.01;          %length of smoothing window in scale direction is 2*sw*nvoice+1
  tw=0.2;          %length of smoothing window in time direction is 2*s*tw+1
  swabs=3;        %length of smoothing window in scale direction at scale s is 2*swabs+1
  siglevel=0.95; %vector of significance levels for pointwise test, e.g. [0.9 0.95], default 0.95.
  
%   critval=cv;  %matrix of critical values calculated e.g. by criticalvaluesWSP; 
                  % each row contains critical values for the corresponding chosen significance level.
  nreal=1000;    %number of realizations to estimate critical values for the corresponding significance values
  [cv] = criticalvaluesWSP([t X],s0,noctave,nvoice,w0,swabs,tw,siglevel,nreal);
  critval=cv;
  arealsiglevel=0.9; %significance level of the areawise test; 
                   %currently only for siglevel=0.95 and for arealsiglevel=0.9 possible, 
                   %i.e. 90 percent of the area of false positive patches is sorted out
  kernel=0;      %bitmap of the reproducing kernel; 
                   %if not provided, it will be calculated during the areawise test
  markt=-999;    %vector of times to be marked by vertical dotted lines; when set to -999 (default), no lines are plotted.
  marks=-999;    %vector of scales to be marked by horizontal dotted lines; when set to -999 (default), no lines are plotted.
  logscale=false; %when true, the contours are plotted in logarithmic scale
  plotvar=true;  %true when graphical output desired
  units='';      %character string giving units of the data sets.
  color=true;   %true (default): color plot, false: gray scale
  labsc=1;      %scale of labels, default: 1, for two-column manuscripts: 1.5, for presentations: >2
  labtext='';   %puts a label in upper left corner of the plot
  sigplot=1;    %0: no significance test plotted, 1: results from pointwise test, 2: results from areawise test, 3: results from both tests


[wclist] = wsp([t X],s0,noctave,nvoice,w0,sw,tw,swabs,siglevel,critval,nreal,arealsiglevel,kernel,markt,marks,logscale,plotvar,units,color,labsc,labtext,sigplot)





figure('color',[1 1 1])
% t=(0:1e-8:500e-8)';
% X=sin(t*2*pi*5e6)+randn(size(t))*.1;
% Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.1;
subplot(3,1,1);
plot(t,X)

subplot(3,1,2);


imagesc(t,log2(wclist.scales),abs(wclist.modulus)')
freq=[512 256 128 64 32 16 8 4 2 1];

set(gca,'ytick',log2(1./freq),'yticklabel',freq)
