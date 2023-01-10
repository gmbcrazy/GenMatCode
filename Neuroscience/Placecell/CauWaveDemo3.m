close all
clear all
fileName='F:\Lu Data\Mouse011\step3\LDL\07062013\NaviReward-M11-070613002-f.nex'
WaveParam.timerange=[445;450];
timeshow=[WaveParam.timerange(1)+1;WaveParam.timerange(2)-1];

WaveParam.Freq=[2:0.5:50];
ntw=100;
nsw=7;
wname='morl'

fc = centfrq(wname);

F=WaveParam.Freq;
scales=sort(fc./F./0.001);  
scales=sort(fc./F./0.001);  
Chan{1}.Name='HippCh7AD';
Chan{2}.Name='CereCh11AD';
Chan{3}.Name='VelocitySmooth';

for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},WaveParam.timerange);
end

[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname,'ntw',ntw,'nsw',nsw);


figure;
imagesc(Data{1}.Time,F(end:-1:1),log(abs(WCS)));axis xy;colorbar

figure;
subplot(3,1,1)
imagesc(Data{1}.Time,F(end:-1:1),abs(WCOH));axis xy
set(gca,'clim',[0 1],'ylim',[0 50],'xlim',timeshow);
colorbar

subplot(3,1,2)
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S1)));axis xy
set(gca,'clim',[-3 -0.5],'ylim',[0 50],'xlim',timeshow)
colorbar

hold on

plot(Data{3}.Time,Data{3}.Data,'color',[0.1 0.1 0.1],'linewidth',2)

subplot(3,1,3)
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S2)));axis xy
set(gca,'clim',[-5 -1],'ylim',[0 50],'xlim',timeshow)
colorbar

set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',[0 0 12 12],'PaperSize',[12 12]);




dataLu.hdr.Fs=1000;
dataLu.hdr.nChans=2;
dataLu.hdr.nSamples=length(Data{1}.Time);
dataLu.hdr.nTrials=1;
dataLu.hdr.label{1}='Hipp';
dataLu.hdr.label{2}='Cere';

dataLu.label{1}='Hipp';
dataLu.label{2}='Cere';
dataLu.time{1}=Data{1}.Time(:)';
dataLu.trial{1}=[Data{1}.Data(:)';Data{2}.Data(:)'];
dataLu.fsamle=1000;

% cfg.output       = 'pow';
% cfg.channel      = 'MEG';
% cfg.method       = 'mtmconvol';
% cfg.taper        = 'hanning';

cfg              = [];
cfg.output       = 'powandcsd';
cfg.method       = 'wavelet';
cfg.foi          = 2:2:25;                         % analysis 2 to 30 Hz in steps of 2 Hz 
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = Data{1}.Time(1):0.001:Data{1}.Time(end);                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
TFRLu = ft_freqanalysis(cfg, dataLu);

TFRLuNew=TFRLu;
TFRLuNew.crsspctrm=[];
TFRLuNew.crsspctrm(1,2,:,:)=WCS;
TFRLuNew.crsspctrm(2,1,:,:)=WCS;
TFRLuNew.crsspctrm(1,1,:,:)=CWT_S1;
TFRLuNew.crsspctrm(2,2,:,:)=CWT_S2;
TFRLuNew.powspctrm=[];
TFRLuNew.powspctrm(1,:,:)=CWT_S1;
TFRLuNew.powspctrm(2,:,:)=CWT_S2;
TFRLuNew.time=Data{1}.Time;
TFRLuNew.freq=F(end:-1:1);

TFRLuNew.dimord: 'chan_chan_freq_time';
channelcmb{1,1}='Hipp';
channelcmb{1,2}='Cere';
tol=0.000001;
[output] = ft_connectivity_csd2transfer(TFRLuNew,'channelcmb',channelcmb,'tol',tol);


%   H is the spectral transfer matrix, Nrpt x Nchan x Nchan x Nfreq (x Ntime),
%      or Nrpt x Nchancmb x Nfreq (x Ntime). Nrpt can be 1.
%   Z is the covariance matrix of the noise, Nrpt x Nchan x Nchan (x Ntime),
%      or Nrpt x Nchancmb (x Ntime).
%   S is the cross-spectral density matrix, same dimensionality as H
%[granger, v, n] = ft_connectivity_granger(H, Z, S, varargin)

H(1,:,:,:)=output.transfer;
Z(1,:,:)=squeeze(output.noisecov);
S(1,:,:,:)=output.crsspctrm;
output.dimord='rpt_chan_freq_time';
[granger, v, n] = ft_connectivity_granger(H, Z, S, 'method','instantaneous');

[granger, v, n] = ft_connectivity_granger(output.transfer, squeeze(output.noisecov), output.crsspctrm);

instantaneous
