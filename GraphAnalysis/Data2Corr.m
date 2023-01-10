function CorrData=Data2Corr(path,keyWord,varargin)

%%%load all the *keyward*.mat data in folder path, which could be either ROI or Vox Data (fMRI)
%%%compute the region*region correlation or Vox*Vox correlation
if nargin==3
   dataLength=varargin{1};
end


DataFile=dir([path '/*' keyWord '*.mat']);
IndexDataFile=zeros(size(DataFile));

for i=1:length(DataFile)
    load([path '/' DataFile(i).name]);
    ltemp=size(TempData,1);
    if nargin==3
    dataLength=min(ltemp,dataLength);
    else
    dataLength =ltemp;
    end
    [CorrData(:,:,i),~]=corrfMRI(TempData(1:dataLength,:));
end


