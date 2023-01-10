function causality=kal2spec(kal,C,channel_num,p,NFFT,Fs)
%%%%kal is the result from [kal,e,Kalman,Q2] = mvaar(y,p,UC,mode,Kalman)
           causality.I2to1=[];
           causality.I1to2=[];
           causality.F2to1=[];
           causality.F1to2=[];
           causality.Coh_cau=[];
           causality.S1=[];
           causality.S2=[];
Duration=length(kal(:,1));
T=channel_num*p;
for t=1:Duration
    for i=1:channel_num
        temp=kal(t,((i-1)*T+1):(i*T));
        A(i,:)=temp;
    end
    Z2=C(:,:,t);
    tmpi=([1:p]-1)*2;

            eyx=Z2(2,2)-Z2(1,2)^2/Z2(1,1); %corrected covariance
            exy=Z2(1,1)-Z2(2,1)^2/Z2(2,2);
            for qq=1:channel_num
                for q=1:channel_num
                    MARP(qq,q).C=A(qq,tmpi+q);
                end
            end
            [H2 FCoeff F]=MARSpec(MARP,Z2,p,Fs,NFFT,0,Fs/2); 
            for k=1: NFFT
                S2=abs(H2(k).C*Z2*H2(k).C'); 
                Coh_cau(k)=abs(S2(1,2))^2/(S2(1,1)*S2(2,2));
                Spec1(k)=S2(1,1);
                Spec2(k)=S2(2,2);
                Iy2x(k)=abs(H2(k).C(1,2))^2*eyx/abs(S2(1,1)); %measure within [0,1]
                Ix2y(k)=abs(H2(k).C(2,1))^2*exy/abs(S2(2,2));
                Fy2x(k)=log(abs(S2(1,1))/abs(S2(1,1)-(H2(k).C(1,2)*eyx*conj(H2(k).C(1,2))))               ); %Geweke's original measure
                Fx2y(k)=log(abs(S2(2,2))/abs(S2(2,2)-(H2(k).C(2,1)*exy*conj(H2(k).C(2,1)))));


%                 handles.ResultData.Sec(j).CorGeweke(k).C(m,n)=Iy2x;
%                 handles.ResultData.Sec(j).CorGeweke(k).C(n,m)=Ix2y;
            end
           causality.I2to1=[causality.I2to1;Iy2x];
           causality.I1to2=[causality.I1to2;Ix2y];
           causality.F2to1=[causality.F2to1;Fy2x];
           causality.F1to2=[causality.F1to2;Fx2y];
           causality.Coh_cau=[causality.Coh_cau;Coh_cau];
          causality.S1=[causality.S1;Spec1];
          causality.S2=[causality.S2;Spec2];
clear A
end
causality.F=F;        
causality.MORDER=p;






