function P3=Period1InNonPeriod2(P1,P2,varargin)

%%%%%%%%P1(1,i) is the start time of ith period in P1;
%%%%%%%%P1(2,i) is the end time of ith period in P1;
%%%%Format of P2 or P3 is as same as P1;
%%%%P3 is to found out Period in P1 NOT satisfied that in P2;
if isempty(P1)
   P3=P1;
   return
end

NonP2=[];
TimeRange=[0;P1(2,end)];
NonP2=[0;P2(1,1)];

for i=1:(size(P2,2)-1)
    NonP2=[NonP2 [P2(2,i);P2(1,i+1)]];
end
NonP2=[NonP2 [P2(2,end);TimeRange(2)]];

% figure;
% hold on
% for i=1:size(P2,2)
%     plot([P2(1,i) P2(2,i)],[1 1],'b-','linewidth',5) ;
% end
% hold on
% for i=1:size(NonP2,2)
%     plot([NonP2(1,i) NonP2(2,i)],[1+0.5 1+0.5],'r-','linewidth',5) ;
% end
% set(gca,'ylim',[0 2])
% 

P3=Period1InPeriod2(P1,NonP2);

P3=MergePeriod(P3);

if nargin==3
   ThresholdPeriod=varargin{1}; 
   Invalid=find(diff(P3)<=ThresholdPeriod);
   P3(:,Invalid)=[];

end