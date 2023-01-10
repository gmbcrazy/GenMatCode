function  [InFieldR,OutFieldR]= GT_FieldRate1D(map,posPDF,PlaceField)

% Mean firing rate
ix=[];
for i=1:length(PlaceField)
    ix=[ix;PlaceField(i).PeakIX];  
end

posPDF1=posPDF(ix);
posPDF1=posPDF1./nansum(nansum(posPDF1));
map1=map(ix);
InFieldR=nansum(nansum(map1.*posPDF1));


nonFieldI=setdiff(1:length(map),ix);
posPDF2=posPDF(nonFieldI);
posPDF2=posPDF2./nansum(nansum(posPDF2));
map2=map(nonFieldI);
OutFieldR=nansum(nansum(map2.*posPDF2));
