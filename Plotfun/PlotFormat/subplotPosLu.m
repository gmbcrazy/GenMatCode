function subplotPosLu(PosMatX,PosMatY,irow,icol,varargin)

%%PosMatX, give the width of subplot, where PosMatX(i,j) give the width of
%%the row i and col j panels

%%PosMatY, give the height of subplot, where PosMatY(i,j) give the height of
%%the row i and col j panels


%%%%%%%%%subplot at the icol row and irow col
%%%%%%%%%subplots with colNum row and rowNum cols in total
[rowNum,colNum]=size(PosMatX);

if nargin<5
   P.xLeft=0.06;
   P.xRight=0.02;
   P.yTop=0.02;
   P.yBottom=0.06;
%    P.xInt=0.02;
%    P.yInt=0.02;
else
   PP=varargin{1};   
   if ~isstruct(PP)   %%%%%P = [xleft xright ytop ybottom];
      P.xLeft=PP(1);
      P.xRight=PP(2);
      P.yTop=PP(3);
      P.yBottom=PP(4);
   else
      P=PP;
   end
end

P.xInt=(1-P.xLeft-P.xRight-sum(PosMatX(1,:)))/colNum;
P.yInt=(1-P.yTop-P.yBottom-sum(PosMatY(:,1)))/rowNum;

if icol==1
tempx=P.xLeft+(icol-1)*P.xInt;
else
tempx=P.xLeft+(icol-1)*P.xInt+sum(PosMatX(irow,1:(icol-1)));
end

tempy=1-P.yTop-(irow-1)*P.yInt-sum(PosMatY(1:irow,icol));

subplot('position',[tempx,tempy,PosMatX(irow,icol),PosMatY(irow,icol)]);