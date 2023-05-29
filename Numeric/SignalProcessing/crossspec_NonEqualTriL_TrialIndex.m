
function Data=crossspec_NonEqualTriL_TrialIndex(TrialSpec,TrialIndex)

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


% ns=size(TPxy);

TPxx=TrialSpec.Sxx(TrialIndex);
TPyy=TrialSpec.Syy(TrialIndex);
TPxy=TrialSpec.Sxy(TrialIndex);

esttype='mscohere';

for itrial=1:length(TrialIndex)
[TTPxx{itrial},f,xunits] = computepsd(squeeze(TPxx{itrial}),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPyy{itrial},f,xunits] = computepsd(squeeze(TPyy{itrial}),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
[TTPxy{itrial},f,xunits] = computepsd(squeeze(TPxy{itrial}),TrialSpec.w,TrialSpec.options.range,TrialSpec.options.nfft,TrialSpec.options.Fs,esttype);
end

[wpli1,wpli2,wpli3]=cross3DSpec2wpli1D(TTPxy);

   for iTrial=1:length(TTPxx) 
       if iTrial==1
          Data.Pxx=nanmean(TTPxx{iTrial},2);
          Data.Pyy=nanmean(TTPyy{iTrial},2);
          Data.Pxy=nanmean(TTPxy{iTrial},2);
       else
          Data.Pxx=Data.Pxx+nanmean(TTPxx{iTrial},2);
          Data.Pyy=Data.Pyy+nanmean(TTPyy{iTrial},2);
          Data.Pxy=Data.Pxy+nanmean(TTPxy{iTrial},2);
       end
   end




Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.wpli1=wpli1;
Data.wpli2=wpli2;
Data.wpli3=wpli3;

Data.Fre=f;



function [wpli1 wpli2 wpli3]=cross3DSpec2wpli1D(inputCrossSpec)

%%%%%%%inputCrossSpec is cross-spectrum, nTrial cell variable, each trial is a 2D matrix, Frequency x Timewindow.
  for itrial=1:length(inputCrossSpec)

      inputdata    = imag(inputCrossSpec{itrial});          % make everything imaginary


      if itrial==1
      siz = [size(inputdata)];

    outsum   = nansum(inputdata,length(siz));      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(inputdata),length(siz)); % normalization of the WPLI
%     if debias
    outssq   = nansum(inputdata.^2,length(siz));

     else
    outsum   = outsum+nansum(inputdata,length(siz));      % compute the sum; this is 1 x size(2:end)
    outsumW  = outsumW+nansum(abs(inputdata),length(siz)); % normalization of the WPLI
%     if debias
    outssq   = outssq+nansum(inputdata.^2,length(siz));

      end

  end
%     wpli1 = outsum./outsumW; % do the pairwise thing in a handy way
    wpli1  = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way

%   %%%%%%%inputCrossSpec is cross-spectrum, nTrial cell variable, each trial is a 2D matrix, Frequency x Timewindow.
  for itrial=1:length(inputCrossSpec)
      inputdata    = imag(inputCrossSpec{itrial});          % make everything imaginary
      siz = [size(inputdata)];

    outsum   = nansum(inputdata,length(siz));      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(inputdata),length(siz)); % normalization of the WPLI
%     if debias
    outssq   = nansum(inputdata.^2,length(siz));
    wpli2(:,itrial)     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way


  end

  wpli2=nanmean(wpli2,2);


%   %%%%%%%inputCrossSpec is cross-spectrum, nTrial cell variable, each trial is a 2D matrix, Frequency x Timewindow.

%%%average Crossspect across window for each trial
  for itrial=1:length(inputCrossSpec)
      inputdata    = inputCrossSpec{itrial};          
      siz = [size(inputdata)];
      meanPxy(:,itrial)=nanmean(inputdata,length(siz));
  end
%%%average Crossspect across window for each trial

    siz=size(meanPxy);
    meanPxy=imag(meanPxy);
    outsum   = nansum(meanPxy,length(siz));      % compute the sum; this is 1 x size(2:end)
    outsumW  = nansum(abs(meanPxy),length(siz)); % normalization of the WPLI
%     if debias
    outssq   = nansum(meanPxy.^2,length(siz));
    wpli3  = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
    wpli3  = outsum./outsumW; % do the pairwise thing in a handy way

% %   wpli3=nanmean(wpli2,2);

%   %     wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
% %     wpli     = (outsum.^2 - outssq)./(outsumW.^2 - outssq); % do the pairwise thing in a handy way
%     wpli     = outsum./outsumW; % do the pairwise thing in a handy way
