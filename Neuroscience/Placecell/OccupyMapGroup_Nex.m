% Mehdi 05092016 :Comments added.
% Function: map-average over sessions
% This functions basically make an bib-wise average of the occ_map and
%   Vectormap over all sessions(1-x) that is given to it as input. So,
%   basically summing up the occ_map and Vectormap of all sessions devided
%   by number of session.
%
% adopted and changed according to the new "OccupyMapAdaptiveSmoothing_Nex.m"
%

function [occ_map,Vectormap,aRowAxis,aColAxis,DistanceIndex,dirMap,pass_map] = OccupyMapGroup_Nex(FileAll,FileIndividual,timerange,p)

DistanceIndex = zeros();
occ_mapTemp = cell(1);
VectormapTemp = cell(1);
pass_mapTemp = cell(1);

for i = 1:length(FileIndividual)
    
    filename = [FileAll,num2str(FileIndividual(i)),'-f.nex'];
    
    if i == 1
        
        [occ_map, Vectormap, aRowAxis, aColAxis, DistanceIndex(i),dirMap, ~, ~, pass_map,~,~,~,~,~] = OccupyMapAdaptiveSmoothing_Nex(filename,timerange,p);       
    else
        [occ_mapTemp{i},VectormapTemp{i},aRowAxis,aColAxis,DistanceIndex(i),dirMapTemp{i},~, ~, pass_mapTemp{i},~,~,~,~,~] = OccupyMapAdaptiveSmoothing_Nex(filename,timerange,p);
        occ_map = occ_map + occ_mapTemp{i};
        Vectormap = Vectormap + VectormapTemp{i};  
        pass_map=pass_map+pass_mapTemp{i};
        dirMap = dirMap + dirMapTemp{i};        
    end   
end

DistanceIndex = sum(DistanceIndex)/length(FileIndividual);
Vectormap = Vectormap/length(FileIndividual);
occ_map = occ_map/length(FileIndividual);
pass_map = pass_map/length(FileIndividual);

dirMap=dirMap/length(FileIndividual);