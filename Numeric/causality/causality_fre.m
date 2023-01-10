
function [causal_influence,fre,A_t]=causality_fre(Data,row_origin,row_result,m)

p=length(Data(:,1));
fre=[0:pi/m:pi];

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
    coeff_matrix2=[coeff_matrix2;temp_XX(k).iteration_matrix];

end


coeff_matrix=coeff_matrix1+coeff_matrix2';

    
A_t=(pinv(coeff_matrix)*Y)';                              

for i=1:m
    Temp_A(i).matrix=A_t(:,((i-1)*p+1):i*p);
end

covariance_matrix=R(1).matrix;
% for i=1:m
%     covariance_matrix=covariance_matrix+Temp_A(i).matrix*R(i).matrix;
% end

% H=eye(p);
clear i
for step=1:length(fre)
for j=1:m
%     H=H+Temp_A(j).matrix*exp(-j*i*2*pi*fre);
    A_f(j).matrix=Temp_A(j).matrix*exp(-j*(-1)^0.5*2*pi*fre(step));
end
A=-eye(p);
for j=1:m
%     H=H+Temp_A(j).matrix*exp(-j*i*2*pi*fre);
A=A-A_f(j).matrix;
end

H=pinv(A);

causal_influence(step)=H(row_result,row_origin)*conj(H(row_result,row_origin))/sum(abs(H(:,row_origin)).*abs(H(:,row_origin)));
end

H;



function u=cross_covariance(X,lag,row_r,row_s)
         N_Temp=length(X(1,:));
         q_Temp=length(X(:,1));

         u=(sum(X(row_r,(lag+1):N_Temp).*X(row_s,1:(N_Temp-lag)))-sum(X(row_r,(lag+1):N_Temp))*sum(X(row_s,1:(N_Temp-lag)))/(N_Temp-lag))/(N_Temp-lag);
