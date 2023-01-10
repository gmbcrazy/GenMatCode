function [FTrans, FCoeff,F] = MARSpec(A,Z,MORDER,fs,NFFT,STFreq,EDFreq)
%[FSpectra FTrans FCoeff FDTF FDTFn FCAUS F]=MARSpec(MARP,Z,MORDER,handles.RawData.fs,NFFT,STFreq,EDFreq);
% A is the coefficients matrix, defined as A(i,j).C, k is the index for
% coefficients
% Z is the noise co-variance matrix, defined as Z(i,j)
% FCoeff is the coefficients matrix in frequncy, defined as MA.C
% FSpectra is the power spectra matrix, defined as MS.C
% FTrans is the transfer matrix MH.C
% FDTF is the directed transfer function
% FDTFn is the normalised directed transfer function
% F is the frequency

% Geweke Measurement of linear dependence and feedback between multiple time series. J Am Stat Assoc 77: 304-324, 1982
% Granger CWJ. Investigating casual relations by econometric models and
% cross-spectral methods. Econometrica 37: 424-438

L=length(A);
MI=eye(L);
%DZ=diag(diag(Z));%???? ZD or Z

tmpOrder=-([1:MORDER+1]-1);
tmpd=(EDFreq-STFreq)/fs*2*pi/NFFT;
stx=STFreq/fs*2*pi-tmpd;
%f=([1:NFFT]-1)*(EDFreq-STFreq)/NFFT+STFreq;

for k=1: NFFT
    x=exp(i*tmpOrder*(k*tmpd+stx));
    for m=1:L
        for n=1:L
            TMPA=[MI(m,n) A(m,n).C];
            FCoeff(k).C(m,n)=sum(TMPA.*x);
        end
    end    
    FTrans(k).C=inv(FCoeff(k).C);
    
    %FSpectra(k).C=abs(FTrans(k).C*DZ*(FTrans(k).C')); %???    
    %MOne=ones(L);
    %FDTF(k).C=abs(FTrans(k).C).^2;
    %tmpM=FDTF(k).C*MOne;
    %FDTFn(k).C=(FDTF(k).C)./tmpM;

    %tmpf=det(FCoeff(k).C);
    %tmpf=abs(tmpf*conj(tmpf));
    %FCAUS(k).C=abs(FCoeff(k).C).^2/tmpf;% I(j->i)=(A(i,j))^2/det(A)^2
end
F=([1:NFFT]-1)*(EDFreq-STFreq)/NFFT+STFreq;
