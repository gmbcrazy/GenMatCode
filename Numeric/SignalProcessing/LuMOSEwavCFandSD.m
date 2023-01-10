function [FourierFactor,sigmaT, cf] = LuMOSEwavCFandSD(varargin)
%   This function is for internal use only. It may change or be removed
%   in a future release.

%#codegen
%   Copyright 2017-2020 MathWorks, Inc.


% When would I use the following?
% coder.internal.prefer_const(wname);
% coder.internal.prefer_const(varargin);
if ~isempty(varargin)
    ga = varargin{1};
    be = varargin{2};
end
% Initialize cf and sigmaT so they are defined on all execution paths for 
% code generation
% We error if these zero upon executing the function.
cf = 0;
sigmaT = 0;

% cf is wavelet center frequency in radians / second, sigmaT is the wavelet
% standard deviation
        % Morse
        cf = morsepeakfreq(ga,be);
        [~,~,~,sigmaT,~] = morseproperties(ga,be);




if coder.target('MATLAB')
    if cf == 0 || sigmaT == 0
        error(message('Wavelet:cwt:CFSigmaZero'));
    end
else
    coder.internal.assert(cf ~=0 && sigmaT ~= 0, 'Wavelet:cwt:CFSigmaZero');
end
% Convert scale from center frequency reference to sampling frequency ref.
FourierFactor = (2*pi)/cf;


function [peakAF, peakCF] = morsepeakfreq(ga,be)
% peakfreq = morsepeakfreq(ga,be) returns the peak frequency for the 
% zero-th order member of the Morse wavelet family parameterized by ga
% (gamma) and be (beta).

%   Copyright 2017-2020 MathWorks, Inc.
%#codegen

% % narginchk(2,2);
% % coder.internal.prefer_const(ga,be);
% peak frequency for 0-th order Morse wavelet is
% $(\frac{\beta}{\gamma})^{1/\gamma}$
peakAF = exp(1/ga*(log(be)-log(ga)));
% Obtain the peak frequency in cyclical frequency
peakCF = peakAF/(2*pi);


function [width,skew,kurt,sigmaT,sigmaF] = morseproperties(ga,be)
% [width,skew,kurt,sigmaT,sigmaF] = morseproperties(ga,be);
% Returns the time width, skew, kurtosis, and the products in the 
% Heisenberg area of the Morse (\beta,\gamma) wavelet.
% 
% This function is for internal use only, it may change in a future
% release.
%
% Algorithm due to JM LilLy
% 
% Lilly, J. M. (2015), jLab: A data analysis package for Matlab, v. 1.6.1, 
% http://www.jmlilly.net/jmlsoft.html.

%#codegen
%   Copyright 2017-2020 MathWorks, Inc.

% % narginchk(2,2);
% % coder.internal.prefer_const(ga);
% % coder.internal.prefer_const(be);
width = sqrt(ga*be);
skew = (ga-3)/width;
kurt=3-skew.^2-(2/width^2);


logsigo1=frac(2,ga).*log(frac(ga,2*be))+gammaln(frac(2*be+1+2,ga))-gammaln(frac(2*be+1,ga));
logsigo2=frac(2,ga).*log(frac(ga,2*be))+2.*gammaln(frac(2*be+2,ga))-2.*gammaln(frac(2*be+1,ga));

sigo=sqrt(exp(logsigo1)-exp(logsigo2));  
ra=2*morse_loga(ga,be)-2*morse_loga(ga,be-1)+morse_loga(ga,2*(be-1))-morse_loga(ga,2*be);
rb=2*morse_loga(ga,be)-2*morse_loga(ga,be-1+ga)+morse_loga(ga,2*(be-1+ga))-morse_loga(ga,2*be);
rc=2*morse_loga(ga,be)-2*morse_loga(ga,be-1+ga./2)+morse_loga(ga,2*(be-1+ga./2))-morse_loga(ga,2*be);

logsig2a=ra+frac(2,ga).*log(frac(be,ga))+2*log(be)+gammaln(frac(2*(be-1)+1,ga))-gammaln(frac(2*be+1,ga));
logsig2b=rb+frac(2,ga).*log(frac(be,ga))+2*log(ga)+gammaln(frac(2*(be-1+ga)+1,ga))-gammaln(frac(2*be+1,ga));
logsig2c=rc+frac(2,ga).*log(frac(be,ga))+log(2)+log(be)+log(ga)+gammaln(frac(2*(be-1+ga./2)+1,ga))-gammaln(frac(2*be+1,ga));

sig2a=exp(logsig2a);
sig2b=exp(logsig2b);
sig2c=exp(logsig2c);
sigt=sqrt(sig2a+sig2b-sig2c);

sigmaT=real(sigt);
sigmaF=real(sigo);


function[loga]=morse_loga(ga,be)
loga=frac(be,ga).*(1+log(ga)-log(be));


function fracout = frac(a,b)

fracout = a/b;






