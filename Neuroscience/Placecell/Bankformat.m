function  ParamTable=Bankformat(ParamTable)

%tentative pour afficher seulement 2 chiffres après la virgule mais ça ne
%marche pas !
% juste to save data with 2 numbers after comma
tabletemp=cell2mat(ParamTable);
tabletemp=100*tabletemp;
tabletemp=floor(tabletemp);
tabletemp=tabletemp/100;  
ParamTable=mat2cell(tabletemp, ones(1,size(tabletemp,1)), ones(1,size(tabletemp,2)));