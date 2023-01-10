function Output=waveform_read_plx_linlab(filename,sig)

[OpenedFileName, Version, Freq, Comment, Trodalness, NPW, PreTresh, SpikePeakV, SpikeADResBits, SlowPeakV, SlowADResBits, Duration, DateTime] = plx_information(filename);
[n,names] = plx_chan_names(filename);
ch=[];
for i=1:n
        if ~isempty(strfind(names(i,:),sig(4:6)))
           ch=[ch i];
           j=i+1;
           if j<=n
           if isempty(strfind(names(j,:),sig(4:6)))
              break    
           end    
           end
        end

end

if Trodalness<=1
    Trodalness=1;    
end

ch=ch(1:min(Trodalness,length(ch)));

if length(ch)==0
    error([sig ' not founded in ' filename]);
end



u=findstr(sig(7),'abcdefghijklmnopqrstuvwxyz');
if isempty(u)
    u=0;
end

for i=1:length(ch)
[n, npw, ts, wave] = plx_waves_v(filename, ch, u);
if i==1
Output.Waveform=wave;
Output.Ts=ts;
Output.Freq=Freq;
Output.NPW=NPW;
else
    Output.Waveform=[Output.Waveform wave];

end

end

Output.NPW=Output.NPW*length(ch);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%neuroshare edition
% [ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\nsPlxLibrary.dll');
% % filename='C:\gpz data\kae-tun1-dam-130-01+01.plx';
% % sig='sig001b';
% if ns_RESULT==0;
% [ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
% end
% 
% if ns_RESULT==0;
%    [ns_RESULT,hFile]=ns_OpenFile(filename);
% end
% 
% if ns_RESULT==0;
%    [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
% end
% 
%     sigEntityID=[];
%     waveformEntityID=[];
%     for EntityID=1:nsFileInfo.EntityCount
%         [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
%         nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
%         
%         q=strcmp(nsEntityLabel{EntityID},sig(1:6));              %sig should be a string like 'scsig041ats'%
%         if q==1; 
%             
%             if nsEntityInfo.EntityType==3
%                waveformEntityID=EntityID;
%            end
%         end  
% 
% 
%         q=strcmp(nsEntityLabel{EntityID},sig(1:6));              %sig should be a string like 'scsig041ats'%
%         if q==1;   
%            if nsEntityInfo.EntityType==4
%               sigEntityID=[sigEntityID;EntityID];
%            end
%         end  
%     end
%     sigEntityID=sigEntityID(findstr(sig(7),'abcdefghijklmnopqrstuvwxyz'));
%     
% [ns_RESULT,nsSegmentInfo]=ns_GetSegmentInfo(hFile,waveformEntityID);
% duration=1*1000/nsSegmentInfo.SampleRate;
% [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,waveformEntityID);
% [ns_RESULT,Timestamp,Data,SampleCount,UnitID]=ns_GetSegmentData(hFile,waveformEntityID,1:nsEntityInfo.ItemCount);
% 
%     
% 
% StartIndex=1;
% [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
% 
% [ns_RESULT,sig_temp.Timestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);
% ns_RESULT = ns_CloseFile(hFile);
% 
% waveform_need_index=[];
% for i=1:length(sig_temp.Timestamps)
%     if min(abs(sig_temp.Timestamps(i)-Timestamp))<0.00021;
%         [m,n]=min(abs(sig_temp.Timestamps(i)-Timestamp));
%         waveform_need_index=[waveform_need_index;n];
%     end
% end


% Output.Waveform=Data(:,waveform_need_index);
% Output.Ts=sig_temp.Timestamps;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%neuroshare edition



