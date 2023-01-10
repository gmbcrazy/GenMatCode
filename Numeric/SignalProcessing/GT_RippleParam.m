function [Output,OutputTotal] = GT_RippleParam(processeddatadir,FileIndex)
%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   
%   INPUTS: index=> [animal#,YYMMDD], session index
%           files=> 3 coloum matrix

%           Animal   Date     Session
%            4      150626       34
%            4      150626       35
%            4      150626       36
%            4      150626       37
%            4      150626       38
%            4      150626       39
%            4      150626       40
%            4      150626       41
%            4      150626       42
%           processeddatadir=> processed data directory
%           timerange=> Analysis period in seconds [5;30] refers to 5-30s 
%           samprateD=> sampling rate of the data (Hz)
%           varargin{1}  WaveParam=>wavelet parameter structure.
%           varargin{2}  SavePath=> Path to save the data.
%           varargin{3}  FigureP=>0 Plot Figure and Save.



Output=struct([]);

clear Temp2 AlignS1 Temp4 Temp5
Page=1;iPlotTemp=1;
for i = 1:size(FileIndex,1) % for each file

animaldir = [processeddatadir, 't',num2str(FileIndex(i,1)), '_', num2str(FileIndex(i,2)) , '\'];
clear eeg thetas theta LFP LFPtheta ripples
    f=FileIndex(i,3);

% load([animaldir,'eeg',num2str(f),'.mat']); %broadgamma periods start/end indices
load([animaldir,'ripples',num2str(f),'.mat']); %theta periods start/end indices
load([animaldir,'fileinfo',num2str(f),'.mat']); %theta periods start/end indices
    Infoshow{i}=['Animal-' num2str(fileinfo.Animal) ' Date-' num2str(fileinfo.Date) ' File-' ...
    num2str(f) ' Depth-' num2str(fileinfo.Depth) ' Stim-' fileinfo.Stimulation];

index=FileIndex(i,1:2);
ripples=ripples{index(1)}{index(2)}{f};

if i==1
Output=ripples;
else
    FName=fieldnames(ripples);
    for j=1:length(FName)
    Output=setfield(Output,{i},FName{j},getfield(ripples,{1},FName{j}));
    end
end
Output(i).FileInfo=fileinfo;

if isempty(ripples.startind)|length(ripples.timerange)==1
Output(i).Duration=[];
Output(i).Fre=[];
fprintf(1,['no ripples detected in File ' Infoshow{i}])
fprintf(1, '\n');
continue

else

end
RippleL=ripples.endtime-ripples.starttime;
Fre=length(ripples.endtime)/diff(ripples.timerange);

Output(i).RippleL=RippleL;
Output(i).Fre=Fre;
% Output(i).Timerange=RippleL;
end

IndexEmpty=[];
for i=1:length(Output)
    if isempty(Output(i).Fre) 
       IndexEmpty=[IndexEmpty;i];
    end
end

Output(IndexEmpty)=[];

OutputTotal = StructFiledMerge(Output);

for i=1:length(Output)
    TimeAll(i)=diff(Output(i).timerange);
end
OutputTotal.FreAll=sum(OutputTotal.Fre(:).*TimeAll(:))/sum(TimeAll);



