function CauCohLag=CauCoh_Timelag(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs,Lag_range,Lag_step)

%%%%%%%this function compute the causality and coherence in path_filename for round(Lag_range/Lag_step) times.
%%%%%%%Data1 is extracted from timerange+timelag, where the ith timelag is defined by Lag_range(1)+(i-1)*Lag_step
%%%%%%%Data2 is extracted from timerange
    CauCohLag.F1to2=[];
    CauCohLag.F2to1=[];
    CauCohLag.MORDER=[];
    CauCohLag.Coh=[];

Timelag=Lag_range(1):Lag_step:Lag_range(2);
for lag_i=1:length(Timelag)  

%     clear Data
[Data(1,:),time]=rate_historam(path_filename,Data_name(1).Name,timerange+Timelag(lag_i),1/fs,1/fs);
[Data(2,:),time]=rate_historam(path_filename,Data_name(2).Name,timerange,1/fs,1/fs);

    Data(1,:)=zscore(Data(1,:))';
    Data(2,:)=zscore(Data(2,:))';

    Nr=1;
    Nl=length(Data(1,:));
    channel_num=2;
    tic
 
    [coh,f_coh]=cohere(Data(1,:),Data(2,:),NFFT*2,fs,NFFT/2,0,'linear');
    CauCohLag.Coh(:,lag_i)=coh';
    CauCohLag.F_coh=f_coh;
%     figure;
%     plot(coh);
    MORDER_temp=[MORDER_band(1):4:MORDER_band(2)];
% MORDER_max=60;
for i=1:length(MORDER_temp)
    [A,Z2]=armorf(Data,Nr,Nl,MORDER_temp(i));
    AIC(i)=2*log(det(Z2))+2*MORDER_temp(i)*channel_num^2/Nl;
    BIC(i)=2*log(det(Z2))+2*MORDER_temp(i)*channel_num^2*log(Nl)/Nl;
    HQC(i)=2*log(det(Z2))+2*MORDER_temp(i)*channel_num^2*log(log(Nl))/Nl;
%     if i>=3
%        if HQC(i)>HQC(i-1)&HQC(i-1)>HQC(i-2)
%           break
%        end
%     end
end


STFreq=fre_band(1);
EDFreq=fre_band(2);

    
    [temp_n,MORDER_i]=min(HQC);
    MORDER=MORDER_temp(MORDER_i);
%     Result=vare(Data',MORDER);
%     Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
%     clear temp_n

    tmp_x=Data;
    clear Data;
    tmpi=([1:MORDER]-1)*2;
            y(1,:)=tmp_x(1,:);
            y(2,:)=tmp_x(2,:);  
            [A,Z2]=armorf(y,Nr,Nl,MORDER); %get the model parameters for each two pairs.
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
%                 Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
%                 Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
CauCohLag.F1to2(:,lag_i)=Fx2y';
CauCohLag.F2to1(:,lag_i)=Fy2x';
CauCohLag.MORDER=[CauCohLag.MORDER;MORDER];
CauCohLag.F_cau=F;
toc
end
CauCohLag.Timelag=Timelag;

