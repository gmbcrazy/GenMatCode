clear all
filename='F:\Lu Data\Mouse027\ldl no odor\03072014\NaviReward-M27-030714002-f.nex';
timerange=[0;900];
p.fileimage='F:\DataTrack Lu\Zone 2014.1.3-\step3.tif';
p.ImageSize=[130.95 130.95];
p.sampleTime=1/25;
p.binWidth=5;
p.minBinTime=0.02;
p.smoothfactor=[1 1];
p.lowSpeedThreshold=3;
p.highSpeedThreshold=80;
p.RawminBinTime=0.1;
p.alphaValue=1000;

[occ_mapTrial, Vectormap,DistanceTrial, aRowAxis, aColAxis,DistanceIndex]=OccupyMapTrial_Nex(filename,timerange,p);

clear DataRaw
for i=1:length(Vectormap)
    DataRaw(i,:)=Vectormap{i}(:)';
end
[coeff, score, latent, Tsquared, explained] = pca(DataRaw);

fileimage=p.fileimage;
arena=imread(fileimage);
[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);
ImageSize=p.ImageSize;

rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;


% figure;
% imagesc(ImageX,ImageY,arena);hold on
% plot(PosX,PosY,'g');hold on
% plot(rows,cols,'r.');hold on

Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];


%     figure;
%     ImageSize=DayTr.Track(i).ImageSize;
%     ImageX=[1:512]*ImageSize(1)/512;
% %     ImageY=[512:-1:1]*ImageSize(2)/512;
%     ImageY=[1:512]*ImageSize(2)/512;
ImageSize=p.ImageSize;
ImageX=[1:512]*ImageSize(1)/512;
ImageY=[1:512]*ImageSize(2)/512;


[tx,ty]=meshgrid(aColAxis,aRowAxis);hold on;
close all
tx=tx(:);
ty=ty(:);
figure;
d=colormap;
for i=1:length(explained)
    figure;
Path1=reshape(coeff(:,i),length(coeff(:,i))/2,2);
PathX=Path1(:,1);
PathY=Path1(:,2);
index=intersect(find(PathX~=0),find(PathY~=0));

quiver(tx(index),ty(index),PathX(index),PathY(index),2,'color',d(i,:),'linewidth',explained(i)*0.1);hold on;

% quiver(tx(index),ty(index),PathX(index),PathY(index),explained(i)*0.1,'color',d(i,:),'linewidth',explained(i)*0.1);hold on;
end
h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
hold on;
% b=contour(aColAxis,aRowAxis,sqrt(reshape(VectormapX,21,21).^2+reshape(VectormapY,21,21).^2),2,'-');

set(gca,'ydir','reverse');
set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
set(gca,'xlim',[Xstart-10 Xend+10],'ylim',[Ystart-7 Yend+7],'box','off','xcolor',[1 1 1],'ycolor',[1 1 1],'fontsize',12);

