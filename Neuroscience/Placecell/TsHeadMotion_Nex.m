function [RotationTS,ARotationTS,AlloDirTS,AlloAccDirTS,FiringMapMotion,AccFiringMapMotion,EdgePlot]=TsHeadMotion_Nex(filename,cellName,timerange,p,EdgeSet)
% % [aMap, posPDF, aRowAxis, aColAxis, rawData,rawMap,spikeMap]=RateMap_Nex(filename,cellName,timerange,p)

% filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';
% cellName='Ch13Cell1';
%p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
%p.ImageSize=[132.99 132.99];
% p.sampleTime=1/adfreq;
% p.binWidth=2;
% p.minBinTime=0.02;
% p.smoothfactor=[1 1];
% p.lowSpeedThreshold=5;
% p.highSpeedThreshold=0;
% p.RawminBinTime=0.1;
% p.alphaValue=1000;
if iscell(cellName)
    Spikes=[];
    for i=1:length(cellName)
        
        nexFile = readNexAll(filename,cellName{i});
        if isfield(nexFile,'neurons')
           [~, Spikestemp] = nex_ts2(filename, cellName{i});
           Spikes=[Spikes;Spikestemp(:)];
        elseif isfield(nexFile,'markers')
               Spikestemp=nexFile.markers.timestamps;

               Spikes=[Spikes;Spikestemp(:)];

        else
        end
    
    end
    Spikes=sort(Spikes);
    n=length(Spikes);
else
            nexFile = readNexAll(filename,cellName);

            if isfield(nexFile,'neurons')

                [~, Spikes] = nex_ts2(filename, cellName);
            else
               Spikes=nexFile.markers{1}.timestamps;

            end
end



Spikes=Spikes(:);
     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;Spikes(timerange(1,i)<Spikes&Spikes<timerange(2,i))];
     end
     
Spikes=temp_sig;

[adfreq, NumPos, ts, fn, PosX] =nex_cont2(filename, 'PosXSmooth');
[adfreq, NumPos, ts, fn, PosY] =nex_cont2(filename, 'PosYSmooth');

rawData.Trace=[PosX(:) PosY(:)];

Lag=ts;

fileimage=p.fileimage;
arena=imread(fileimage);


%     figure;
%     ImageSize=DayTr.Track(i).ImageSize;
%     ImageX=[1:512]*ImageSize(1)/512;
% %     ImageY=[512:-1:1]*ImageSize(2)/512;
%     ImageY=[1:512]*ImageSize(2)/512;
ImageSize=p.ImageSize;
ImageX=[1:512]*ImageSize(1)/512;
ImageY=[1:512]*ImageSize(2)/512;

%     ImageX=[1:512];
%     ImageY=[1:512];
    
% imagesc(ImageX,ImageY,arena);hold on
% temp=double(arena);

[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);

rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;


% figure;
% imagesc(ImageX,ImageY,arena);hold on
% plot(PosX,PosY,'g');hold on
% plot(rows,cols,'r.');hold on

Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
% plot(Center(1),Center(2),'b*');hold on;
% plot([Xstart Xstart],[Ystart Yend],'r:');hold on;
% plot([Xend Xend],[Ystart Yend],'r:');hold on;
% plot([Xstart Xend],[Ystart Ystart],'r:');hold on;
% plot([Xstart Xend],[Yend Yend],'r:');hold on;
% 
% axis xy

RX=Xend-Xstart;
RY=Yend-Ystart;

posTime=((1:NumPos)-1)*p.sampleTime+Lag;
     validIndex=[];
     for i=1:length(timerange(1,:))
         validIndex=[validIndex;find(timerange(1,i)<posTime&posTime<timerange(2,i))];
     end
     
     PosX=PosX(validIndex);
     PosY=PosY(validIndex);
     posTime=posTime(validIndex);

NormTrace=NORMtrace([PosX(:) PosY(:)],p);
rawData.Trace=NormTrace;

[x,y,t]=SpeedThreshold(PosX,PosY, posTime,p.lowSpeedThreshold, p.highSpeedThreshold);

% [x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime-0.8,p.lowSpeedThreshold, p.highSpeedThreshold);

