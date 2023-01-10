function [occ_mapTrial, Vectormap,DistanceTrial, aRowAxis, aColAxis,DisCohTrial]=OccupyMapTrial_Nex(filename,timerange,p)


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


[adfreq, NumPos, ts, fn, PosX] =nex_cont2(filename, 'PosXSmooth');
[adfreq, NumPos, ts, fn, PosY] =nex_cont2(filename, 'PosYSmooth');

[Explore TSStim]=File2PathTrial(filename,p,timerange);

if isempty(Explore)
   occ_mapTrial=[];
   Vectormap=[];
   DistanceTrial=[];
   aRowAxis=[];
   aColAxis=[]
   DisCohTrial=[];
   return
end

clear temp_index temp_time


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

for iTrial=1:length(Explore)
PosX=Explore(iTrial).X;
PosY=Explore(iTrial).Y;


[x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime+Lag,p.lowSpeedThreshold, p.highSpeedThreshold);
[occ_map,IndexMap,rawMap, aRowAxis, aColAxis] = OccupancyVector_map(x, y,Xstart,Ystart,Xend,Yend,p);
% aRowAxis=ImageSize(2)-aRowAxis;

x=x(:);
y=y(:);

vectorPosition=[diff(x) diff(y)];
vectorPosition(isnan(vectorPosition))=0;
t=t(2:end);

% a1=isnan(x);
% a2=isnan(y);
% a3=a1+a2;
% a3=find(a3==0);
% x(a3)=[];
% y(a3)=[];
% t(a3)=[];
% vectorPosition=vectorPosition/p.sampleTime;

% [THmatrix,Rmatrix]=cart2pol(vectorPosition(:,1),vectorPosition(:,2))
% quiver(x(1:end-1),y(1:end-1),THmatrix(:),Rmatrix(:));hold on;

% [TH,R]=cart2pol(vectorPosition(:,1),vectorPosition(:,2));

[m,n]=size(IndexMap);
% THmatrix=zeros(m,n);
% Rmatrix=zeros(m,n);
VectormapX=zeros(m,n);
VectormapY=zeros(m,n);


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

% VectormapY=boxcarSmoothing(VectormapY);
% VectormapX=boxcarSmoothing(VectormapX);

VectormapY(isnan(occ_map))=0;
VectormapX(isnan(occ_map))=0;

temp=occ_map;
temp(isnan(temp))=0;


% VectormapY=VectormapY.*weighted;
% VectormapX=VectormapX.*weighted;


% occ_map(isnan(occ_map))=0;
% occ_map=boxcarSmoothing(occ_map);

% occ_map(isnan(temp))=nan;

DistanceIndex=sum(sum(sqrt(VectormapY.^2+VectormapX.^2)))/DistanceWhole;

% temp(isnan(temp))=0;
% temp=temp./sum(sum(temp));
% temp1=log(temp);
% temp1(isinf(temp1))=0;
% temp1(isnan(temp1))=0;
% 
% DistanceIndex=-sum(sum(temp.*temp1));
% 
% DistanceIndex=sum(sum(sqrt(VectormapY.^2+VectormapX.^2).^(1./NUMvisit)))/DistanceWhole;


% DistanceIndex=sum(sum(sqrt(VectormapY.^2+VectormapX.^2).*(occ_map/sum(sum(occ_map)))))/DistanceWhole;
% DistanceIndex=sum(sum(sqrt(VectormapY.^2+VectormapX.^2).*occ_map))/DistanceWhole

% occ_map(isnan(temp))=nan;

% VectormapY = SmoothDec(VectormapY,[5,5]);
% VectormapX = SmoothDec(VectormapX,[5,5]);
% VectormapY = boxcarSmoothing(VectormapY);
% VectormapX = boxcarSmoothing(VectormapX);
% figure;
% a=imagesc(aColAxis,aRowAxis,occ_map,[0 max(max(occ_map))]);hold on
% 
% 
% set(a,'alphadata',~isnan(occ_map));
% % plot(rows,cols,'r.');hold on;
% plot(PosX,PosY,'g');hold on;
% 
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% 
% hold on;

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
Vectormap{iTrial}=[VectormapX VectormapY];
occ_mapTrial{iTrial}=occ_map;
DistanceTrial(iTrial)=DistanceWhole;
DisCohTrial(iTrial)=DistanceIndex;
end
% h=imagesc(ImageX,ImageY,arena);
% set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
% set(gca,'ydir','reverse')
% 
% p=ImageInsert(a,h)


% figure;
% h=imagesc(aColAxis,aRowAxis, posPDF,[0 0.002]);hold on
% set(h,'alphadata',~isnan( posPDF));
% plot(spkx,spky,'r.');hold on;
% plot(rows,cols,'r.');hold on;
% plot(PosX,PosY,'g');hold on
% 

 
%  [map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(Spikes,x,y,((1:NumPos)-1)*p.sampleTime,Xstart,Ystart,Xend,Yend,p,1);
%  imagesc(map)



% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Load the box template
box = boxcarTemplate2D();

% Size of map
[numRows,numCols] = size(map);

sMap = zeros(numRows,numCols);

for ii = 1:numRows
    for jj = 1:numCols
        
        for k = 1:5
            % Phase index shift
            sii = k-3;
            % Phase index
            rowInd = ii+sii;
            % Boundary check
            if rowInd<1
                rowInd = 1;
            end
            if rowInd>numRows
                rowInd = numRows;
            end
            
            for l = 1:5
                % Position index shift
                sjj = l-3;
                % Position index
                colInd = jj+sjj;
                % Boundary check
                if colInd<1
                    colInd = 1;
                end
                if colInd>numCols
                    colInd = numCols;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(rowInd,colInd) * box(k,l);
            end
        end
    end
end
   

% Gaussian boxcar template 5 x 5
function box = boxcarTemplate2D()

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];

box = single(box);
   









