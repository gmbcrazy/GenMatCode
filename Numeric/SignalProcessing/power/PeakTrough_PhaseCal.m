function [filtPhase,PeakTrough,filtSig]=PeakTrough_filtPhaseCal(eeg,Passband,ZeroBand,SamplingRate,MINW)
 
%%%%%%%%mainly based on method from 
%"Cycle-by-cycle analysis of neural oscillations
%published in Journal of Neurophysiology doi: 10.1152/jn.00273.2019"

% Fernández-Ruiz A, Oliva A, Nagy GA, Maurer AP, Berényi A, Buzsáki G. 2017. 
% Entorhinal-CA3 Dual-Input Control of Spike Timing in the Hippocampus by Theta-Gamma Coupling. Neuron 93:1213–1226.e5. doi:10.1016/j.neuron.2017.02.017



%%%output PeakTrough gives the index of the negative, postive peak of the filtered
%%%signals as well as those of zero crossing; 

% MINW=SamplingRate/Passband(2)/2;

zcd = dsp.ZeroCrossingDetector;
zci = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);                    % Returns Zero-Crossing Indices Of Argument Vector
% zx = zci(y);                                         

if Passband(1)>0
[bb,aa] = butter(4,[Passband(1)/(SamplingRate/2) Passband(2)/(SamplingRate/2)],'bandpass');
else
[bb,aa] = butter(4,Passband(2)/(SamplingRate/2),'low');
  
end
filtSig = FiltFiltM(bb,aa,eeg(:));

if sum(abs(Passband-ZeroBand))==0
zeroSig=filtSig;
else
[bb,aa] = butter(4,[ZeroBand(1)/(SamplingRate/2) ZeroBand(2)/(SamplingRate/2)],'bandpass');
zeroSig = FiltFiltM(bb,aa,eeg(:));
end
TH=median(-filtSig)+0.5*std(filtSig);
[NegPB,NegPBI]=findpeaks(-filtSig,'MinPeakDistance',MINW); %%%%%%%%Currently used;
Invalid=(NegPB<TH);
NegPB(Invalid)=[];
NegPBI(Invalid)=[];

%         [PosP,PosPI]=findpeaks(filtPhase,'MinPeakHeight',3.1,'MinPeakWidth',MINW,'MaxPeakWidth',MAXW);
%         [NegP,NegPI]=findpeaks(-filtPhase(:),'MinPeakHeight',3.1,'MinPeakWidth',MINW,'MaxPeakWidth',MAXW);
        
        clear PosPB PosPBI RisePBI DecayPBI;
        PosPBI=zeros(size(NegPBI))+nan;
        RisePBI=zeros(size(NegPBI))+nan;
        DecayPBI=zeros(size(NegPBI))+nan;

        filtPhase=zeros(size(filtSig))+nan;
        
        
        for i=1:(length(NegPB)-1)
            temp1=filtSig(NegPBI(i):NegPBI(i+1));
            [PosPB(i),i1]=max(temp1);
            PosPBI(i)=NegPBI(i)+i1-1;
            
            temp2=zeroSig(NegPBI(i):PosPBI(i));
            temp22=zci(temp2);
            temp22(temp22==length(temp2))=[];
            RisePBI(i)=NegPBI(i)+round(median(temp22))-1;
            
            temp3=zeroSig(PosPBI(i):NegPBI(i+1));
            temp33=zci(temp3);
            temp33(temp33==length(temp3))=[];
            DecayPBI(i)=PosPBI(i)+round(median(temp33))-1;
            
            tempIVector=[NegPBI(i) RisePBI(i) PosPBI(i) DecayPBI(i) NegPBI(i+1)];
            lVector=NegPBI(i+1)-NegPBI(i)+1;
            if sum(isnan(tempIVector))==0&&min(diff(tempIVector))>0
               filtPhase(NegPBI(i):NegPBI(i+1)) = interp1(tempIVector,[-pi -pi/2 0 pi/2 pi],NegPBI(i):NegPBI(i+1),'linear');
               filtPhase(NegPBI(i))=-pi;
%                filtPhase(NegPBI(i)+1)=-pi;
            end
        end
% %         TimeI=[PosPBI(:);NegPBI(:);DecayPBI(:);RisePBI(:)];
% %         P1=zeros(size(PosPBI))+pi/2;
% %         P2=zeros(size(NegPBI))+pi/2;
% %         P3=zeros(size(RisePBI))+pi/2;
% %         P4=zeros(size(DecayPBI))+pi/2;
%         P1=P1
% %         TimeI(isnan(TimeI))=[];
% %         [TimeI,~]=sort(TimeI);
% %         TimeI=unique(TimeI);
% %         P1=zeros(size(TimeI))+pi/2;
% %         P1=cumsum(P1);
% %         filtPhaseNew = interp1(TimeI,P1,1:length(eeg),'linear');
% %         filtPhaseNew=mod(filtPhaseNew,2*pi)-pi;
        Invalid=isnan(PosPBI)|isnan(NegPBI)|isnan(RisePBI)|isnan(DecayPBI);

        PosPBI(Invalid)=[];
        NegPBI(Invalid)=[];
        RisePBI(Invalid)=[];
        DecayPBI(Invalid)=[];

        
        PeakTrough.Neg=NegPBI(:);
        PeakTrough.Pos=PosPBI(:);
        PeakTrough.Rise=RisePBI(:);
        PeakTrough.Decay=DecayPBI(:);

