[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile('E:\experiment\temp\lab04-02-020205001-01.nex');
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end





    sigEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

        q=strcmp(nsEntityLabel{EntityID},'sig017a_wf');              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
     
     
    end
 
    
        
     
     
if isempty(sigEntityID)
    'there is no corresponding  wave or in the file'
    filename
   
   return;
end


[ns_RESULT,nsSegmentInfo]=ns_GetSegmentInfo(hFile,sigEntityID);
duration=1*1000/nsSegmentInfo.SampleRate;
[ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
[ns_RESULT,Timestamp,Data,SampleCount,UnitID]=ns_GetSegmentData(hFile,sigEntityID,1:nsEntityInfo.ItemCount);

 ns_RESULT = ns_CloseFile(hFile);