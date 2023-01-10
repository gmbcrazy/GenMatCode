clear all;
close all;
PathFileName='F:\Lu Data\Mouse020\step3\14022014\NaviReward-M20-140214003.smr';

ArtifactHigh=0.2;    %- set high frequency artifact duration as 0.2s after the first stimuli, substiu
ArtifactLow=1;  %- set low frequency artifact duration as 1s after the first stimuli
adfreq=1000;

fid=fopen(PathFileName);
Chan=6;

[Head]=SONFileHeader(fid);
[ChanList]=SONChanList(fid);

Nex.version=104;
Nex.comment='';
Nex.freq=20000;
Nex.tbeg=0;      %- beginning of recording session (in seconds)
Nex.tend=0;      %- resording session (in seconds)
duration=0;

Nex.neurons={};
Nex.contvars={};
Nex.events={};
Nex.markers={};

Lag=0;

[StimT,header]=SONGetChannel(fid, 27,'seconds');
diffStimT=diff(StimT);

diffStimT=diff(StimT);
if isempty(find(diffStimT>0.5))
   FirstStimT(:,1)=StimT(1);
else
   index=[1;find(diffStimT>0.5)+1'];
   FirstStimT(:,1)=StimT(index);
end
ReFirstStimT=FirstStimT;
clear StimT FirstStimT index diffStimT


    [TChannel]= SONChannelInfo(fid,Chan);
    freq=TChannel.idealRate;
    [dataO,header]=SONGetChannel(fid, Chan,'seconds');
    [data,h]=SONADCToDouble(dataO,header);
    if header.start<0.0001
   TempLag=0;
else
   TempLag=header.start;
end
Lag=max([Lag TempLag]);

    
    duration=max([duration header.stop-header.start]);
    
        
%   %the artifact casued by MFB stimuli(1s data after stimuli) was set to zero for further process     
%    [RewardT RewardType]=RewardFindSMR(PathFileName);
   if ~isempty(ReFirstStimT)
      
      Index=ceil((ReFirstStimT-Lag)*freq);
      Index=Index(:);
      clear Artifact
      
      
      sf=data(:);
      Invalidsf=[];
      for ii=1:length(Index)
          Invalid{ii}=Index(ii):(Index(ii)+freq*ArtifactHigh);
          Invalid{ii}(find(Invalid{ii}>length(data)))=[];
          temp=data(Invalid{ii});
          Invalidsf=[Invalidsf Invalid{ii}];
      end
      sf(Invalidsf)=[];


      meandata=mean(sf);stddata=std(sf);
            [g,a]=ar1nv(sf);

      for ii=1:length(Index)
          if isempty(Invalid{ii})
          else
          yred=rednoise(length(Invalid{ii}),g,a);
          data(Invalid{ii})=yred(:);
%           data(Invalid{ii})= random('norm',meandata,stddata,length(Invalid{ii}),1);        

          end
      end

      invalidii=[];
      Artifact=zeros(length(Index),length(((Index(ii)+freq*ArtifactHigh)+1):(Index(ii)+freq*ArtifactLow)));
      for ii=1:length(Index)
          Invalid{ii}=(Index(ii)+freq*ArtifactHigh+1):(Index(ii)+freq*ArtifactLow);
          if isempty(Invalid{ii})
             invalidii=[invalidii ii];

          elseif max(Invalid{ii})<length(data)
             temp=data(Invalid{ii});
             Artifact(ii,:)=temp(:)';
             clear temp
          else
             Invalid{ii}(find(Invalid{ii}>length(data)))=[];
             invalidii=[invalidii ii];
          end
%           data(Invalid)=0;
      end
      Artifact(invalidii,:)=[];
      Artifact=mean(Artifact);
      for ii=1:length(Index)
          data(Invalid{ii})=data(Invalid{ii})-Artifact(1:length(Invalid{ii}))';
      end
      clear Invalid
       
   end
   [dataRaw,h]=SONADCToDouble(dataO,header);
   dataTime=((1:length(dataRaw))-1)/adfreq;
   
   
   fid=fclose(fid);
   
%    figure;
%    plot(Artifact');hold on;
%    plot(mean(Artifact),'r','linewidth',2)
   
   timerange=[204.8;206.3];
   dataIndex=find(dataTime>timerange(1)&dataTime<timerange(2));
   
   
 
   TsStart=ReFirstStimT(min(find(ReFirstStimT>timerange(1))));
   TempTime=((1:length(Artifact))-1)/adfreq+TsStart+ArtifactHigh;
   
   HighdataIndex=find(dataTime>TsStart&dataTime<=(TsStart+ArtifactHigh));

   
   figure;
   subplot('position',[0.03 0.55 0.55 0.35])
   plot(dataTime(dataIndex),dataRaw(dataIndex),'k');
   hold on;
   plot(TempTime,Artifact,'r','linewidth',2);
   set(gca,'xlim',timerange,'ylim',[-1 1],'box','off','xtick',(timerange(1):1:timerange(2)),'xticklabel',(timerange(1):1:timerange(2))-timerange(1),'ytick',[-1:1:1])
   legend('rawdata','Artifact LowFreq')
   
   subplot('position',[0.7 0.55 0.25 0.35])
   plot(dataTime(HighdataIndex),dataRaw(HighdataIndex),'k');
   hold on;
   plot(dataTime(HighdataIndex),data(HighdataIndex),'b');
   set(gca,'xlim',[TsStart TsStart+ArtifactHigh],'ylim',[-4 2],'box','off','xtick',[],'ytick',[-1:1:1])
   legend('rawdata','Red Noise AR(1) Model')
   
   subplot('position',[0.03 0.08 0.55 0.35])
   plot(dataTime(dataIndex),data(dataIndex));
   set(gca,'xlim',timerange,'ylim',[-1 1],'box','off','xtick',(timerange(1):1:timerange(2)),'xticklabel',(timerange(1):1:timerange(2))-timerange(1),'ytick',[-1:1:1])
   xlabel('Time (s)');
   legend('Artifact Remove')
   
   
   subplot('position',[0.7 0.08 0.25 0.35])

   Fs = 1000;
   h = spectrum.welch('Hann',4096,0.5);
   nfft=4096;
% h = spectrum.welch;

    hpsdraw = psd(h,dataRaw,'NFFT',nfft,'Fs',adfreq);
    hpsd = psd(h,data,'NFFT',nfft,'Fs',adfreq);

    plot(hpsdraw.Frequencies,db(hpsdraw.Data),'k');hold on;
    plot(hpsd.Frequencies,db(hpsd.Data),'b')
    set(gca,'xlim',[0 200],'box','off','xtick',[0:50:200],'ylim',[-140 -20])
   xlabel('Frequency (Hz)');
   ylabel('Power (DB)')

   
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',[0 0 24 23],'PaperSize',[24 20]);
saveas(gcf,['E:\my program\UPMC\filter\ArtifactRemoveTest\redNoise.png'],'png');
% close all

   
   
   
   
%       h = spectrum.welch('Hann',4096,0.5);
%    nfft=4096;
%     hpsd = psd(h,random('norm',0,1,20000000,1),'NFFT',nfft,'Fs',adfreq);
%     plot(hpsd.Frequencies,db(hpsd.Data),'b')
% 
   
   
   
   
   
   
   

