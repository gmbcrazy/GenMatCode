function [R,RFisher]=ParcorrfMRI(X)

%%%%Input X is a*b matrix, a is length of time series, b is channel num

[~,b]=size(X);

% R=corr(X);


parfor i=1:b
    S1=X(:,i);
    S2=X(:,i:b);
    
    TempRow{i}=corr(S1,S2);
%     parfor j=i:b
%         S1=X(:,i);
%         S2=X(:,j);
%         R(i,j)=corr(S1,S2);
%     end

end

for i=1:b
    R(i,i:b)=TempRow{i};
end

R=triu(R,1)+R';
for i=1:b
    R(i,i)=1; 
end


RFisher=real(0.5.*log((R+1)./(1-R)));
for i=1:b
    RFisher(i,i)=Inf;
end


