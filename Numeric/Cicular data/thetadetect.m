q=input('The type of library?');
[ns_RESULT]=ns_SetLibrary(q);

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
    filename=input('file name?');
    [ns_RESULT,hFile]=ns_OpenFile(filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end

sigEntityID=[];
thetaEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
   nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   q=findstr(nsEntityLabel{EntityID},'theta_maxts');
     if ~isempty(q);   
         thetaEntityID=[thetaEntityID,EntityID];
     end  

   q=findstr(nsEntityLabel{EntityID},'sig');
     if ~isempty(q);   
        sigEntityID=[sigEntityID,EntityID];
     end  
   
   
   
   
end


[ns_RESULT,nsthetaEntityInfo]=ns_GetEntityInfo(hFile,thetaEntityID);
[ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);


StartIndex=1;
[m,sizeThetaData]=size(thetaEntityID);
[m,sizeSigData]=size(sigEntityID);

for i=1:sizeThetaData
[ns_RESULT,theta(i).Timestamps]=ns_GetNeuralData(hFile,thetaEntityID(i),StartIndex,nsthetaEntityInfo(i).ItemCount);
theta(i).ItemCount=nsthetaEntityInfo(i).ItemCount;
theta(i).Interval=diff(theta(i).Timestamps);
end

for i=1:sizeSigData
[ns_RESULT,sig(i).Timestamps]=ns_GetNeuralData(hFile,sigEntityID(i),StartIndex,nssigEntityInfo(i).ItemCount);
sig(i).ItemCount=nssigEntityInfo(i).ItemCount;
sig(i).Interval=diff(sig(i).Timestamps);
end