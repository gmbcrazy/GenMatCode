function AllData=rowAddingPower(AllData,SingleData,varargin)


if nargin==3   %%%%%%%%%%%%%%%using varargin{1} to substitute SingleData when SingleData is [].
   Sub=varargin{1};
else
   Sub=[];
end

%%%%Adding single Data as a new row of AllData
[m,n]=size(AllData);


if isempty(AllData)
   a=0;    %%%%set SingleData as All Data
elseif m==1   
   if sum(abs(AllData))==0
      a=1; %%%%set SingleData as All Data
   else
      a=1;
   end
else
   a=1;    %%%%set SingleData as new row of All Data
    
end

switch a
    case 0
    
        if isempty(SingleData)
           AllData=SingleData;
           if ~isempty(Sub)
               AllData=Sub(:)';
               
           end

        else
           AllData=SingleData(:)';
        end 
    case 1
        if isempty(SingleData)
           AllData=AllData;
           if ~isempty(Sub)
               AllData(end+1,:)=Sub(:)';
           end
        else
           AllData(end+1,:)=SingleData(:)';
        end 
        
end