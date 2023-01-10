function [s] = fieldmerge(s1,field);


s=[];
if isfield(s1,field)
    for i=1:length(s1)
        s=[s;getfield(s1,{i},field)];
    end
end
