function [AIC,M]=AIC_DiTrial(InputData,CausalityParameter)

MORDER_band=CausalityParameter.MORDER_band;
fre_band=CausalityParameter.fre_band;
NFFT=CausalityParameter.NFFT;
fs=CausalityParameter.fs;
downsample=CausalityParameter.downsample;
Data=zeros(length(InputData),0);

for i=1:length(InputData)
    for j=1:length(InputData{i})
        InputData{i}(j).Data=decimate(InputData{i}(j).Data,downsample);
        Nl(j)=length(InputData{i}(j).Data);
    end
end



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
kernel_parameter.sigma=downsample/fs;
kernel_parameter.TimeStampResolution=1/fs;


% Datanew=Data(:,1:downsample:length(Data(1,:)));

fs=fs/downsample;

%     NFFT=512;
%     STFreq=2;
%     EDFreq=50;
STFreq=fre_band(1);
EDFreq=fre_band(2);
%     fs=1000;
    Nr=length(Nl);
    channel_num=2;
    Data(1,:)=zscore(detrend(Data(1,:)))';
    Data(2,:)=zscore(detrend(Data(2,:)))';
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
    [A_temp(i).data,Z2_temp(i).data]=armorf_DiTrial(Data,Nr,Nl,MORDER_temp(i));

    
    AIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2/sum(Nl);
    BIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(sum(Nl))/sum(Nl);
    HQC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(log(sum(Nl)))/sum(Nl);
%     if i>=3
%        if HQC(i)>HQC(i-1)&HQC(i-1)>HQC(i-2)
%           break
%        end
%     end
end


[M n]=min(AIC);
M=A_temp(n);


