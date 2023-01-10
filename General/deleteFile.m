
function deleteFile(pathFolder,DeletFile)

% if strcmp(pathFolder(end),'\')
% else
%     pathFolder=[pathFolder '\'];
% end
FileList=dir(pathFolder);
delete([pathFolder '\*' DeletFile '*']);

for i=1:length(FileList)
    
    if strcmp(FileList(i).name,'.')
       
    elseif strcmp(FileList(i).name,'..')
        
        
    elseif FileList(i).isdir
           deleteFile([pathFolder '\' FileList(i).name],DeletFile);
    else
    end
        

end