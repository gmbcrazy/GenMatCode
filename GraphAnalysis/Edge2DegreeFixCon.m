function [Degree,Ix]=Edge2DegreeFixCon(Pval,ConnTh)

b=diag(ones(size(Pval,1),1));
Pval=Pval+b;
temp1=Pval(:);

[~,Ix]=sort(temp1);
NeedLength=ceil(round((size(Pval,1)*(size(Pval,2)-1)*ConnTh))/2)*2;

Iy=Ix(1:NeedLength);

temp2=zeros(size(temp1))-1;
temp2(Iy)=temp1(Iy);

Pnew=reshape(temp2,size(Pval,1),size(Pval,2));
Pnew(Pnew>=0)=1;
Pnew(Pnew<0)=0;

Degree=sum(Pnew);


[~,Ix]=sort(Degree,'descend');

