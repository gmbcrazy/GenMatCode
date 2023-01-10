
function Result=dirFile(path,FileName)

%%%FileName could be '*.*'

% if strcmp(pathFolder(end),'\')
% else
%     pathFolder=[pathFolder '\'];
% end
pathFolder=[path '\' FileName];
Result=dir(pathFolder);
folderFind=dir(path);
folderFind(1:2)=[];  
for i=1:length(folderFind)
    if folderFind(i).isdir==1
       NewSearching=[folderFind(i).folder '\' folderFind(i).name '\'];
       ResultNew=dirFile(NewSearching,FileName);
       Result=[Result;ResultNew];
    end
end
