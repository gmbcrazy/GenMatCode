function A=subplotLUpage(rowNum,colNum,iPage,varargin)

%%%%%%%%%subplot at the icol row and irow col
%%%%%%%%%subplots with colNum the iPage th subplot in total

if mod(iPage,colNum)~=0
irow=floor(iPage/colNum)+1;
icol=mod(iPage,colNum);
else
irow=round(iPage/colNum);
icol=colNum;
end



if nargin<4             %%%%%%Default Margin and Interval Parameter
   P.xLeft=0.06;        %%%%%%Left Margin
   P.xRight=0.02;       %%%%%%Right Margin
   P.yTop=0.02;         %%%%%%Top Margin
   P.yBottom=0.06;      %%%%%%Bottom Margin
   P.xInt=0.02;         %%%%%%Width-interval between subplots
   P.yInt=0.02;         %%%%%%Height-interval between subplots
else
   P=varargin{1}; 
   if ~isstruct(P)
      PP=P;
      clear P
      P.xLeft=PP(1);
      P.xRight=PP(2);
      P.yTop=PP(3);
      P.yBottom=PP(4);
      P.xInt=0.001;
      P.yInt=0.001;

   end
   
end

A=subplotLU(rowNum,colNum,irow,icol,P);


