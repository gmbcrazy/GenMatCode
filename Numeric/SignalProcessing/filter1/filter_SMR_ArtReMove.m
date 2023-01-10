function [Nex Lag]=filter_SMR_ArtReMove(PathFileName,ChanParameter,FilterParamter,NexFile)


% FilterParamter.HippDelta=1;   %%%%2-4Hz
% FilterParamter.HippTheta=1;   %%%%4-12Hz
% FilterParamter.HippBeta=1;    %%%%15-30Hz
% FilterParamter.HippGamma=1;   %%%%30-80Hz
% FilterParamter.HippRipple=1;  %%%%140-230Hz


% FilterParamter.HippDeltaOrder=1000;  
% FilterParamter.HippThetaOrder=500;   
% FilterParamter.HippBetaOrder=1;    
% FilterParamter.HippGammaOrder=1;   
% FilterParamter.HippRippleOrder=1;  

% FilterParamter.CereTheta=1;   %%%%4-12Hz
% FilterParamter.CereGamma=1;   %%%%30-80Hz


% FilterParamter.CereThetaOrder=500;   
% FilterParamter.CereGammaOrder=1;   


% ChanParameter.Hipp=[5 6 7 8];
% ChanParameter.Cere=[11 12];
% ChanParameter.Smart=[1 2 3 4];

ArtifactHigh=0.2;    %- set high frequency artifact duration as 0.2s after the first stimuli, substiu
ArtifactLow=1;  %- set low frequency artifact duration as 1s after the first stimuli


fid=fopen(PathFileName);

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






%%%%%%%%%%read and write stimuli event to new file 
[StimT,header]=SONGetChannel(fid, 27,'seconds');

if ~isempty(StimT)
diffStimT=diff(StimT);
StimIntervalIndex=find(diffStimT>0.5);
invalid=find(StimIntervalIndex<20);
StimIntervalIndex(invalid)=[];                                        %%%%%%%a train of stimulus includs more than 20 pulses
StimT(1:invalid)=[];


if isempty(StimIntervalIndex)
   FirstStimT(:,1)=StimT(1);
elseif ~isempty(StimIntervalIndex)
   index=[1;StimIntervalIndex+1'];
   FirstStimT(:,1)=StimT(index);
else  
   FirstStimT=[];
end
ReFirstStimT=FirstStimT;
clear StimT FirstStimT index diffStimT
else
FirstStimT=[];
ReFirstStimT=[];
clear StimT FirstStimT index diffStimT
end


for i=1:length(ChanParameter.Hipp)
    Chan=ChanParameter.Hipp(i);
    [TChannel]= SONChannelInfo(fid,Chan);
    freq=TChannel.idealRate;
    [dataO,header]=SONGetChannel(fid, Chan,'seconds');
    [data,h]=SONADCToDouble(dataO,header);
    data=-data;                              %%%%%%%%%%%%%%%%%%%%%Signal of NeuroLyx should be reverted
    if header.start<0.0001
   TempLag=0;
else
   TempLag=header.start;
end
Lag=max([Lag TempLag]);

    
    duration=max([duration header.stop-header.start]);
    
    
        Nex.contvars{end+1,1}.data=data;
        Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'AD'];
        Nex.contvars{end,1}.varVersion=100;
        Nex.contvars{end,1}.MVOfffset=0;
        Nex.contvars{end,1}.ADFrequency=freq;
        Nex.contvars{end,1}.timestamps=0;
        Nex.contvars{end,1}. fragmentStarts=1;
        
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

% subsitute signals during stimuli with random noise
      meandata=mean(sf);stddata=std(sf);
            [g,a]=ar1nv(sf);

      for ii=1:length(Index)
          if isempty(Invalid{ii})
          else
          yred=rednoise(length(Invalid{ii}),g,a);
          data(Invalid{ii})=yred(:);
%           data(Invalid{ii})= random('norm',meandata,stddata,length(Invalid{ii}),1);        
          %           data(Invalid{ii})= random('norm',meandata,stddata,length(Invalid{ii}),1);

          end
      end
