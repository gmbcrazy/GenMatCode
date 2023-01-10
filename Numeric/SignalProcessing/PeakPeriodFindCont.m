function [MaxTs StartTs OverTs]=PeakPeriodFindCont(Data,ADfreq,Threshold,TimeTh,varargin)

if nargin==5
   MergeTh=varargin{1};
end
Index=zeros(size(Data));
Index(find(Data>=Threshold))=1;

IndexR=[0;Index(:);0];
S=find(diff(IndexR)==1);
O=find(diff(IndexR)==-1)-1;

Duration=O-S+1;

Invalid=find((Duration/ADfreq)<TimeTh);

S(Invalid)=[];
O(Invalid)=[];
Duration(Invalid)=[];
if ~isempty(S)
for i=1:length(S)
   [temp IMaxTs]=max(Data(S(i):O(i)));
   IMaxTs=S(i)+IMaxTs-1;
   MaxTs(i)=IMaxTs/ADfreq;
    
end
   StartTs=(S-1)/ADfreq;
   OverTs=O/ADfreq;

else
    MaxTs=[];
    StartTs=[];
    OverTs=[];
    
end

if nargin==5
   OverT=OverTs(1:end-1);
   StartT=StartTs(2:end);
   Temp=find((StartT-OverT)<MergeTh);
   if ~isempty(Temp)
   OverT(Temp)=[];
   StartT(Temp)=[];
   
   StartTs=[StartTs(1);StartT(:)];
   OverTs=[OverT(:);OverTs(end)];

   end
   
end



