function Causality=Causality_Pair_ripple(path_filename,Data_name,ref_name,timerange,range,CausalityParameter)


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

raster_data{1}=reshape(raster_data{1}',1,Nr*Nl);
raster_data{2}=reshape(raster_data{2}',1,Nr*Nl);


Data(1,:)=raster_data{1};Data(2,:)=raster_data{2};
% 
% [Data(1,:),time]=rate_historam(path_filename,Data_name(1).Name,timerange,1/fs,0.001);
% [Data(2,:),time]=rate_historam(path_filename,Data_name(2).Name,timerange,1/fs,0.001);

% fs=1000;
% 

% 
% spikewf=exp(-(0:0.001:0.15)/0.006);
% all_data=[];
% for i=1:length(Data_name)
%     [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,DataEntityID(i));
% 
%     StartIndex=1;
%     temp_timerange(1)=ceil(timerange(1)/0.001);
%     temp_timerange(2)=floor(timerange(2)/0.001);
% 
%     if nsdataEntityInfo.EntityType==4    %%%%%%%%%%data is timestamps type
%        [ns_RESULT,temp_data]=ns_GetNeuralData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
%        temp_data=temp_data(find(temp_data>temp_timerange(1)/1000&temp_data<temp_timerange(2)/1000));
%        temp_data=round(temp_data*1000);
%        temp_train=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
%        for j=1:length(temp_data)
%            temp_spike=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
%            temp_spike((temp_data(j)-temp_timerange(1)+1):(temp_data(j)+length(spikewf)-temp_timerange(1)))=spikewf;
%            temp_train=temp_train+temp_spike;
%        end
%        temp_train=temp_train(1:(temp_timerange(2)-temp_timerange(1)+1))'+1;
%        
%    elseif nsdataEntityInfo.EntityType==2 %%%%%%%%%%data is continuous type
%        [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
%        temp_train=temp_data(temp_timerange(1):temp_timerange(2));
%    else
%        'datatype shoud be timestamps or continuous'
%        return
%    end 
%    
%    all_data=[all_data,temp_train];
%    clear temp_train temp_data temp_spike
% 
%     
% end
% ns_RESULT = ns_CloseFile(hFile);
% all_data=all_data';
% Data=all_data;
% 










%     NFFT=512;
%     STFreq=2;
%     EDFreq=50;
STFreq=fre_band(1);
EDFreq=fre_band(2);
%     fs=1000;
    channel_num=2;
% MORDER_max=60;

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
    Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
    clear temp_n

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
                Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
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