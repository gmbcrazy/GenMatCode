function Output=PhasePrecessionPlot_MergeTrial(TrialData,BinNum,PlaceFieldIX,PlotMode,SpaBin,LinearCirParam,NormParam)

%%%%%%%Calculate Phase Precession for ignore the running direction

%%%%%%%TrialDataPos(i).Pos: Spike Position of the ith trial, if position is circular data, must be degree (0-360)
%%%%%%%TrialDataPos(i).Phase: Spike Phase of the ith trial

%%%%%%%PosInt: Interval of PlaceField Start and End
%%%%%%%PlotMode: 0 for no plot; 1 for scatter plot;2 for density plot;3 for both combined
%%%%%%%LinearCirParam: 0 for linear position; 1 for circular position;
%%%%%%%NormParam: 0 for raw position for place field; 1 for normalized place field: starting with 0 end with 1;

if isempty(PlaceFieldIX)
    Output.a=nan;
    Output.b=nan;
    Output.rho=nan;
    Output.pval=nan;
%     disp('no place field is detected');
    return
    
else
    SpaStart=SpaBin(1:end-1);
    SpaEnd=SpaBin(2:end);
    SpaCenter=(SpaStart+SpaEnd)/2;
    for iField=1:length(PlaceFieldIX)
        
        
        Mark=zeros(1,length(SpaBin)-1);
        Mark(PlaceFieldIX(iField).PeakIX)=1;
        FieldTemp=MarkToPeriod(Mark);
        
        ReverseParam=min(diff(sort(PlaceFieldIX(iField).PeakIX))); 
        if size(FieldTemp,2)==2    %%%%%%%%%Place field begin at late circular position and end at early circular position
           PosIntAll{iField}(1)=max(SpaStart(FieldTemp(1,2)));  %%%%%%%Beginning of the 2nd Tempfield
           PosIntAll{iField}(2)=min(SpaEnd(FieldTemp(2,1)));  %%%%%%%%%%%%%End of the 1st Tempfield
        elseif size(FieldTemp,2)==1                %%%%%%%%%Place field begin at early circular position and end at late circular position
           PosIntAll{iField}(1)=max(SpaStart(FieldTemp(1,1)));  %%%%%%%Beginning of the Tempfield
           PosIntAll{iField}(2)=min(SpaEnd(FieldTemp(2,1)));  %%%%%%%%%%%%%End of the Tempfield
        else
           PosIntAll{iField}=[];
           disp('no place field');
           
        end
        
        
    end
end
    
Pos=[];
Phase=[];
for iTrial=1:length(TrialData)
    Pos=[Pos;TrialData(iTrial).Pos];
    Phase=[Phase;TrialData(iTrial).Phase];
end


% PlotMode=0;
for iField=1:length(PlaceFieldIX)
%     figure;
    Output(iField)=PhasePrecessionPlot(Pos,Phase,BinNum,PosIntAll{iField},PlotMode,LinearCirParam,NormParam);
end