% subsitute signals during stimuli with random noise

      clear Artifact
      invalidii=[];
      if length(Index)==1
      else
                Artifact=zeros(length(Index),length((Index(ii)+freq*ArtifactHigh):(Index(ii)+freq*ArtifactLow)));
      for ii=1:length(Index)
          Invalid{ii}=(Index(ii)+freq*ArtifactHigh):(Index(ii)+freq*ArtifactLow);
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
       
   end
   
       
        Nex.contvars{end+1,1}.data=data;
        Nex.contvars{end,1}.name=['ReHippCh' num2str(Chan) 'AD'];
        Nex.contvars{end,1}.varVersion=100;
        Nex.contvars{end,1}.MVOfffset=0;
        Nex.contvars{end,1}.ADFrequency=freq;
        Nex.contvars{end,1}.timestamps=0;
        Nex.contvars{end,1}. fragmentStarts=1;

%   %the artifact casued by MFB stimuli(1s data after stimuli) was set to zero for further process     

    if FilterParamter.HippDelta       %filter data in delta band
       Nex.contvars{end+1,1}.data=FilterDelta(data,freq,FilterParamter.HippDeltaOrder)';
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'Delta'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;
    end                          %filter data in delta band
    

    
    if FilterParamter.HippTheta      %filter data in theta band
        
       [sf,thetamax_ts_all]=FilterTheta(data,freq,FilterParamter.HippThetaOrder);
       [sf_theta,thetamaxts_ts,norm_tsf,norm_phase_sf]=ThetaNormalize(data,freq);

       Nex.contvars{end+1,1}.data=sf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'Theta'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_tsf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'ThetaN'];  
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_phase_sf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'PhaseN'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'theta_maxts_all'];
       Nex.neurons{end,1}.timestamps=thetamax_ts_all';
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'theta_maxts_f'];
       Nex.neurons{end,1}.timestamps=thetamaxts_ts';
    end                   %filter data in theta band
%     

    if FilterParamter.HippBeta       %filter data in beta band
       Nex.contvars{end+1,1}.data=FilterBeta(data,freq,FilterParamter.HippBetaOrder)';
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'Delta'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;
    end                          %filter data in beta band

    
    if FilterParamter.HippGamma     %filter data in gamma band

       [sf,RMS_gamma,norm_gsf,gammamax_ts]=FilterGamma(data,freq,FilterParamter.HippGammaOrder);
       
       
       Nex.contvars{end+1,1}.data=sf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'Gamma'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_gsf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'GammaN'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=RMS_gamma(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'GammaRMS'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;
       
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'gamma_maxts'];
       Nex.neurons{end,1}.timestamps=gammamax_ts';
    end                    %filter data in gamma band
    
    
    
    
    
        if FilterParamter.HippRipple     %filter data in ripple band

       [sf,RMS_ripple,norm_rsf,ripplemax_ts,ripplemax_ts_p,ripplestart_ts,rippleover_ts]=FilterRipple(data,freq,FilterParamter.HippRippleOrder);
       
       
       Nex.contvars{end+1,1}.data=sf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'Ripple'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_rsf(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'RippleN'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=RMS_ripple(:);
       Nex.contvars{end,1}.name=['HippCh' num2str(Chan) 'RippleRMS'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;
       
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'ripple_maxts'];
       Nex.neurons{end,1}.timestamps=ripplemax_ts';
       
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'ripple_maxts_p'];
       Nex.neurons{end,1}.timestamps=ripplemax_ts_p';

       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'ripple_start'];
       Nex.neurons{end,1}.timestamps=ripplestart_ts';

       
       Nex.neurons{end+1,1}.name=['HippCh' num2str(Chan) 'ripple_end'];
       Nex.neurons{end,1}.timestamps=rippleover_ts';

    end                    %filter data in ripple band

    
end


