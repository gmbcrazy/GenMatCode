function [Degree,Ix]=Edge2Degree(EdgeMatrix)

Degree=sum(abs(EdgeMatrix));

[~,Ix]=sort(Degree,'descend');

