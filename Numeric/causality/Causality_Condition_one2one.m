function Causality=Causality_Condition_one2one(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs)

%Done by Lu Zhang in April 9th,2008 accordin to the works of Yonghong Chen
%in 2006 "Frequency decomposition of conditional granger causality and
%application to multivariate neural field potential data",Journal of Neuroscience Methods 150 (2006) 228¨C237


% path_filename='E:\brust theta\lab02\xk128\final_two_days\04.nex'
% Data_name(1).Name='scsig029ats';
% Data_name(2).Name='AD27_ad_000';
% timerange=[1123;1130];




% [ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');
% 
% if ns_RESULT==0;
% [ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
% end
% 
% if ns_RESULT==0;
%    [ns_RESULT,hFile]=ns_OpenFile(path_filename);
% end
% 
% if ns_RESULT==0;
%    [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
% end
% 
% DataEntityID=zeros(1,length(Data_name));
% for i=1:length(Data_name)
% 
%     for EntityID=1:nsFileInfo.EntityCount
%         [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
%         nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
%      
%         q=strcmp(nsEntityLabel{EntityID},Data_name(i).Name);      
%         if q==1;   
%            DataEntityID(i)=EntityID;
%         end  
%     end
% end
% % 
% % 
% spikewf=exp(-(0:0.001:0.15)/0.002);
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
for i=1:length(Data_name)
[Data(i,:),time]=rate_historam(path_filename,Data_name(i).Name,timerange,1/fs,1/fs);
end



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
    Nr=1;
    Nl=length(Data(1,:));
    channel_num=length(Data(:,1));
    
    

    
    

for i=1:channel_num
    Data(i,:)=zscore(detrend(Data(i,:)))';
end
% MORDER_max=60;
    MORDER_temp=MORDER_band(1):1:MORDER_band(2);

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



    
    [temp_n,MORDER_i]=min(AIC);
    MORDER=MORDER_temp(MORDER_i)
    Result=vare(Data',MORDER);
%     Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
%     clear temp_n

    tmpi=([1:MORDER]-1)*channel_num;
            [A_Original,Z2_Original]=armorf(Data,Nr,Nl,MORDER);
        
            
for i=1:channel_num%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Fy2x(i,j) refer to causality from channel i to channel j 
    for j=1:channel_num
      
        if i==j
           Fy2x(i,j).Causality=[];
       else
           
if i==3&j==2
   temp_tran1=eye(3);
   temp_tran2=eye(3);
   temp_tran1(i,:)=0;temp_tran1(i,2)=1;
   temp_tran1(2,:)=0;temp_tran1(2,i)=1;
   
   temp_tran2(1,:)=0;temp_tran2(1,3)=1;
   temp_tran2(3,:)=0;temp_tran2(3,1)=1;

elseif i==1&j==2
    
    temp_tran1=eye(channel_num);
    temp_tran2=eye(channel_num);
    temp_tran1(2,2)=0;temp_tran1(2,i)=1;temp_tran1(i,i)=0;temp_tran1(i,2)=1;

else
   temp_tran1=eye(3);
   temp_tran2=eye(3);

   temp_tran1(2,2)=0;temp_tran1(2,i)=1;temp_tran1(i,i)=0;temp_tran1(i,2)=1;
   temp_tran2(1,1)=0;temp_tran2(1,j)=1;temp_tran2(j,j)=0;temp_tran2(j,1)=1;
   
end


        A=zeros(size(A_Original));
        for m=1:length(A_Original)/channel_num
            A(1:channel_num,((m-1)*channel_num+1):(m*channel_num))=temp_tran2*temp_tran1*A_Original(1:channel_num,((m-1)*channel_num+1):(m*channel_num))*temp_tran1*temp_tran2;
        end
        Z2=temp_tran2*temp_tran1*Z2_Original*temp_tran1*temp_tran2;


%           jj=setdiff([1:channel_num],[i,j]);
%           [A,Z2]=armorf(Data([j,i,jj],:),Nr,Nl,MORDER);
       

        
        
            for p=1:channel_num
                for q=1:channel_num
                    MARP(p,q).C=A(p,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,MORDER,fs,NFFT,STFreq,EDFreq); 
     
            
            P1=eye(channel_num);
            P1(2:channel_num,1)=-Z2(2:channel_num,1)/Z2(1,1);
            Z2=P1*Z2;
            Z2_1=Z2(2:channel_num,2:channel_num);
            P2=eye(channel_num);
            P2(3:channel_num,2)=-Z2_1(2:(channel_num-1),1)/Z2_1(1,1);
            Z2=P2*Z2*P1'*P2';

            
            for k=1:NFFT
                T_length=length(H2(k).C);
                H2(k).C=H2(k).C*pinv(P2*P1);
                Temp_Hxx=H2(k).C(1,1);
                Temp_Hxz=H2(k).C(1,3:T_length);
                Temp_Hzx=H2(k).C(3:T_length,1);
                Temp_Hyz=H2(k).C(2,3:T_length);
                Temp_Hzy=H2(k).C(3:T_length,2);
                Temp_Hxy=H2(k).C(1,2);
                Temp_Hyx=H2(k).C(2,1);
                Temp_Hyy=H2(k).C(2,2);
                Temp_Hzz=H2(k).C(3:T_length,3:T_length);
                
                Temp_Zxx=Z2(1,1);
                Temp_Zxz=Z2(1,3:T_length);
                Temp_Zzx=Z2(3:T_length,1);
                Temp_Zyz=Z2(2,3:T_length);
                Temp_Zzy=Z2(3:T_length,2);
                Temp_Zxy=Z2(1,2);
                Temp_Zyx=Z2(2,1);
                Temp_Zyy=Z2(2,2);
                Temp_Zzz=Z2(3:T_length,3:T_length);
                
                
                
                
                
                H_bar=pinv([Temp_Hxx Temp_Hxz;Temp_Hzx Temp_Hzz])*[Temp_Hxy;Temp_Hzy];
                Z_bar=Z2([1,3:T_length],[1,3:T_length])+H_bar*[Temp_Zxy Temp_Zzy']+[Temp_Zxy;Temp_Zzy]*H_bar'+Temp_Zyy*H_bar*H_bar';
%                 P_bar=[ones(T_length-2) zeros(T_length-2,1);-Z_bar(1,2:(T_length-1))/Z2(1,1) 1];
                P_bar=[ones(T_length-2) zeros(T_length-2,1);-Z_bar(1,2:(T_length-1))/Z_bar(1,1) 1];

                G=[Temp_Hxx Temp_Hxz;Temp_Hzx Temp_Hzz]*pinv(P_bar);
                G_expand=[G(1,1) 0 G(1,2:(T_length-1));0 1 zeros(1,T_length-2);G(2:(T_length-1),1) zeros(T_length-2,1) G(2:(T_length-1),2:(T_length-1))];
                Q=pinv(G_expand)*H2(k).C;
                Fy2x(i,j).Causality(k)=log(abs(det(Z_bar(1,1)))/abs(Q(1,1)*Z2(1,1)*Q(1,1)'));
                
            end
                
            end
            
        end
    end
    
        Causality.Fy2x= Fy2x;
        Causality.F=F;
        Causality.Result=Result;
        Causality.Morder=MORDER;
