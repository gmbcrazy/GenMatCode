function energy=wf_energ(input,electrod,ch)


% Output.Waveform=wave;
% Output.Ts=ts;
% Output.Freq=Freq;
% Output.NPW=NPW;



for ii=1:length(ch)
    index=((ch(ii)-1)*input.NPW/electrod+1):ch(ii)*input.NPW/electrod;
    wave_temp=input.Waveform(:,index);
    for i=1:length(input.Ts)
        energy(ii,i)=sqrt(sum(wave_temp(i,:).*wave_temp(i,:)));
    end
    clear wave_temp
end
