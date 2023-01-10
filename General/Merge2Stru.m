function smerge=Merge2Stru(s1,s2)
fields = fieldnames(s1)';
 fields(2,:) = cellfun(@(f) [s1.(f) s2.(f)], fields, 'unif', false);
 smerge = struct(fields{:});