for i=1:length(ChanParameter.Cere)
    Chan=ChanParameter.Cere(i);
    [TChannel]= SONChannelInfo(fid,Chan);
    freq=TChannel.idealRate;
    [dataO,header]=SONGetChannel(fid, Chan,'seconds');
    [data,h]=SONADCToDouble(dataO,header);
    data=-data;                              %%%%%%%%%%%%%%%%%%%%%Signal of NeuroLyx should be reverted

    if freq==20000
       lowf=600;
       highf=0;
       [CereSpike,filtwts] = eegfilt(data(:)',freq,lowf,highf,0,100,0);
        Nex.contvars{end+1,1}.data=CereSpike(:);
        Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'Spike'];
        Nex.contvars{end,1}.varVersion=100;
        Nex.contvars{end,1}.MVOfffset=0;
        Nex.contvars{end,1}.ADFrequency=freq;
        Nex.contvars{end,1}.timestamps=0;
        Nex.contvars{end,1}. fragmentStarts=1;
        
       lowf=0;
       highf=475;
       [data,filtwts] = eegfilt(data(:)',freq,lowf,highf,0);
       data=downsample(data,20);
       data=data(:);

    end
    
    data=data(:);
    
if header.start<0.0001
   TempLag=0;
else
   TempLag=header.start;
end
Lag=max([Lag TempLag]);

       freq=1000;


    duration=max([duration header.stop-header.start]);
    
    
        Nex.contvars{end+1,1}.data=data;
        Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'AD'];
        Nex.contvars{end,1}.varVersion=100;
        Nex.contvars{end,1}.MVOfffset=0;
        Nex.contvars{end,1}.ADFrequency=freq;
        Nex.contvars{end,1}.timestamps=0;
        Nex.contvars{end,1}. fragmentStarts=1;
        
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

% subsitute signals during stimuli with random noise
      meandata=mean(sf);stddata=std(sf);
            [g,a]=ar1nv(sf);
      for ii=1:length(Index)
          if isempty(Invalid{ii})
          else
          yred=rednoise(length(Invalid{ii}),g,a);
          data(Invalid{ii})=yred(:);
%           data(Invalid{ii})= random('norm',meandata,stddata,length(Invalid{ii}),1);        
          %           data(Invalid{ii})= random('norm',meandata,stddata,length(Invalid{ii}),1);

          end
      end
% subsitute signals during stimuli with random noise

      clear Artifact
      invalidii=[];
      if length(Index)==1
      else
                Artifact=zeros(length(Index),length((Index(ii)+freq*ArtifactHigh):(Index(ii)+freq*ArtifactLow)));
      for ii=1:length(Index)
          Invalid{ii}=(Index(ii)+freq*ArtifactHigh):(Index(ii)+freq*ArtifactLow);
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
       
   end
   
       
        Nex.contvars{end+1,1}.data=data;
        Nex.contvars{end,1}.name=['ReCereCh' num2str(Chan) 'AD'];
        Nex.contvars{end,1}.varVersion=100;
        Nex.contvars{end,1}.MVOfffset=0;
        Nex.contvars{end,1}.ADFrequency=freq;
        Nex.contvars{end,1}.timestamps=0;
        Nex.contvars{end,1}. fragmentStarts=1;

%   %the artifact casued by MFB stimuli(1s data after stimuli) was set to zero for further process     
    
    if FilterParamter.CereTheta      %filter data in theta band
        
       [sf,thetamax_ts_all]=FilterTheta(data,freq,FilterParamter.CereThetaOrder);
       [sf_theta,thetamaxts_ts,norm_tsf,norm_phase_sf]=ThetaNormalize(data,freq);

       Nex.contvars{end+1,1}.data=sf(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'Theta'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_tsf(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'ThetaN'];  
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_phase_sf(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'PhaseN'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       
       Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'theta_maxts_all'];
       Nex.neurons{end,1}.timestamps=thetamax_ts_all';
       Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'theta_maxts_f'];
       Nex.neurons{end,1}.timestamps=thetamaxts_ts';
    end                   %filter data in theta band
%     
    
    if FilterParamter.CereGamma     %filter data in gamma band

       [sf,RMS_gamma,norm_gsf,gammamax_ts]=FilterGamma(data,freq,FilterParamter.CereGammaOrder);
       
       
       Nex.contvars{end+1,1}.data=sf(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'Gamma'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=norm_gsf(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'GammaN'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;

       Nex.contvars{end+1,1}.data=RMS_gamma(:);
       Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'GammaRMS'];
       Nex.contvars{end,1}.varVersion=100;
       Nex.contvars{end,1}.MVOfffset=0;
       Nex.contvars{end,1}.ADFrequency=freq;
       Nex.contvars{end,1}.timestamps=0;
       Nex.contvars{end,1}. fragmentStarts=1;
       
       Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'gamma_maxts'];
       Nex.neurons{end,1}.timestamps=gammamax_ts';
    end                    %filter data in gamma band
    
    
    
    
    
