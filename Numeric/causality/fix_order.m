function n=fix_order(Data,j,order_set)

N=length(Data(1,:));
q=length(Data(:,1));
for i=1:length(order_set)
    V_Q_m=Q_m_basic(Data,j,order_set(i));
    AIC(i)=log(V_Q_m)+2*order_set(i)*q/N;
end

[m,n]=min(AIC);
figure;plot(order_set,AIC,'r.-');
    
    

