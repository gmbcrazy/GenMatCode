function [PathScore VectorIndex]=PathFindMotion(VectorMap,OccMap,TimesSTD)

%%%%%%%%VectorIndex indicates the vector in the input VectorMap, which is
%%%%%%%%TimesSTD std above the mean


VectorR=(VectorMap(:,1).^2+VectorMap(:,2).^2).^0.5;

index=~isnan(OccMap);

% hist(VectorR)
th=mean(VectorR(index))+TimesSTD*std(VectorR(index));
% hist(VectorR(index),200);hold on;plot([th th],[0 20]);

VectorIndex=find(VectorR>th);


PathScore=sum(VectorMap(index,:));
PathScore=(PathScore(1)^2+PathScore(2)^2)^0.5;


