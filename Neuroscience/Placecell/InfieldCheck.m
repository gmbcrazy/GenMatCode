function Index=InfieldCheck(Track,Field,DistTh,NumTh)
%%%%%%%%%%%Check the if Track inside of Field
%%%%%%%%%%%Track(:,1) is x coorrdinate, Track(:,2) is y coorrdinate; The same for variable Field

[Num,~]=size(Track);
% [FieldNum,~]=size(Field);

Index=zeros(Num,1);


for i=1:Num
    
    TempD=((Field(:,1)-Track(i,1)).^2+(Field(:,2)-Track(i,2)).^2).^0.5;
    if length(find(TempD<=DistTh))>=NumTh
       Index(i)=1;
    end
    
end

% Index=find(Index==1);
