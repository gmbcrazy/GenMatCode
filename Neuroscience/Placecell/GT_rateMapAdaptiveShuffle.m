function [aMap,posPDF]=GT_rateMapAdaptiveShuffle(SpikeTs,PosX,PosY,PosT,RangeX,RangeY,p)

%%%%%%%%Calculate adaptive rateMap for place cell analysis.
% p.shape         Shape of the box. Square box = 1, Cylinder = 2.
% %               1 dim: shape. 1 = box, 2 = cylinder, 3 = linear track
%                 2 dim: Side length or diameter of the arena.
%p.timerange indicates that raw spike should be in p.timerange and shuffled
%spike should also be in p.timerange

tic
[x,y,t]=SpeedThreshold(PosX,PosY,PosT,p.lowSpeedThreshold, p.highSpeedThreshold);

timerange=p.timerange;  %%%%%%Analysis Period
ShuffleNum=p.ShuffleNum;%%%%%%Num. of shuffling
ShuffleRange=p.ShuffleRange;%%%%%%Time-Shift range [0;20] refers to randomly shift time
%%%%from 0 to 20s for example


 timeMarkStart=timerange(1,1);
 RawSpikes=SpikeTs-timeMarkStart;
 timerange=timerange-timeMarkStart;
 ShuffleLag = random('uni',ShuffleRange(1),ShuffleRange(2),ShuffleNum,1);
for Shufflei=1:ShuffleNum
   SpikeTs=RawSpikes+ShuffleLag(Shufflei);
   SpikeTs=sort(rem(SpikeTs,max(timerange(2,:))));
   SpikeTs=unique(SpikeTs);
SpikeTs=SpikeTs+timeMarkStart;





[spkx,spky,~,SpikeTsNeed] = spikePos(SpikeTs,x,y,t);
Xstart=RangeX(1);
Xend=RangeX(2);
Ystart=RangeY(1);
Yend=RangeY(2);
center_arena_x=p.centerXY(1);
center_arena_y=p.centerXY(2);

SpikeData=[SpikeTsNeed(:) spkx(:),spky(:)];
[aMap(:,Shufflei), posPDF(:,Shufflei), ~, ~] = ratemapAdaptiveSmoothing(x, y,...
                        spkx, spky, Xstart,Ystart,Xend,Yend, p.sampleTime,...
                                        p, p.shape, center_arena_x,...
                                            center_arena_y);
                                        
end
toc