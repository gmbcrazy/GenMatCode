function Output=edgeFromMetaResult(p,pth,varargin)

%%%%%p must be a symetric matrix satisfying p(i,j)=p(j,i)
if isstr(p)
   load(p);
   p=pval_meta;
end


if nargin==2
   MCcorrection='FWER';
else
   MCcorrection=varargin{1};
end

if ~isempty(strfind(MCcorrection,'FWER'))
   pth=pth/(size(p,1)*(size(p,1)-1)/2);   %%%%%%%%%%%%%bonforni corection
elseif ~isempty(strfind(MCcorrection,'FDR'))  %%%%%%%%%%%%%Fdr corection
   pth=Thfdr_Pmatrix(p,pth)+0.0000000000001;
else                      
   pth=pth;
end
    
l=size(p,1);
%%%%%%extract edge such that for any i from 1 to length(Output,1),p(Output(i,1),Output(i,2))<=pth


col=repmat(1:l,l,1);
row=col';


p=tril(p,-1);
p=p+triu(zeros(l,l)+1);

col=tril(col,-1);
row=tril(row,-1);

col=col(:);
row=row(:);
p=p(:);

col(p>pth)=[];
row(p>pth)=[];

Output=[col row];
% Val=find((col-row)>0);
% Output=Output(Val,:);

