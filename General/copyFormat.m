
function copyFormat(path,Folder,DestiFolder,NeedFile)

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

if CreatFolder==1
   mkdir(DestiFolderNew);
end
% % copyFileFactor=0;

for ii=1:length(FileList)
        if strcmp(FileList(ii).name,'.')
           continue
        elseif strcmp(FileList(ii).name,'..')
           continue
        else
        end
    b=strfind(FileList(ii).name,'.');
% %     FileList(ii).name
% %     ii
    if ~isempty(b)
    b=min([b+1 length(FileList(ii).name)]);
    if strcmp(FileList(ii).name(b:end),NeedFile)
       copyfile([pathFolder '\*.' NeedFile],DestiFolderNew);
           break
    end
    end
end

for ii=1:length(FileList)
    
    if strcmp(FileList(ii).name,'.')
     
    elseif strcmp(FileList(ii).name,'..')

    elseif FileList(ii).isdir
           copyFormat(pathFolder,FileList(ii).name,DestiFolderNew,NeedFile);
    else
%           b=strfind(FileList(i).name,'.');
%             if strcmp(FileList(i).name((b(end)+1):end),NeedFile)
%                copyFileFactor=1;
%                copyfile([pathFolder '\*.' NeedFile],DestiFolderNew);
%                copyFileFactor=0;
% 
%                continue
%             end
    end
        

end
%             if copyFileFactor==1
%                copyfile([pathFolder '\*.' NeedFile],DestiFolderNew);
%                copyFileFactor=0;
%              end

