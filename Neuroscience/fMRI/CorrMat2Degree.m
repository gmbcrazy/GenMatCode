function Degree=CorrMat2Degree(data,Perth)

temp1=zeros(size(data))-1;
temp1=tril(temp1);

temp=triu(data,1)+temp1;
temp=temp(:);
temp(temp==-1)=[];

temp=sort(temp(:),'descend');
Th=round(length(temp)*Perth);
Th=max(min(Th,length(temp)),1);

TempData=zeros(size(data));
TempData((data>Th))=1;

Degree=sum(TempData);
Degree=Degree(:);