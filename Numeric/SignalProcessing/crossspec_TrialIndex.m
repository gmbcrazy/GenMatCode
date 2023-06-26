
function Data=crossspec_TrialIndex(TrialSpec,TrialIndex)

%%%%Calculated weighted phase lag index, Averaged Coherence, PSD across trial based different
%%%%TrialIndex Needed.

%%%%TrialSpec is calculated from coh_TrialData.m
%%%%TrialSpec.Sxy is cross spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.Sxx is power spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.Syy is power spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.options is parameters.

%%%%TrialIndex is Trial Index included for averaing the results.


if isempty(TrialIndex)
   Data.Pxx=[];
   Data.Pyy=[];
   Data.Pxy=[];
   Data.Cxy=[];
   Data.Fre=[];
   Data.wpli=[];
   return
end

TPxx=TrialSpec.Sxx(TrialIndex,:,:);
TPyy=TrialSpec.Syy(TrialIndex,:,:);
TPxy=TrialSpec.Sxy(TrialIndex,:,:);
if length(gpuDevice)>=1
   TPxx=gpuArray(TPxx);
   TPyy=gpuArray(TPyy);
   TPxy=gpuArray(TPxy);
end

ns=size(TPxy);


esttype='mscohere';

for itrial=1:length(TrialIndex)
[TTPxx(itrial,:,:),f,xunits] = computepsd(squeeze(TPxx(itrial,:,:)),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPyy(itrial,:,:),f,xunits] = computepsd(squeeze(TPyy(itrial,:,:)),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPxy(itrial,:,:),f,xunits] = computepsd(squeeze(TPxy(itrial,:,:)),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
end

wpli=cross3DSpec2wpli1D(TTPxy);

if length(TrialIndex)>1
Data.Pxx=nanmean(nanmean(TTPxx,3),1);
Data.Pyy=nanmean(nanmean(TTPyy,3),1);
Data.Pxy=nanmean(nanmean(TTPxy,3),1);
elseif length(TrialIndex)==1
Data.Pxx=nanmean(TTPxx,3);
Data.Pyy=nanmean(TTPyy,3);
Data.Pxy=nanmean(TTPxy,3);
else
    
end



Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.wpli=wpli;
Data.Fre=f;



function wpli=cross3DSpec2wpli1D(inputCrossSpec)

%%%%%%%inputCrossSpec is cross-spectrum, 3D matrix, Trial x Frequency x Timewindow.
  inputdata    = imag(inputCrossSpec);          % make everything imaginary
  siz = [size(inputdata) 1];

  n = siz(1);
  if n==1
    outsum   = nansum(inputdata,length(siz)-1);      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(inputdata),length(siz)-1); % normalization of the WPLI
%     if debias
      outssq   = nansum(inputdata.^2,length(siz)-1);
      wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
%       wpli     = outsum./outsumW; % estimator of E(Im(X))/E(|Im(X)|)
%     wpli = reshape(wpli,siz(2:end));
  elseif n>1
    outsum   = nansum(nansum(inputdata,1),length(siz)-1);      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(nansum(abs(inputdata),1),length(siz)-1); % normalization of the WPLI
%     if debias
    outssq   = nansum(nansum(inputdata.^2,1),length(siz)-1);
    wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
%       wpli     = outsum./outsumW; % estimator of E(Im(X))/E(|Im(X)|)
%     wpli = reshape(wpli,siz(2:end));
   
  else
    wpli=[];
  end
