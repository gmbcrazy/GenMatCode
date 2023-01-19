
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

for itrial=1:length(TrialIndex)
[TTPxx,f,xunits] = computepsd(TPxx(itrial,:,:),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPyy,f,xunits] = computepsd(TPyy(itrial,:,:),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPxy,f,xunits] = computepsd(TPxy(itrial,:,:),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
end

if length(TrialIndex)>1
Data.Pxx=nanmean(nanmean(TPxx,3),1);
Data.Pyy=nanmean(nanmean(TPyy,3),1);
Data.Pxy=nanmean(nanmean(TPxy,3),1);
elseif length(TrialIndex)==1
Data.Pxx=nanmean(TPxx,3);
Data.Pyy=nanmean(TPyy,3);
Data.Pxy=nanmean(TPxy,3);
else
    
end



Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.Fre=f;



function wpli=cross3DSpec2wpli1D(inputCrossSpec)

%%%%%%%inputCrossSpec is cross-spectrum, 3D matrix, Trial x Frequency x Timewindow.
  inputdata    = imag(inputCrossSpec);          % make everything imaginary
  siz = [ size(inputdata) 1];

  n = siz(1);
  if n==1
    outsum   = nansum(inputdata,1);      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(inputdata),1); % normalization of the WPLI
%     if debias
      outssq   = nansum(inputdata.^2,1);
      wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
%       wpli     = outsum./outsumW; % estimator of E(Im(X))/E(|Im(X)|)
    wpli = reshape(wpli,siz(2:end));
  elseif n>1
    outsum   = nansum(nansum(inputdata,1),siz(end-1));      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(nansum(abs(inputdata),1),siz(end-1)); % normalization of the WPLI
%     if debias
      outssq   = nansum(nansum(inputdata.^2,1),siz(end-1));
      wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
%       wpli     = outsum./outsumW; % estimator of E(Im(X))/E(|Im(X)|)
    wpli = reshape(wpli,siz(2:end));
   
  else
    wpli=[];
  end
