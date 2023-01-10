function [aMap,aRowAxis,aColAxis,posPDF,SpikeData]=GT_rateMapAdaptive(SpikeTs,PosX,PosY,PosT,RangeX,RangeY,p)

%%%%%%%%Calculate adaptive rateMap for place cell analysis.
% p.shape         Shape of the box. Square box = 1, Cylinder = 2.
% %               1 dim: shape. 1 = box, 2 = cylinder, 3 = linear track
%                 2 dim: Side length or diameter of the arena.


[x,y,t]=SpeedThreshold(PosX,PosY,PosT,p.lowSpeedThreshold, p.highSpeedThreshold);
[spkx,spky,~,SpikeTsNeed] = spikePos(SpikeTs,x,y,t);
Xstart=RangeX(1);
Xend=RangeX(2);
Ystart=RangeY(1);
Yend=RangeY(2);
center_arena_x=p.centerXY(1);
center_arena_y=p.centerXY(2);

SpikeData=[SpikeTsNeed(:) spkx(:),spky(:)];
[aMap, posPDF, aRowAxis, aColAxis] = ratemapAdaptiveSmoothing(x, y,...
                        spkx, spky, Xstart,Ystart,Xend,Yend, p.sampleTime,...
                                        p, p.shape, center_arena_x,...
                                            center_arena_y);