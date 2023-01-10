function [r,p]=corr_NanMat(A,NanSort)

if NanSort==1
NanNum=sum(isnan(A));
[NanNum,SortI]=sort(NanNum);
[r,p]=corr_NanMat(A(:,SortI),0);
r1=r;p1=p;
for j=1:length(SortI)
    p1(:,SortI(j))=p(:,j);
    r1(:,SortI(j))=r(:,j);

end
   p=p1;
   r=r1;
end


sampleN=size(A,2);
r=zeros(sampleN,sampleN);
p=zeros(sampleN,sampleN);
for i=1:(sampleN-1)
    index=~isnan(A(:,i));
    [r(i,i+1:sampleN),p(i,i+1:sampleN)]=corr(A(index,i),A(index,(i+1:end)),'rows','pairwise');
end

r=r+r';
p=p+p';
r=r+eye(sampleN);
