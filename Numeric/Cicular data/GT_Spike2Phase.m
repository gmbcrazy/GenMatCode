 function SpikePhase = GT_Spike2Phase(spikes,lfp,samplingRate,passband,method,powerThresh,varargin)
% USAGE
%[PhaseLockingData] = bz_PhaseModulation(varargin)
% 
% INPUTS
% spikes        -spike time cellinfo struct
%
% lfp           -lfp struct with a single channel from bz_GetLFP()
%
% passband      -frequency range for phase modulation [lowHz highHz] form
%
% intervals     -(optional) may specify timespans over which to calculate 
%               phase modulation.  Formats accepted: tstoolbox intervalSet
%               or a 2column matrix of [starts stops] in seconds
%
% samplingRate  -specifies lfp sampling frequency default=1250
%
% method        -method selection for how to generate phase, 
%               possibilties are: 'hilbert' (default) or 'wavelet'
%
% powerThresh   -integer power threshold to use as cut off, 
%               measured in standard deviations (default = 2)
%
% plotting      -logical if you want to plot, false if not, default=true
%
% saveMat       -logical to save cellinfo .mat file with results, default=false
%
%
% OUTPUTS
%
% phasedistros  - Spike distribution perecentages for each cell in each bin
%               specified by phasebins
%
% phasebins     - 180 bins spanning from 0 to 2pi
%
% phasestats    - ncellsx1 structure array with following (via
%                 CircularDistribution.m from FMAToolbox)
%                    phasestats.m        mean angle
%                    phasestats.mode     distribution mode
%                    phasestats.k        concentration
%                    phasestats.p        p-value for Rayleigh test
%
% 
% Calculates distribution of spikes over various phases from a specified
% cycle of an lfp vector.   Phase 0 means peak of lfp wave.
%
% Brendon Watson 2015
% edited by david tingley, 2017

PhaseBand=[];

SpikePhase=zeros(length(spikes),size(passband,2));
% SpikePhase=nan;
lfp=lfp(:);
for j=1:size(passband,2)

%% Get phase for every time point in LFP
switch lower(method)
    case ('hilbert')
        [b a] = butter(4,[passband(1,j)/(samplingRate/2) passband(2,j)/(samplingRate/2)],'bandpass');
%         [b a] = cheby2(4,20,passband/(samplingRate/2));
        filt = FiltFiltM(b,a,(lfp(:,1)));
        power = fastrms(filt,ceil(samplingRate./passband(1,j)));  % approximate power is frequency band
        hilb = hilbert(filt);
        lfpphase=angle(hilb);
%         lfpphase = mod(angle(hilb),2*pi);
        clear fil
    case ('wavelet')% Use Wavelet transform to calulate the signal phases
