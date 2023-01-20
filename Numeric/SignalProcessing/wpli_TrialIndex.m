
function Data=wpli_TrialIndex(TrialSpec,TrialIndex)

%%%%weighted phase lag index, weighted phase lag index (debiased version) across trial based different
%%%%TrialIndex Needed.

% computes the weighted phase lag index
% Key algorighm is modifed by Lu Zhang, from FT_CONNECTIVITY_WPLI.m in fieldtrip toolbox,
% Vinck M, Oostenveld R, van Wingerden M, Battaglia F, Pennartz CM. An improved index
% of phase-synchronization for electrophysiological data in the presence of
% volume-conduction, noise and sample-size bias. Neuroimage. 2011 Apr
% 15;55(4):1548-65.


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

TPxx=TrialSpec.Sxx(TrialIndex,:,:);
TPyy=TrialSpec.Syy(TrialIndex,:,:);
TPxy=TrialSpec.Sxy(TrialIndex,:,:);

if length(TrialIndex)>1
Data.Pxx=nanmean(TPxx);
Data.Pxy=nanmean(TPxy);
Data.Pyy=nanmean(TPyy);
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
Data.WPLI = wpli; % weighted phase lag index
Data.Fre=f;


