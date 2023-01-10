fnam='E:\Presentation\Wavelet\';

close all
clear all
fileName='F:\Lu Data\Mouse011\step3\LDL\07062013\NaviReward-M11-070613002-f.nex'
WaveParam.timerange=[410;510];

% fileName='F:\Lu Data\Mouse014\ldl\LDL no object\06082013\NaviReward-M14-060813004-f.nex'
% WaveParam.timerange=[310;410];
% 

% fileName='F:\Lu Data\Mouse014\ldl\LDL no object\18072013\NaviReward-M14-180713002-f.nex'
% WaveParam.timerange=[200;240];
% 
% 
% fileName='F:\Lu Data\Mouse023\LDL no odor\10042014\NaviReward-M23-100414002-f.nex'
% WaveParam.timerange=[530;610];


timeshow=[WaveParam.timerange(1)+2;WaveParam.timerange(2)-2];

WaveParam.Freq=[2:0.25:60];
ntw=200;
nsw=5;
wname='morl';
fc = centfrq(wname);

F=WaveParam.Freq;
scales=sort(fc./F./0.001);  
[scales I]=sort(fc./F./0.001);  
Chan{1}.Name='HippCh8AD';
Chan{2}.Name='CereCh11AD';



for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},WaveParam.timerange);
end


[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname,'ntw',ntw,'nsw',nsw);

figure;
subplot(4,1,1)
imagesc(Data{1}.Time,F(end:-1:1),abs(WCOH));axis xy
set(gca,'clim',[0 1],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow);
colorbar

DataD=Data;
Rate=5;
for i=1:length(Chan)
%     DataD{i}=ContArtRemoveNex(fileName,Chan{i},WaveParam.timerange,Rate);
DataD{i}.Data=decimate(DataD{i}.Data,Rate);
DataD{i}.Time=downsample(DataD{i}.Time,Rate);


end

FS=[4:0.5:12];
[scales I]=sort(fc./FS./0.001/Rate);

smoothW=20;
ntw=20;
nsw=5;

[SWCOH,SWCS,SCWT_S1,SCWT_S2]=wcoherLU(zscore(DataD{1}.Data),zscore(DataD{2}.Data),scales,wname,'ntw',ntw,'nsw',nsw);
theta=[6;12];
Index=find(FS>=theta(1)&FS<=theta(2));
CohTheta=SmoothDec(mean(abs(SWCOH(I(Index),:))),smoothW);
S1Theta=SmoothDec(mean(abs(SCWT_S1(I(Index),:))),smoothW);

subplot(4,1,2)
plot(DataD{1}.Time,CohTheta)
set(gca,'clim',[0 1],'ylim',[0 1],'xlim',timeshow);
colorbar;


subplot(4,1,3)
imagesc(Data{1}.Time,F(end:-1:1),10*log10(abs(CWT_S1)));axis xy
set(gca,'clim',[-10 10],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow);
colorbar;

subplot(4,1,4)
plot(DataD{1}.Time,S1Theta)
set(gca,'clim',[0 1],'ylim',[0 5],'xlim',timeshow);
colorbar;


