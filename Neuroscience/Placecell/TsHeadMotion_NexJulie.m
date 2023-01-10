
function [RotationTS,ARotationTS,AlloDirTS,AlloAccDirTS]=TsHeadMotion_NexJulie(filename,cellName,timerange)

[x,y,t]=SpeedThreshold(PosX,PosY, posTime,p.lowSpeedThreshold, p.highSpeedThreshold);
sum(isnan(x));
[spkx,spky,spkInd] = spikePos(Spikes,x,y,t);
                          
Invalid=find(spkInd>(length(x)-1));
if ~isempty(Invalid)
    spkx(Invalid)=[];
    spky(Invalid)=[];
    spkInd(Invalid)=[];
    [num2str(length(Invalid)) 'spikes removed']
end


x=x(:);
y=y(:);


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

