function LFPTrial=MakeTrialLFP(LFP,Period,SampleR)

%%%%%%%%Output LFPTrial is a struct, prepared for psd_TrialData.m
%%LFPTrial(i).Data is the LFP in the ith trial
%%LFPTrial(i).Time is the trial time starting with 0s. 
%%%%%%%%sampleTime is from [0:length(LFP)-1]/SampleR;

for i=1:size(Period,2)
    iS=max(round(Period(1,i)*SampleR),1);
    iO=min(round(Period(2,i)*SampleR),length(LFP));
    LFPTrial(i).Data=LFP(iS:iO);
    LFPTrial(i).Time=([iS:iO]-1)/SampleR;
end


