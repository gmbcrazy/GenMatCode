function S=Power_cross_spectra(Data,m)
%Data should be a q*p matrix that Data(i,:) refer to signal of channel i with length p
%algorithm is based on the book "spectral analysis of economic time series" writen by C.W.J. Granger in 1964 published by princeton university press


channel_num=length(Data(:,1));
n=length(Data(1,:));
% %%%%%%%%%%%%%%%%%%%%%%%using Parzen weights
for k=0:m
    if k>=0&k<=m/2
        l(k+1)=1-6*k*k*(1-k/m)/m/m;
    elseif  k<=m&k>=m/2
        l(k+1)=2*(1-k/m)^3;
    else
    end
% %%%%%%%%%%%%%%%%%%%%%%%using Parzen weights





% %%%%%%%%%%%%%%%%%%%%%%%using Tukey-Hanning weights
% l(k+1)=0.5*(1+cos(pi*k/m));
% %%%%%%%%%%%%%%%%%%%%%%%using Tukey-Hanning weights

end

for x=1:channel_num
    [auto_spectral(x,:),temp]=cross_spectral(Data(x,:),Data(x,:),l);
end



for x=1:channel_num
    for y=1:channel_num
        [c_temp,q_temp]=cross_spectral(Data(x,:),Data(y,:),l);
        S(x,y,:)=(c_temp.^2+q_temp.^2)./(auto_spectral(x,:).*auto_spectral(y,:));
    end
end