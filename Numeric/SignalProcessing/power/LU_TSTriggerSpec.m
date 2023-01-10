function [Spec,Fplot] = LU_TSTriggerSpec(LFP,samprate,TS,Range,varargin)

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
%Timerange: analysis period.[1 40 120;30 88 160] indicate 1-30s,
%40-88s and 120-160s for three analysis period in total;

% % Default setting
% Fband=WaveParam.Fband;  %%%frequency band for calculating wavelet
% nb=WaveParam.nb; %%%%number of scales for calculating wavelet
% WaveParam.DownSample=5; %DownSampling
% % Default setting


if nargin<5
% Default setting
Fband=[20;180];
WaveParam.MorseParam=[3 20 2];  %%%%[gamma beta D]
% nb=WaveParam.nb; %%%%number of scales
% WaveParam.DownSample=5; %DownSampling


% WaveParam.samprate=samprate;
% WaveParam.Freq=[1:150]; %Frequeny band interested
% WaveParam.Zscore=0; %default 0, raw power is calculated; ~=0, power is normalzied for each frequency respectively
%%%%%%%%%%%%%%%%%%%%%across time;
% Default setting
elseif nargin==5
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Fband=WaveParam.Fband;
SavePath=[];
SaveShow=[];

elseif nargin==6
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Fband=WaveParam.Fband;

   if isfield(Param,'SavePath')
   SavePath=Param.SavePath;
   SaveShow=Param.SaveShow;
   else
   SavePath=[];
   SaveShow=[];
   end

else
    
end
samprate=samprate/WaveParam.DownSample;
if WaveParam.DownSample>1
    LFP=downsample(LFP,WaveParam.DownSample);
end
    
    

dt=1/samprate;
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
Fre=Frad/2/pi*samprate;
elseif length(Fband)>2
Frad=morsespace(gamma,beta,HIGH,LOW,D);
numF=(length(Fband)-1);
FradStep=(Frad(1)-Frad(end))/numF;
  
Frad2=Frad(1):(-FradStep):Frad(end);
Fre2=Frad2/2/pi*samprate;
   
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
LFPOutput={};
ThetaTimeStamps=[];
SampleL=[];
if isempty(TS)
    Spec=[];
    TSstart=[];
    F=Fband;
%     Fplot=F(end:-1:1);
    Fplot=F;
    Div=[];
    
    if ~isempty(SavePath)
% %     save([SavePath SaveShow '.mat'],'sample','ThetaTS','LFPOutput','WaveParam','PhaseBin','Timerange');
    save([SavePath SaveShow '.mat'],'Spec','TSstart','WaveParam','Fplot');
    
    end
    return
end

tic
Duration=diff(Range);
NumI=round(Duration*samprate);
HalfI=round(NumI/2);
CenterI=round(TS*samprate);

Istart=CenterI-HalfI;
Iend=CenterI+HalfI;

Istart=Istart(:)';
Iend=Iend(:)';

TimerangeI=[Istart;Iend];

Istart=Istart-samprate;
Iend=Iend+samprate;



Istart(Istart<=0)=1;
Iend(Iend>length(LFP))=length(LFP);

ExI1=TimerangeI(1,:)-Istart;
ExI2=Iend-TimerangeI(2,:);
% % Invalid=[ExI1<0|ExI2<0]



%%%%%%%%ii loops      multiple theta period in one recording file
for ii=1:length(Istart)
    %%%%%%%%Inlcuding 1s before the theta start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
%     ii
    LFPtemp=LFP(Istart(ii):Iend(ii));
    LFPtemp=zscore(LFPtemp);
    Time=([1:length(LFPtemp)]-1)/samprate;
    Time=Time+(Istart(ii)-1)/samprate;

cwtS1=wavetrans(LFPtemp(:),{gamma,beta,Frad});  %%%%Jlab calculation;
% [cwtS1,Fre]=cwt(LFPtemp,fb,samprateD,'FrequencyLimits',Fband,'VoicesPerOctave',nv);
S1Power=abs(cwtS1)';

S1Power(:,end-ExI2(ii)+1:end)=[];
S1Power(:,1:ExI1(ii))=[];

LFPtemp(end-ExI2(ii)+1:end)=[];
LFPtemp(1:ExI1(ii))=[];


Time(end-ExI2(ii)+1:end)=[];
Time(1:ExI1(ii))=[];

bin_width=dt;
Fplot=Fre;
% Splot=cwtS1.scales;
% S1Power=abs(cwtS1);
% WaveParam.Zscore=1;
if WaveParam.Zscore
   S1Power=zscore(S1Power,0,2); %%%%%%%%%%%%%normalize over time
% S1Power=zscore(S1Power,0,1);  %%%%%%%%%%%%%normalize over frequency
end


% % Spec(ii).Data=S1Power;
% % Spec(ii).Time=Time;
% % Spec(ii).LFP=LFPtemp;
% % TSstart(ii)=Timerange(1,ii);
Spec.TS=TS;
Spec.LFP{ii}=LFPtemp;

if ExI1(ii)<0||ExI2(ii)<0
   Spec.Data(:,:,ii)=nan;
 
else
   Spec.Data(:,:,ii)=S1Power;
end

% thetamax_ts=round(thetamax_ts);
% % figure;
% % % plot(LFPthetatemp(:,2));hold on;plot(thetamax_ind,-pi,'r.')
% % plot(LFPthetatemp(:,1));hold on;plot(thetamax_ind,0,'r.')

% BackW=round(WaveParam.Range*samprateD);
% ForW=BackW;


end
%%%%%%%%ii loops      multiple theta period in one recording file
   

if nargout==3
   varargout{1}=TSstart;
end
   
if ~isempty(SavePath)
   save([SavePath SaveShow '.mat'],'Spec','WaveParam','Fplot');
end
toc

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



