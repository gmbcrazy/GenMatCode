
function FileList=SearchFile(path,FileKeyWord)


FileList=dir([path '*' FileKeyWord]);


FileList1=dir(path);

for i=3:length(FileList1)
    if FileList1(i).isdir
       FileListTemp=SearchFile([FileList1(i).folder '\' FileList1(i).name '\'],FileKeyWord);
     
       FileList=[FileList;FileListTemp];
    end
end
