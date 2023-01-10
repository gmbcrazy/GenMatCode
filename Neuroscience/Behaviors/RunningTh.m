
function [VelocityFirst VelocityLast]=RunningTh(Velocity,Vth,Tth,adfreq)
%running period was defined speed>Vth conutinously for Tth time at least.


% Velocity=smrORnex_cont(fileName,Chan,timerange);
VelocityFirst=zeros(2,length(Velocity));
VelocityLast=zeros(2,length(Velocity));

for i=1:length(Velocity)
    if isempty(Velocity(i).Data);
       continue
    end
    Mark=zeros(1,length(Velocity(i).Data));
    temp=Velocity(i).Data;
    
    Mark(temp>=Vth)=1;
    Mark=[0 Mark(:)' 0];
    S=find(diff(Mark)==1);
    O=find(diff(Mark)==-1)-1;
    
    if isempty(S)
        'speed threshold for running is too high';
        S=1;
        O=1;
    else
    end
    ValidIndex=[S;O];

    Duration=O-S+1;
    index=find((Duration)>=(Tth*adfreq));
%     if isempty(index)
       [temp1,temp2]=max(Duration);
       
        FirstDuration=ValidIndex(:,temp2);
        LastDuration=ValidIndex(:,temp2);
%  
%     else
%         FirstDuration=ValidIndex(:,index(1));
%         LastDuration=ValidIndex(:,index(end));
%     end
    VelocityFirst(:,i)=(FirstDuration-1)/adfreq+Velocity(i).Time(1);
    VelocityLast(:,i)=(LastDuration-1)/adfreq+Velocity(i).Time(1);
end
