function [S1 f] = pmtmLu(x,ts_start,IntervalRemove,params)
%WELCH Welch spectral estimation method.
%   [Pxx,F] = WELCH(X,WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,ESTTYPE)
% Inputs:
%       params: structure with fields tapers, pad, Fs, fpass, err, trialave
%           - optional
%             tapers : precalculated tapers from dpss or in the one of the following
%                       forms:  
%                       (1) A numeric vector [TW K] where TW is the
%                           time-bandwidth product and K is the number of
%                           tapers to be used (less than or equal to
%                           2TW-1). 
%                       (2) A numeric vector [W T p] where W is the
%                           bandwidth, T is the duration of the data and p 
%                           is an integer such that 2TW-p tapers are used. In
%                           this form there is no default i.e. to specify
%                           the bandwidth, you have to specify T and p as
%                           well. Note that the units of W and T have to be
%			                consistent: if W is in Hz, T must be in seconds
% 			                and vice versa. Note that these units must also
%			                be consistent with the units of params.Fs: W can
%		    	            be in Hz if and only if params.Fs is in Hz.
%                           The default is to use form 1 with TW=3 and K=5
%
%	        pad		    (padding factor for the FFT) - optional (can take values -1,0,1,2...). 
%                    -1 corresponds to no padding, 0 corresponds to padding
%                    to the next highest power of 2 etc.
%			      	 e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
%			      	 to 512 points, if pad=1, we pad to 1024 points etc.
%			      	 Defaults to 0.
%           Fs   (sampling frequency) - optional. Default 1.
%           fpass    (frequency band to be used in the calculation in the form
%                                   [fmin fmax])- optional. 
%                                   Default all frequencies between 0 and Fs/2
%           err  (error calculation [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
%                                   [0 p] or 0 - no error bars) - optional. Default 0.
%           trialave (average over trials when 1, don't average when 0) - optional. Default 0

%   Inputs:
%      see "help pwelch" for complete description of all input arguments.
%      ESTTYPE - is a string specifying the type of estimate to return, the
%                choices are: psd, cpsd, tfe, and mscohere.
%
%   Outputs:
%      Depends on the input string ESTTYPE:
%      Pxx - Power Spectral Density (PSD) estimate, or
%      MS  - Mean-square spectrum, or
%      Pxy - Cross Power Spectral Density (CPSD) estimate, or
%      Txy - Transfer Function Estimate (TFE), or
%      Cxy - Magnitude Squared Coherence.
%      F   - frequency vector, in Hz if Fs is specified, otherwise it has
%            units of rad/sample

%   Author(s): P. Pacheco
%   Copyright 1988-2006 The MathWorks, Inc.
%   $Revision: 1.1.6.11 $  $Date: 2010/12/06 00:12:25 $


%   References:
%     [1] Petre Stoica and Randolph Moses, Introduction To Spectral
%         Analysis, Prentice-Hall, 1997, pg. 15
%     [2] Monson Hayes, Statistical Digital Signal Processing and
%         Modeling, John Wiley & Sons, 1996.

error(nargchk(4,10,nargin,'struct'));
error(nargoutchk(0,3,nargout,'struct'));

% Parse input arguments.
% [x,M,isreal_x,y,Ly,win,winName,winParam,noverlap,k,L,options] = ...
%     welchparse(x,esttype,varargin{:});
M=length(x);
win=params.tapers(2);
Fs=params.Fs;
nfft=params.nfft;
noverlap=params.noverlap;

% Frequency vector was specified, return and plot two-sided PSD
freqVectorSpecified = false; nrow = 1;
if length(nfft) > 1, 
    freqVectorSpecified = true; 
    [ncol,nrow] = size(nfft); 
end

% Window length
nwind = round(win*Fs);

% Make x and win into columns
x = x(:); 

% Determine the number of columns of the STFT output (i.e., the S output)
ncol = fix((M-noverlap)/(nwind-noverlap));

%
% Pre-process X
%
colindex = 1 + (0:(ncol-1))*(nwind-noverlap);
rowindex = (1:nwind)';


t = ((colindex-1)+((nwind)/2)')/Fs+ts_start;




% Compute the periodogram power spectrum of each segment and average always
% compute the whole power spectrum, we force Fs = 1 to get a PS not a PSD.

% Initialize

LminusOverlap = nwind-noverlap;
xStart = 1:LminusOverlap:ncol*LminusOverlap;
xEnd   = xStart+nwind-1;

if ~isempty(IntervalRemove)
IntervalRemove=IntervalRemove-ts_start;
Invalid=[];

xStartTime=xStart/Fs+ts_start;
xEndTime=xEnd/Fs+ts_start;

for i=1:length(IntervalRemove)
    temp1=find(xStartTime>=IntervalRemove(i,1)&xStartTime<=IntervalRemove(i,2));
    temp2=find(xEndTime>=IntervalRemove(i,1)&xEndTime<=IntervalRemove(i,2));
    temp3=find(xStartTime<=IntervalRemove(i,1)&xEndTime>=IntervalRemove(i,2));

    Invalid=[Invalid;temp1(:);temp2(:);temp3(:)];
    clear temp1 temp2 temp3;
end
    Invalid=unique(Invalid);
    xStart(Invalid)=[];
    xEnd(Invalid)=[];
end

k=length(xStart);

for i=1:k
    datax(:,i)=x(xStart(i):xEnd(i));
end

[N,C1]=size(datax);

[tapers,pad,Fs,fpass,err,trialave]=getparams(params);

nfft=params.nfft;

[f,findx]=getfgrid(Fs,nfft,fpass); 
[tapers,eigs]=dpsschk(tapers,N,Fs); % check tapers
J1=mtfftc(datax,tapers,nfft,Fs);
J1=J1(findx,:,:);
S1=squeeze(mean(conj(J1).*J1,2));

S1=squeeze(mean(S1,2))