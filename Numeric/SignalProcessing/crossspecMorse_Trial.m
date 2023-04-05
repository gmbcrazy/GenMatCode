
function Data=crossspecMorse_Trial(TrialSpec)

%%%%Calculated weighted phase lag index, Averaged Coherence, PSD across trial based different
%%%%TrialIndex Needed.

%%%%TrialSpec is calculated from coh_TrialData.m
%%%%TrialSpec.Sxy is cross spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.Sxx is power spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.Syy is power spectrum 3D matrix, Trial x Frequency x Timewindow.
%%%%TrialSpec.options is parameters.



D = gpuDevice;
reset(D);

TPxx=TrialSpec.Sxx;
TPyy=TrialSpec.Syy;
TPxy=TrialSpec.Sxy;
if length(gpuDevice)>=1
   TPxx=gpuArray(TPxx);
   TPyy=gpuArray(TPyy);
   TPxy=gpuArray(TPxy);
end

ns=size(TPxy);

% Data.Pxx=nanmean(TPxx,length(ns));
% Data.Pxy=nanmean(TPxy,length(ns));
% Data.Pyy=nanmean(TPyy,length(ns));

Data.Pxx=gather(nanmean(TPxx,3));
Data.Pyy=gather(nanmean(TPyy,3));
Data.Pxy=gather(nanmean(TPxy,3));

wpli=gather(cross3DSpec2wpli2D(TPxy));


Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.wpli=wpli;
Data.Fre=TrialSpec.Fre;



function wpli=cross3DSpec2wpli2D(inputCrossSpec)

%%%%%%%inputCrossSpec is cross-spectrum, 3D matrix, Trial x Frequency x Timewindow.
  inputdataRaw    = imag(inputCrossSpec);          % make everything imaginary
  siz = [size(inputdataRaw) 1];

  n = siz(1);
  for itrial=1:n
    inputdata=inputdataRaw(itrial,:,:);
    outsum   = nansum(inputdata,length(siz)-1);      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(inputdata),length(siz)-1); % normalization of the WPLI
%     if debias
      outssq   = nansum(inputdata.^2,length(siz)-1);
      wplitemp     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
      wplitemp     = outsum./outsumW; % estimator of E(Im(X))/E(|Im(X)|)
      wpli(itrial,:) = wplitemp;
   
  end


