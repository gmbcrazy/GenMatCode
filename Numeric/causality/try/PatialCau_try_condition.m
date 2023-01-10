function Causality=PatialCau_try_condition(Data,fre_band,fs,NFFT,MORDER_band)

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
                P_bar=[ones(T_length-2) zeros(T_length-2,1);-Z_bar(1,2:(T_length-1))/Z2(1,1) 1];
                G=[Temp_Hxx Temp_Hxz;Temp_Hzx Temp_Hzz]*pinv(P_bar);
                G_expand=[G(1,1) 0 G(1,2:(T_length-1));0 1 zeros(1,T_length-2);G(2:(T_length-1),1) zeros(T_length-2,1) G(2:(T_length-1),2:(T_length-1))];
                Q=pinv(G_expand)*H2(k).C;
                Fy2x(i,j).Causality(k)=log(abs(det(Z_bar(1,1)))/abs(Q(1,1)*Z2(1,1)*Q(1,1)'));
                
            end
                
%             hold on;plot(F,Fy2x,'g');
            
        Causality.F2to1= Fy2x;
        Causality.F= F;
        
        
        
