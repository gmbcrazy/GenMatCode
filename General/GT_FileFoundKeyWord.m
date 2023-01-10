function tempFolder=GT_FileFoundKeyWord(Path,FolderKeyWord)

% % 
% % Path='Y:\singer\LuZhang Temp Data\Tree Track 1\';
% % FolderKeyWord='VI1_180202';
if ischar(FolderKeyWord)
ListFolder=dir([Path '*' FolderKeyWord '*']);
elseif iscell(FolderKeyWord)
    for i=1:length(FolderKeyWord)
        FolderAll{i}=dir([Path '*' FolderKeyWord{i} '*']);
    end
    
    tempFolder=FolderAll{1};
    for i=2:length(FolderAll)
        tempFolder=intersectFolder(tempFolder,FolderAll{i});
    end
    
else    
end

function a=intersectFolder(a,b)

indexN=[];
for i=1:length(a)
    for j=1:length(b)
        if strmatch(a(i).name,b(j).name)
           indexN=[indexN;i];
           break
        end
    end
end

a=a(indexN);




