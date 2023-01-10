function [IndexPh,IndexMotion]=CellMatch_str(Cell1,Cell2,varargin)

% % MatchCell1(path,keyWord,Cell1,varargin)

      for i=1:length(Cell2)
       a=strfind(Cell2{i},'_');
       Cell2{i}(a)=[];
      end



if nargin==3    %%%%%%%%%%%%excluding pre-keywords
   EXPhInfoKeyword=varargin{1};
   lex=length(EXPhInfoKeyword);
      for i=1:length(Cell2)
       a=strfind(Cell2{i},EXPhInfoKeyword);
       a=min(a);
       Cell2{i}=deblank(Cell2{i}(a+lex:end));
      end
elseif nargin==4 %%%%%%%%%%%%excluding post-keywords
   EXPhInfoKeyword=varargin{2};
   lex=length(EXPhInfoKeyword);
      for i=1:length(Cell2)
       a=strfind(Cell2{i},EXPhInfoKeyword);
       a=min(a);
       Cell2{i}=deblank(Cell2{i}(1:(a-1)));
      end

else
    
end


if iscell(Cell1)
   TempInfo=Cell1;
else
   for i=1:length(Cell1)
       TempInfo{i}=num2str(Cell1(i));
   end
end

IndexPh=[];
IndexMotion=[];
for i=1:length(TempInfo)
    for j=1:length(Cell2)
        if strcmp(TempInfo{i},Cell2{j})
           IndexPh=[IndexPh;i];
           IndexMotion=[IndexMotion;j];
            break
        else
            
        end
    end
end


