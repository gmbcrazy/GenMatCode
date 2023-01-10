
FileIndex=[1 2 3 4 5 6 7];

WaveParam.ALLFreq=[1:0.5:50];


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

close all
for j=1:length(FileIndex)
for i=1:length(NexFile{FileIndex(j)}.Individual)
fileName=[NexFile{FileIndex(j)}.General num2str(NexFile{FileIndex(j)}.Individual(i)) '-f.nex'];

[MapSpec{j,i},aRowAxis,aColAxis]=MapSpeed(fileName,p);

end
end

% MapSpec{j,i}=MapALlband{iii};
for j=1:length(FileIndex)
    
    figure;
for i=1:length(NexFile{FileIndex(j)}.Individual)

subplot(1,5,i)
h=imagesc(aColAxis,aRowAxis,smooth2a(MapSpec{j,i}.mapSpeed,2,2));
set(h,'alphadata',~isnan(MapSpec{j,i}.mapSpeed));
set(gca,'clim',[0 25],'box','off');
hold on;
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
hold on;
plot(MapSpec{j,i}.X,MapSpec{j,i}.Y,'color',[0.2 0.2 0.2])
% hold on;axis xy


end
end
% clear MapSpec

