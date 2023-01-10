p.timerange=[0;200];
p.ArtifactPeriod=[-0.1;0.2];
p.lowSpeedThreshold=0;
p.highSpeedThreshold=80;
p.fileimage='F:\DataTrack Lu\Zone 2014.1.3-\step3.tif';
p.ImageSize=[132.99 132.99];
p.binWidth=4;
p.minBinTime=0.001;

Variable.Name='CWCh11-7F6-12';
fileName='D:\my program\UPMC\Nex\psd analysis\NaviReward-M18-110214002-f.nex';

[VariMap,VariMapSample,VariMapXY,aRowAxis,aColAxis]=MapCont(fileName,Variable,p);

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

figure;

% a=imagesc(aColAxis,aRowAxis,VariMap,[0 max(max(VariMap))]);hold on
temp=VariMap;
temp(isnan(temp))=0;
a=imagesc(aColAxis,aRowAxis,SmoothDec(temp,[0.5 0.5]),[0 max(max(temp))]);hold on

set(a,'alphadata',~isnan(VariMap));
% plot(rows,cols,'r.');hold on;

h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% 
set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
set(gca,'xlim',[Xstart Xend+20],'ylim',[Ystart Yend+20],'box','off','xcolor',[1 1 1],'ycolor',[1 1 1],'fontsize',12);

hold on;
figure;
surf(aColAxis,aRowAxis(end:(-1):1),VariMap);axis xy

% figure;
% for i=1:length(aColAxis)
%    for j=1:length(aRowAxis)
%        if ~isempty(VariMapSample{i,j})
%        plot3(VariMapXY.X{i,j},VariMapXY.Y{i,j},VariMapSample{i,j},'r.');hold on;
%        end
%    end
% end
% a=imagesc(aColAxis,aRowAxis,VariMap,[0 max(max(VariMap))]);hold on
% 






