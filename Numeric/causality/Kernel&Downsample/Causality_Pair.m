function Causality=Causality_Pair(path_filename,Data_name,timerange,CausalityParameter)


% 
% path_filename='E:\brust theta\lab02\xk128\final_two_days\04.nex'
% Data_name(1).Name='scsig029ats';
% Data_name(2).Name='AD27_ad_000';
% timerange=[1123;1130];
MORDER_band=CausalityParameter.MORDER_band;
fre_band=CausalityParameter.fre_band;
NFFT=CausalityParameter.NFFT;
fs=CausalityParameter.fs;
downsample=CausalityParameter.downsample;


tic
kernel_parameter.form='EXP';
kernel_parameter.sigma=downsample/fs;
kernel_parameter.TimeStampResolution=1/fs;


[Data(1,:),time]=rate_histogram_kernel(path_filename,Data_name(1).Name,timerange,1/fs,1/fs,kernel_parameter);
[Data(2,:),time]=rate_histogram_kernel(path_filename,Data_name(2).Name,timerange,1/fs,1/fs,kernel_parameter);
% 

Data=Data(:,1:downsample:length(Data(1,:)));

fs=fs/downsample;


STFreq=fre_band(1);
EDFreq=fre_band(2);
%     fs=1000;
    Nr=1;
    Nl=length(Data(1,:));
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

    MORDER_temp=MORDER_band(1):2:MORDER_band(2);
% MORDER_max=60;
for i=1:length(MORDER_temp)
    [A_temp(i).data,Z2_temp(i).data]=armorf(Data,Nr,Nl,MORDER_temp(i));
    AIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2/Nl;
    BIC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(Nl)/Nl;
    HQC(i)=2*log(det(Z2_temp(i).data))+2*MORDER_temp(i)*channel_num^2*log(log(Nl))/Nl;
%     if i>=3
%        if HQC(i)>HQC(i-1)&HQC(i-1)>HQC(i-2)
%           break
%        end
%     end
end



    
    [temp_n,MORDER_i]=min(HQC);
    MORDER=MORDER_temp(MORDER_i)
    
    Result=vare(Data',MORDER);
% for i=1:MORDER
%     Stationary_result1=adf(Data(1,:)',0,i);
%     prt(Stationary_result1,Data_name(1).Name);

%     Stationary_result2=adf(Data(2,:)',0,i);
%     prt(Stationary_result2,Data_name(2).Name);
% end
    Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
    clear temp_n

    tmp_x=Data;
%     clear Data;
    tmpi=([1:MORDER]-1)*2;
            y(1,:)=tmp_x(1,:);
            y(2,:)=tmp_x(2,:);  
%             [A,Z2]=armorf(y,Nr,Nl,MORDER); %get the model parameters for each two pairs.
            A=A_temp(MORDER_i).data;Z2=Z2_temp(MORDER_i).data;
            clear A_temp Z2_temp;
            eyx=Z2(2,2)-Z2(1,2)^2/Z2(1,1); %corrected covariance
            exy=Z2(1,1)-Z2(2,1)^2/Z2(2,2);
            for p=1:2
                for q=1:2
                    MARP(p,q).C=A(p,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,MORDER,fs,NFFT,STFreq,EDFreq); 
            for k=1: NFFT
                S2=abs(H2(k).C*Z2*H2(k).C'); 
                Coh_cau(k)=abs(S2(1,2))^2/(S2(1,1)*S2(2,2));
                Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
%             [pp,cohe,Fx2y1,Fy2x1]=pwcausal(Data,Nr,Nl,MORDER,fs,F);
Causality.I1to2=Ix2y;
Causality.I2to1=Iy2x;
Causality.F1to2=Fx2y;
Causality.F2to1=Fy2x;
Causality.Coh=Coh_cau;
Causality.AIC=AIC;
Causality.HQC=HQC;
Causality.BIC=BIC;
Causality.MORDER=MORDER;
Causality.F=F;
Causality.Result=Result;
Causality.Vnames=Vnames;


toc
% figure;
% subplot(2,1,1);plot(F,Ix2y);hold on;plot(F,Iy2x,'r');
% subplot(2,1,2);plot(F,Fx2y);hold on;plot(F,Fy2x,'r');
% 
% 
% 
% Data(1,:)=zscore(smoothts(Data(1,:),'g',3))';
% Data(2,:)=zscore(smoothts(Data(2,:),'g',3))';
% ChannelNo=2;
% MORDER=12;
% [A,Z]= armorf(Data,10,floor(length(Data(2,:))/10),MORDER);
%     tmpi=([1:MORDER]-1)*ChannelNo;
%     for m=1:ChannelNo
%         for n=1:ChannelNo
%             MARP(m,n).C=A(m,tmpi+n);
%         end
%     end        
%     
%     [FTrans FCoeff F]=MARSpec(MARP,Z,MORDER,1000,1024,1,200);
% 
% 
% for step=1:length(F)
%     S(step).C=FTrans(step).C*Z*conj((FTrans(step).C)');
% end
% 
% for step=1:length(F)
%     Temp_S=S(step).C;
%     Temp_H=FTrans(step).C;
%     
%     I1to2(step)=-log(1-(Z(2,2)-Z(1,2)^2/Z(1,1))*abs(Temp_H(1,2))^2/abs(Temp_S(1,1)));
%     I2to1(step)=-log(1-(Z(1,1)-Z(1,2)^2/Z(2,2))*abs(Temp_H(2,1))^2/abs(Temp_S(2,2)));
%     Inf2to1(step)=abs(Temp_H(2,1))^2/(abs(Temp_H(2,1))^2+abs(Temp_H(2,2))^2);
%     Inf1to2(step)=abs(Temp_H(1,2))^2/(abs(Temp_H(1,1))^2+abs(Temp_H(1,2))^2);
%     C2to1(step)=abs(Temp_H(2,1))^2;
%     C1to2(step)=abs(Temp_H(1,2))^2;
% 
% end
% figure;
% subplot(3,1,1);plot(F,I1to2);hold on;plot(F,I2to1,'r');
% subplot(3,1,2);plot(F,Inf1to2);hold on;plot(F,Inf2to1,'r');
% subplot(3,1,3);plot(F,C1to2);hold on;plot(F,C2to1,'r');
% 
% 
% 
% 
% [c,fre]=causality_fre(Data,2,1,63);
% 
% 
% plot(1./(0.001*(2*pi./fre)),c);
% 
% 
% [pp,cohe,Fx2y,Fy2x]=pwcausal(Data,1,length(Data(1,:)),20,1000,[1:40]);