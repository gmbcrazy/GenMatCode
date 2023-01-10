function [ss] = StructFiledMerge(s1,varargin)
% Combine all index togother
if nargin==2
  s=varargin{1};
else
  s=fieldnames(s1);  
end

ss=struct([]);
for ifield=1:length(s)
    ss=setfield(ss,{1},s{ifield},getfield(s1,{1},s{ifield}));
end

if length(s1)<=1
   return
end


for ifield=1:length(s)
%     setfield(ss,{1},s{ifield})=getfield(s1,{1},s{ifield});
for i=2:length(s1)
    if isnumeric(getfield(s1,{i},s{ifield}))
    ss=setfield(ss,{1},s{ifield},[getfield(ss,{1},s{ifield});getfield(s1,{i},s{ifield})]);
    end
end

end