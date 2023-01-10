function Data=MergeField(Struct,field)

Data=[];
for i=1:length(Struct)
    Data=[Data;getfield(Struct,{i},field)];
    
    
end