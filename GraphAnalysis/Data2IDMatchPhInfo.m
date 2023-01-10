function [IndexData,IndexPhInfo]=Data2IDMatchPhInfo(path,keyWord,PhInfo,varargin)

if nargin==4
   EXPhInfoKeyword=varargin{1};
   lex=length(EXPhInfoKeyword);
end


DataFile=dir([path '/*' keyWord '*.mat']);

IndexDataFile=zeros(size(DataFile));

for i=1:length(DataFile)
% % %     DataFile(i).name
    TEMPIndex=[];
    MatchNum=[];
    for j=1:length(PhInfo)
        if ischar(PhInfo)    
           temp=PhInfo(j,:);
        elseif iscell(PhInfo)
               if ischar(PhInfo{j})
                  temp=PhInfo{j};
               else 
                  temp=num2str(PhInfo{j});
               end
        else
            temp=num2str(PhInfo(j));
        end
        temp=deblank(temp);
        if nargin==4
        ex=strfind(temp,EXPhInfoKeyword);
        if ~isempty(ex)
            temp(ex:(ex+lex-1))=[]; 
        end
        end
%         temp
        
        if ~isempty(strfind(DataFile(i).name,temp))
% % %            [a,b,c]=intersect(DataFile(i).name,temp);
           a=strFindLength(DataFile(i).name,temp);
% % %            if length(a)>1
% % %                if max(diff(b))>1||max(diff(c))>1
% % %                   continue
% % %                end
% % %            end
           TEMPIndex=[TEMPIndex;j];
           MatchNum=[MatchNum;a];
% %            IndexDataFile(i)=j;
%            break
        end   
    end
    if ~isempty(TEMPIndex)
       [~,temp]=max(MatchNum);
       IndexDataFile(i)=TEMPIndex(temp);
    end
end

IndexData=find(IndexDataFile~=0);
IndexPhInfo=IndexDataFile(IndexData);



function count=strFindLength(s1,s2)

count=0;
while length(s2)>1
    if ~isempty(findstr(s1,s2))
        s2(1)=[];
        count=count+1;
    end
end

