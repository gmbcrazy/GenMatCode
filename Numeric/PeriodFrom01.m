function Period=PeriodFrom01(Mark)

%%%%%%%%Mark is continous 0 and 1 signals
%%%%%%%%Find out the start/end of non-zero periods Period
%%%%%%%%Period(1,i) is start Index of Period i
%%%%%%%%Period(2,i) is end Index of Period i

Mark=Mark(:);
Mark=[0;Mark;0];
Temp=diff(Mark);
temp1=find(Temp>0.5);
temp2=find(Temp<-0.5);
if ~isempty(temp1)
Period=[temp1(:)';temp2(:)'-1];
else
Period=[];
end