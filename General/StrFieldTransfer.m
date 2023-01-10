function Str1=StrFieldTransfer(Str1,Str2,IdxStr1,IdxStr2)

%%%%%%transfer the field of Str2 to Str1
if nargin==2
   IdxStr1=1;
   IdxStr2=1;
end

A=fieldnames(Str2);

for i=1:length(A)
    Str1=setfield(Str1,{IdxStr1},A{i},getfield(Str2,{IdxStr2},A{i}));
end