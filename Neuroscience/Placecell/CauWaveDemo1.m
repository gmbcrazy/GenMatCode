close all
clear all
fileName='F:\Lu Data\Mouse011\step3\LDL\07062013\NaviReward-M11-070613002-f.nex'
WaveParam.timerange=[430;460];
timeshow=[WaveParam.timerange(1)+5;WaveParam.timerange(2)-5];

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


% figure;
% imagesc(Data{1}.Time,F(end:-1:1),log(abs(WCS)));axis xy;colorbar

figure;
subplot(3,1,1)
% imagesc(Data{1}.Time,F(end:-1:1),abs(WCOH));axis xy;colorbar
imagesc(Data{1}.Time,F(end:-1:1),log(abs(WCS)));axis xy;colorbar
set(gca,'ylim',[0 50]);
% set(gca,'clim',[0 1],'ylim',[0 50],'xlim',timeshow);
colorbar

subplot(3,1,2)
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S1)));axis xy;colorbar
% set(gca,'clim',[-3 -0.5],'ylim',[0 50],'xlim',timeshow)
set(gca,'ylim',[0 50],'clim',[-12 4])

colorbar

hold on

plot(Data{3}.Time,Data{3}.Data,'color',[0.1 0.1 0.1],'linewidth',2)

subplot(3,1,3)
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S2)));axis xy;colorbar
% set(gca,'clim',[-5 -1],'ylim',[0 50],'xlim',timeshow)
set(gca,'ylim',[0 50],'clim',[-12 4])

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
cfg.method       = 'mtmfft';

cfg.foi          = 2:1:50;                         % analysis 2 to 30 Hz in steps of 2 Hz 
cfg.t_ftimwin    = ones(length(cfg.foi),1).*0.5;   % length of time window = 0.5 sec
cfg.toi          = Data{1}.Time(1):0.001:Data{1}.Time(end);                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)

cfg              = [];
cfg.output       = 'pow';
cfg.output       = 'powandcsd';
% cfg.channel      = 'MEG';
cfg.method       = 'mtmconvol';
cfg.taper        = 'hanning';
cfg.foi          = 2:2:50;                         % analysis 2 to 30 Hz in steps of 2 Hz 
cfg.t_ftimwin    = ones(length(cfg.foi),1).*2;   % length of time window = 0.5 sec
cfg.toi          = Data{1}.Time(1):2:Data{1}.Time(end);                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
TFRLu = ft_freqanalysis(cfg, dataLu)




cfg            = [];
cfg.output     = 'powandcsd';
cfg.method     = 'mtmfft';
% cfg.foilim     = [5 50];
cfg.foi          = 5:4:50;                         % analysis 2 to 30 Hz in steps of 2 Hz 

cfg.toi          = Data{1}.Time(1):1:Data{1}.Time(end);                  % time window "slides" from -0.5 to 1.5 sec in steps of 0.05 sec (50 ms)
cfg.tapsmofrq  = 3;
% cfg.keeptrials = 'yes';
cfg.channel    = {'Hipp' 'Cere'};
cfg.channelcmb = {'Hipp' 'Cere'};
cfg.t_ftimwin    = ones(length(cfg.foi),1).*2;   % length of time window = 0.5 sec
TFRLu           = ft_freqanalysis(cfg, dataLu)


cfg            = [];
cfg.method     = 'coh';
cfg.channelcmb = {'Hipp' 'Cere'};
fd             = ft_connectivityanalysis(cfg, TFRLu);







TFRLu = ft_freqanalysis(cfg, dataLu);

imagesc(abs(squeeze(TFRLu.crsspctrm)))


TFRLuNew=TFRLu;
TFRLuNew.crsspctrm=[];
TFRLuNew.crsspctrm=[];


TFRLuNew.crsspctrm(1,2,:,:)=squeeze(TFRLu.crsspctrm);
TFRLuNew.crsspctrm(2,1,:,:)=squeeze(TFRLu.crsspctrm);
TFRLuNew.crsspctrm(1,1,:,:)=squeeze(TFRLu.powspctrm(1,:,:));
TFRLuNew.crsspctrm(2,2,:,:)=squeeze(TFRLu.powspctrm(2,:,:));


