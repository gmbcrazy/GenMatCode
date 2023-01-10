


path_filename='E:\brust theta\lab02\xk128\final_two_days\05-f.nex';


timerange=[1730;1750];
fre_band=[0;250];
MORDER_band=[20];
NFFT=512;
fs=500;





[Data(1,:),time]=rate_historam(path_filename,'AD27_ad_000',timerange,1/fs,1/fs);

lowf=6;
highf=10;
freq=500;
fz=freq/2;
[b,a]=ellip(6,3,50,highf/fz);

sf=filtfilt(b,a,Data);
[b,a]=ellip(6,3,50,lowf/fz,'high');

sf=filtfilt(b,a,sf);


Data(2,:)=sf;
Data(2,8:length(Data))=sf(1,1:(length(Data)-7));
Data(3,:)=zeros(1,length(Data));

for i=12:length(Data)
    Data(3,i)=Data(2,i-4)+0.2*Data(2,i-7)-0.5*Data(3,i-1);
end

Data(3,:)=randn(1,length(Data))*0.0001+Data(3,:);







     Data(1,:)=Original_data(3,:);   
     Data(2,:)=Original_data(2,:);   
     Data(3,:)=Original_data(1,:);   
        fre_band=[0;250];
MORDER_band=[15;30];
NFFT=512;
fs=500;








STFreq=fre_band(1);
EDFreq=fre_band(2);
%     fs=1000;
    Nr=1;
    Nl=length(Data(1,:));
    channel_num=length(Data(:,1));
for i=1:channel_num
    Data(i,:)=zscore(Data(i,:))';
end
% MORDER_max=60;
for i=MORDER_band(1):MORDER_band(2)
    [A,Z2]=armorf(Data,Nr,Nl,i);
    AIC(i)=2*log(det(Z2))+2*i*channel_num^2/Nl;
end



    
    [temp_n,MORDER]=min(AIC);
%     Result=vare(Data',MORDER);
%     Vnames=strvcat(Data_name(1).Name,Data_name(2).Name);
%     clear temp_n

    tmpi=([1:MORDER]-1)*channel_num;
            [A,Z2]=armorf(Data,Nr,Nl,MORDER); %get the model parameters for each two pairs.
            for p=1:channel_num
                for q=1:channel_num
                    MARP(p,q).C=A(p,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,MORDER,fs,NFFT,STFreq,EDFreq); 
            
%             
%             P1=eye(channel_num);
%             P1(2:channel_num,1)=-Z2(2:channel_num,1)/Z2(1,1);
%             Z2=P1*Z2;
%             Z2_1=Z2(2:channel_num,2:channel_num);
%             P2=eye(channel_num);
%             P2(3:channel_num,2)=-Z2_1(2:(channel_num-1),1)/Z2_1(1,1);
%             Z2=P2*Z2*P1'*P2';

            
            for k=1:NFFT
                T_length=length(H2(k).C);
%                 H2(k).C=H2(k).C*pinv(P2*P1);
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
                P_bar=[ones(T_length-2) zeros(T_length-2,1);-Z_bar(1,2:(T_length-1))/Z2(1,1) 1];
                G=[Temp_Hxx Temp_Hxz;Temp_Hzx Temp_Hzz]*pinv(P_bar);
                G_expand=[G(1,1) 0 G(1,2:(T_length-1));0 1 zeros(1,T_length-2);G(2:(T_length-1),1) zeros(T_length-2,1) G(2:(T_length-1),2:(T_length-1))];
                Q=pinv(G_expand)*H2(k).C;
                
                Fy2x(k)=log(abs(det(Z_bar(1,1)))/abs(Q(1,1)*Z2(1,1)*Q(1,1)'));
                
 
                
            end
            hold on;plot(F,Fy2x,'g');
            
        Causality.I2to1= Fy2x;
        Causality.F=F;


        
        
        
        
        
        fre_band=[0;250];
MORDER_band=[15;30];
NFFT=512;
fs=500;


        
     Original_data=randn(1,10000)+0.6*sin((1:10000)/19);
     Original_data(2,:)=zeros(1,10000);
     Original_data(3,:)=zeros(1,10000);
    
     rand1=random('Normal',0,0.2,1,length(Original_data));
     rand2=random('Normal',0,0.3,1,length(Original_data));

    for i=13:length(Original_data)
        Original_data(2,i)=Original_data(1,i-12)+rand1(i);
    end        
%         
%     for i=2:length(Original_data)
%         Original_data(3,i)=0.5*Original_data(3,i-1)+Original_data(2,i-1)+rand2(i);
%     end        
 lowf=6;
highf=10;
freq=1000;
fz=freq/2;
[b,a]=ellip(6,3,50,highf/fz);

sf=filtfilt(b,a,Original_data(1,:));
[b,a]=ellip(6,3,50,lowf/fz,'high');

sf=filtfilt(b,a,sf);

			thetamax_ts = [];
			max_theta = min(sf);
			threshold = 1/8 * max_theta;
			
			len_theta = length(sf);
			
			flag_over = 0;
			flag1 = 0;
			flag2 = 0;
			
			for i=1:len_theta
                
                if ~flag_over & (sf(i) < threshold)
                    flag_over = 1;
                    flag1 = 1;
                    p_start = i;
                end
                if flag_over & (sf(i) > threshold)
                    flag_over = 0;
                    flag2 = 1;
                    p_end = i;
                end
                if flag1 & flag2
                    [ad_max,p_max] = min(sf(p_start:p_end));
                    thetamax_ts=[thetamax_ts,p_max+p_start-1];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
        thetamax_ts_original=thetamax_ts*0.001;
        thetamax_ts=thetamax_ts_original;
        add_ts=[];
        for i=1:length(thetamax_ts)
add_ts=[add_ts,thetamax_ts(i)+randn(1,11)*0.02-0.008];
end
thetamax_ts=union(thetamax_ts,add_ts);
thetamax_ts(find(diff(thetamax_ts)<0.001))=[];
thetamax_ts(find(thetamax_ts<=0|thetamax_ts>=10))=[];
thetamax_ts=[0.001,thetamax_ts,9.999];
[bindata,temp]=hist(thetamax_ts,5000);

Original_data1(1,:)=mean([Original_data(1,1:2:10000);Original_data(1,2:2:10000)]);
Original_data1(2,:)=mean([Original_data(2,1:2:10000);Original_data(2,2:2:10000)]);
Original_data1(3,:)=bindata;
Original_data=Original_data1;

     Data(1,:)=Original_data(2,:);   
     Data(2,:)=Original_data(3,:);   
  
        fre_band=[0;250];
        NFFT=512;

        STFreq=fre_band(1);
EDFreq=fre_band(2);
    fs=500;
    Nr=1;
    Nl=length(Data(1,:));
    channel_num=2;
    Data(1,:)=zscore(Data(1,:))';
    Data(2,:)=zscore(Data(2,:))';
  MORDER_band=[15;30]
% MORDER_max=60;
for i=MORDER_band(1):MORDER_band(2)
    [A,Z2]=armorf(Data,Nr,Nl,i);
    AIC(i)=2*log(det(Z2))+2*i*channel_num^2/Nl;
end



    
    [temp_n,MORDER]=min(AIC);
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
                Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));
                
%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end

            
            
            
            plot(F,Fy2x,'r',F,Fx2y,'b')