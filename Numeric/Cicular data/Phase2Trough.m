function Ts=Phase2Trough(PhaseData,SamplingRate)

len_t=length(PhaseData);
         Ts=[];
         for j=1:len_t
             if j==1&&PhaseData(j)<-3.141
                 Ts=[Ts,j];
             elseif j==len_t&&PhaseData(j)<-3.141
                 Ts=[Ts,j];
             elseif j~=1&&j~=len_t
                 if (PhaseData(j-1)-PhaseData(j))>6.0&&(PhaseData(j+1)-PhaseData(j))>0
                     Ts=[Ts,j-1+(pi-PhaseData(j-1))/((pi-PhaseData(j-1))+(pi+PhaseData(j)))];

                 end
             else
                 
             end
         end
Ts=(Ts-1)/SamplingRate;

% Ts=round(Ts);
