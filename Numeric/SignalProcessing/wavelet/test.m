clear all
close all
dt=0.001;
t=[0:1000]*0.001;
X=sin(t*2*pi*8)+randn(size(t))*.1;
X=X(:);
t=t(:);

figure('color',[1 1 1])
% t=(0:1e-8:500e-8)';
% X=sin(t*2*pi*5e6)+randn(size(t))*.1;
% Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.1;
subplot(3,1,1);
plot(t,X)

subplot(3,1,2);

% wt([t X]);
% freq=[1024 512 128 64 32 16 8 4 2 1 0.5 0.25 0.125]*1000;
% set(gca,'ytick',log2(1./freq),'yticklabel',freq/1000)


[wave,period,scale,coi,sig95]=wt([t X],'J1',100);

imagesc(t,log2(period),abs(wave))
freq=[512 256 128 64 32 16 8 4 2 1];

set(gca,'ytick',log2(1./freq),'yticklabel',freq)



subplot(3,1,3);
imagesc(t,period,abs(wave))

freq=[128 64 32 16 8 4 2 1]*dt;
set(gca,'ytick',log2(1./freq))

set(gca,'ytick',log2(1./freq),'yticklabel',freq/dt)
ylabel('Frequency (MHz)')


figure('color',[1 1 1])
t=(0:1e-8:500e-8)';
X=sin(t*2*pi*5e6)+randn(size(t))*.1;
Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.1;
wtc([t X],[t Y])
freq=[128 64 32 16 8 4 2 1];
set(gca,'ytick',log2(1./freq),'yticklabel',freq)
ylabel('Frequency (MHz)')


dt=t(2)-t(1);
s0=2*dt;
scale=400:-2:2;
s0=0.002;
param=-1;
[S1,period1,scale1,coix] = waveletLu(X,0.001,s0,scale,'MORLET',param);


figure;
imagesc(t,log2(scale1),(abs(S1)));axis xy
set(gca,'ytick',(log2(1./scale(1:50:end))),'yticklabel',sort(scale(1:50:end)))







figure('color',[1 1 1])
subplot(2,1,1)
t=(0:1e-8:500e-8)';
X=sin(t*2*pi*5e6)+randn(size(t))*.01;
Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.01;
[wave,period,scale,coi,sig95]=wt([t X]);
imagesc(t,log2(1./scale),abs(wave));
freq=scale*1e6;
set(gca,'ytick',sort(log2(1./freq)))

set(gca,'ytick',log2(1./freq),'yticklabel',freq/1e6)
ylabel('Frequency (MHz)')
subplot(2,1,2)
plot(t,X)













figure('color',[1 1 1])
subplot(2,1,1)
t=(0:1e-8:500e-8)';
X=sin(t*2*pi*5e6)+randn(size(t))*.1;
Y=sin(t*2*pi*5e6+.4)+randn(size(t))*.1;
wt([t X])
freq=[128 64 32 16 8 4 2 1]*1e6;
set(gca,'ytick',log2(1./freq),'yticklabel',freq/1e6)
ylabel('Frequency (MHz)')
subplot(2,1,2)

plot(t,X)













