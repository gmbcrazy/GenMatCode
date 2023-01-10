function wave_duration=wave_duration(wave,freq)
%%%%%%%%%wave should be a waveform
[tough,n]=min(wave);
[peak,m]=max(wave(n:length(wave)));
wave_duration=(m+1)/freq;