% [occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,Xstart,Ystart,Xend,Yend,p);
% yAxis=ImageSize(2)-yAxis;
% figure;subplot(1,2,1);imagesc(xAxis, yAxis,rawMap);subplot(1,2,2);imagesc(xAxis, yAxis,occ_map);hold on;
sum(isnan(x));
[spkx,spky,spkInd] = spikePos(Spikes,x,y,t);
% [aMap, rawMap, aRowAxis, aColAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
                          
Invalid=find(spkInd>(length(x)-1));
if ~isempty(Invalid)
    spkx(Invalid)=[];
    spky(Invalid)=[];
    spkInd(Invalid)=[];
    [num2str(length(Invalid)) 'spikes removed']
end



% [occ_map,IndexMap,rawMap, aRowAxis, aColAxis] = OccupancyVector_map(spkx, spky,Xstart,Ystart,Xend,Yend,p);
% aRowAxis=ImageSize(2)-aRowAxis;

x=x(:);
y=y(:);

NormTrace=NORMtrace([x y],p);
x=NormTrace(:,1);
y=NormTrace(:,2);

vectorPosition=[diff(x) diff(y)];
Motion_Vector=vectorPosition;
directVector = vectorPosition./[sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)  sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)]; % devision by each vector-length
accerVector=diff(Motion_Vector);
accerDirVector=accerVector./[sqrt(accerVector(:,1).^2+accerVector(:,2).^2)  sqrt(accerVector(:,1).^2+accerVector(:,2).^2)]; % devision by each vector-length

% [DirAng,~]=cart2pol(directVector);


V1=directVector(1:(end-1),:);
V2=directVector(2:end,:);

Rotation=-asin(V1(:,1).*V2(:,2)-V2(:,1).*V1(:,2))+pi/2;

AV1=accerDirVector(1:(end-1),:);
AV2=accerDirVector(2:end,:);

ARotation=-asin(V1(1:(end-1),1).*AV2(:,2)-AV2(:,1).*V1(1:(end-1),2))+pi/2;

Motion_Vector=Motion_Vector(1:(end-1),:);
[AlloDir,MotionR]=cart2pol(Motion_Vector(:,1),Motion_Vector(:,2));
MotionR=MotionR/p.sampleTime;
% % MotionR=sqrt(Motion_Vector(:,1).^2+Motion_Vector(:,2).^2)/p.sampleTime;
[MotionCart(:,1),MotionCart(:,2)]=pol2cart(Rotation,MotionR);

%%%%%%%%if Rotation > 0, conterclockwise, go left
%%%%%%%%if Rotation < 0, clockwise, go right
spkInd(find(spkInd>length(V1)))=[];
MotionCartTS=MotionCart(spkInd,:);
AlloDirTS=AlloDir(spkInd);

RotationTS=Rotation(spkInd);
directVectorTS=directVector(spkInd,:);
Motion_VectorTS=Motion_Vector(spkInd,:);

[OccMotion,EdgePlot.Mot]=hist3([MotionCart],'edges',EdgeSet.Mot);
RawOccMotion=OccMotion;
[MotionMapTS,~]=hist3([MotionCartTS],'edges',EdgeSet.Mot);
OccMotion=smooth2a(OccMotion,1);
MotionMapTS=smooth2a(MotionMapTS,1);
FiringMapMotion=smooth2a(MotionMapTS./OccMotion,1)/p.sampleTime;
FiringMapMotion(OccMotion==0)=nan;
FiringMapMotion(RawOccMotion<=p.RawminBinTime)=nan;
FiringMapMotion(OccMotion<=p.minBinTime)=nan;


accerVector=accerVector(1:(end-1),:);
[AlloAccDir,accerMotionR]=cart2pol(accerVector(:,1),accerVector(:,2));

accerMotionR=accerMotionR/p.sampleTime/p.sampleTime;
% % % accerMotionR=sqrt(accerVector(:,1).^2+accerVector(:,2).^2);
[AccMotionCart(:,1),AccMotionCart(:,2)]=pol2cart(ARotation,accerMotionR);

spkInd(find(spkInd>length(AV1)))=[];
AccMotionCartTS=AccMotionCart(spkInd,:);
accerVectorTS=accerVector(spkInd,:);
accerDirVectorTS=accerDirVector(spkInd,:);
AlloAccDirTS=AlloAccDir(spkInd);
ARotationTS=ARotation(spkInd);

