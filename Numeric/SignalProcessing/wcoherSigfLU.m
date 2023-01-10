function varargout = wcoherSigfLU(s1,s2,scales,wname,NTW,NSW,mccount,SimuLength,Pvalue)
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
flag_SMOOTH = false;
if ~isempty(NSW) && isequal(fix(NSW),NSW) && (NSW>0)
    flag_SMOOTH = true;
end
if ~isempty(NTW) && isequal(fix(NTW),NTW) && (NTW>0)
    flag_SMOOTH = true;
else
    NTW = min([round(0.05*length(s1)),20]);
end


ar1=[ar1nv(s1(:)) ar1nv(s2(:))];
nbins=1000;
wlc=zeros(length(scales),nbins);

wbh = waitbar(0,['Running Monte Carlo (significance)'],'Name','Monte Carlo (WTC)');

% mccount=100;
for i=1:mccount
     waitbar(i/mccount,wbh);
%     d1=rednoise(length(s1),ar1(1),1);    
%     d2=rednoise(length(s1),ar1(2),1);   
    
    d1=rednoise(SimuLength,ar1(1),1);    
    d2=rednoise(SimuLength,ar1(2),1);    

cfs_d1    = cwt(d1,scales,wname);
cfs_d10   = cfs_d1;
cfs_d1    = smoothCFS(abs(cfs_d1).^2,flag_SMOOTH,NSW,NTW);
cfs_d1    = sqrt(cfs_d1);
cfs_d2    = cwt(d2,scales,wname);
cfs_d20   = cfs_d2;
cfs_d2    = smoothCFS(abs(cfs_d2).^2,flag_SMOOTH,NSW,NTW);
cfs_d2    = sqrt(cfs_d2);
cfs_cross = conj(cfs_d10).*cfs_d20;
cfs_cross = smoothCFS(cfs_cross,flag_SMOOTH,NSW,NTW);
WCOH      = abs(cfs_cross./(cfs_d1.*cfs_d2));
     for s=1:length(scales)
        cd=WCOH(s,:);
        cd=max(min(cd,1),0);
        cd=floor(cd*(nbins-1))+1;
        for jj=1:length(cd)
            wlc(s,cd(jj))=wlc(s,cd(jj))+1;
        end

     end

end

tempP=1-Pvalue;

for s=1:length(scales)
    rsqy=((1:nbins)-tempP)/nbins;
    ptile=wlc(s,:);
    idx=find(ptile~=0);
    ptile=ptile(idx);
    rsqy=rsqy(idx);
    ptile=cumsum(ptile);
    ptile=(ptile-tempP)/ptile(end);
    sig95(s)=interp1(ptile,rsqy,Pvalue);
end
wtcsig=sig95(:);
close(wbh);




varargout = {wtcsig};




%----------------------------------------------------------------------
function CFS = smoothCFS(CFS,flag_SMOOTH,NSW,NTW)

if ~flag_SMOOTH , return; end
if ~isempty(NTW)
    len = NTW;
    F   = ones(1,len)/len;
    CFS = conv2(CFS,F,'same');
end
if ~isempty(NSW)
    len = NSW;
    F   = ones(1,len)/len;    
    CFS = conv2(CFS,F','same');
end

