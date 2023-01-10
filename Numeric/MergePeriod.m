function Period=MergePeriod(Period)
        
%%%%%if the start time of one period is earlier than the end of previous
%%%%%period? merge the two.
if isempty(Period)
   return
end

if size(Period,2)==1
   return
end
[~,sortI]=sort(Period(1,:));
Period=Period(:,sortI);

Invalid=find(diff(Period)<=0);
Period(:,Invalid)=[];



Gap=Period(1,2:end)-Period(2,1:(end-1));
MerI=find(Gap<=0);
while ~isempty(MerI)&&length(Period(1,:))>1
Period(2,MerI(1))=Period(2,MerI(1)+1);
Period(:,MerI(1)+1)=[];

Gap=Period(1,2:end)-Period(2,1:(end-1));
MerI=find(Gap<=0);

end 


