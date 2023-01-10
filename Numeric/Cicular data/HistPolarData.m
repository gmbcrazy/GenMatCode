function [R,Rstd,xbin,Rmean]=HistPolarData(theta,Rho,cic_deg_bin)

%%%%%creat histogram data for circular data
%%%%%%%Created by Lu Zhang 4th Sept, 2017

%%%%%Output
%%%%R:Mean Vector Length in Each circular bin
%%%%Rstd:Std Vector Length in Each circular bin
%%%%xbin: Bin center in radius for each circular bin
%%%%Rmean=[angle radius] is the mean vector of all raw data
%%%%%Output

%%%%%Input
%%%%%theta: angel in rad of vector data
%%%%%Rho:Radius of vector data
%%%%%Bin width in degree
%%%%%Input

% cic_deg_bin=10;
theta=theta(:);
Rho=Rho(:);

bin_rad=abs(circ_ang2rad(cic_deg_bin));

xbin=[-pi:bin_rad:pi];

for i=1:(length(xbin)-1)
    Index=find(theta>=xbin(i)&theta<xbin(i+1));
    
    if ~isempty(Index)
    temp1=theta(Index);
    temp2=Rho(Index);
    
    t=(-1)^0.5;
    z=abs(temp2).*exp(t.*temp1);    
    R(i)=abs(nanmean(z));
% %     Rstd(i) = sqrt(2*(1-R(i)));      % 26.20
    Rstd(i) = std(z);      % 26.20
  
    
    else
    R(i)=0;
    Rstd(i)=0;
    end
   
end
xT=(xbin(1:end-1)+xbin(2:end))/2;
Rmean=circ_mean(theta,Rho);
RL=circ_r(theta,Rho);

Rmean=[Rmean RL];

xbin=[xT(:);xT(1)];
R(end+1)=R(1);
Rstd(end+1)=Rstd(1);
R=R(:);
Rstd=Rstd(:);






