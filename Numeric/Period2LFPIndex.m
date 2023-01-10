function [LFPIndex,LFPStartOverIndex]=Period2LFPIndex(Period,LFPtime)

%%%%%%%%Period(1,i) is the start time of ith period in Period;
%%%%%%%%Period(2,i) is the end time of ith period in Period;
%%%%LFPtime is the sampling time of LFP data;

%%%%%%%LFPIndex is the index of LFP data within Period;
%%%%%%%LFPStartOverIndex(1,i) is the index of LFP at the start time of ith period;
%%%%%%%LFPStartOverIndex(2,i) is the index of LFP at the end time of ith period;


if ~isempty(Period)
   LFPIndex=[];
   for i=1:size(Period,2)
       IndexTemp=find(LFPtime>=Period(1,i)&LFPtime<=Period(2,i)); 
       LFPIndex=[LFPIndex;IndexTemp(:)];
       
       [~,LFPStartOverIndex(1,i)]=min(abs(LFPtime-Period(1,i)));
       [~,LFPStartOverIndex(2,i)]=min(abs(LFPtime-Period(2,i)));
     
   end
else
    LFPIndex=[];
    LFPStartOverIndex=[];
   
end

