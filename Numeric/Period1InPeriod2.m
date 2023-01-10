function P3=Period1InPeriod2(P1,P2)

%%%%%%%%P1(1,i) is the start time of ith period in P1;
%%%%%%%%P1(2,i) is the end time of ith period in P1;
%%%%Format of P2 or P3 is as same as P1;
%%%%P3 is to found out Period in P1 satisfied that in P2;

if size(P2,2)==1
   P3=[];
   for i=1:size(P1,2)
       Ptemp(1)=max([P1(1,i) P2(1)]);
       Ptemp(2)=min([P1(2,i) P2(2)]);
       if diff(Ptemp)>0
          P3=[P3 Ptemp(:)];
       end  
   end
else
   P3=[];
   for j=1:size(P2,2)
       P4=Period1InPeriod2(P1,P2(:,j));
       P3=[P3 P4];
   end
end