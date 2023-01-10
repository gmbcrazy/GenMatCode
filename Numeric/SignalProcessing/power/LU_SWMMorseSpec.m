function [sample,ThetaTS,varargout] = LU_SWMMorseSpec(LFP,LFPtheta,thetaphase,samprate,timerange,varargin)

%%%%extract slow wave modulated(SWM) spectrum for each single slow wave circle;
%%%%spectrum is calcuated using morse wavelet based jLab toolbox;http://www.jmlilly.net/ 

%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   Extract Wavelet Spectrum for Each Single Theta Circle
%   Spectrum by Theta Phase.
%   Coded by Lu Zhang; math2437@hotmail.com
%   Last updated: (19th Dec 2019)

%Output:
%sample is the vectorized spectrum normalized in theta phase
%ThetaTS(i) is timeStamps(theta trough) of sample(:,i)


%LFP: raw LFPs
%LFPtheta: filtered LFPs in theta Band
%thetaphase: phase of filtered LFPs, usually calculated by hilbert transform;
%samprate: sampling rate;
%timerange: analysis period.[1 40 120;30 88 160] indicate 1-30s,
%40-88s and 120-160s for three analysis period in total;

% % Default setting
% Fband=WaveParam.Fband;  %%%frequency band for calculating wavelet
% nb=WaveParam.nb; %%%%number of scales for calculating wavelet
% WaveParam.DownSample=5; %DownSampling
% % Default setting


if nargin<6
% Default setting
Fband=[20;180];
WaveParam.MorseParam=[3 20 2];  %%%%[gamma beta D]
% nb=WaveParam.nb; %%%%number of scales
% WaveParam.DownSample=5; %DownSampling


% WaveParam.samprate=samprate;
% WaveParam.Freq=[1:150]; %Frequeny band interested
% WaveParam.Zscore=0; %default 0, raw power is calculated; ~=0, power is normalzied for each frequency respectively
%%%%%%%%%%%%%%%%%%%%%across time;
PhaseNum=20;
PhaseStep=2*pi/PhaseNum;
PhaseBin=-pi:PhaseStep:pi;
SavePath=[];
SaveShow=[];

% Default setting
elseif nargin==6
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Fband=WaveParam.Fband;
SavePath=[];
SaveShow=[];

PhaseNum=20;
PhaseStep=2*pi/PhaseNum;
PhaseBin=-pi:PhaseStep:pi;
elseif nargin==7
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Fband=WaveParam.Fband;

Param=varargin{2};
PhaseBin=Param.PhaseBin;
   if isfield(Param,'SavePath')
   SavePath=Param.SavePath;
   SaveShow=Param.SaveShow;
   else
   SavePath=[];
   SaveShow=[];
   end

else
    