%         if FilterParamter.CereRipple     %filter data in ripple band
% 
%        [sf,RMS_ripple,norm_rsf,ripplemax_ts,ripplemax_ts_p,ripplestart_ts,rippleover_ts]=FilterRipple(data,freq,FilterParamter.CereRippleOrder);
%        
%        
%        Nex.contvars{end+1,1}.data=sf(:);
%        Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'Ripple'];
%        Nex.contvars{end,1}.varVersion=100;
%        Nex.contvars{end,1}.MVOfffset=0;
%        Nex.contvars{end,1}.ADFrequency=freq;
%        Nex.contvars{end,1}.timestamps=0;
%        Nex.contvars{end,1}. fragmentStarts=1;
% 
%        Nex.contvars{end+1,1}.data=norm_rsf(:);
%        Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'RippleN'];
%        Nex.contvars{end,1}.varVersion=100;
%        Nex.contvars{end,1}.MVOfffset=0;
%        Nex.contvars{end,1}.ADFrequency=freq;
%        Nex.contvars{end,1}.timestamps=0;
%        Nex.contvars{end,1}. fragmentStarts=1;
% 
%        Nex.contvars{end+1,1}.data=RMS_ripple(:);
%        Nex.contvars{end,1}.name=['CereCh' num2str(Chan) 'RippleRMS'];
%        Nex.contvars{end,1}.varVersion=100;
%        Nex.contvars{end,1}.MVOfffset=0;
%        Nex.contvars{end,1}.ADFrequency=freq;
%        Nex.contvars{end,1}.timestamps=0;
%        Nex.contvars{end,1}. fragmentStarts=1;
%        
%        Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'ripple_maxts'];
%        Nex.neurons{end,1}.timestamps=ripplemax_ts';
%        
%        Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'ripple_maxts_p'];
%        Nex.neurons{end,1}.timestamps=ripplemax_ts_p';
% 
%        Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'ripple_start'];
%        Nex.neurons{end,1}.timestamps=ripplestart_ts';
% 
%        
%        Nex.neurons{end+1,1}.name=['CereCh' num2str(Chan) 'ripple_end'];
%        Nex.neurons{end,1}.timestamps=rippleover_ts';
% 
%     end                    %filter data in ripple band

    
end








%%%%%%%%%%read and write stimuli event to new file 
[StimT,header]=SONGetChannel(fid, 27,'seconds');

if ~isempty(StimT)
diffStimT=diff(StimT);
StimIntervalIndex=find(diffStimT>0.5);
invalid=find(StimIntervalIndex<20);
StimIntervalIndex(invalid)=[];                                        %%%%%%%a train of stimulus includs more than 20 pulses
StimT(1:invalid)=[];


if isempty(StimIntervalIndex)
   FirstStimT(:,1)=StimT(1);
