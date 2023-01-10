function Output=Pos2SpaPeriod(Pos,Time,SpaEdge,Speed,SpeedTh)

%%%%%%%%%Output the time period when the subject stays in each spatial bin
%%%%%%%%%defined by the edge of those spatial bin (SpaEdge).

NumBin=length(SpaEdge)-1;
CBin=discretize(Pos,SpaEdge);
SpaBin=(SpaEdge(1:end-1)+SpaEdge(2:end))/2;

    if nargin==3     %%%%%%No speed threshold is applied withut input speed and speed threshold
    Speed=zeros(size(Pos));
    SpeedTh=[-1 1];
    elseif nargin==4
    Speed=varargin{1};
    SpeedTh=varargin{2};
    else
    end
    
    l=min(length(Pos),length(Speed));
    Pos=Pos(1:l);
    Time=Time(1:l);
    Speed=Speed(1:l);
    
ValidSpeedI=(Speed>=SpeedTh(1))&(Speed<=SpeedTh(2));
 
for iSpa=1:NumBin
    Mark=(CBin==iSpa)&ValidSpeedI;         
    P1=MarkToPeriod(Mark);
    P2(1,:)=Time(P1(1,:));
    P2(2,:)=Time(P1(2,:));

    Output.Period{iSpa}=P2;
    clear P2
end
    Output.SpaEdge=SpaEdge;
    Output.SpaBin=SpaBin;
    
%%%%%%%%Checking if period at different positions overlapped or not
% figure;hold on;
% A=colormap(jet);
% step=floor(size(jet,1)/(NumBin+1));
% colorSpa=A(1:step:size(jet,1),:);
% 
% for iSpa=1:NumBin
%     P2=Output.Period{iSpa};
%     for iT=1:size(P2,2)
%         plot([P2(1,iT) P2(2,iT)],[iSpa iSpa],'o-','color',colorSpa(iSpa,:));
%     
%     end
% end
%%%%%%%%Checking if period at different positions overlapped or not
