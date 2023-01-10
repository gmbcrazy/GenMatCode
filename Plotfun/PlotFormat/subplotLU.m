function A=subplotLU(rowNum,colNum,irow,icol,varargin)

%%%%%%%%%subplot at the icol row and irow col
%%%%%%%%%subplots with colNum row and rowNum cols in total


if nargin<5             %%%%%%Default Margin and Interval Parameter
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

xWidth=(1-P.xLeft-P.xRight-P.xInt*(colNum-1))/colNum;
yWidth=(1-P.yTop-P.yBottom-P.yInt*(rowNum-1))/rowNum;

tempx=P.xLeft+(icol-1)*(xWidth+P.xInt);
tempy=1-P.yTop-irow*yWidth-(irow-1)*P.yInt;

A=subplot('position',[tempx,tempy,xWidth,yWidth]);

if isfield(P,'yTick')
   set(gca,'ytick',P.yTick,'yticklabel',[]);
end
if isfield(P,'xTick')
   set(gca,'xtick',P.xTick,'xticklabel',[]);
end



