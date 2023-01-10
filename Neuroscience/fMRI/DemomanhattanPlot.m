
AAL=1:116
for i=1:length(AAL)
    IndexI=find(AAL==i);
    diffIndex=setdiff(1:size(Pall,1),IndexI);
    Ptemp=Pall(IndexI,diffIndex);
    Ptemp=Ptemp(Ptemp>0);
    Data(i).value=-log10(Ptemp(:));
    Data(i).Name=AALName(i);
end