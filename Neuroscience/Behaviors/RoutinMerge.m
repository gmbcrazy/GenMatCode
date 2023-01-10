function Routin=RoutinMerge(Routin)

TempRoutin=Routin{1};
for i=2:length(Routin)
    for ii=1:length(Routin{i})
        if ~isempty(Routin{i}(ii).Xraw)
        TempRoutin(end+1).Zone=Routin{i}(ii).Zone;
        
        if length(Routin{i}(ii).Xraw)~=length(Routin{i}(ii).Yraw)
            length(Routin{i}(ii).Xraw)
            length(Routin{i}(ii).Yraw)
            length(Routin{i}(ii).Zone)

        end

        TempRoutin(end).Xraw=Routin{i}(ii).Xraw;
        TempRoutin(end).Yraw=Routin{i}(ii).Yraw;
        end
    end
end

Routin=TempRoutin;