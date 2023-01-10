function [Cxy,Pxx,Pyy,f] = welchCohLu(x,ts_start,IntervalRemove,varargin)
%WELCH Welch spectral estimation method.
%   [Pxx,F] = WELCH(X,WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,ESTTYPE)
%   [Pxx,F] = WELCH({X},WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,'psd')
%   [Pxx,F] = WELCH({X},WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,'ms')
%   [Pxy,F] = WELCH({X,Y},WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,'cpsd')
%   [Txy,F] = WELCH({X,Y},WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,'tfe')
%   [Cxy,F] = WELCH({X,Y},WINDOW,NOVERLAP,NFFT,Fs,SPECTRUMTYPE,'mscohere')
%
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
% error(nargoutchk(0,3,nargout,'struct'));
esttype='mscohere';
% Parse input arguments.
[x,M,isreal_x,y,Ly,win,winName,winParam,noverlap,k,L,options] = ...
    welchparse(x,esttype,varargin{:});

Fs=options.Fs;

% Frequency vector was specified, return and plot two-sided PSD
freqVectorSpecified = false; nrow = 1;
if length(options.nfft) > 1, 
    freqVectorSpecified = true; 
    [ncol,nrow] = size(options.nfft); 
end

% Window length
nwind = length(win);

% Make x and win into columns
x = x(:); 
win = win(:); 

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
if freqVectorSpecified, 
    Sxx = zeros(length(options.nfft),1);   
else
    Sxx = zeros(options.nfft,1); 
end
range = options.range;

LminusOverlap = L-noverlap;
xStart = 1:LminusOverlap:k*LminusOverlap;
xEnd   = xStart+L-1;

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


        % Note: (Sxy1+Sxy2)/(Sxx1+Sxx2) != (Sxy1/Sxy2) + (Sxx1/Sxx2)
        % ie, we can't push the computation of Cxy into computeperiodogram.
        Sxy = zeros(options.nfft,1); % Initialize
        Syy = zeros(options.nfft,1); % Initialize
        for i = 1:k,
            temp1=detrend(x(xStart(i):xEnd(i)));  
            temp1=x(xStart(i):xEnd(i));
            temp2=detrend(y(xStart(i):xEnd(i)));
            temp2=y(xStart(i):xEnd(i));     

            [Sxxk,w] = computeperiodogram(temp1,...
                win,options.nfft,esttype,options.Fs);
            [Syyk,w] =  computeperiodogram(temp2,...
                win,options.nfft,esttype,options.Fs);
            [Sxyk,w] = computeperiodogram({temp1,...
                temp2},win,options.nfft,esttype,options.Fs);
            Sxx  = Sxx + Sxxk;
            Syy  = Syy + Syyk;
            Sxy  = Sxy + Sxyk;
        end
Sxx = Sxx./k; % Average the sum of the periodograms

    Sxy = Sxy./k; % Average the sum of the periodograms

        Syy = Syy./k; % Average the sum of the periodograms

% Generate the freq vector directly in Hz to avoid roundoff errors due to
% conversions later.
if ~freqVectorSpecified, 
    w = psdfreqvec('npts',options.nfft, 'Fs',options.Fs);
else
    if strcmpi(options.range,'onesided')
        warning(message('signal:welch:InconsistentRangeOption'));
    end
    options.range = 'twosided';
end


% Compute the 1-sided or 2-sided PSD [Power/freq] or mean-square [Power].
% Also, corresponding freq vector and freq units.
[Pxy,f,xunits] = computepsd(Sxy,w,options.range,options.nfft,options.Fs,esttype);

[Pxx,w,units] = computepsd(Sxx,w,options.range,options.nfft,options.Fs,esttype);
[Pyy,f,xunits] = computepsd(Syy,w,options.range,options.nfft,options.Fs,esttype);
 Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Cxy

% [EOF]
