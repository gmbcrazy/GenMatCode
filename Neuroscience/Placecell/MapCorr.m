function [Rxy,Zxy,Pxy] = MapCorr(map1,map2)

map1=map1(:);
map2=map2(:);

Index1=isnan(map1);
Index2=isnan(map2);

Index=find((Index1+Index2)==0);

if ~isempty(Index)
   [Rxy,Pxy]=corr(map1(Index),map2(Index));
else
   Rxy=-2;
   Pxy=2;
end
Zxy=atanh(Rxy);
Zxy(Rxy==-2)=NaN;
Zxy(isnan(Zxy))=0;
