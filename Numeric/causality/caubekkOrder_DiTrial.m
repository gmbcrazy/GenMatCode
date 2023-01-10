function Output=caubekkOrder_DiTrial(InputData,CausalityParameter)

MORDER_band=CausalityParameter.MORDER_band;
fre_band=CausalityParameter.fre_band;
NFFT=CausalityParameter.NFFT;
fs=CausalityParameter.fs;
downsampleP=CausalityParameter.downsample;
Data=zeros(length(InputData),0);

Nlcount=0;
Nl=zeros(length(InputData{1}),2);
for i=1:length(InputData)
    for j=1:length(InputData{i})
%         InputData{i}(j).Data=decimate(InputData{i}(j).Data,downsampleP);
        InputData{i}(j).Data=downsample(InputData{i}(j).Data,downsampleP);

        Nltemp(j)=length(InputData{i}(j).Data);
    end
end

a=cumsum(Nltemp);
Temp=[0 cumsum(Nltemp(1:end-1))]+1;
Nl=[Temp(:) a(:)];
clear a Temp



for i=1:length(InputData)
    TempData{i}=[];
end

for i=1:length(InputData)
    for j=1:length(InputData{i})
        TempData{i}=[TempData{i} InputData{i}(j).Data(:)'];
%         Nl(j)=length(InputData{i}(j).Data);
    end
end
Data=[];
for i=1:length(InputData)
    Data=[Data;TempData{i}];
end
% tic

kernel_parameter.form='EXP';
kernel_parameter.sigma=downsampleP/fs;
kernel_parameter.TimeStampResolution=1/fs;


% Datanew=Data(:,1:downsampleP:length(Data(1,:)));

fs=fs/downsampleP;

%     NFFT=512;
%     STFreq=2;
%     EDFreq=50;
STFreq=fre_band(1);
EDFreq=fre_band(2);
%     fs=1000;
    Nr=length(Nl(:,1));
    channel_num=2;
%     Data(1,:)=zscore(detrend(Data(1,:)))';
%     Data(2,:)=zscore(detrend(Data(2,:)))';
%     Data(1,:)=zscore(Data(1,:))';
%     Data(2,:)=zscore(Data(2,:))';
% 
  % 
% for i=25:MORDER_band(2)
%     Stationary_result1=adf(Data(1,:)',0,i);
%     prt(Stationary_result1,Data_name(1).Name);
% 
%     Stationary_result2=adf(Data(2,:)',0,i);
%     prt(Stationary_result2,Data_name(2).Name);
% end

    MORDER_temp=MORDER_band(1):1:MORDER_band(2);
% MORDER_max=60;
for i=1:length(MORDER_temp)
%     [A_temp(i).data,Z2_temp(i).data]=armorf_DiTrial(Data,Nr,Nl,MORDER_temp(i));
   [A_temp(i).data,Z2_temp(i).data,pre(i).data]=armorfrepeat(Data,Nr,Nl,MORDER_temp(i));
   output  = arma_bekk_mvgarch4Repeat(data,ar_order,bekk_order, Nr, Nl, ARMABEKKoptions);
% %    TempN=Nl(end,2)-MORDER_temp(i)*Nr;
%     TempN=mean(diff(Nl'));
% %     AIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2/TempN;
% %     BIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(TempN)/TempN;
%     HQC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(log(TempN))/TempN;
%     [coeff{1}, error{1}] = armorf(data,Nr,Nl,order);
clear errors
errors = predictionerror2(A_temp(i).data, Data, Nr, Nl, MORDER_temp(i));
LLF = arma_LLF(errors', Z2_temp(i).data, Nr, Nl, MORDER_temp(i));
[AIC(i),BIC(i)] = aicbic(LLF,size(Data,1)*size(Data,1)*MORDER_temp(i),size(Data,2));

%     if i>=3
%        if HQC(i)>HQC(i-1)&HQC(i-1)>HQC(i-2)
%           break
%        end
%     end
end

% [optcoeff, opterror, optchangepoint, AIC, BIC] = opttvCau(Data, Nr, Nl, MORDER_temp(end));


Output.AIC=AIC;
Output.BIC=BIC;
% Output.HQC=HQC;
Output.Order=MORDER_temp;


