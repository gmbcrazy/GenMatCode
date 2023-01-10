function [y,time]=rate_histogram(path_filename,data_name,timerange,bin_width,step)
%path_filename should be a string like 'E:\experiment\lab03-04-072005006.nex'%
%timerange=[timestart;timeend]%eg.[122 533;221 466];

% [ns_RESULT]=ns_SetLibrary('D:\matlab plug in\sigTOOL\sigTOOL Neuroscience Toolkit\File\menu_Import\group_NeuroScience File Formats\nex\NeuroExplorerNeuroShareLibrary.dll');
% 
[ns_RESULT]=ns_SetLibrary('D:\matlab plug in\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(path_filename);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end

    dataEntityID=[];

    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;
   

        q=strcmp(nsEntityLabel{EntityID},data_name);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           dataEntityID=EntityID;
           break
        end  
     
     
    end

    if isempty(dataEntityID)
       'there is no corresponding data in the file'
       path_filename
       ns_RESULT = ns_CloseFile(hFile);
       y=-1;
       return;
    end
  
    [ns_RESULT,nsdataEntityInfo]=ns_GetEntityInfo(hFile,dataEntityID);

    StartIndex=1;
    bin_start=[];
    for i=1:length(timerange(1,:))
        temp_start=timerange(1,i):step:(timerange(1,i)+step*round((timerange(2,i)-timerange(1,i)-bin_width)/step));
        if length(temp_start)>round((timerange(2,i)-timerange(1,i)-bin_width)/step)
            temp_start(length(temp_start))=[];
        end
        bin_start=[bin_start;temp_start'];
        clear temp_start;
    end
    bin_over=bin_start+bin_width;

    if nsdataEntityInfo.EntityType==4
      [ns_RESULT,temp_data]=ns_GetNeuralData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);
      ns_RESULT = ns_CloseFile(hFile);
%       for i=1:length(bin_start)
%           y(i)=length(find(temp_data>=bin_start(i)&temp_data<bin_over(i)));
%       end
    y=[];
    for i=1:length(timerange(1,:))
        temp_data1=temp_data(find(temp_data>=timerange(1,i)&temp_data<=timerange(2,i)));

        temp_data1=[temp_data1;timerange(1,i);(timerange(2,i)-bin_width)];
        [temp_num,nonsense]=hist(temp_data1,length(bin_start));
        temp_num(1)=temp_num(1)-1;temp_num(length(temp_num))=temp_num(length(temp_num))-1;
        y=[y,temp_num];
        clear temp_start temp_data1 temp_num;
    end

      


%       figure;bar(bin_start+step/2,y);title(data_name);

  elseif nsdataEntityInfo.EntityType==2
%         [ns_RESULT,c,temp_data]=ns_GetAnalogData(hFile,dataEntityID,StartIndex,nsdataEntityInfo.ItemCount);

matlab_version=version;
matlab_version=str2num(matlab_version(1:3));
if matlab_version>=7
         [adfreq, n, ts, fn, d] = nex_cont2(path_filename,data_name);
else
         [adfreq, n, ts, fn, d] = nex_cont(path_filename,data_name);

end
         if length(fn)>1
            add_number=diff(ts)*adfreq-fn(1:(length(fn)-1));
         end

         for i=1:length(fn)
             if i==1
                fn_original{i}=d(1:fn(1));
            else
               fn_start=sum(fn(1:(i-1)))+1;
               fn_over=sum(fn(1:i));
               fn_original{i}=d(fn_start:fn_over);
           end
        end

        fn_new=fn_original{1};

        if length(fn)>1
           for i=1:(length(fn)-1)
               fn_new=[fn_new,(fn_original{i}(1))*ones(1,round(add_number(i))),fn_original{i+1}];

    
           end
        end

       ns_RESULT = ns_CloseFile(hFile);
       temp_data=fn_new';
       
       
       if bin_width==0.001
           
           y=temp_data(max(ceil(bin_start(1)*1000),1):min((length(bin_start)-1+max(ceil(bin_start(1)*1000),1)),length(temp_data)))';
           
       else
       
          for i=1:length(bin_start)
              y(i)=mean(temp_data(max(ceil(bin_start(i)*1000),1):floor(bin_over(i)*1000)));
          end
       end
%       figure;plot(bin_start+step/2,y);title(data_name);
       
   else
       'the data should be Timestamps or continuous LFP'
       y=[];
       ns_RESULT = ns_CloseFile(hFile);
       return
   end
    time=bin_start;
