function Causality=causality_MORDER_range(Data,fre_band,fs,NFFT,MORDER_range)

for i=1:length(MORDER_range)
    
    MORDER_band=[MORDER_range(i);MORDER_range(i)];
    Causality{i}=causality_try1to1(Data,fre_band,fs,NFFT,MORDER_band);
end
