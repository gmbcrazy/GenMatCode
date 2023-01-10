function p=ImageInsert(BackGroundImag,InsertedImag)


if ischar(BackGroundImag)
    p2=imread(BackGroundImag);
else
    p2=BackGroundImag;
end

if ischar(InsertedImag)
    p1=imread(InsertedImag);
else
    p1=InsertedImag;
end


[m,n,junk]=size(p2);
index=[];
for i=1:m
    for j=1:n
        if p1(i,j,1)>248&&p1(i,j,1)>248&&p1(i,j,1)>248
        else
           index=[index;i j];
        end
    
    end
end
    
% plot(index(:,1),index(:,2),'.')

p=p2;

l=length(index(:,1));

for i=1:l
    p(index(i,1),index(i,2),:)=p1(index(i,1),index(i,2),:);
end

