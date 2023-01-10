function varargout = armorf_DiTrial(x,Nr,Nl,p)
%ARMORF   AR parameter estimation via LWR method by Morf modified.
%   x is a matrix whose every row is one variable's time series
%   Nr is the number of realizations, Nl is a vector where Nl(i) is the length of ith realization
%   If the time series are stationary long, just let Nr=1, Nl=length(x)
%   p is the order of AR model
%
%   A = ARMORF(X,NR,NL,P) returns the polynomial coefficients A corresponding to 
%     the AR model estimate of matrix X using Morf's method.
%
%   [A,E] = ARMORF(...) returns the final prediction error E (the
%   covariance matrix of the white noise of the AR model).
%
%   [A,E,K] = ARMORF(...) returns the vector K of reflection 
%     coefficients (parcor coefficients).
%
%   Ref: M. Morf, etal, Recursive Multichannel Maximum Entropy Spectral Estimation,
%              IEEE trans. GeoSci. Elec., 1978, Vol.GE-16, No.2, pp85-94.
%        S. Haykin, Nonlinear Methods of Spectral Analysis, 2nd Ed.
%              Springer-Verlag, 1983, Chapter 2
%
% original function armorf finished on Aug.9, 2002 by Yonghong Chen


% Initialization
InvalidTr=find(Nl<p+1);
Temp=[0 cumsum(Nl)];  %So start index of ith realization is Temp(i)+1, the end index of ith realization is Temp(i+1); 
                      %The ith realization data is x(Temp(i)+1:Temp(i+1))

if ~isempty(InvalidTr)
   invalidIn=[];
    for i=1:length(InvalidTr)
        invalidIn=[invalidIn InvalidTr(i):InvalidTr(i)+1];
    end
    Nr=Nr-length(InvalidTr);
    Nl(InvalidTr)=[];
    x(:,invalidIn)=[];
end

[L,N]=size(x);
R0=zeros(L,L);
R0f=R0;
R0b=R0;
pf=R0;
pb=R0;
pfb=R0;
ap(:,:,1)=R0;
bp(:,:,1)=R0;
En=R0;
Temp=[0 cumsum(Nl)];
for i=1:Nr
    En=En+x(:,Temp(i)+1:Temp(i+1))*x(:,Temp(i)+1:Temp(i+1))';
    ap(:,:,1)=ap(:,:,1)+x(:,Temp(i)+2:Temp(i+1))*x(:,Temp(i)+2:Temp(i+1))'/(Nl(i)-1);        
    bp(:,:,1)=bp(:,:,1)+x(:,Temp(i)+1:Temp(i+1)-1)*x(:,Temp(i)+1:Temp(i+1)-1)'/(Nl(i)-1);
end
ap(:,:,1) = inv((chol(ap(:,:,1)/Nr))');
bp(:,:,1) = inv((chol(bp(:,:,1)/Nr))');
for i=1:Nr
    efp = ap(:,:,1)*x(:,Temp(i)+2:Temp(i+1));
    ebp = bp(:,:,1)*x(:,Temp(i)+1:Temp(i+1)-1);
    pf = pf + efp*efp';
    pb = pb + ebp*ebp';
    pfb = pfb + efp*ebp';
end
En = chol(En/N)'; % Covariance of the noise

% Initial output variables
coeff = [];%  Coefficient matrices of the AR model
kr=[];  % reflection coefficients

for m=1:p
   % Calculate the next order reflection (parcor) coefficient
   ck = inv((chol(pf))')*pfb*inv(chol(pb));
   kr=[kr,ck];
   % Update the forward and backward prediction errors
   ef = eye(L)- ck*ck';
   eb = eye(L)- ck'*ck;
     
   % Update the prediction error
   En = En*chol(ef)';
   E = (ef+eb)./2;   
   
   % Update the coefficients of the forward and backward prediction errors
   ap(:,:,m+1) = zeros(L);
   bp(:,:,m+1) = zeros(L);
   pf = zeros(L);
   pb = zeros(L);
   pfb = zeros(L);

   for i=1:m+1       
       a(:,:,i) = inv((chol(ef))')*(ap(:,:,i)-ck*bp(:,:,m+2-i));
       b(:,:,i) = inv((chol(eb))')*(bp(:,:,i)-ck'*ap(:,:,m+2-i));
   end
   for k=1:Nr
       efp = zeros(L,Nl(k)-m-1);
       ebp = zeros(L,Nl(k)-m-1);
       for i=1:m+1
           k1=m+2-i+Temp(k)+1;
           k2=Nl(k)-i+1+Temp(k);
           efp = efp+a(:,:,i)*x(:,k1:k2);
           ebp = ebp+b(:,:,m+2-i)*x(:,k1-1:k2-1);
       end
       pf = pf + efp*efp';
       pb = pb + ebp*ebp';
       pfb = pfb + efp*ebp';
   end
   ap = a;
   bp = b;
end
for j=1:p
    coeff = [coeff,inv(a(:,:,1))*a(:,:,j+1)];
end

varargout{1} = coeff;
if nargout >= 2
    varargout{2} = En*En';
end
if nargout >= 3
    varargout{3} = kr;
end
    