end
samprateD=samprate/WaveParam.DownSample;
dt=1/samprateD;
HIGH=max(Fband)*dt*2*pi;LOW=min(Fband)*dt*2*pi;
% imagesc(t,F,log10(abs(wu)'));

%%%%%%
% D=2;
% gamma=3;
% beta=20;
MorseParam=WaveParam.MorseParam;



gamma=MorseParam(1);
beta=MorseParam(2);
D=MorseParam(3);
HIGH=max(Fband)*dt*2*pi;
LOW=min(Fband)*dt*2*pi;   %%%%%%frequencies in radius

if length(Fband)==2
Frad=morsespace(gamma,beta,HIGH,LOW,D);
Fre=Frad/2/pi*samprateD;
elseif length(Fband)>2
Frad=morsespace(gamma,beta,HIGH,LOW,D);
numF=(length(Fband)-1);
FradStep=(Frad(1)-Frad(end))/numF;
  
Frad2=Frad(1):(-FradStep):Frad(end);
Fre2=Frad2/2/pi*samprateD;
   
Frad=Frad2;
Fre=Fre2;
clear Frad2 Fre2

end


%%%%%%%if use mathworks wavelet toolbox

%%%%%%number of frequencies (scales) was numoctaves*nv
% numoctaves=(log2(max(Frad)/min(Frad)));
%%%%%%number of octaves is determined by max scales (frequency radius)and min scales (frequency radius)
%%%%%%This is determined by mathworks wavelet toolbox internally;

%%%%%%thus if we want similar fre reslution with Lilly's toolbox (http://www.jmlilly.net/); the nv
%%%%%%paramters should be set as following; 

% nv=round((length(Frad))/numoctaves/2)*2;   %%%it must be an even number.
% Fband=WaveParam.Fband;
% fb = cwtfilterbank('Wavelet','Morse','WaveletParameter',[gamma gamma*beta],'SamplingFrequency',samprateD,'FrequencyLimits',Fband);

%%%%%%%if use mathworks wavelet toolbox



% [psi,psif]=morsewave(SampleFre/2,gamma,beta,Frad);



% imagesc(t,F,log10(abs(wu)'));
% % % D=2;
% % % gamma=3;
% % % beta=20;


ThetaSpec={};
ThetaPhase={};
ThetaFilter={};
LFPOutput={};
ThetaTimeStamps=[];
SampleL=[];
if isempty(timerange)
    sample=[];
    ThetaTS=[];
    F=Fband;
%     Fplot=F(end:-1:1);
    Fplot=F;
    Div=[];
    
    if ~isempty(SavePath)
% %     save([SavePath SaveShow '.mat'],'sample','ThetaTS','LFPOutput','WaveParam','PhaseBin','timerange');
    save([SavePath SaveShow '.mat'],'sample','ThetaTS','LFPOutput','WaveParam','PhaseBin','Fplot','Div','timerange');
    end
    return
end

tic
Duration=round(diff(timerange));
NumThetaPeriod=length(Duration);

Istart=round(timerange(1,:)*samprate)+1;
Iend=round(timerange(2,:)*samprate)+1;
timerangeI=round(timerange*samprate)+1;

%%%%%%%%ii loops      multiple theta period in one recording file
for ii=1:length(Duration)
    %%%%%%%%Inlcuding 1s before the theta start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
    Istart(ii)=max(Istart(ii)-samprate,1);
    Iend(ii)=min(Iend(ii)+samprate,length(LFPtheta(:,1)));
    tempI=Istart(ii):Iend(ii);
    if isempty(tempI)
        continue
    end
    
    TExclude=[timerangeI(1,ii)-Istart(ii) Iend(ii)-timerangeI(2,ii)]/samprate;
    TimeInclude(:,ii)=[Istart(ii);Iend(ii)]/samprate;
    TInclude=([Istart(ii) Iend(ii)]-Istart(ii))/samprate;
    TInclude=[TInclude(1)+TExclude(1) TInclude(2)-TExclude(2)];
    
    LFPtemp=LFP(tempI);
    LFPthetatemp=LFPtheta(tempI);
    LFPphasetemp=thetaphase(tempI);

    LFPtemp=zscore(decimate(LFPtemp,WaveParam.DownSample));
    LFPthetatemp=downsample(LFPthetatemp,WaveParam.DownSample);
    LFPphasetemp=downsample(LFPphasetemp,WaveParam.DownSample);

  
% WaveParam.Fband=WaveParam.Freq;
% Fband=WaveParam.Fband;

cwtS1=wavetrans(LFPtemp(:),{gamma,beta,Frad});  %%%%Jlab calculation;
% [cwtS1,Fre]=cwt(LFPtemp,fb,samprateD,'FrequencyLimits',Fband,'VoicesPerOctave',nv);
S1Power=abs(cwtS1)';

% 

bin_width=dt;
Fplot=Fre;
% Splot=cwtS1.scales;
% S1Power=abs(cwtS1);
% WaveParam.Zscore=1;
if WaveParam.Zscore
   S1Power=zscore(S1Power,0,2); %%%%%%%%%%%%%normalize over time
% S1Power=zscore(S1Power,0,1);  %%%%%%%%%%%%%normalize over frequency
end

Time=([1:length(LFPtemp)]-1)/samprateD;

temp=LFPphasetemp;
len_t=length(temp);
         thetamax_ts=[];
         for j=1:len_t
             if j==1&&temp(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j==len_t&&temp(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j~=1&&j~=len_t
                 if (temp(j-1)-temp(j))>6.0&&(temp(j+1)-temp(j))>0
                     thetamax_ts=[thetamax_ts,j-1+(pi-temp(j-1))/((pi-temp(j-1))+(pi+temp(j)))];

                 end
             else
                 
             end
         end
thetamax_ts=(thetamax_ts-1)/samprateD;
thetamax_ts(thetamax_ts>TInclude(2))=[];
thetamax_ts(thetamax_ts<TInclude(1))=[];

thetamax_ind=round(thetamax_ts*samprateD);
% thetamax_ts=round(thetamax_ts);
% % figure;
% % % plot(LFPthetatemp(:,2));hold on;plot(thetamax_ind,-pi,'r.')
% % plot(LFPthetatemp(:,1));hold on;plot(thetamax_ind,0,'r.')

% BackW=round(WaveParam.Range*samprateD);
% ForW=BackW;

if ii==1
    tempPhase=LFPphasetemp(:);
%     tempFilteredLFP=LFPthetatemp(:);
else
    tempPhase=[tempPhase;LFPphasetemp(:)];
%     tempFilteredLFP=[tempFilteredLFP;LFPthetatemp(:)];

end

thetamax_ts=thetamax_ts+TimeInclude(1,ii);
thetamax_ts=thetamax_ts(:);
for iii=1:(length(thetamax_ind)-1)
    s=round(max(thetamax_ind(iii),1));
    o=round(min(thetamax_ind(iii+1),len_t));
    ThetaSpec{end+1,1}=S1Power(:,s:o)';
    ThetaPhase{end+1,1}=LFPphasetemp(s:o);
    LFPOutput{end+1,1}=LFPtemp(s:o);
    SampleL(end+1)=length(s:o);
    ThetaFilter{end+1,1}=LFPthetatemp(s:o);
end
ThetaTimeStamps=[ThetaTimeStamps;thetamax_ts(1:(end-1))];


end
%%%%%%%%ii loops      multiple theta period in one recording file
   
   ThetaSpecN = aveY_discretizeX(ThetaSpec,ThetaPhase,PhaseBin);    
   for i=1:length(ThetaSpecN)
       ThetaSpecNew(:,:,i)=ThetaSpecN{i};
   end
   clear ThetaSpec;
   
   ThetaTS=ThetaTimeStamps; clear ThetaTimeStamps;
   
%     WaveParam.Freq=[20:2:120];
%     Fplot=WaveParam.Freq(end:-1:1);
    Div=size(ThetaSpecNew);
    sample=reshape(ThetaSpecNew,Div(1)*Div(2),Div(3));
    Ivalid=find(sum(isnan(sample),1)>0);
    sample(:,Ivalid)=[];
    ThetaTS(Ivalid)=[];
    LFPOutput(Ivalid)=[];
    SampleL(Ivalid)=[];
    ThetaPhase(Ivalid)=[];
    ThetaFilter(Ivalid)=[];
    %%%%%%%%%%%Probability
for i=1:size(sample,2)
    sample(:,i)=sample(:,i)-min(sample(:,i));
    sample(:,i)=sample(:,i)/sum(sample(:,i))+0.00001;
    sample(:,i)=sample(:,i)/sum(sample(:,i));
end
    %%%%%%%%%%%Probability

ParamOut.LFPOutput=LFPOutput;
ParamOut.ThetaPhase=ThetaPhase;
ParamOut.ThetaFilter=ThetaFilter;

ParamOut.WaveParam=WaveParam;
ParamOut.PhaseBin=PhaseBin;
ParamOut.Phaseplot=(PhaseBin(1:end-1)+PhaseBin(2:end))/2;
% ParamOut.Splot=Splot;
ParamOut.Fplot=Fplot;
ParamOut.Div=Div;
ParamOut.timerange=timerange;
ParamOut.SampleL=SampleL;

if nargout==3
   varargout{1}=ParamOut;
end
   
if ~isempty(SavePath)
   save([SavePath SaveShow '.mat'],'sample','SampleL','ThetaTS','LFPOutput','WaveParam','PhaseBin','Fplot','Div','timerange','ThetaPhase');
end
toc
end
% % % % function CFS = smoothCFS(CFS,flag_SMOOTH,NSW,NTW)
% % % % 
% % % % if ~flag_SMOOTH , return; end
% % % % if ~isempty(NTW)
% % % %     len = NTW;
% % % %     F   = ones(1,len)/len;
% % % %     CFS = conv2(CFS,F,'same');
% % % % end
% % % % if ~isempty(NSW)
% % % %     len = NSW;
% % % %     F   = ones(1,len)/len;    
% % % %     CFS = conv2(CFS,F','same');
% % % % end

function cfs = smoothCFS(cfs,scales,dt,ns)
N = size(cfs,2);
npad = 2.^nextpow2(N);
omega = 1:fix(npad/2);
omega = omega.*((2*pi)/npad);
omega = [0., omega, -omega(fix((npad-1)/2):-1:1)];

% Normalize scales by DT because we are not including DT in the
% angular frequencies here. The smoothing is done by multiplication in
% the Fourier domain
normscales = scales./dt;
for kk = 1:size(cfs,1)
    F = exp(-0.25*(normscales(kk)^2)*omega.^2);
    smooth = ifft(F.*fft(cfs(kk,:),npad));
    cfs(kk,:)=smooth(1:N);
end
% Convolve the coefficients with a moving average smoothing filter across
% scales
H = 1/ns*ones(ns,1);
cfs = conv2(cfs,H,'same');



end