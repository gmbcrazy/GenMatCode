function EdgeIndex=EdgeExtract(PathFile,pth,varargin)

if nargin==3
   if strfind(varargin{1},'fdr')
   qfdr=pth;
   end
end

if ischar(PathFile)
load(PathFile);
p=pval_meta;
else
    p=PathFile;
end

if nargin==3
pth=Thfdr_Pmatrix(p,qfdr);
end
temp=tril(zeros(size(p))-1)+triu(p,1);
temp=temp';
temp=temp(:);
temp(temp==-1)=[];
EdgeIndex=find(temp<=pth);       %%%%%%%%%%%%%%%%%%%
