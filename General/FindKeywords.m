function output=FindKeywords(filePtr,Keywords)

output=-1;
while (feof(filePtr) ~= 1)
junk=fgetl(filePtr);	% this will make the function execute much faster but should be optional
if strfind(junk,Keywords)
    output=1;
    break
end
end


