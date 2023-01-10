function Output=GT_MountainResult(filePtr)

% % filePtr='C:\Users\lzhang481\SingerLab\MoutainLab\data\cluster_metrics.json';
data = loadjson(filePtr);

for i=1:length(data.clusters)
    label(i)=data.clusters{i}.label;
    temp1(i)=data.clusters{i}.metrics;
end

Output = StructFiledMerge(temp1);
Output.label=label(:);


