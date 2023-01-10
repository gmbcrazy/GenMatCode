timerange=[167;172];
time_plot=[169;170.5];
time_plot=[169.8404;170.3763];
% time_plot=[165;175];
time_plot=[169.820;170.428];

adname='AD03_ad_000';

% bin_y=bin_y+random('norm',0,std(bin_y)*0.2,1,length(bin_y));
% 
% [S,F,T]=spec_kal('E:\research\data\lab04-niu405-160608\lab04-niu405-130608010-aligned.nex','sig049a',KalmanInput,fre,timerange,F);
path_filename='E:\research\my paper nature\paper graph1\graph1\lab04-niu405-160608000-f.nex';
% timerange=[1125.68;1128.68];
% path_filename='E:\research\data\xk128\04-f.nex';
[bin_x,T]=rate_historam(path_filename,adname,timerange,0.001,0.001);

% plot(bin_x)

s=[0.01:0.01:5 5.1:2:40];

s=exp((3):(-0.01):(-0));

% wname='db7';

wname='gaus1';
% wname='cgau1';

% wname='db1';

% waveinfo('gaus1')
c=cwt(bin_x,s,wname);
f=scal2frq(s,wname,0.001);

fc=centfrq(wname);
% fa=fc*1000./s;
fa=1:500;
s=fa./fc./1000;

% figure;
% plot(f,fa)
f=fa;

figure;
% [x,y]=meshgrid(T,f);
subplot(2,1,1);
imagesc(T,f,(abs(c)));axis xy

set(gca,'xlim',[min(T) max(T)],'ylim',[100 250])

set(gca,'xlim',[min(time_plot) max(time_plot)],'ylim',[0 250])

% surfc(x,y,abs(c));axis xy;
% set(get(gca,'children'),'linestyle','none')
subplot(2,1,2);plot(T,bin_x);set(gca,'xlim',[min(time_plot) max(time_plot)])
% set(gca,'xlim',[min(T) max(T)])
