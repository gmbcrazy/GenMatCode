function [CoorD2,Speed2,time2,Speed,Time]=SmoothPos1D(CoorD1,MarkNan,SampleRate,UpRate,WinSize)

%%%Smooth the 1D linear track(1 Direction, Go without Return) or 1D circular Track.

% %     MarkNan=isnan(CoorD1);
    Period=PeriodFrom01(MarkNan);
    Time=([1:length(CoorD1)]-1)/SampleRate;
    StepRe=1/UpRate;
    
    
    PeriodMax=sort(CoorD1(~isnan(CoorD1)),'descend');
    PeriodMax=mean(PeriodMax(1:5));
    
    PeriodMin=sort(CoorD1(~isnan(CoorD1)),'ascend');
    PeriodMin=mean(PeriodMin(1:5));

    PeriodL=PeriodMax;
    
    NonNanI=find(isnan(CoorD1)==0);
    TempCoorD1=CoorD1(NonNanI);
    TrialI=find(diff(TempCoorD1)>(PeriodL*4/5))+1;

    
    CoorD1Tran=CoorD1;
    for iA=1:length(TrialI)
        Ost=NonNanI(TrialI(iA));
% %         if iA<length(TrialI)
% %         Oen=NonNanI(TrialI(iA+1))-1;
% %         else
% %         Oen=length(Time);
% %         end
        CoorD1Tran(Ost:end)=CoorD1Tran(Ost:end)-PeriodL;
       
    end

%     sum(isnan(CoorD1Tran))
    MarkNan=isnan(CoorD1Tran);
    Period=PeriodFrom01(MarkNan);
    FixValue=[];
    P1=Period(1,:)-1;
    P2=Period(2,:)+1;
    l=length(MarkNan);
    
    P3=[P1;P2];
    for i=1:size(Period,2)
        FixIndex=[P1(i) P2(i)];
        FixIndex(FixIndex<=0|FixIndex>l)=[];
        CoorD1Tran(Period(1,i):Period(2,i))=CoorD1Tran(min(FixIndex));
        if length(FixIndex)==1
        CoorD1Tran(Period(1,i):Period(2,i))=CoorD1Tran(min(FixIndex));
        elseif length(FixIndex)==2
            Num=Period(2,i)-Period(1,i)+1;
            Step=diff(CoorD1Tran(FixIndex))/Num;
            CoorD1Tran(Period(1,i):Period(2,i))=CoorD1Tran(FixIndex(1))+Step*(1:Num);
        end
    end
%     plot(Time,CoorD1);hold on;
% 
%     plot(Time,CoorD1Tran);hold on;
%     plot(Time(NonNanI(TrialI)),CoorD1Tran(NonNanI(TrialI)),'r*')

    
    Speed=[0;diff(CoorD1Tran(:))./diff(Time(:))];
    time2Num=round((Time(end)-Time(1))/StepRe);  %%%re-define the sampling points with StepRe variable
    time2=Time(1):StepRe:((time2Num)*StepRe+Time(1));
    CoorD2Tran = interp1(Time,CoorD1Tran,time2);  %%%%%re-sampling
    CoorD2Tran=smooth2005(CoorD2Tran,WinSize,'rlowess'); %%%%%%smoothing
    Speed2=[0;diff(CoorD2Tran(:))./diff(time2(:))];

    AddTimePoint=Time(NonNanI(TrialI));
    
    CoorD2=CoorD2Tran;
%     plot(CoorD2);hold on
    for iA=1:length(TrialI)
        Ost(iA)=min(find((time2-AddTimePoint(iA))>=0))
        CoorD2(Ost(iA):length(CoorD2))=CoorD2(Ost(iA):length(CoorD2))+PeriodL;
    end
    CoorD2(CoorD2<0)=0;