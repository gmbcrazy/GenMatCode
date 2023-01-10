function [RotationTS,AlloDirTS]=TsDirMotion(spkInd,x,y)
%%%comopute the direction vectors (egocentric(RotationTS) and
%%%allocentric(AlloDirTS)) for spiketrains, tracking positions is x and y.
%%%spkInd indicate the index of tracking for all spikes

spkx=x(spkInd);
spky=y(spkInd);
% [aMap, rawMap, aRowAxis, aColAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
                          
Invalid=find(spkInd>(length(x)-1));
if ~isempty(Invalid)
% %     spkx(Invalid)=[];
% %     spky(Invalid)=[];
    spkInd(Invalid)=[];
    if length(Invalid)>2
    [num2str(length(Invalid)) 'spikes removed']
    end
end



% [occ_map,IndexMap,rawMap, aRowAxis, aColAxis] = OccupancyVector_map(spkx, spky,Xstart,Ystart,Xend,Yend,p);
% aRowAxis=ImageSize(2)-aRowAxis;

x=x(:);
y=y(:);

vectorPosition=[diff(x) diff(y)];
Motion_Vector=vectorPosition;
directVector = vectorPosition./[sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)  sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)]; % devision by each vector-length
% % accerVector=diff(Motion_Vector);
% % accerDirVector=accerVector./[sqrt(accerVector(:,1).^2+accerVector(:,2).^2)  sqrt(accerVector(:,1).^2+accerVector(:,2).^2)]; % devision by each vector-length

% % [DirAng,~]=cart2pol(directVector);
Motion_Vector=Motion_Vector(1:(end-1),:);
[AlloDir,~]=cart2pol(Motion_Vector(:,1),Motion_Vector(:,2));
%%%MotionR=MotionR;
% % MotionR=sqrt(Motion_Vector(:,1).^2+Motion_Vector(:,2).^2)/p.sampleTime;
% % [MotionCart(:,1),MotionCart(:,2)]=pol2cart(Rotation,MotionR);
V1=directVector(1:(end-1),:);
V2=directVector(2:end,:);
Rotation=-asin(V1(:,1).*V2(:,2)-V2(:,1).*V1(:,2))+pi/2;
% % % 

%%%%%%%%if Rotation > 0, conterclockwise, go left
%%%%%%%%if Rotation < 0, clockwise, go right
spkInd(find(spkInd>length(V1)))=[];
% % MotionCartTS=MotionCart(spkInd,:);
AlloDirTS=AlloDir(spkInd);
RotationTS=Rotation(spkInd);
directVectorTS=directVector(spkInd,:);
Motion_VectorTS=Motion_Vector(spkInd,:);

% % % % [OccMotion,EdgePlot.Mot]=hist3([MotionCart],'edges',EdgeSet.Mot);
% % % % RawOccMotion=OccMotion;
% % % % [MotionMapTS,~]=hist3([MotionCartTS],'edges',EdgeSet.Mot);
% % % % OccMotion=smooth2a(OccMotion,1);
% % % % MotionMapTS=smooth2a(MotionMapTS,1);
% % % % FiringMapMotion=smooth2a(MotionMapTS./OccMotion,1)/p.sampleTime;
% % % % FiringMapMotion(OccMotion==0)=nan;
% % % % FiringMapMotion(RawOccMotion<=p.RawminBinTime)=nan;
% % % % FiringMapMotion(OccMotion<=p.minBinTime)=nan;







