function [data_without_speed_artefact] = RemoveSpeedDownArtifacts(TimeBetween2Measure,...
                            data_without_speed_artefact, threshold_down)
                        
if ischar(threshold_down)    
    threshold_down=str2num(threshold_down);
end

X = data_without_speed_artefact(:,2); 
Y = data_without_speed_artefact(:,3);

v=sqrt((diff(X).^2+diff(Y).^2))/TimeBetween2Measure;
below=(v<threshold_down);


%if needed we add a zero so that diff is able to identify the segment at
%the extremities
if (below(1)==1)&&(below(end)==1)
	below=[0;below;0];
    decalage=1;
elseif (below(1)==1)&&(below(end)==0)
	below=[0;below];
	decalage=1;
elseif (below(1)==0)&&(below(end)==1)
	below=[below;0];
    decalage=0;
else
   %(below(1)==0)&&(below(end)==0)
   decalage=0;
   %we do nothing
end

below_diff=diff(below);
u=(abs(below_diff)==1);
% length(u) is paired 
% u(1:(end-1)) :  begining of segments minus 1
% u(2:(end)) :  end of segments 
%num_of_segment is the total number of segment (segt IN + segt OUT)

ind = find(u);
ind=ind(:);
num_of_segments=length(ind)/2;

        for i=1:num_of_segments
            
                p=ind(2*i-1)+1; %because diff find the begining of segments MINUS 1
                q=ind(2*i);
                p=p-decalage;
                q=q-decalage;
                data_without_speed_artefact(p:q,:)=NaN;
        end

figure, plot(v)
        


X = data_without_speed_artefact(:,2); 
Y = data_without_speed_artefact(:,3);

v=sqrt((diff(X).^2+diff(Y).^2))/TimeBetween2Measure;
hold on, plot(v,'r');
close;

data_without_speed_artefact(isnan(data_without_speed_artefact(:,1)), :)=[];





