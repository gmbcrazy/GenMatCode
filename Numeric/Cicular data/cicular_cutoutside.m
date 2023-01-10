function [wave_new,sig_new]=cicular_cutoutside(time_start,time_end,wave,sig)    %to cut off the time in the begining and at the end which are not needed according to the user%
                                                               %wave is timestamps of theta or ripple and so on,sig is timestamps of spikes of neuron%
cuttime_start=wave(min(find(wave>=time_start)));
cuttime_end=wave(max(find(wave<=time_end)));

wave1=wave-cuttime_start;
q1=min(find(wave1>=0.0000));

wave2=wave-cuttime_end;
q2=max(find(wave2<=0.0000));

wave_new=wave([q1:q2]);                                 %cut off the time before time_start and after time_end in the wave%

sig1=sig-cuttime_start;
q1=min(find(sig1>=0.0000));

sig2=sig-cuttime_end;
q2=max(find(sig2<=0.0000));

sig_new=sig([q1:q2]);                                 %cut off the time before time_start and after time_end in the sig%
