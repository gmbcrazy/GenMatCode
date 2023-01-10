function Cau=cau_NexTrialData(Data1,Data2,CausalityParameter)

ValidIndex=1:length(Data1);

Fs=CausalityParameter.fs;
% window=CausalityParameter.window;
% noverlap=CausalityParameter.noverlap;
nfft=CausalityParameter.NFFT;
downsample=CausalityParameter.downsample;

if isfield(CausalityParameter,'Timerange')
Time=CausalityParameter.Timerange;
else
Time=[0;200000];
end

numTrial=0;

   Cau.I1to2=zeros(length(Data1),nfft);
   Cau.I2to1=zeros(length(Data1),nfft);
   Cau.F1to2=zeros(length(Data1),nfft);
   Cau.F2to1=zeros(length(Data1),nfft);
   Cau.Coh=zeros(length(Data1),nfft);
   Cau.AIC=zeros(length(Data1),1);
   Cau.HQC=zeros(length(Data1),1);
   Cau.BIC=zeros(length(Data1),1);
   Cau.MORDER=zeros(length(Data1),1);
   Cau.F=0;
   Cau.Pxx=zeros(length(Data1),nfft);
   Cau.Pyy=zeros(length(Data1),nfft);




for i=1:length(Data1)
    
if isempty(Data1(i).Data)
   ValidIndex(i)=0;
   continue
end

    
% figure;
% plot(Data1(i).Data);

if isempty(Time)
   Temp1=Data1(i).Data;
   Temp2=Data2(i).Data;


else



    if Time(1)>=0
        TempTime=Data1(i).Time-Data1(i).Time(1);
    else
        TempTime=Data1(i).Time-Data1(i).Time(end);
    end

   Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
   Temp1=detrend(zscore(Data1(i).Data));
   Temp2=detrend(zscore(Data2(i).Data));
   
   Temp1=Temp1(Temp_index);
   Temp2=Temp2(Temp_index);

end

if isempty(Temp1)
   Temp1=zscore(detrend(Data1(i).Data));
   Temp2=zscore(detrend(Data2(i).Data));

end




% figure;
% plot(Temp1,'r.')

if length(Temp1)<(CausalityParameter.MORDER_band(2)*downsample)
   ValidIndex(i)=0;
   continue
%    Add=Temp1;
%    Temp1=[Temp1;Add];  
end



TCausality=causality_1to1([Temp1(:)';Temp2(:)'],CausalityParameter);


   Cau.I1to2(i,:)=TCausality.I1to2;
   Cau.I2to1(i,:)=TCausality.I2to1;
   Cau.F1to2(i,:)=TCausality.F1to2;
   Cau.F2to1(i,:)=TCausality.F2to1;
   Cau.Coh(i,:)=TCausality.Coh;
   Cau.AIC(i)=TCausality.AIC;
   Cau.HQC(i)=TCausality.HQC;
   Cau.BIC(i)=TCausality.BIC;
   Cau.MORDER(i)=TCausality.MORDER;
   Cau.F=TCausality.F;

   Cau.Pxx(i,:)=TCausality.Pxx;
   Cau.Pyy(i,:)=TCausality.Pyy;


% [Sxy(i,:),Sxx(i,:),Syy(i,:),w,options] = welchCohLuTrial({Temp1(:),Temp2(:)},window,noverlap,nfft,Fs);

end


   Cau.ValidIndex=ValidIndex;

% Sxy=Sxy/numTrial;
% Sxx=Sxx/numTrial;
% Syy=Syy/numTrial;
% 
% [Pxy,f,xunits] = computepsd(Sxy,w,options.range,options.nfft,options.Fs,esttype);
% [Pxx,f,units] = computepsd(Sxx,w,options.range,options.nfft,options.Fs,esttype);
% [Pyy,f,xunits] = computepsd(Syy,w,options.range,options.nfft,options.Fs,esttype);
%  Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Cxy


