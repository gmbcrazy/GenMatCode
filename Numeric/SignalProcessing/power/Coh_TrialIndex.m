
function Data=Coh_TrialIndex(TrialSpec,TrialIndex)

%%%%Calculated Averaged Coherence, PSD across trial based different
%%%%TrialIndex Needed.

%%%%TrialSpec is calculated from coh_TrialData.m
%%%%TrialSpec.Sxy is cross spectrum 2D matrix, Trial x Frequency.
%%%%TrialSpec.Sxx is power spectrum 2D matrix, Trial x Frequency.
%%%%TrialSpec.Syy is power spectrum 2D matrix, Trial x Frequency.
%%%%TrialSpec.options is parameters.

%%%%TrialIndex is Trial Index included for averaing the results.


if isempty(TrialIndex)
   Data.Pxx=[];
   Data.Pyy=[];
   Data.Pxy=[];
   Data.Cxy=[];
   Data.Fre=[];
   return
end

TPxx=TrialSpec.Sxx(TrialIndex,:);
TPyy=TrialSpec.Syy(TrialIndex,:);
TPxy=TrialSpec.Sxy(TrialIndex,:);

if length(TrialIndex)>1
Data.Pxx=mean(TPxx);
Data.Pxy=mean(TPxy);
Data.Pyy=mean(TPyy);
elseif length(TrialIndex)==1
   Data.Pxx=(TPxx);
   Data.Pxy=(TPxy);
   Data.Pyy=(TPyy);
else
    
end
esttype='mscohere';

[Data.Pxx,f,xunits] = computepsd(Data.Pxx',TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[Data.Pyy,f,xunits] = computepsd(Data.Pyy',TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[Data.Pxy,f,xunits] = computepsd(Data.Pxy',TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);


Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.Fre=f;
