
FileIndex=[1 2 3 4 5 6];

WaveParam.ALLFreq=[1:0.5:50];


Fband{1}=[4;8];
Fband{2}=[8;12];
Fband{3}=[4;12];
Fband{4}=[20;30];

% Fband{2}=[15;20];
% Fband{3}=[20;50];
% Fband{4}=[50;100];
% Fband{5}=[120;250];


for iii=1:length(Fband)
    
Chan{1}.Name='HippCh7AD';
Chan{2}.Name='CereCh11AD';
RefPara.Name='NaviRewardTs';
WaveParam.timerange=[0;720];
% WaveParam.Freq=[5:0.2:12];
WaveParam.Freq=Fband{iii};

WaveParam.wname='morl';
WaveParam.Samplingrate=1000;
WaveParam.ntw=100;
WaveParam.nsw=7;
WaveParam.range=[-2 2];


p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
p.ImageSize=[132.99 132.99];
p.sampleTime=1/25;
p.binWidth=2;
p.minBinTime=0.02;
p.smoothfactor=[1 1];
p.lowSpeedThreshold=0;
p.highSpeedThreshold=50;
p.RawminBinTime=0.1;
p.alphaValue=10;



arena=imread(p.fileimage);
% imagesc(arena);
ImageSize=[132.99 132.99];
    ImageX=[1:512]*ImageSize(1)/512;
    ImageY=[1:512]*ImageSize(2)/512;

% close all
for j=1:length(FileIndex)
for i=1:length(NexFile{FileIndex(j)}.Individual)
fileName=[NexFile{FileIndex(j)}.General num2str(NexFile{FileIndex(j)}.Individual(i)) '-f.nex'];

[MapSpec{j,i},aRowAxis,aColAxis]=MapCohWavelet(fileName,Chan,WaveParam,p);

end
end

MapALlband{iii}=MapSpec;
% MapSpec{j,i}=MapALlband{iii};
% for j=1:length(FileIndex)
%     
%     figure;
% for i=1:length(NexFile{FileIndex(j)}.Individual)
% 
% subplot(3,5,i)
% h=imagesc(aColAxis,aRowAxis,smooth2a(MapSpec{j,i}.mapC,2,2));
% set(h,'alphadata',~isnan(MapSpec{j,i}.mapC));
% set(gca,'clim',[0 1],'box','off');
% hold on;
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% % hold on;axis xy
% 
% 
% subplot(3,5,i+5)
% h=imagesc(aColAxis,aRowAxis,log(smooth2a(MapSpec{j,i}.mapS1,2,2)));
% set(h,'alphadata',~isnan(MapSpec{j,i}.mapS1));
% set(gca,'clim',[-2 0],'box','off');
% hold on;
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% % hold on;axis xy
% 
% 
% subplot(3,5,i+10)
% 
% h=imagesc(aColAxis,aRowAxis,log(smooth2a(MapSpec{j,i}.mapS2,2,2)));
% set(h,'alphadata',~isnan(MapSpec{j,i}.mapS2));
% set(gca,'clim',[-4 -1],'box','off');
% hold on;
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% % hold on;axis xy
% % 
% % hold on;axis xy
% 
% end
% end
% clear MapSpec

end



for j=1:length(FileIndex)
for i=1:length(NexFile{FileIndex(j)}.Individual)
fileName=[NexFile{FileIndex(j)}.General num2str(NexFile{FileIndex(j)}.Individual(i)) '-f.nex'];
[MapV{j,i},aRowAxis,aColAxis]=MapSpeed(fileName,p);
end
end



for iii=1:length(Fband)
    
Chan{1}.Name='HippCh7AD';
Chan{2}.Name='CereCh11AD';
RefPara.Name='NaviRewardTs';
WaveParam.timerange=[0;720];
% WaveParam.Freq=[5:0.2:12];
WaveParam.Freq=Fband{iii};

WaveParam.wname='morl';
WaveParam.Samplingrate=1000;
WaveParam.ntw=100;
WaveParam.nsw=7;
WaveParam.range=[-2 2];


p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
p.ImageSize=[132.99 132.99];
p.sampleTime=1/25;
p.binWidth=2;
p.minBinTime=0.02;
p.smoothfactor=[1 1];
p.lowSpeedThreshold=0;
p.highSpeedThreshold=50;
p.RawminBinTime=0.1;
p.alphaValue=10;



arena=imread(p.fileimage);
% imagesc(arena);
ImageSize=[132.99 132.99];
    ImageX=[1:512]*ImageSize(1)/512;
    ImageY=[1:512]*ImageSize(2)/512;

% close all

for j=1:length(FileIndex)
    
    figure;
for i=1:length(NexFile{FileIndex(j)}.Individual)

subplot(4,5,i)
h=imagesc(aColAxis,aRowAxis,smooth2a(MapALlband{iii}{j,i}.mapC,2,2));
set(h,'alphadata',~isnan(MapALlband{iii}{j,i}.mapC));
set(gca,'clim',[0 1],'box','off');
hold on;
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% hold on;axis xy


subplot(4,5,i+5)
h=imagesc(aColAxis,aRowAxis,log(smooth2a(MapALlband{iii}{j,i}.mapS1,2,2)));
set(h,'alphadata',~isnan(MapALlband{iii}{j,i}.mapS1));
set(gca,'clim',[-2 0],'box','off');
hold on;
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% hold on;axis xy


subplot(4,5,i+10)
h=imagesc(aColAxis,aRowAxis,log(smooth2a(MapALlband{iii}{j,i}.mapS2,2,2)));
set(h,'alphadata',~isnan(MapALlband{iii}{j,i}.mapS2));
set(gca,'clim',[-4 -1],'box','off');
hold on;
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);



subplot(4,5,i+15)
h=imagesc(aColAxis,aRowAxis,smooth2a(MapV{j,i}.mapSpeed,2,2));
set(h,'alphadata',~isnan(MapV{j,i}.mapSpeed));
set(gca,'clim',[0 25],'box','off');
hold on;
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
hold on;
plot(MapV{j,i}.X,MapV{j,i}.Y,'color',[0.4 0.4 0.4])
% hold on;axis xy
% hold on;axis xy
% 
% hold on;axis xy

end
end
% clear MapSpec

end