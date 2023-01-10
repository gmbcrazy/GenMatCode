function [x,y] = RemoveRearingArtifacts (x,y,zone,sampleTime, inclusion_zone)

 
% Remplace the artifact points by re-calculated points using an interpolation 
% btw the neighbouring correct points
WorkingData=[x,y];
Artifacts=(zone~=inclusion_zone);

k=1;
while  k <= length(WorkingData)
    if (Artifacts(k)==1)
       % k is the first point containing an artefact
       if (k==1) 
            % The artefact is in 1st position : 
            i=k+1;
            while ( Artifacts(i)==1 && i<length(WorkingData) )
                i=i+1;
            end
            % i is th fisrt point considered as correct 
            WorkingData (k,:) =WorkingData (i,:);
            k=k+1;% Julie ajout 121105
            

       elseif ((k~=1) && (k~=length(WorkingData)) ) 
            i=k+1;
            while ( Artifacts(i)==1 && i<length(WorkingData) )
                i=i+1;
            end                
            % i is th fisrt point considered as correct                
            if (i>=length(WorkingData))
                % The last points are all artefect : they are put equal to the last correct point 
                Tab=repmat(WorkingData (k-1,:),(length(WorkingData)-k+1),1);
                WorkingData (k:length(WorkingData),:) =Tab;
            else                    
                for j=1:i-k
                    % j is the false point counter
                    % x
                    WorkingData(k+j-1,1)=(1-(j./(i-k+1)))*WorkingData(k-1,1)+(j./(i-k+1))*WorkingData(i,1);
                    % y
                    WorkingData(k+j-1,2)=(1-(j./(i-k+1)))*WorkingData(k-1,2)+(j./(i-k+1))*WorkingData(i,2);

                end
            end
            k=i;
       elseif(k==length(WorkingData)) 
           WorkingData (k,:)= WorkingData (k-1,:);
           k=k+1;
        end
    else
        k=k+1;
    end
end
    
x = WorkingData(:,1);
y = WorkingData(:,2);
