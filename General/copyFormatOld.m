
function copyFormatOld(path,Folder,DestiFolder,NeedFile)

% if strcmp(pathFolder(end),'\')
% else
%     pathFolder=[pathFolder '\'];
% end
pathFolder=[path '\' Folder];
FileList=dir(pathFolder);
FileList2=dir(DestiFolder);

CreatFolder=1;
DestiFolderNew=[DestiFolder '\' Folder];

for i=1:length(FileList2)
    if FileList2(i).isdir==1
if strcmp(Folder,FileList2(i).name)
   CreatFolder=0;
   break
end
    end
end

if CreatFolder==1;
   mkdir(DestiFolderNew);
end
copyFileFactor=0;
for i=1:length(FileList)
    
    if strcmp(FileList(i).name,'.')
       
    elseif strcmp(FileList(i).name,'..')
        
        
    elseif FileList(i).isdir
           copyFormat(pathFolder,FileList(i).name,DestiFolderNew,NeedFile);
           
           
           
    else
          b=strfind(FileList(i).name,'.');
            if strcmp(FileList(i).name((b(end)+1):end),NeedFile)
               copyFileFactor=1;
               break
            end
    end
        

end

if copyFileFactor==1
   copyfile([pathFolder '\*.' NeedFile],DestiFolderNew);
   copyFileFactor=0;
end