p.timerange=[0;600];
p.ArtifactPeriod=[-0.1;0.2];
p.lowSpeedThreshold=0;
p.highSpeedThreshold=100;
p.fileimage='F:\DataTrack Lu\Zone 2014.1.3-\step3.tif';
p.ImageSize=[132.99 132.99];
p.binWidth=2;
p.minBinTime=0.001;
p.EgoRange=[-30 30 -30 30];

Variable.Name='CWCh11-7F6-12';
fileName='E:\my program\UPMC\Nex\psd analysis\NaviReward-M18-110214002-f.nex';

[VariMap,VariMapSample,VariMapXY,aRowAxis,aColAxis]=EgoMapCont(fileName,Variable,p);

figure;
a=imagesc(aColAxis,aRowAxis,VariMap,[0 max(max(VariMap))]);hold on

temp=VariMap;
temp(isnan(temp))=0;
a=imagesc(aColAxis,aRowAxis,SmoothDec(temp,[1 1]),[0 max(max(temp))]);hold on
% set(a,'alphadata',~isnan(VariMap));
% plot(rows,cols,'r.');hold on;

% 
% set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
% set(gca,'xlim',[Xstart Xend+20],'ylim',[Ystart Yend+20],'box','off','xcolor',[1 1 1],'ycolor',[1 1 1],'fontsize',12);

hold on;
figure;
surf(aColAxis,aRowAxis,VariMap);axis xy

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