TFRLuNew.crsspctrm(1,1,2,:,:)=squeeze(TFRLu.crsspctrm);
TFRLuNew.crsspctrm(1,2,1,:,:)=squeeze(TFRLu.crsspctrm);
TFRLuNew.crsspctrm(1,1,1,:,:)=squeeze(TFRLu.powspctrm(1,:,:));
TFRLuNew.crsspctrm(1,2,2,:,:)=squeeze(TFRLu.powspctrm(2,:,:));
[c, v, outcnt] = ft_connectivity_corr(TFRLuNew)


cfg            = [];
cfg.method     = 'coh';
cfg.channelcmb = {'Hipp' 'Cere'};

channelcmb{1,1}='Hipp';
channelcmb{1,2}='Cere';


fd= ft_connectivityanalysis(cfg, TFRLu);

figure;
imagesc(fd.time,fd.freq,squeeze(fd.cohspctrm));

[output] = ft_connectivity_csd2transfer(TFRLuNew,'channelcmb',channelcmb);

figure;
subplot(3,1,2)
a=sqrt(abs(squeeze(TFRLu.powspctrm(1,:,:))));
a(isnan(a))=0;
b=sqrt(abs(squeeze(TFRLu.powspctrm(2,:,:))));
b(isnan(b))=0;
c=squeeze(TFRLu.crsspctrm);
c(isnan(c))=0;

a1=squeeze(TFRLu.powspctrm(1,:,:));
b1=squeeze(TFRLu.powspctrm(2,:,:));

a2=sqrt(smoothCFSLu(abs(a1).^2,1,5,25));
b2=sqrt(smoothCFSLu(abs(b1).^2,1,5,25));

c1=conj(a1).*b1;
c2=squeeze(TFRLu.crsspctrm);
c3=smoothCFSLu(c2.^2,1,5,25);

coh=(abs(c3))./(a2.*b2);
imagesc(cfg.toi,cfg.foi,log(abs(a)));axis xy;colorbar
set(gca,'ylim',[0 50],'clim',[-12 4])


% figure;
% subplot(3,1,1);
% imagesc(cfg.toi,cfg.foi,log(sqrt(abs(c1))));axis xy;colorbar
% set(gca,'ylim',[0 50],'clim',[-12 4])
% 
% subplot(3,1,2);
% imagesc(cfg.toi,cfg.foi,log(abs(c2)));axis xy;colorbar
% set(gca,'ylim',[0 50],'clim',[-12 4])
% 
% subplot(3,1,3);
% imagesc(cfg.toi,cfg.foi,log(abs(c3)));axis xy;colorbar
% set(gca,'ylim',[0 50],'clim',[-12 4])
% 
% 

cc=abs(a.*conj(b)).^2./(abs(a).*abs(b));
cc=abs(c).^2./(abs(a).*abs(b));

subplot(3,1,3)
% imagesc(cfg.toi,cfg.foi,log(abs(squeeze(TFRLu.powspctrm(2,:,:)))));axis xy;colorbar
imagesc(cfg.toi,cfg.foi,log(abs(b)));axis xy;colorbar
set(gca,'ylim',[0 50],'clim',[-12 4])

cc=abs(c).^2./(abs(a).*abs(b));


subplot(3,1,1)
% imagesc(cfg.toi,cfg.foi,(abs(squeeze(TFRLu.crsspctrm))));axis xy
% imagesc(cfg.toi,cfg.foi,abs(cc));axis xy
% imagesc(cfg.toi,cfg.foi,log(abs(cc)));axis xy;colorbar
% imagesc(cfg.toi,cfg.foi,log(abs(c2)));axis xy;colorbar
imagesc(cfg.toi,cfg.foi,(abs(coh)));axis xy;colorbar

set(gca,'ylim',[0 50],'clim',[-12 4])



% imagesc(cfg.toi,cfg.foi,log(abs(c)));axis xy
% colorbar

powspctrm

squeeze

             Fs: 300
         nChans: 187
       nSamples: 900
    nSamplesPre: 300
        nTrials: 266
          label: {187x1 cell}
           grad: [1x1 struct]
           orig: [1x1 struct]



