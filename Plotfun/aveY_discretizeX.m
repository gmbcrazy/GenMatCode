function [yy,numbin]= aveY_discretizeX(y,x,xbin,varargin)

%%%%%%%y is m*n matrix, x is m*1 vector
%%%%%%%divided x into xbin
%%%%%%%averaged the y in each x xbin.

if ~iscell(x)
    bins = discretize(x,xbin);    
    for ii=1:(length(xbin)-1)
        yy(ii,:)=mean(y(bins==ii,:),1);
        numbin(ii)=sum(bins==ii);
    end
elseif iscell(x)
    yyy={};
    for i=1:size(x,1)
        for j=1:size(x,2)
            yyy{i,j}=aveY_discretizeX(y{i,j},x{i,j},xbin);
        end 
    end
    yy=yyy;
    clear yyy
    numbin=[];
elseif isempty(x)
    yy=[];  
    numbin=[];
else
    yy=[];  
    numbin=[];
end


% if narvargin==4
%    yy=CellMat2Mat(cellY);
% end
% 
% function MatY=CellMat2Mat(cellY)
% 
% MatY=[];
% iM=1;
% if ~iscell(cellY)
%    MatY=cat(3,MatY);
% else
%     for i=1:size(cellY,1)
%         for j=1:size(cellY,2)
%             MatY=CellMat2Mat(cellY{i,j});
%         end 
%     end
% end








