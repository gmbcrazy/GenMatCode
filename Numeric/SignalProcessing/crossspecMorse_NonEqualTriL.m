function [Sxy,Sxx,Syy,Fre,ValidIndex]=crossspecMorse_NonEqualTriL(Data1,Data2,samprate,varargin)

%%%%Calculat cross-spectrum of trial data with equal length of duration.
%%%%Output Sxy, Sxx, Syy is 3D matrix, trial * nfft * window 

ValidIndex=1:length(Data1);



if nargin<3
% Default setting
Fband=[20;180];
WaveParam.MorseParam=[3 20 2];  %%%%[gamma beta D]
% nb=WaveParam.nb; %%%%number of scales
% WaveParam.DownSample=5; %DownSampling


% WaveParam.samprate=samprate;
% WaveParam.Freq=[1:150]; %Frequeny band interested


% Default setting
elseif nargin==4
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Fband=WaveParam.Fband;
MorseParam=WaveParam.MorseParam;
else
    
end
% samprateD=samprate/WaveParam.DownSample;
dt=1/samprate;
HIGH=max(Fband)*dt*2*pi;LOW=min(Fband)*dt*2*pi;
% imagesc(t,F,log10(abs(wu)'));
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


%%%%%%
% D=2;
% gamma=3;
% beta=20;
MorseParam=WaveParam.MorseParam;



if isfield(WaveParam,'Timerange')
Time=WaveParam.Timerange;
else
Time=[0;200000];
end



numTrial=0;
% Sxx=zeros(length(Data1),nfft,k)+nan;
% Syy=zeros(length(Data1),nfft,k)+nan;
% Sxy=zeros(length(Data1),nfft,k)+nan;
for i=1:length(Data1)
    
if isempty(Data1(i).Data)
   ValidIndex(i)=0;
   continue
end

    
% figure;
% plot(Data1(i).Data);

if isempty(Time)
   Temp1=Data1(i).Data;
   Temp2=Data2(i).Data;


else



    if Time(1)>=0
        TempTime=Data1(i).Time-Data1(i).Time(1);
    else
        TempTime=Data1(i).Time-Data1(i).Time(end);
    end

   Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
   Temp1=detrend(zscore(Data1(i).Data));
   Temp2=detrend(zscore(Data2(i).Data));
   
   Temp1=Temp1(Temp_index);
   Temp2=Temp2(Temp_index);

end

if isempty(Temp1)
   Temp1=zscore(detrend(Data1(i).Data));
   Temp2=zscore(detrend(Data2(i).Data));

end

[WCOH,temp1,temp2,temp3,Fre] = LU_MorseCoh(Temp1,Temp2,samprate,WaveParam);

if ~isempty(temp1)
   Sxy{i}=temp1';
   Sxx{i}=temp2';
   Syy{i}=temp3';
else
   ValidIndex(i)=0;

      
end

% [Sxy(i,:),Sxx(i,:),Syy(i,:),w,options] = welchCohLuTrial({Temp1(:),Temp2(:)},window,noverlap,nfft,Fs);

end
ValidIndex(ValidIndex==0)=[];



% Sxy=Sxy/numTrial;
% Sxx=Sxx/numTrial;
% Syy=Syy/numTrial;
% 
% % for itrial=1:size(Sxy)
% % [Pxy,f,xunits] = computepsd(Sxy,w,options.range,options.nfft,options.Fs,esttype);
% % [Pxx,f,units] = computepsd(Sxx,w,options.range,options.nfft,options.Fs,esttype);
% % [Pyy,f,xunits] = computepsd(Syy,w,options.range,options.nfft,options.Fs,esttype);
% % end
%  Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Cxy

function CFS = smoothCFS(CFS,flag_SMOOTH,NSW,NTW)

if ~flag_SMOOTH , return; end
if ~isempty(NTW)
    len = NTW;
    F   = ones(1,len)/len;
    CFS = conv2(CFS,F,'same');
end
if ~isempty(NSW)
    len = NSW;
    F   = ones(1,len)/len;    
    CFS = conv2(CFS,F','same');
end

% % function cfs = smoothCFS(cfs,scales,dt,ns)
% % N = size(cfs,2);
% % npad = 2.^nextpow2(N);
% % omega = 1:fix(npad/2);
% % omega = omega.*((2*pi)/npad);
% % omega = [0., omega, -omega(fix((npad-1)/2):-1:1)];
% % 
% % % Normalize scales by DT because we are not including DT in the
% % % angular frequencies here. The smoothing is done by multiplication in
% % % the Fourier domain
% % normscales = scales./dt;
% % for kk = 1:size(cfs,1)
% %     F = exp(-0.25*(normscales(kk)^2)*omega.^2);
% %     smooth = ifft(F.*fft(cfs(kk,:),npad));
% %     cfs(kk,:)=smooth(1:N);
% % end
% % % Convolve the coefficients with a moving average smoothing filter across
% % % scales
% % H = 1/ns*ones(ns,1);
% % cfs = conv2(cfs,H,'same');







