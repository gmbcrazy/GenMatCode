
function  AIC=AIC_m(Data,row_origin,row_result)

p=length(Data(:,1));
for m=1:200
% for m=1:floor(length(Data(1,:))/4)
for k=1:m+1
    for r=1:p
        for i=1:p
            R(k).matrix(r,i)=cross_covariance(Data,(k-1),r,i);
        end
    end
end

Y=[];
for k=2:(m+1)
Y=[Y;(R(k).matrix)'];
end

X=zeros(m*p^2,m*p^2);

X=[];
for i=1:m
    X=[X,R(i).matrix];
end
XX=zeros(p,p);
for i=2:m
    XX=[XX,R(i).matrix];
end

iteration_matrix=[zeros((m*p-p),p),eye(m*p-p);zeros(p,m*p)];

temp_X(1).iteration_matrix=X;
temp_XX(1).iteration_matrix=XX;
for k=2:m
    temp_X(k).iteration_matrix=temp_X(k-1).iteration_matrix*iteration_matrix;
    temp_XX(k).iteration_matrix=temp_XX(k-1).iteration_matrix*iteration_matrix;

end

coeff_matrix1=[];
coeff_matrix2=[];

for k=1:m
    coeff_matrix1=[coeff_matrix1;temp_X(k).iteration_matrix];
    coeff_matrix2=[coeff_matrix2;temp_X(k).iteration_matrix];

end


coeff_matrix=coeff_matrix1+coeff_matrix2';

    
A_t=(pinv(coeff_matrix)*Y)';                              

for i=1:m
    Temp_A(i).matrix=A_t(:,((i-1)*p+1):i*p);
end

covariance_matrix=R(1).matrix;
for i=1:m
    covariance_matrix=covariance_matrix-Temp_A(i).matrix*R(i).matrix;
end
AIC(m)=2*log(det(covariance_matrix))+2*p^2*m/length(Data(1,:));

end


function u=cross_covariance(X,lag,row_r,row_s)
         N_Temp=length(X(1,:));
         q_Temp=length(X(:,1));

         u=(sum(X(row_r,(lag+1):N_Temp).*X(row_s,1:(N_Temp-lag)))-sum(X(row_r,(lag+1):N_Temp))*sum(X(row_s,1:(N_Temp-lag)))/(N_Temp-lag))/(N_Temp-lag);
