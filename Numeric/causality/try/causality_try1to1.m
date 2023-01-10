function Causality=causality_try1to1(Data,fre_band,fs,NFFT,MORDER_band)


tic


%     NFFT=512;
%     STFreq=2;
%     EDFreq=50;
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

    MORDER_temp=MORDER_band(1):1:MORDER_band(2);
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
%     Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
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
% Causality.Vnames=Vnames;

toc