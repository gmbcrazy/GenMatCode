function Period=MarkToPeriod(Mark)

%%%%%%%Mark is vector with 0 (non-occurs) and 1 (occurs) values
%%%%%%%Period gives the occurs period
%%%%%%%Period(1,:) is the start Index of each period;Period(2,:) is the end Index of each period
if max(Mark)<1
   Period=[];
   return
end

Mark=[0;Mark(:);0];
dM=diff(Mark);

Period(1,:)=find(dM>0.5);
Period(2,:)=find(dM<-0.5)-1;

