function Show=PthReport(varargin)

% % % Show=PthReport(P,Pth,R,RegionList,IntrestIndex)
    P=varargin{1};
    Pth=varargin{2};
    R=varargin{3};
    RegionList=varargin{4};

if  nargin==5;
    IntrestIndex=varargin{5};
    ShowCase=1;
else
    ShowCase=0;
end

switch ShowCase
    case 0
Ptemp=triu(P,1);
Ptemp=Ptemp+tril(ones(size(P))*2);
[SigR,SigC]=find(Ptemp<=Pth);

if isempty(SigR)
   Show='No significant P value' 
else
   Show='                                               ';
   for i=1:length(SigR)
       Temp=[RegionList(SigR(i),:) '  ' RegionList(SigC(i),:) ' P=' showNum(Ptemp(SigR(i),SigC(i)),2) '  ' showNum(R(SigR(i),SigC(i)),3)];
       Show(i,1:length(Temp))=Temp;
   end       
end

    case 1
        
        
SigC=find(P(IntrestIndex,:)<=Pth);

if isempty(SigC)
   Show='No significant P value' 
else
   Show='                                               ';
   for i=1:length(SigC)
       Temp=[RegionList(IntrestIndex,:) '  ' RegionList(SigC(i),:) ' P=' showNum(Ptemp(IntrestIndex,SigC(i)),2) '  ' showNum(R(IntrestIndex,SigC(i)),3)];
       Show(i,1:length(Temp))=Temp;
   end       
end


end