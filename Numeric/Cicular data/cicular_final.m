function cicular_sigFile=cicular_final(filename,timerange,waveType,sig_needed_index,wave_needed_index,wave_normalize_index,theta_normalize,normalize_range)
%filename should be a string like 'lab03-04-072005006.nex'%
%timerange=[timestart,timeend]%
%sig_needed_index is a vector.For example,if sig_needed_index=[2,4,5],it means we want to deal with the 2th,4th,5th sig%
%wave_needed_index is a vector.For example,if wave_needed_index=[2,4,5],it means we want to deal with the 2th,4th,5th wave%
%waveType should be a string like 'theta_maxts'%
%theta_normalize should be a string like 'theta_normalize'%
[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end

sigEntityID=[];
thetaEntityID=[];
thetaNormlizedEntityID=[];
for EntityID=1:nsFileInfo.EntityCount
   [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
   nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   q=findstr(nsEntityLabel{EntityID},waveType);             %waveType should be a string like 'theta_maxts'%      
     if ~isempty(q);   
         thetaEntityID=[thetaEntityID,EntityID];
     end  

   q=findstr(nsEntityLabel{EntityID},'sig');
     if ~isempty(q);   
        sigEntityID=[sigEntityID,EntityID];
     end  
     
   q=findstr(nsEntityLabel{EntityID},theta_normalize);      %theta_normalize should be a string like 'theta_normalize'%
     if ~isempty(q);   
        thetaNormlizedEntityID=[thetaNormlizedEntityID,EntityID];
     end  
     
     
 end
 

 
[ns_RESULT,nsthetaEntityInfo]=ns_GetEntityInfo(hFile,thetaEntityID);
[ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
[ns_RESULT,nsthetaNormalizeEntityInfo]=ns_GetEntityInfo(hFile,thetaNormlizedEntityID);

StartIndex=1;
sizeThetaData=length(thetaEntityID);
sizeSigData=length(sigEntityID);
sizeThetaNormalizeData=length(thetaNormlizedEntityID);
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


for i=1:sizeThetaNormalizeData
[ns_RESULT,c,ThetaNormalizeData(i).Vol]=ns_GetAnalogData(hFile,thetaNormlizedEntityID(i),StartIndex,nsthetaNormalizeEntityInfo(i).ItemCount);
ThetaNormalizeData(i).ItemCount=nsthetaNormalizeEntityInfo(i).ItemCount;
end

for i=1:length(wave_needed_index)
    for j=1:length(sig_needed_index)
        for z=1:length(wave_normalize_index)
            t=((i-1)*length(sig_needed_index)+j-1)*length(wave_normalize_index)+z;
            wave_n=theta(wave_needed_index(i)).Timestamps;
            sig_n=sig(sig_needed_index(j)).Timestamps;
            [wave_new,sig_new]=cicular_cutoutside(timerange(1),timerange(2),wave_n,sig_n);
            [cicular_sigFile(t).Data,cicular_sigFile(t).Timestamps]=cicular_num(wave_new,sig_new,ThetaNormalizeData(wave_normalize_index(z)).Vol,normalize_range);
            cicular_sigFile(t).Wave_name=nsEntityLabel{thetaEntityID(wave_needed_index(i))};
            cicular_sigFile(t).Sig_name=nsEntityLabel{sigEntityID(sig_needed_index(j))};
            cicular_sigFile(t).Wavenormalize_name=nsEntityLabel{thetaNormlizedEntityID(wave_normalize_index(z))};
            
        end
    end
end
ns_RESULT = ns_CloseFile(hFile);