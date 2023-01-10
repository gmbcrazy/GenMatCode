function s3 = SingleStructFiledMerge(s1,s2,varargin)
%%%%s1 and s2 must be single size of Structure variable. s1(2) s2(2) is
%%%%invalid.

%%%%Combine field of s2 to the same field of s1;

if nargin==2
   s=fieldnames(s1);
elseif nargin==2
   s=varargin{1};
else
    
end
s3=s1;

for ifield=1:length(s)
%     setfield(ss,{1},s{ifield})=getfield(s1,{1},s{ifield});
    if isnumeric(getfield(s1,{1},s{ifield}))
       s3=setfield(s3,{1},s{ifield},[getfield(s1,{1},s{ifield});getfield(s2,{1},s{ifield})]);
    end

end