[AccOccMotion,EdgePlot.Acc]=hist3([AccMotionCart],'edges',EdgeSet.Acc);
RawAccOccMotion=AccOccMotion;
[AccMotionMapTS,~]=hist3([AccMotionCartTS],'edges',EdgeSet.Acc);
AccOccMotion=smooth2a(AccOccMotion,1);
AccMotionMapTS=smooth2a(AccMotionMapTS,1);
AccFiringMapMotion=smooth2a(AccMotionMapTS./AccOccMotion,1)/p.sampleTime;
AccFiringMapMotion(AccOccMotion==0)=nan;

AccFiringMapMotion(RawAccOccMotion<=p.RawminBinTime)=nan;
AccFiringMapMotion(AccOccMotion<=p.minBinTime)=nan;


RotationTS(isnan(RotationTS))=[];
ARotationTS(isnan(ARotationTS))=[];

AccFiringMapMotion=AccFiringMapMotion';
FiringMapMotion=FiringMapMotion';
%%%%%%%%if Rotation > 0, conterclockwise, go left
%%%%%%%%if Rotation < 0, clockwise, go right
% % % spkInd(find(spkInd>length(V1)))=[];
% % % Rotation=Rotation(spkInd);
% % % directVector=directVector(spkInd,:);
% % % Motion_Vector=Motion_Vector(spkInd,:);
% % % accerVector=accerVector(spkInd,:);
% % % 

% % % % [~,MotionLength]=cart2pol(Motion_Vector)
% % % % 
% % % % V1=vectorPosition(1:(end-1),:);
% % % % V2=vectorPosition(2:end,:);
% % % % 
% % % % spkInd(find(spkInd>length(V1)))=[];
% % % % 
% % % % V1=V1(spkInd,:);
% % % % V2=V2(spkInd,:);
% % % % 
% % % % Invalid=isnan(sum(V1,2)+sum(V2,2));
% % % % V1(Invalid,:)=[];
% % % % V2(Invalid,:)=[];
% % % % 
% % % % for i=1:length(V1(:,1))
% % % %     r(i,:) = vrrotvec([V2(i,:) 0],[V1(i,:) 0]);
% % % % end
% % % % 
% % % % r=r(:,3).*r(:,4);
% % % % 
% % % % % [AngLdir,RhOdir] = cart2pol(directVector(:,1),directVector(:,2));
% % % % 
% % % % [x,y]=pol2cart(r,zeros(size(r))+1);
% % % % figure;
% % % % [N,C]=hist3([x(:) y(:)],[40 40]);
% % % % imagesc(C{1},C{2},N');axis xy
% % % % figure;
% % % %     NumBin=20;LimM=1;
% % % %     PhaseHistPolar(r,NumBin,LimM,[1 0 0]);
% % % % PolData=[AngL(:) RhO(:)];
% % % %         MeanAng=circ_mean(AngL);
% % % %         StdAng=circ_std(AngL);
% % % %         VectorL=circ_r(AngL);
% % % % [pval, z] = circ_rtest(AngL);
% % % % Rayleigh=[pval z];
% % % % 
% % % %  figure
% % % %      circ_plot(r,'hist',[],100,true,true,'linewidth',2,'color','r')        
% % % % %         alpha = randn(60,1)*.4+pi/2;
% % % %         PhaseHistPolar(alpha,NumBin,0.05,[1 0 0]);
% % % % [x,y]=pol2cart(r,zeros(size(r))+1);
% % % % 
% % % % 
% % % % figure;
% % % % plot(x,y,'r.')
% % % % 
% % % % v1=[0 1 0];
% % % % v2=[1 0 0];
% % % % 
% % % % v1=[1 0 0];
% % % % v2=[0 1 0];
% % % % 
% % % % r = vrrotvec(v1,v2)
% % % % 
% % % % subspace(v1',v2')
% % % % 
% % % % a3 = acos(dot(v1 / norm(v1), v2 / norm(v2)))
% % % % alpharad = acos(dot(v1,v2) / sqrt( dot(v1, v2) * dot(v1, v2)))
% % % % 
% % % % 




