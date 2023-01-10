function V_Q_m=Q_m_basic(Data,j,m)


N=length(Data(1,:));
q=length(Data(:,1));


uj=[];
for p=1:q
    for lag_temp=1:m    
        uj_temp(lag_temp)=cross_covariance(Data,lag_temp,j,p);
    end
    uj=[uj,uj_temp];
    
end




M=[];
for r=1:q
    M_r_Temp=[];
    for s=1:q
        M_temp=[];
        for k=1:m
            for i=1:m
            
                if k-i>=0
                   M_temp(i,k)=cross_covariance(Data,abs(k-i),r,s);
               else
                   M_temp(i,k)=cross_covariance(Data,abs(k-i),s,r);
               end
           end
       end
    
       M_r_Temp= [M_r_Temp,M_temp];
     
    end
 
M=[M;M_r_Temp];

end


a=M\uj';
a=reshape(a,m,q);
a=a';
for t=(m+1):N
    Data_Temp1=Data(:,[(t-1):-1:(t-m)]);
    Pj(t-m)=sum(sum(a.*Data_Temp1));
end


Data_Temp1=Data(:,(m+1:N));
V_Q_m=sum((Data_Temp1(j,:)-Pj).^2)/(N-m);


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         

function u=cross_covariance(X,lag,row_r,row_s)
         N_Temp=length(X(1,:));
         q_Temp=length(X(:,1));

         u=(sum(X(row_r,(lag+1):N_Temp).*X(row_s,1:(N_Temp-lag)))-sum(X(row_r,(lag+1):N_Temp))*sum(X(row_s,1:(N_Temp-lag)))/(N_Temp-lag))/(N_Temp-lag);
