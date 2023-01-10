function width_index=wave_width_Peak2Trough(wave)


%%%%%%%%%1/e negative peak was chosen as the threshold
[peak,n]=max(wave);
[trough,m]=min(wave(n:length(wave)));
[trough,m]=min(wave);

width_index=abs(n-m);



