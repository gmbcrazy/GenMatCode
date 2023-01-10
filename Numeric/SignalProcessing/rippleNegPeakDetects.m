function  [rippleNpeakI,rippleNpeakSO,rippleRMSPeakI]=rippleNegPeakDetects(filteredRipple,RMSwindowSize,ThSDpeak,ThSDstartOver)


%%%%%detect negative peak and start and over time index for filtered
%%%%%signals filteredRipple; RMSwindowSize for window size calculating root
%%%%%mean square (RMS); mean(RMS)+ThSDpeak*std(RMS) is threshold for ripple events;
%%%%%mean(RMS)+ThSDstartOver*std(RMS) is threshold for ripple start or over;

pow=fastrms(filteredRipple,RMSwindowSize);
ave_p=mean(pow);
std_p=std(pow);

Thpeak=ThSDpeak*std_p+ave_p;
Thso=ThSDstartOver*std_p+ave_p;


len_r=length(pow);


mark_ripple=pow>Thpeak;
mark_rippleSO=pow>Thso;

rippleI=MarkToPeriod(mark_ripple);
for i=1:size(rippleI,2)
   [~,temp1]=min(filteredRipple(rippleI(1,i):rippleI(2,i)));
   rippleNpeakI(i)=rippleI(1,i)-1+temp1;
   [~,temp1]=min(pow(rippleI(1,i):rippleI(2,i)));
   rippleRMSPeakI(i)=rippleI(1,i)-1+temp1;
end

rippleSOI=MarkToPeriod(mark_rippleSO);

for i=1:length(rippleNpeakI)
    temp1=find((rippleNpeakI(i)-rippleSOI(1,:)>0)&(rippleNpeakI(i)-rippleSOI(2,:)<0));
    if ~isempty(temp1)
       rippleNpeakSO(1,i)=rippleSOI(1,temp1(1));
       rippleNpeakSO(2,i)=rippleSOI(2,temp1(1));

    else
       rippleNpeakSO(:,i)=nan;
    end
end

