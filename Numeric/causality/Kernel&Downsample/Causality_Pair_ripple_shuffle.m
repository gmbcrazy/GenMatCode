function Causality_shuffle=Causality_Pair_ripple_shuffle(path_filename,Data_name,ref_name,timerange,range,CausalityParamete)

shuffle_num=ShuffleParameter.shuffle_num;
P_value=ShuffleParameter.P_value;
trial_length=ShuffleParameter.trial_length;


MORDER_band=CausalityParameter.MORDER_band;
fre_band=CausalityParameter.fre_band;
NFFT=CausalityParameter.NFFT;
fs=CausalityParameter.fs;
downsample=CausalityParameter.downsample;

kernel_parameter.form='EXP';
kernel_parameter.sigma=downsample/fs;
kernel_parameter.TimeStampResolution=1/fs;


[nvar, names, types] = nex_info2(path_filename);

for ii=1:length(Data_name)
for i=1:nvar
    if strncmp(names(i,:),Data_name(ii).Name,length(Data_name(ii).Name))
       Variable(ii)=types(i);
       break
    end
end
end

[raster_data{1},time1,ts_origin1]=perievent_raster_file(path_filename,Data_name(1).Name,ref_name,timerange,1/fs,range);
[raster_data{2},time2,ts_origin2]=perievent_raster_file(path_filename,Data_name(2).Name,ref_name,timerange,1/fs,range);



invalid=[];
for i=1:length(ts_origin1)
    if isempty(ts_origin1)
       invalid=[invalid;i];
    end
end
raster_data{1}(invalid)=[];raster_data{2}(invalid)=[];
    Nl=length(raster_data{1}(1,:));
    Nr=length(raster_data{1}(:,1));
    
 for ii=1:length(Data_name)
    
     if (Variable(ii)==0)||(Variable(ii)==1)                %%%%%%%%%%%%event variable
       
       [kernel,norm,m_idx] = makeKernel65(kernel_parameter.form,kernel_parameter.sigma,kernel_parameter.TimeStampResolution);
       
       for j=1:Nr
       rate_f=conv(kernel,raster_data{ii}(j,:));
       index_s=m_idx;
       index=index_s:(index_s+Nl-1);
       rate_f=rate_f(index);
       raster_data{ii}(j,:)=rate_f;
       clear rate_f;
       end
    end
 end
    
 raster_data{1}=zscore(raster_data{1}')';raster_data{2}=zscore(raster_data{2}')';

 raster_data{1}=raster_data{1}(:,1:downsample:length(raster_data{1}(1,:)));
 raster_data{2}=raster_data{2}(:,1:downsample:length(raster_data{2}(1,:)));
 
fs=fs/downsample;
Nl=length(raster_data{1}(1,:));

 
 O_Data(1,:)=reshape(raster_data{1}',1,Nr*Nl);
 O_Data(2,:)=reshape(raster_data{2}',1,Nr*Nl);

 
    STFreq=fre_band(1);
    EDFreq=fre_band(2);


    channel_num=2;
    Causality_shuffle.F1to2=[];
    Causality_shuffle.F2to1=[];
    Causality_shuffle.F_sense1to2=[];
    Causality_shuffle.F_sense2to1=[];
for shuffle_temp=1:shuffle_num  
    temp_raster_data{1}=raster_data{1};
    temp_raster_data{2}=raster_data{2};
    
    resample_index=1:(Nl*Nr);
    resample1=shuffle(resample_index);
%     Data(:,resample1)=Data_original(:,resample_index);
    resample2=shuffle(resample_index);
%   temp_raster_data{1}(:,resample1)=temp_raster_data{1}(:,resample_index);  
%   temp_raster_data{2}(:,resample2)=temp_raster_data{2}(:,resample_index);  
 Data(1,resample1)=O_Data(1,resample_index);
 Data(2,resample2)=O_Data(2,resample_index);
    clear temp_raster_data{1} temp_raster_data{2}
% MORDER_max=60;
for i=MORDER_band(1):MORDER_band(2)
    [A,Z2]=armorf(Data,Nr,Nl,i);
    AIC(i)=2*log(det(Z2))+2*i*channel_num^2/Nl;
end



    
    [temp_n,MORDER]=min(AIC);
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
                Coh_cau(k)=abs(S2(1,2))^2/(S2(1,1)*S2(2,2));

%                 Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
%                 Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
Causality_shuffle.F1to2=[Causality_shuffle.F1to2;Fx2y];
Causality_shuffle.F_sense1to2=[Causality_shuffle.F_sense1to2;max(Fx2y)];
Causality_shuffle.F2to1=[Causality_shuffle.F2to1;Fy2x];
Causality_shuffle.F_sense2to1=[Causality_shuffle.F_sense2to1;max(Fy2x)];

Causality_shuffle.Coh(shuffle_temp)=max(Coh_cau);
Causality.F=F;
end



temp=sort(Causality_shuffle.F_sense1to2);
Causality_shuffle.threhold_F1to2=temp(min(length(temp),round(1/P_value)));


temp=sort(Causality_shuffle.F_sense2to1);
Causality_shuffle.threhold_F2to1=temp(min(length(temp),round(1/P_value)));

temp=sort(Causality_shuffle.Coh);
Causality_shuffle.threhold_Coh=temp(min(length(temp),round(1/P_value)));






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