function gscatterLU(data1,data2,group,colorMat,Marker,MarkerSize,varargin)

if nargin<7
GroupM=unique(group);
else
GroupM=varargin{1};   
end


for i=1:length(GroupM)

    if iscell(group)
       if ischar(group{1})
       Ind = arrayfun(@(k) strcmp(group{k},GroupM{i}), 1:length(group), 'UniformOutput', false);
       Ind = find(cell2mat(Ind)==1);
       end
    else
        Ind=find(group==GroupM(i));
        length(Ind);
    end
    hold on;
    scatter(data1(Ind),data2(Ind),MarkerSize,colorMat(i,:),Marker);

end
hold off;

        