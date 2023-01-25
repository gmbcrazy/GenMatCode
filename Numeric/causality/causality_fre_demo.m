a=sin(0:0.1:50);
b=a+random('norm',0,0.5,1,length(a));
b=[[1 2 1 2 0.1 0],b];
a=[a,[1 2 1 2 0.1 0]];
Data(1,:)=a+random('norm',0,0.2,1,length(a));
Data(2,:)=b;


% Data_name(1).Name='scsig053ats';
% Data_name(2).Name='scsig029ats';
% Data_name(3).Name='scsig041ats';
% Data_name(4).Name='AD27_ad_000';
% 
% 
% causality_xk=zeros(4,4);
% causality_xk(1,4)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,1,4,50,[1050;1060]);
% causality_xk(2,4)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,2,4,50,[1050;1060]);
% causality_xk(3,4)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,3,4,50,[1050;1060]);
% causality_xk(4,1)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,4,1,50,[1050;1060]);
% causality_xk(4,2)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,4,2,50,[1050;1060]);
% causality_xk(4,3)=causality_file('E:\brust theta\lab02\xk128\final_two_days\04.nex',Data_name,4,3,50,[1050;1060]);

[adfreq,n,ts,fn,AD1]=nex_cont('E:\brust theta\lab02\xk128\final_two_days\04.nex','AD24_ad_000');
[adfreq,n,ts,fn,AD2]=nex_cont('E:\brust theta\lab02\xk128\final_two_days\04.nex','AD27_ad_000');

Data=[AD1;AD2];

freq=1000;
lowf=5;
highf=10;
freq=1000;
fz=freq/2;
[b,a]=ellip(6,3,50,highf/500);

sf=filtfilt(b,a,Data(1,:));
[b,a]=ellip(6,3,50,lowf/500,'high');

sf=filtfilt(b,a,sf);
    sf=sf+random('norm',0,0.01,1,length(sf));
    

Data(2,:)=sf;

Data(2,10:(length(Data(1,:))-1))=Data(2,1:(length(Data(1,:))-10));
Data=Data(:,1150000:1200000);
% plot(Data(1,:));hold on;plot(Data(2,:),'r')
% AIC=AIC_m(Data,1,2);
% Data(1,:)=zscore(Data(1,:))';
% Data(2,:)=zscore(Data(2,:))';







path_filename='E:\brust theta\lab02\xk128\final_two_days\04.nex'
Data_name(1).Name='scsig029ats';
Data_name(2).Name='AD27_ad_000';
timerange=[1123;1130];
m=20;

[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(path_filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end



DataEntityID=zeros(1,length(Data_name));

for i=1:length(Data_name)

    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
     
        q=strcmp(nsEntityLabel{EntityID},Data_name(i).Name);      
        if q==1;   
           DataEntityID(i)=EntityID;
        end  
     
     
    end
    
end


spikewf=exp(-(0:0.001:0.15)/0.002);
all_data=[];
for i=1:length(Data_name)
    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,DataEntityID(i));

    StartIndex=1;
    temp_timerange(1)=ceil(timerange(1)/0.001);
    temp_timerange(2)=floor(timerange(2)/0.001);

    if nsdataEntityInfo.EntityType==4    %%%%%%%%%%data is timestamps type
       [ns_RESULT,temp_data]=ns_GetNeuralData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
       temp_data=temp_data(find(temp_data>temp_timerange(1)/1000&temp_data<temp_timerange(2)/1000));
       temp_data=round(temp_data*1000);
       temp_train=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
       for j=1:length(temp_data)
           temp_spike=zeros(1,(temp_timerange(2)-temp_timerange(1)+1+length(spikewf)));
           temp_spike((temp_data(j)-temp_timerange(1)+1):(temp_data(j)+length(spikewf)-temp_timerange(1)))=spikewf;
           temp_train=temp_train+temp_spike;
       end
       temp_train=temp_train(1:(temp_timerange(2)-temp_timerange(1)+1))'+1;
       
   elseif nsdataEntityInfo.EntityType==2 %%%%%%%%%%data is continuous type
       [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,DataEntityID(i),StartIndex,nsdataEntityInfo.ItemCount);
       temp_train=temp_data(temp_timerange(1):temp_timerange(2));
   else
       'datatype shoud be timestamps or continuous'
       return
   end 
   
   all_data=[all_data,temp_train];
   clear temp_train temp_data temp_spike

    
end
ns_RESULT = ns_CloseFile(hFile);
all_data=all_data';
Data=all_data;








    NFFT=512;
    STFreq=2;
    EDFreq=50;
    fs=1000;
    Nr=1;
    Nl=length(Data(1,:));
    channel_num=2;
MORDER=60;
for i=1:MORDER
    [A,Z2]=armorf(Data,Nr,Nl,i);
    AIC(i)=2*log(det(Z2))+2*i*channel_num^2/Nl;
end

    
    MORDER=14;

    tmp_x=Data;
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
                Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end

    

subplot(2,1,1);plot(F,Ix2y);hold on;plot(F,Iy2x,'r');
subplot(2,1,2);plot(F,Fx2y);hold on;plot(F,Fy2x,'r');



Data(1,:)=zscore(smoothts(Data(1,:),'g',3))';
Data(2,:)=zscore(smoothts(Data(2,:),'g',3))';
ChannelNo=2;
MORDER=12;
[A,Z]= armorf(Data,10,floor(length(Data(2,:))/10),MORDER);
    tmpi=([1:MORDER]-1)*ChannelNo;
    for m=1:ChannelNo
        for n=1:ChannelNo
            MARP(m,n).C=A(m,tmpi+n);
        end
    end        
    
    [FTrans FCoeff F]=MARSpec(MARP,Z,MORDER,1000,1024,1,200);


for step=1:length(F)
    S(step).C=FTrans(step).C*Z*conj((FTrans(step).C)');
end

for step=1:length(F)
    Temp_S=S(step).C;
    Temp_H=FTrans(step).C;
    
    I1to2(step)=-log(1-(Z(2,2)-Z(1,2)^2/Z(1,1))*abs(Temp_H(1,2))^2/abs(Temp_S(1,1)));
    I2to1(step)=-log(1-(Z(1,1)-Z(1,2)^2/Z(2,2))*abs(Temp_H(2,1))^2/abs(Temp_S(2,2)));
    Inf2to1(step)=abs(Temp_H(2,1))^2/(abs(Temp_H(2,1))^2+abs(Temp_H(2,2))^2);
    Inf1to2(step)=abs(Temp_H(1,2))^2/(abs(Temp_H(1,1))^2+abs(Temp_H(1,2))^2);
    C2to1(step)=abs(Temp_H(2,1))^2;
    C1to2(step)=abs(Temp_H(1,2))^2;

end
figure;
subplot(3,1,1);plot(F,I1to2);hold on;plot(F,I2to1,'r');
subplot(3,1,2);plot(F,Inf1to2);hold on;plot(F,Inf2to1,'r');
subplot(3,1,3);plot(F,C1to2);hold on;plot(F,C2to1,'r');




[c,fre]=causality_fre(Data,2,1,63);


plot(1./(0.001*(2*pi./fre)),c);


[pp,cohe,Fx2y,Fy2x]=pwcausal(Data,1,length(Data(1,:)),20,1000,[1:40]);