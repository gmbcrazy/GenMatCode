function [x,y,t,zone] = RebuildDataWaveMissingPoints (x,y,t,zone,sampleTime)



diff_t=diff(t);
% Build the missing points using an interpolation 
% btw the neighbouring existing points
Artifacts=(diff_t>=1.8*sampleTime);

while sum(Artifacts)>0
    ind=find(Artifacts);
    k=ind(1);
    mp=round((diff_t(k)-sampleTime)/sampleTime); % mp missing points
    x_segt=[];
    y_segt=[];
    t_segt=[];
    z_segt=[];
    for j=1:mp
        x_segt(j)=(((mp+1)-j)/(mp+1))*x(k) + ((j)/(mp+1))*x(k+1);
        y_segt(j)=(((mp+1)-j)/(mp+1))*y(k) + ((j)/(mp+1))*y(k+1);
        t_segt(j)=(((mp+1)-j)/(mp+1))*t(k) + ((j)/(mp+1))*t(k+1);
        z_segt(j)=zone(k);
    end
    x=[x(1:k); x_segt(:); x(k+1:end)];
    y=[y(1:k); y_segt(:); y(k+1:end)];
    t=[t(1:k); t_segt(:); t(k+1:end)];
    zone=[zone(1:k); z_segt(:); zone(k+1:end)];
    %j=0; 
%     clear j
    diff_t=diff(t);
    Artifacts=(diff_t>=1.8*sampleTime);
end
 

% diff_t=diff(t);
% % Remplace the artifact points by re-calculated points using an interpolation 
% % btw the neighbouring correct points
% WorkingData=[x,y];
% Artifacts=(diff_t>p.sampleTime);
% % Artifacts=(zone~=inclusion_zone);
% missing_points=
% k=1;
% while  k <= length(WorkingData)
%     if (Artifacts(k)==1)
%        % k is the first point containing an artefact
%        if (k==1) 
%             % The artefact is in 1st position : 
%             i=k+1;
%             while ( Artifacts(i)==1 && i<length(WorkingData) )
%                 i=i+1;
%             end
%             % i is th fisrt point considered as correct 
%             WorkingData (k,:) =WorkingData (i,:);
%             k=k+1;% Julie ajout 121105
%             
% 
%        elseif ((k~=1) && (k~=length(WorkingData)) ) 
%             i=k+1;
%             while ( Artifacts(i)==1 && i<length(WorkingData) )
%                 i=i+1;
%             end                
%             % i is th fisrt point considered as correct                
%             if (i>=length(WorkingData))
%                 % The last points are all artefect : they are put equal to the last correct point 
%                 Tab=repmat(WorkingData (k-1,:),(length(WorkingData)-k+1),1);
%                 WorkingData (k:length(WorkingData),:) =Tab;
%             else                    
%                 for j=1:i-k
%                     % j is the false point counter
%                     % x
%                     WorkingData(k+j-1,1)=(1-(j./(i-k+1)))*WorkingData(k-1,1)+(j./(i-k+1))*WorkingData(i,1);
%                     % y
%                     WorkingData(k+j-1,2)=(1-(j./(i-k+1)))*WorkingData(k-1,2)+(j./(i-k+1))*WorkingData(i,2);
%                     %t
%                     WorkingData(k+j-1,3)=(1-(j./(i-k+1)))*WorkingData(k-1,3)+(j./(i-k+1))*WorkingData(i,3);
%                     
%                     
%                     
%                 end
%             end
%             k=i;
%        elseif(k==length(WorkingData)) 
%            WorkingData (k,:)= WorkingData (k-1,:);
%            k=k+1;
%         end
%     else
%         k=k+1;
%     end
%   
%     t=WorkingData(:,3);
%     
%     diff_t=diff(t);  
%     Artifacts=(diff_t>p.sampleTime);
% 
%     
% end
%     
% x = WorkingData(:,1);
% y = WorkingData(:,2);