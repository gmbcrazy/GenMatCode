clear all
filename='F:\Lu Data\Mouse026\LDL no odor\17092014\NaviReward-M26-170914001-f.nex';
cellName='Ch409Cell3';
timerange=[0;725];
p.fileimage='F:\DataTrack Lu\Zone 2014.1.3-\step3.tif';
p.ImageSize=[132.99 132.99];
p.sampleTime=1/25;
p.binWidth=4;
p.minBinTime=0.02;
p.smoothfactor=[1 1];
p.lowSpeedThreshold=3;
p.highSpeedThreshold=60;
p.RawminBinTime=0.1;
p.alphaValue=1000;
% [aMap, posPDF, aRowAxis, aColAxis,temp]=RateMapAdaptive_Nex(filename,cellName,timerange,p);
[aMap, posPDF, aRowAxis, aColAxis,~,~]=RateMap_Nex(filename,cellName,timerange,p);

EdgeSet.Mot={[-0.14:0.02:0.14],[-0.1:0.02:0.9]};
EdgeSet.Acc={[-1:0.05:1],[-1:0.05:1]};
[RotationTS,ARotationTS,AlloDirTS,AlloAccDirTS,FiringMapMotion,AccFiringMapMotion,EdgePlot]=TsHeadMotion_Nex(filename,cellName,timerange,p,EdgeSet);

r = circ_plot(RotationTS)

figure;
NumBin=20; LimM=0.1;
subplot(1,2,1)
[~,LimM]=PhaseHistPolar(RotationTS,NumBin,LimM,[1 0 0]);

subplot(1,2,2)
[~,LimM]=PhaseHistPolar(RotationTS,NumBin,LimM,[1 0 0]);
plot(cos(RotationTS),sin(RotationTS),'ro');
hold on;plot(cos(0:0.01:2*pi),sin(0:0.01:2*pi),'k-');plot([0 0],[-1 1],'k:');plot([-1 1],[0 0],'k:')


[PolData,MeanAng,StdAng,VectorL,Rayleigh]=TsHeadMotion_Nex(filename,cellName,timerange,p);

figure;
q=aMap;
q(isnan(q))=0;
h=imagesc(aColAxis,aRowAxis,boxcarSmoothing(q));hold on
[a,arenasize]=NORMarenaPlot(p,1);

set(gca,'clim',[0 15])
set(h,'alphadata',~isnan(aMap));
    axis xy
 
    
% % % Temp=NORMtrace([aColAxis(:) aRowAxis(:)],p);
% % % aColAxis=Temp(:,1);
% % % aRowAxis=Temp(:,2);
% % % aColAxis=aColAxis(end:-1:1);
% % % 
% aRowAxis=aRowAxis(end:-1:1);
% % % aRowAxis=aRowAxis+p.binWidth/100/2;
% % % aColAxis=aColAxis+p.binWidth/100/2;

% % 
[occ_map,Vectormap,aRowAxis,aColAxis]=TsTriMotionMap_Nex(filename,cellName,timerange,p);
figure;
[tx,ty]=meshgrid(aColAxis,aRowAxis);hold on;
tx=tx(:);
ty=ty(:);
VectormapX=Vectormap(:,1);
VectormapY=Vectormap(:,2);
index=intersect(find(VectormapX~=0),find(VectormapY~=0));

quiver(tx(index),-ty(index),VectormapX(index),-VectormapY(index),2,'r','linewidth',0.5);hold on;
hold on;
% 
[a,arenasize]=NORMarenaPlot(p,1);
set(gca,'xlim',[-0.5 0.5],'ylim',[-0.5 0.5])
% set(gca,'ydir','reverse');
axis xy

Mo=reshape(sqrt(VectormapX.^2+VectormapY.^2),26,26);
r = fieldMotionCohere(Vectormap,zeros(26,26));
hold on;
h=imagesc(aColAxis,aRowAxis,100*boxcarSmoothing(Mo(end:-1:1,:)));
set(h,'alphadata',~isnan(aMap));
set(gca,'clim',[0 25])
[a,arenasize]=NORMarenaPlot(p,1);

axis xy
% set(gca,'clim',[0 0.1])
figure;
h=imagesc(aColAxis,aRowAxis,posPDF)
set(h,'alphadata',~isnan(aMap));

hold on;
% 
[a,arenasize]=NORMarenaPlot(p,1);

set(gca,'xlim',[-0.5 0.5],'ylim',[-0.5 0.5],'clim',[0 0.02])
% set(gca,'ydir','reverse');
axis xy



[~,Motion, aRowAxis, aColAxis,DistIndex,rawTrace]=OccupyMapAdaptiveSmoothing_NexLuOldVersion(filename,timerange,p); 
[occ_map, Vectormap,  aRowAxis, aColAxis, DistanceIndex, direction_map, distance_map, speed_map, pass_map, ppc, ppcCohPass, ppcCohOccp, plv, plvCoh] = OccupyMapAdaptiveSmoothing_Nex(filename,timerange,p);

figure;
[tx,ty]=meshgrid(aColAxis,aRowAxis);hold on;
tx=tx(:);
ty=ty(:);
VectormapX=direction_map(:,1);
VectormapY=direction_map(:,2);
index=intersect(find(VectormapX~=0),find(VectormapY~=0));

quiver(tx(index),ty(index),VectormapX(index),VectormapY(index),2,'r','linewidth',0.5);hold on;
% set(gca,'ydir','reverse');

% plot(rawTrace(:,1),rawTrace(:,2))

hold on;
% 
[a,arenasize]=NORMarenaPlot(p,1);
set(gca,'xlim',[-0.5 0.5],'ylim',[-0.5 0.5])
axis xy


