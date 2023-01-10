
close all
clear all

fileName='F:\Lu Data\Mouse020\LDL no odor\27022014\NaviReward-M20-270214002-f.nex'
WaveParam.timerange=[500;550];


timeshow=[WaveParam.timerange(1)+5;WaveParam.timerange(2)-5];
Chan{1}.Name='HippCh8AD';
Chan{2}.Name='CereCh11AD';

for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},WaveParam.timerange);
end
t=Data{1}.Time(:);

[wave,period,scale,coi,sig95]=wt([t Data{1}.Data],'S0',0.04,'J1',25);

[wave,period,scale,coi,sig95]=wtc([t Data{1}.Data],[t Data{2}.Data],'S0',0.01,'J1',60);

figure;
imagesc(t,log2(period),(abs(wave)))
freq=[512 256 128 64 32 16 8 4 2 1];

set(gca,'ytick',log2(1./freq),'yticklabel',freq)
hold on;
[c,h] = contour(t,log2(period),sig95,[1 1],'k'); 




WaveParam.Freq=[1:0.25:40];
ntw=400;
nsw=5;
wname='morl';
fc = centfrq(wname);

F=WaveParam.Freq;
scales=sort(fc./F./0.001);  
scales=sort(fc./F./0.001);  
[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname,'ntw',ntw,'nsw',nsw);


figure;
imagesc(Data{1}.Time,F(end:-1:1),abs(WCOH));axis xy

figure;
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S1)));axis xy


scale=[2:5:800]*0.002;
param=-1;
[X,period,scale,coix] = waveletLu(Data{1}.Data,0.001,scale,'MORLET',param);

figure;
imagesc(t,0.002./period,log(abs(X)));
