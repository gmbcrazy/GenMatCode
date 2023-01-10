function varargout = wavesigfLU(s1,F,adfreq,Pvalue)
%WCOHER Wavelet coherence.
%	For two signals S1 and S2, WCOH = WCOHER(S1,S2,SCALES,WAME)
%   returns the Wavelet Coherence (WCOH).
%   SCALES is a vector which contains the scales, and WNAME is a 
%   string containing the name of the wavelet used for the continuous 
%   wavelet transform.
%
%   In addition, [WCOH,WCS] = WCOHER(...) returns also the
%   Wavelet Cross Spectrum (WCS).
%
%   In addition, [WCOH,WCS,CWT_S1,CWT_S2] = WCOHER(...) returns 
%   also the continuous wavelet transforms of S1 and S2.
%
%   [...] = WCOHER(...,'ntw',VAL,'nsw',VAL) allows to smooth the 
%   CWT coefficients before computing WCOH and WCS. Smoothing
%   can be done in time or scale, specifying in each case the width 
%   of the window using positive integers:
%       'ntw' : N-point time window  (defaut is min[20,0.05*length(S1)])
%       'nsw' : N-point scale window (default is 1).
%
%   [...] = WCOHER(...,'plot') displays the modulus and phase 
%   of the Wavelet Coherence (WCOH).
%
%   [...] = WCOHER(...,'plot',TYPEPLOT) allows to display other plots.
%	The valid values for TYPEPLOT are:
%       'wcoh' : More on WCOH phase is displayed.
%       'wcs'  : WCS is displayed.
%       'cwt'  : Continuous wavelet transforms are displayed.
%       'all'  : All the outputs are displayed.
%
%   Arrows representing the phase are displayed on the Wavelet
%   Coherence plots. 
%   [...] = WCOHER(...,'nat',VAL,'nas',VAL,'ars',ARS) allows to 
%   change the number and the scale factor for the arrows (see QUIVER):
%       'nat' : number of arrows in time.
%       'nas' : number of arrows in scale.
%       'asc' : scale factor for the arrows.
%       ARS = 2 doubles their relative length, and ARS = 0.5 
%       halves the length.

%   M. Misiti, Y. Misiti, G. Oppenheim, J.M. Poggi 02-Feb-2010.
%   Last Revision: 29-Mar-2012.
%   Copyright 1995-2012 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $ $Date: 2012/04/20 19:48:16 $
ar1=[ar1nv(s1(:))];

variance = std(s1(:))^2;



fft_theor = (1-ar1^2) ./ (1-2*ar1*cos(F*2*pi/adfreq)+ar1^2);  % [Eqn(16)]
fft_theor = variance*fft_theor;  % include time-series variance
dof=2;

	chisquare = chisquare_inv(Pvalue,dof)/dof;
	signif = fft_theor*chisquare ;  % [Eqn(18)]
    
	signif = sqrt(signif) ;  % [Eqn(18)]






varargout = {signif};



