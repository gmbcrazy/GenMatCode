function VelocityPeriStim(NexFile)



for i=1:length(NexFile.Individual)
    
    fileName=[NexFile.General num2str(NexFile.Individual(i)) '-f.nex'];
    Vth=2.5;
    DataParam.Name='VelocitySmooth';
%     DataParam.Name='VelocityRaw';

    timerange=[0;720];
    range=[-2;2];
    bin_width=0.04;


[Explore RewardType Dist NormDist TSStim]=NaviCheckNex(fileName,Vth);

DirectIndex=find(NormDist<=pi/2&RewardType==1);
InDirectIndex=find(NormDist>pi/2&RewardType==1);
ForageIndex=find(RewardType==2);
NaviIndex=find(RewardType==1);
DiretColor=[0.5 0.1 1];
iDiretColor=[0.1 0.6 0.8];
ForColor=[0.9 0.3 0.1];
NaviColor=[0.1 0.8 0.1];
figure;

if length(DirectIndex)>=2&&length(InDirectIndex)>=2

[Diraster DataType rastertime DiCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(DirectIndex),timerange,range,bin_width);
[iDiraster DataType rastertime iDiCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(InDirectIndex),timerange,range,bin_width);
[Foreraster DataType rastertime ForeCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(ForageIndex),timerange,range,bin_width);

subplot('position',[0.1 0.45 0.8 0.5]);
error_area(rastertime,mean(Diraster(DiCorrectIn,:)),ste(Diraster(DiCorrectIn,:)),DiretColor,0.3);
hold on;
error_area(rastertime,mean(iDiraster(iDiCorrectIn,:)),ste(iDiraster(iDiCorrectIn,:)),iDiretColor,0.3);
hold on;
error_area(rastertime,mean(Foreraster(ForeCorrectIn,:)),ste(Foreraster(ForeCorrectIn,:)),ForColor,0.3);
hold on;
set(gca,'xlim',range,'ylim',[0 30],'tickdir','out','box','off','ytick',[0:10:30],'xtick',range(1):1:range(2));
% plot(range,[0 0],'k');hold on;plot([range(1) range(1)],[0 30],'k');
xlabel('Time From Reward s');
ylabel('Speed cm/s');

subplot('position',[0.05 0.05 0.28 0.28]);
ExplorePlot(Explore,DirectIndex,DiCorrectIn,DiretColor);hold on;

hold on;
subplot('position',[0.36 0.05 0.28 0.28]);
ExplorePlot(Explore,InDirectIndex,iDiCorrectIn,iDiretColor);

hold on;
subplot('position',[0.67 0.05 0.28 0.28]);
ExplorePlot(Explore,ForageIndex,ForeCorrectIn,ForColor);


set(get(gca,'parent'),'color','w');




elseif length(DirectIndex)<2&&length(InDirectIndex)>=2
    
[Naviraster DataType rastertime NaviCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(NaviIndex),timerange,range,bin_width);
[Foreraster DataType rastertime ForeCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(ForageIndex),timerange,range,bin_width);

error_area(rastertime,mean(Naviraster(NaviCorrectIn,:)),ste(Naviraster(NaviCorrectIn,:)),ForColor,0.3);
hold on;
error_area(rastertime,mean(Foreraster(ForeCorrectIn,:)),ste(Foreraster(ForeCorrectIn,:)),ForColor,0.3);

elseif length(DirectIndex)>=2&&length(InDirectIndex)<2
    
[Diraster DataType rastertime DiCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(DirectIndex),timerange,range,bin_width);
[Foreraster DataType rastertime ForeCorrectIn]=PeriEventRaster(fileName,DataParam,TSStim(ForageIndex),timerange,range,bin_width);

error_area(rastertime,mean(Diraster(DiCorrectIn,:)),ste(Diraster(DiCorrectIn,:)),DiretColor,0.3);
hold on;
error_area(rastertime,mean(Foreraster(ForeCorrectIn,:)),ste(Foreraster(ForeCorrectIn,:)),ForColor,0.3);
hold on;

else
  
end


    
end






function ExplorePlot(Explore,ExploreIn,CorrectInEx,colorP)

ExploreIn=ExploreIn(CorrectInEx);



ImageSize=[132.99 132.99];
ImageX=[1:512]*ImageSize(1)/512;
ImageY=[1:512]*ImageSize(2)/512;
fileimage='F:\DataTrack Lu\M07\Zone\step3.tif';


arena=imread(fileimage);

[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);

rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;

Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);


h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
set(gca,'xlim',[Xstart Xend],'ylim',[Ystart Yend],'box','off','xcolor',[1 1 1],'ycolor',[1 1 1]);


for i=1:length(ExploreIn)
    hold on;

    plot(Explore(ExploreIn(i)).X,Explore(ExploreIn(i)).Y,'color',colorP);hold on;
    plot(Explore(ExploreIn(i)).X(1),Explore(ExploreIn(i)).Y(1),'color',colorP,'marker','*');hold on;
    plot(Explore(ExploreIn(i)).X(end),Explore(ExploreIn(i)).Y(end),'color',colorP,'marker','o');hold on;
end

text(Xend-10,Yend-10,['n=' num2str(length(ExploreIn))]);

% arena;