%         nvoice = 12;
%         freqlist= 2.^(log2(passband(1)):1/nvoice:log2(passband(2)));
%         error('awt_freqlist, where did this come from?')
%         wt = awt_freqlist(double(lfp(:,1)), samplingRate, freqlist);
%         amp = (real(wt).^2 + imag(wt).^2).^.5;
%         phase = atan2(imag(wt),real(wt));
%         [~,mIdx] = max(amp'); %get index with max power for each timepiont
%         for i = 1:size(wt,1)
%             lfpphase(i) = phase(i,mIdx(i));
%         end
%         lfpphase = mod(lfpphase,2*pi);
        [wave,f,t,coh,wphases,raw,coi,scale,priod,scalef]=getWavelet(double(lfp(:,1)),samplingRate,passband(1,j),passband(2,j),8,0);
        [~,mIdx]=max(wave);%get index max power for each timepiont
        pIdx=mIdx'+[0;size(f,2).*cumsum(ones(size(t,1)-1,1))];%converting to indices that will pick off single maxamp index from each of the freq-based phases at eacht timepoint
        lfpphase=wphases(pIdx);%get phase of max amplitude wave at each timepoint
%         lfpphase = mod(lfpphase,2*pi);%covert to 0-2pi rather than -pi:pi
% %     case ('peaks')
        % not yet coded
        % filter, smooth, diff = 0, diffdiff = negative
    case ('morse')
        if nargin==7
            MorseParam=varargin{1};
        else
            MorseParam=[3 20 2 8];  %%%%[gamma beta D Num.F]
            %%%%%%%%%NumF. of Fre points with each band  
        end
        gamma=MorseParam(1);
        beta=MorseParam(2);
        D=MorseParam(3);
        dt=1/samplingRate;
        HIGH=passband(2,j)*dt*2*pi;
        LOW=passband(1,j)*dt*2*pi;   %%%%%%frequencies in radius
        Frad=morsespace(gamma,beta,HIGH,LOW,D);
        if length(MorseParam)==3
           Frad=Frad;
        elseif length(MorseParam)==4
            numF=8;                             
            FradStep=(Frad(1)-Frad(end))/(numF-1);
            Frad2=Frad(1):(-FradStep):Frad(end);
            Frad=Frad2;
%         Fre2=Frad2/2/pi*samprateD;
%         Fre=Fre2;
        else

        end
        cwtS1=wavetrans(lfp(:,1),{gamma,beta,Frad});  %%%%Jlab calculation;
        cwtS1=cwtS1';
        wave=abs(cwtS1);
        wphases=angle(cwtS1);
        [~,mIdx]=max(wave);%get index max power for each timepiont
        pIdx=mIdx'+[0;length(Frad).*cumsum(ones(size(cwtS1,2)-1,1))];%converting to indices that will pick off single maxamp index from each of the freq-based phases at eacht timepoint
        lfpphase=wphases(pIdx);%get phase of max amplitude wave at each timepoint
%         lfpphase = mod(lfpphase,2*pi);%covert to 0-2pi rather than -pi:pi

        
end

PhaseBand=[PhaseBand lfpphase(:)];

% %% update intervals to remove sub-threshold power periods
% disp('finding intervals below power threshold...')
% thresh = mean(power) + std(power)*powerThresh;
% minWidth = (samplingRate./passband(2)) * 2; % set the minimum width to two cycles
% 
% below=find(power<thresh);
% if max(diff(diff(below))) == 0
%     below_thresh = [below(1) below(end)];
% elseif length(below)>0;
%     ends=find(diff(below)~=1);
%     ends(end+1)=length(below);
%     ends=sort(ends);
%     lengths=diff(ends);
%     stops=below(ends)./samplingRate;
%     starts=lengths./samplingRate;
%     starts = [1; starts];
%     below_thresh(:,2)=stops;
%     below_thresh(:,1)=stops-starts;
% else
%     below_thresh=[];
% end
% 
% % now merge interval sets from input and power threshold
% intervals = SubtractIntervals(intervals,below_thresh);  % subtract out low power intervals
% intervals = intervals(diff(intervals')>minWidth./samplingRate,:); % only keep min width epochs
% 
% bools = InIntervals(spikes,intervals);
% bools = ceil(spikes(bools)*samplingRate);
bools = ceil(spikes*samplingRate);
bools(bools==0)=1;
bools(bools>length(lfpphase))=length(lfpphase);

tempPhase=lfpphase(bools);
SpikePhase(:,j)=tempPhase(:);



end

%% Cumulative effect across all spikes from all cells... not saving these stats for now
% phasebins=[];
% if length(cum_spkphases) > 10
%     [cpd,phasebins,cps]=CircularDistribution(cum_spkphases,'nBins',180);
%     cRp = cps.p;
% 
%     if plotting
%         h(end+1) = figure;
%         hax = subplot(1,2,1); 
%         rose(cum_spkphases)
%         title(hax,['All Spikes/Cells Accumulated. Rayleigh p = ' num2str(cps.p) '.'])
% 
%         hax = subplot(1,2,2); 
%         bar(phasebins*180/pi,cpd)
%         xlim([0 360])
%         set(hax,'XTick',[0 90 180 270 360]) 
%         hold on;
%         plot([0:360],cos(pi/180*[0:360])*0.05*max(cpd)+0.95*max(cpd),'color',[.7 .7 .7])
%         set(h(end),'name',['PhaseModPlotsForAllCells']);
%     end
% end
% % 
% % detectorName = 'bz_PhaseModulation';
% % channels = lfp.channels;
% % detectorParams = v2struct(intervals,samplingRate,method,plotting,numBins,...
% %     passband,powerThresh,channels);
% % 
% % PhaseLockingData = v2struct(phasedistros,phasebins,...
% %                             phasestats,spkphases,...
% %                             detectorName, detectorParams);
% % PhaseLockingData.region = spikes.region;
% % PhaseLockingData.UID = spikes.UID;
% % PhaseLockingData.sessionName = spikes.sessionName;
% % 
% % if saveMat
% %  save([lfp.Filename(1:end-4) '.PhaseLockingData.cellinfo.mat'],'PhaseLockingData');
% % end