elseif ~isempty(StimIntervalIndex)
   index=[1;StimIntervalIndex+1'];
   FirstStimT(:,1)=StimT(index);
else  
   FirstStimT=[];
end
ReFirstStimT=FirstStimT;
clear FirstStimT index diffStimT
else
FirstStimT=[];
ReFirstStimT=[];
clear FirstStimT index diffStimT
end


if isempty(StimT)
   RewardT=[];
   RewardType=[];
   Nex.markers{end+1,1}.name='FirstStim';
   Nex.markers{end,1}.varVersion=100;
   Nex.markers{end,1}.timestamps=-1;
   Nex.markers{end,1}.values{1,1}.name='Mark1';
   Nex.markers{end,1}.values{1,1}.strings{1,1}=num2str(-1);

   Nex.events{end+1,1}.varVersion=100;
   Nex.events{end,1}.name='NaviRewardTs';
   Nex.events{end,1}.timestamps=-1;

Nex.events{end+1,1}.varVersion=100;
Nex.events{end,1}.name='ForageRewardTs';
Nex.events{end,1}.timestamps=-1;

else
    diffStimT=diff(StimT);
StimT=StimT-Lag;
Nex.events{end+1,1}.varVersion=100;
Nex.events{end,1}.name='StimTs';
Nex.events{end,1}.timestamps=StimT;



diffStimT=diff(StimT);
if isempty(find(diffStimT>0.5))
   FirstStimT(:,1)=StimT(1);
   RewardType=[];
else
   index=[1;find(diffStimT>0.5)+1'];
   FirstStimT(:,1)=StimT(index);

%    return
end

Nex.markers{end+1,1}.name='FirstStim';
Nex.markers{end,1}.varVersion=100;

[Temp,h]=SONGetMarkerChannel(fid, 32, 'seconds');
RewardMarkT=Temp.timings;
RewardMark=Temp.markers;


RewardT=FirstStimT;
RewardMark=double(RewardMark(:,1));
if length(RewardT)==length(RewardMark)
   RewardType=RewardMark;
else
    
   index=find(RewardMark~=2&RewardMark~=1);
   
   if isempty(index)
       
      index=find(RewardMark==2|RewardMark==1);
      if ~isempty(index)
         if index(end)<length(RewardMark)
            RewardT(end)=[];
            RewardMark(end)=[];      
         end
      end
   RewardType(:,1)=RewardMark(RewardMark==1|RewardMark==2);
%    l=length(RewardType(:,1));
%    index=find(RewardMark==2|RewardMark==1);
%    RewardType(:,2)=RewardMark(index(1:l));
   else
      if RewardMark(1)==1||RewardMark(1)==2
         RewardMark=[0;RewardMark];
         index=find(RewardMark==2|RewardMark==1);
      end

         if (index(end)+1)<length(RewardMark)
            RewardT(end)=[];
            RewardMark(end)=[];      
         end
         index1=find(RewardMark~=2&RewardMark~=1);
         index2=find(RewardMark==2|RewardMark==1);
         if length(index1)<length(index2)
            invalid=find(diff(index2)==1)+1;
            RewardT(invalid)=[];
         end
         
   RewardType(:,1)=RewardMark(RewardMark~=2&RewardMark~=1);
%    l=length(RewardType(:,1));
%    index=find(RewardMark~=1&RewardMark~=2);
%    RewardType(:,2)=RewardMark(index(1:l));


   end
   

%    index=find(RewardMark==2|RewardMark==1);

 
end



% ans = 
% 
%        name: 'Mark1'
%     strings: {18x1 cell}

Nex.markers{end,1}.timestamps=RewardT;
Nex.markers{end,1}.values{1,1}.name='Mark1';
for i=1:length(RewardT)
    Nex.markers{end,1}.values{1,1}.strings{i,1}=num2str(RewardType(i,1));
end


%%%%%%%%%%read and write stimuli event to new file 

%%%%%%%%%% write stimuli event to new file 
index=find(RewardType==1|RewardType==3);
Nex.events{end+1,1}.varVersion=100;
Nex.events{end,1}.name='NaviRewardTs';
Nex.events{end,1}.timestamps=RewardT(index);

index=find(RewardType==2|RewardType==4|RewardType==5|RewardType==6);
Nex.events{end+1,1}.varVersion=100;
Nex.events{end,1}.name='ForageRewardTs';
Nex.events{end,1}.timestamps=RewardT(index);
%%%%%%%%%% write stimuli event to new file 

    
end










%%%%%%%%%%read out TTL from the smart and rewrite the timestamps to new Nex file 
ChanParameter.Smart=[1 2 3 4];
clear Chan
ZoneTriT=[];
ZoneTri=[];
for ii=1:length(ChanParameter.Smart)
 Chan=ChanParameter.Smart(ii);
[TChannel]= SONChannelInfo(fid,Chan);
[data,header]=SONGetChannel(fid, Chan,'seconds');
[data,h]=SONADCToDouble(data,header);
diff_data=diff([0;data;0]);
TriggerT=(find(diff_data>4))/TChannel.idealRate+header.start;
ZoneTriT=[ZoneTriT;TriggerT(:)];
ZoneTri=[ZoneTri;zeros(size(TriggerT(:)))+Chan];
end

ZoneTriT=ZoneTriT-Lag;
[ZoneTriT sortIndex]=sort(ZoneTriT);
ZoneTriT(find(ZoneTriT<0&ZoneTriT>-0.001))=0;
ZoneTri=num2str(ZoneTri(sortIndex));

Nex.markers{end+1,1}.name='TTLSmart';
Nex.markers{end,1}.varVersion=100;
Nex.markers{end,1}.timestamps=ZoneTriT;
Nex.markers{end,1}.values{1,1}.name='Chan';
for i=1:length(ZoneTriT)
    Nex.markers{end,1}.values{1,1}.strings{i,1}=ZoneTri(i);
end


%%%%%%%%%%read out TTL from the smart and rewrite the timestamps to new Nex file 












fid=fclose(fid);



Nex.tend=duration;     %- resording session (in seconds)
writeNexFile(Nex,NexFile);



