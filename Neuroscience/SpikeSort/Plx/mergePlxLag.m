function result=mergePlxLag(fileMerge,fileSorted,fileAll,fileIndividual,varargin)

% fileMerge='F:\Lu Data\Test\Merge1.plx';
% fileSorted='F:\Lu Data\Test\Merge1sorted.plx';
% fileAll='F:\Lu Data\Test\NaviReward-M17-31121300';
% fileIndividual=[2 3 4];

ChAll=[1 5 9];

Correct=0;
ChI=1;
ChTest=ChAll(ChI);
while Correct==0


for i=1:length(fileIndividual)
    MergedFile=[fileAll num2str(fileIndividual(i)) '.plx'];
    [n(i), ts{i}] = plx_ts(MergedFile, ChTest, 0);
    [tscounts, wfcounts, evcounts] = plx_info(MergedFile, 0);
%     [tscounts, wfcounts, evcounts, contcounts] = plx_info(MergedFile, 0);

    if n(i)==0
       ChI=ChI+1;
       ChTest=ChAll(ChI);
        break
        
    else
       Correct=1;
    end
end

if Correct==1

[n_All, ts_All] = plx_ts(fileMerge, ChTest, 0);
TemptsAll=ts_All;
% [n, names] = plx_chan_names(fileMerge)
% [n,names] = plx_adchan_names(fileMerge)
% 
% plx_ad_info(fileMerge)
% [tscounts, wfcounts, evcounts, contcounts] = plx_info(fileMerge, 0)

[adfreq, nTemp, tsStart, fn] = plx_ad_gap_info(fileMerge, 0)
    if tsStart~=-1
       l=20;
    for i=1:length(ts)
    l=min(length(ts{i}),l);
        for ii=1:l
            lag(i,ii)=ts_All(min(find((ts_All-ts{i}(ii)-tsStart(i))>=-0.0001)))-ts{i}(ii);
        end
    end

lag=lag(:,1:l);


    for i=1:length(ts)
        LagFinal(i)=-10;
        if max(abs(diff(lag(i,:))))<0.0001
           LagFinal(i)=median(lag(i,:));
        else
         'Merge Plxfiles do not match with original';
        end    
    end
    
    else
        
        for i=1:length(ts)
        LagFinal(i)=median(TemptsAll(1:n(i))-ts{i});
        TemptsAll(1:n(i))=[];
        end
    
    end
end


end



[n, names] = plx_chan_names(fileSorted);

[tscounts, wfcounts, evcounts, contcounts] = plx_info(fileSorted, 1);
wfcounts(:,1)=[];

Ch_ID=[];
TempName=names;

str_need=TempName(1,:);
for i=1:(n-1)
    if strcmp(str_need,TempName(i+1,:))
       TempName(i+1,1)='z';
    else
       str_need=TempName(i+1,:);
    end

end


for i=1:n
    if strcmp(TempName(i,1:2),'nw')
          Ch_ID=[Ch_ID;i];        
    end
end

%No sorted spikes
if length(wfcounts(:,1))==1
   ts_spike=[];
   return
end
%No sorted spikes
% clear Nex
Nex.version=104;
Nex.comment='';
Nex.freq=20000;
Nex.tbeg=0;       %- beginning of recording session (in seconds)
Nex.tend=0;     %- resording session (in seconds)
duration=0;
Nex.contvars={};
Nex.events={};
Nex.markers={};

for i=1:length(Ch_ID)
    temp=wfcounts(:,Ch_ID(i));
    l=length(temp);
    for ii=1:(l-1)    
       [n, tsSorted] = plx_ts(fileSorted, Ch_ID(i), ii);
       if n==0
       
       else
           if ii==1&&i==1
                         NewTS=split_TS(tsSorted,LagFinal);
                         if length(names(1,:))==6
                         Ch=str2num(names(Ch_ID(i),4:6));
                         elseif length(names(1,:))==5
                        Ch=str2num(names(Ch_ID(i),4:5));
                         else    
                         end
                      temp='abcdefghijklmnopqrstuvwxyz';
                     tempName=['Ch' num2str(Ch) 'Cell' num2str(ii)];
                     Nex.neurons{1,1}.name=tempName;
                     clear temp
                     Nex.neurons{end,1}.timestamps=NewTS;

           else
                         NewTS=split_TS(tsSorted,LagFinal);
                         if length(names(1,:))==6
                         Ch=str2num(names(Ch_ID(i),4:6));
                         elseif length(names(1,:))==5
                        Ch=str2num(names(Ch_ID(i),4:5));
                         else    
                         end
                      temp='abcdefghijklmnopqrstuvwxyz';
                     tempName=['Ch' num2str(Ch) 'Cell' num2str(ii)];
                     if isfield(Nex,'neurons')
                        Nex.neurons{end+1,1}.name=tempName;
                     else
                        Nex.neurons{1,1}.name=tempName;
             
                     end
                     clear temp
                     Nex.neurons{end,1}.timestamps=NewTS;
           end
           
       end
    end
end


for i=1:length(fileIndividual)
    NexNew{i}=Nex;
    for ii=1:length(Nex.neurons)
        NexNew{i}.neurons{ii}.timestamps=[];
        NexNew{i}.neurons{ii}.timestamps=Nex.neurons{ii}.timestamps{i};
%         NexNew{i}.neurons{ii}.varVersion='101';
    end
    
end
clear Nex
Nex=NexNew;

if nargin==5   %%%%%%%Nex writing path is different from Plx reading path
   fileAll=varargin{1};
end

for i=1:length(Nex)
    NexFilePath=[fileAll num2str(fileIndividual(i)) '-f.nex'];
    NexOld = readNexFile(NexFilePath);
    for ii=1:length(NexOld.contvars)
         NexOld.contvars{ii,1}.fragmentStarts=1;
    end
    if isfield(NexOld,'neurons')
        
       if iscell(NexOld.neurons)&&length(NexOld.neurons)>=1
          for ii=1:length(Nex{i}.neurons)
              NexOld.neurons{end+1}=Nex{i}.neurons{ii};
          end
       else
          NexOld.neurons=Nex{i}.neurons;
       end
    else
       NexOld.neurons=Nex{i}.neurons;
    end
    result{i}=writeNexFile(NexOld,NexFilePath);
end



function NewTS=split_TS(tsO,LagTS)

for i=length(LagTS):-1:1
    tstemp=tsO(find((tsO-LagTS(i))>=0));
    tsO=setdiff(tsO,tstemp);
    NewTS{i}=tstemp-LagTS(i); 
end














