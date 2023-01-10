function [Output, aRowAxis, aColAxis]=PCAMapGroup_Nex(FileAll,p)

% if isstruct(FileAll)
%     for i=1:length(FileAll)
%     NexFile{i}=[FileAll(i).General num2str(FileAll(i).Individual) '-f.nex'];
%     end
% else
%     NexFile=FileAll;
% end


% i_plus=1;
for i=1:length(FileAll.Individual)
    filename=[FileAll.General num2str(FileAll.Individual(i)) '-f.nex'];
    timerange=FileAll.Timerange(:,i);
    if i==1
       [occ_mapTrial, Vectormap,DistanceTrial, aRowAxis, aColAxis,DisCohTrial]=OccupyMapTrial_Nex(filename,timerange,p);
    else
       [Tempocc_mapTrial, TempVectormap,TempDistanceTrial, aRowAxis, aColAxis,TempDisCohTrial]=OccupyMapTrial_Nex(filename,timerange,p);
       
       DistanceTrial=[DistanceTrial(:);TempDistanceTrial(:)];
       DisCohTrial=[DisCohTrial(:);TempDisCohTrial(:)];
       occ_mapTrial=[occ_mapTrial Tempocc_mapTrial];
       Vectormap=[Vectormap TempVectormap];
    end
end

Output.Vectormap=Vectormap;
Output.occ_map=occ_mapTrial;
Output.Distance=DistanceTrial;
Output.DisCoh=DisCohTrial;
Output.p=p;



for i=1:length(Vectormap)
    DataRaw(i,:)=Vectormap{i}(:)';
end
[coeff, score, latent, Tsquared, explained] = pca(DataRaw);


for i=1:length(explained)
Path1(:,:,i)=reshape(coeff(:,i),length(coeff(:,i))/2,2);
PathX(:,i)=Path1(:,1,i);
PathY(:,i)=Path1(:,2,i);
% index=intersect(find(PathX~=0),find(PathY~=0));
% quiver(tx(index),ty(index),PathX(index),PathY(index),explained(i)*0.1,'color',d(i,:),'linewidth',explained(i)*0.1);hold on;
end

Output.PathX=PathX;
Output.PathY=PathY;
Output.PCAscore=score;
Output.latent=latent;
Output.Tsquared=Tsquared;
Output.explained=explained;







