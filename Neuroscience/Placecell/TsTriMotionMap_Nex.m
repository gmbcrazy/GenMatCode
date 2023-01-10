function [occ_map,Vectormap,DirVectormap,aRowAxis,aColAxis]=TsTriMotionMap_Nex(filename,cellName,timerange,p)
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
sum(isnan(x))
[spkx,spky,spkInd] = spikePos(Spikes,x,y,t);
% [aMap, rawMap, aRowAxis, aColAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
                          
Invalid=find(spkInd>(length(x)-1));
if ~isempty(Invalid)
    spkx(Invalid)=[];
    spky(Invalid)=[];
    spkInd(Invalid)=[];
    [num2str(length(Invalid)) 'spikes removed']
end



[occ_map,IndexMap,rawMap, aRowAxis, aColAxis] = OccupancyVector_map(spkx, spky,Xstart,Ystart,Xend,Yend,p);
% aRowAxis=ImageSize(2)-aRowAxis;

x=x(:);
y=y(:);

NormTrace=NORMtrace([x y],p);
x=NormTrace(:,1);
y=NormTrace(:,2);


vectorPosition=[diff(x) -diff(y)];
vectorPosition(isnan(vectorPosition))=0;
directVector = [diff(x) -diff(y)];
% spkInd=(spkInd-1);
% spkInd(spkInd<=0)=1;
vectorPosition=vectorPosition(spkInd,:);

t=t(2:end);

[m,n]=size(IndexMap);
% THmatrix=zeros(m,n);
% Rmatrix=zeros(m,n);
VectormapX=zeros(m,n);
VectormapY=zeros(m,n);
DirVectormapX=VectormapX;
DirVectormapY=VectormapY;


% (mehdi)
%--------------------------------------------------------------------------
% make unity movement vecotr (independent of speed), pure direction
%--------------------------------------------------------------------------
% to avoid devision by zero (remove directVector=0+0i)
% % if ~isempty(find(directVector(:,1)==0 & directVector(:,2)==0, 1))
% %     directVector(directVector(:,1)==0 & directVector(:,2)==0, :)=[nan nan];
% % end 
directVector = vectorPosition./[sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)  sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)]; % devision by each vector-length
directVector(isnan(directVector)) = 0;


%--------------------------------------------------------------------------
% Set instant movement vector zero for those nan(out of speedThreshold)



invalidIndex=find(diff(t)>1/adfreq*2);
DistanceWhole=0;
NUMvisit=zeros(m,n);
temp=occ_map;
temp(isnan(temp))=0;
weighted=temp/sum(sum(temp));

for i=1:m
    for j=1:n
        IndexMap{i,j}=setdiff(IndexMap{i,j},length(x));
%         IndexMap{i,j}=setdiff(IndexMap{i,j},invalidIndex);
        if ~isempty(IndexMap{i,j})
            if length(IndexMap{i,j})>=2
        VectormapX(i,j)= sum(vectorPosition(IndexMap{i,j},1));
        VectormapY(i,j)= sum(vectorPosition(IndexMap{i,j},2));
        
        DirVectormapX(i,j)= sum(directVector(IndexMap{i,j},1));
        DirVectormapY(i,j)= sum(directVector(IndexMap{i,j},2));

        NUMvisit(i,j)=length(IndexMap{i,j});
        
%         temp=sum(sqrt(sum(vectorPosition(IndexMap{i,j},:)'.^2)))*weighted(i,j);
        temp=sum(sqrt(sum(vectorPosition(IndexMap{i,j},:)'.^2)));
%         temp=temp.^(1/length(length(IndexMap{i,j})));
        DistanceWhole=DistanceWhole+temp;
%         [THmatrix(i,j),Rmatrix(i,j)]=cart2pol(VectormapX(i,j),VectormapY(i,j));
            end
    end
    end

end

vectorPosition(invalidIndex,:)=[];

% DistanceWhole=sum(sqrt(sum(vectorPosition'.^2)));



VectormapY(isnan(VectormapY))=0;
VectormapX(isnan(VectormapX))=0;
VectormapY(isnan(occ_map))=0;
VectormapX(isnan(occ_map))=0;

DirVectormapY(isnan(DirVectormapY))=0;
DirVectormapX(isnan(DirVectormapX))=0;
DirVectormapY(isnan(occ_map))=0;
DirVectormapX(isnan(occ_map))=0;




clear Temp
Temp=NORMtrace([aColAxis(:) aRowAxis(:)],p);
aColAxis=Temp(:,1);
aRowAxis=Temp(:,2);
aRowAxis=aRowAxis(end:-1:1);

% aRowAxis=aRowAxis+p.binWidth/100/2;




% figure;
% [tx,ty]=meshgrid(aColAxis,aRowAxis);hold on;
% tx=tx(:);
% ty=ty(:);
VectormapX=VectormapX(:);
VectormapY=VectormapY(:);
% index=intersect(find(VectormapX~=0),find(VectormapY~=0))
% quiver(tx(index),ty(index),VectormapX(index),VectormapY(index),0,'r','linewidth',1.5);hold on;
% 
% figure;
% quiver(tx(index),ty(index),VectormapX(index),VectormapY(index),1/Distance*100,'b','linewidth',1.5);hold on;

% 
Vectormap=[VectormapX VectormapY];
DirVectormap=[DirVectormapX(:) DirVectormapY(:)];

% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% set(gca,'ydir','reverse')
% 
% p=ImageInsert(a,h)
if nargout==1
   varargout{1}=occ_map;
elseif nargout==2
   varargout{1}=occ_map;
   varargout{2}=Vectormap;
elseif nargout==4
       
   varargout{1}=occ_map;
   varargout{2}=Vectormap;
   varargout{3}=aRowAxis;
   varargout{4}=aColAxis;
% % % elseif nargout==5
% % %        
% % %    varargout{1}=occ_map;
% % %    varargout{2}=Vectormap;
% % %    varargout{3}=aRowAxis;
% % %    varargout{4}=aColAxis;
% % %    varargout{5}=DistanceIndex;
% % % 
% % % elseif nargout==6
% % %    varargout{1}=occ_map;
% % %    varargout{2}=Vectormap;
% % %    varargout{3}=aRowAxis;
% % %    varargout{4}=aColAxis;
% % %    varargout{5}=DistanceIndex;
% % %    varargout{6}=rawDataTrace;

else

end


% aRowAxis=ImageSize(2)-aRowAxis;
% figure;
% h=imagesc(aColAxis,aRowAxis,aMap,[0 max(max(aMap))]);hold on
% set(h,'alphadata',~isnan(aMap));
% plot(spkx,spky,'r.');hold on;
% % plot(rows,cols,'r.');hold on;
% plot(PosX,PosY,'g');hold on;
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% 

% figure;
% h=imagesc(aColAxis,aRowAxis, posPDF,[0 0.002]);hold on
% set(h,'alphadata',~isnan( posPDF));
% plot(spkx,spky,'r.');hold on;
% plot(rows,cols,'r.');hold on;
% plot(PosX,PosY,'g');hold on
% 

 
%  [map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(Spikes,x,y,((1:NumPos)-1)*p.sampleTime,Xstart,Ystart,Xend,Yend,p,1);
%  imagesc(map)












