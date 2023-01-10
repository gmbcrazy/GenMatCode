 function [SpikePhase,Fre] = GT_Spike2PhaseMorlet(spikes,lfp,samprate,varargin)

if nargin<4
% Default setting
Fband=WaveParam.Fband;
nb=WaveParam.nb; %%%%number of scales
WaveParam.DownSample=5; %DownSampling
% Default setting
elseif nargin==4
WaveParam=varargin{1};
WaveParam.samprate=samprate;
else
    
end

PhaseBand=[];

SpikePhase=zeros(length(spikes),length(WaveParam.Fband));
% SpikePhase=nan;
lfp=lfp(:);
samprateD=samprate/WaveParam.DownSample;
LFPtemp=zscore(decimate(lfp,WaveParam.DownSample));

% WaveParam.Fband=WaveParam.Freq;
% Fband=WaveParam.Fband;
Fband=WaveParam.Fband;
MorletFourierFactor = 4*pi/(6+sqrt(2+6^2));  %%previously used

if length(Fband)==2
   nb=WaveParam.nb; %%%%number of scales
   scalesBand=1./(Fband*MorletFourierFactor);
%    scalesBand=FourierFactor./Fband;

   s0 = scalesBand(2);
   smax = scalesBand(1);
   ds=(log2(smax)-log2(s0))/(nb-1);
   scales = struct('s0',s0,'ds',ds,'nb',nb,'type','pow','pow',2);
   
else
   scales=1./(Fband*MorletFourierFactor);
%    scales=FourierFactor./Fband;

end

%    Fre=1./scales/MorletFourierFactor;

dt=1/samprateD;
cwtS1 = cwtft({LFPtemp,dt},'scales',scales,'wavelet','morl');
% invscales = 1./scales(:);
if length(Fband)==2
Fre=cwtS1.frequencies;
else
    Fre=Fband;
end
% invscales = repmat(invscales,1,length(LFPtemp));
%%%%No smoothing
lfpphase=angle(cwtS1.cfs);

bools = ceil(spikes*samprateD);
SpikePhase=lfpphase(:,bools)';

