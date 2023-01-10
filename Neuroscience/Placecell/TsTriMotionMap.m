function [occ_map,Vectormap,DirVectormap,aRowAxis,aColAxis]=TsTriMotionMap(spkInd,x,y,t,spkx,spky,Xstart,Ystart,Xend,Yend,p)
% % [aMap, posPDF, aRowAxis, aColAxis, rawData,rawMap,spikeMap]=RateMap_Nex(filename,cellName,timerange,p)

% filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';
% cellName='Ch13Cell1';

% plot(Center(1),Center(2),'b*');hold on;
% plot([Xstart Xstart],[Ystart Yend],'r:');hold on;
% plot([Xend Xend],[Ystart Yend],'r:');hold on;
% plot([Xstart Xend],[Ystart Ystart],'r:');hold on;
% plot([Xstart Xend],[Yend Yend],'r:');hold on;
% 
% axis xy
%%%comopute the direction vectors (egocentric(RotationTS) and
%%%allocentric(AlloDirTS)) for spiketrains, tracking positions is x and y.
%%%spkInd indicate the index of tracking for all spikes
Invalid=union(find(spkInd>=(length(x)-1)),find(spkInd<=0));
spkInd(Invalid)=[];
spkx(Invalid)=[];
spky(Invalid)=[];

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

[m,n]=size(IndexMap);

if isempty(spkInd)
    occ_map=zeros(m,n);
    DirVectormap=[occ_map(:) occ_map(:)];
    Vectormap=[occ_map(:) occ_map(:)];
    return
end
vectorPosition=vectorPosition(spkInd,:);

t=t(2:end);

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


adfreq=1/p.sampleTime;
invalidIndex=find(diff(t)>1/adfreq*2);
DistanceWhole=0;
NUMvisit=zeros(m,n);
temp=occ_map;
temp(isnan(temp))=0;
weighted=temp/sum(sum(temp));

for i=1:m
    for j=1:n
        IndexMap{i,j}=setdiff(IndexMap{i,j},length(x)-1);
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







