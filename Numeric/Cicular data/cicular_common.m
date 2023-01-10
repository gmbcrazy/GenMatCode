function cicular_sigFile=cicular_common(path_name,sig,AD_name,timerange)


[ns_RESULT]=ns_SetLibrary('C:\MATLAB6p5\toolbox\Matlab-Import-Filter-2-4\RequiredResources\NeuroExplorerNeuroShareLibrary.dll');

if ns_RESULT==0;
[ns_RESULT,nsLibraryInfo]=ns_GetLibraryInfo;
end

if ns_RESULT==0;
   [ns_RESULT,hFile]=ns_OpenFile(path_name);
end

if ns_RESULT==0;
   [ns_RESULT,nsFileInfo]=ns_GetFileInfo(hFile);
end




    sigEntityID=[];
    ADEntityID=[];
    Ref_TSEntityID=[];
    for EntityID=1:nsFileInfo.EntityCount
        [ns_RESULT,nsEntityInfo]=ns_GetEntityInfo(hFile,EntityID);
        nsEntityLabel{EntityID}=nsEntityInfo.EntityLabel;

        q=strcmp(nsEntityLabel{EntityID},sig);              %sig should be a string like 'scsig041ats'%
        if q==1;   
           sigEntityID=EntityID;
        end  
     
        q=strcmp(nsEntityLabel{EntityID},AD_name);      %wave_normalize should be a string like 'AD15delta_ad_000'%
        if q==1;   
           ADEntityID=EntityID;
        end  
     
%         if ~isempty(AD_name,'theta'))
%            q=strcmp(nsEntityLabel{EntityID},[AD_name(1:4),'AD44theta_maxts_all']); 
%            if q==1;
%               Ref_TSEntityID=EntityID;
%            end
%         end
%         
        
     
    end

 
    if isempty(ADEntityID)|isempty(sigEntityID)
       'there is no corresponding sig or wave or wavenormalize in the file'
       path_name
       ns_RESULT = ns_CloseFile(hFile);
     cicular_sigFile.Wave_name=AD_name;
     cicular_sigFile.Sig_name=sig;
     cicular_sigFile.filename=path_name;
     
     cicular_sigFile.Timestamps=[];
     cicular_sigFile.Data=[];
     cicular_sigFile.Spike_origin=[];
     cicular_sigFile.TimeSpan=nsFileInfo.TimeSpan;
%      cicular_sigFile.RefTimestamps=[];

       return;
    end
    StartIndex=1;

    [ns_RESULT,nssigEntityInfo]=ns_GetEntityInfo(hFile,sigEntityID);
    [ns_RESULT,nsADEntityInfo]=ns_GetEntityInfo(hFile,ADEntityID);
    
    
%     if ~isempty(Ref_TSEntityID)
%        [ns_RESULT,nsRef_TSEntityInfo]=ns_GetEntityInfo(hFile,Ref_TSEntityID);
%        [ns_RESULT,Ref_Timestamps]=ns_GetNeuralData(hFile,Ref_TSEntity,StartIndex,nsRef_TSEntityInfo.ItemCount);
%      
%      temp_Ref_TS=[];
%         for i=1:length(timerange(1,:))
%             temp_Ref_TS=[temp_Ref_TS;Ref_Timestamps(find(timerange(1,i)<Ref_Timestamps&Ref_Timestamps<timerange(2,i)))];
%       
%         end
%          RefTimestamps=temp_Ref_TS;
%          clear temp_Ref_TS
%      else
%          RefTimestamps=[];
%     end
%     cicular_sigFile.RefTimestamps=RefTimestamps;
    [ns_RESULT,sigTimestamps]=ns_GetNeuralData(hFile,sigEntityID,StartIndex,nssigEntityInfo.ItemCount);

     cicular_sigFile.Wave_name=nsEntityLabel{ADEntityID};
     cicular_sigFile.Sig_name=nsEntityLabel{sigEntityID};
     cicular_sigFile.filename=path_name;
     
     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;sigTimestamps(find(timerange(1,i)<sigTimestamps&sigTimestamps<timerange(2,i)))];
     end
    sigTimestamps=temp_sig;
    
    clear temp_sig

    cicular_sigFile.Spike_origin=sigTimestamps;

%     [ns_RESULT,c,ADData]=ns_GetAnalogData(hFile,ADEntityID,StartIndex,nsADEntityInfo.ItemCount);
    
          [adfreq, n, ts, fn, d] = nex_cont(path_name,AD_name);

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

        ADData=fn_new;

    ns_RESULT = ns_CloseFile(hFile);
    
    cicular_sigFile.TimeSpan=length(ADData)/1000;
    analytic_sf=hilbert(smooth(ADData,3));
    phase_sf=angle(analytic_sf);

    
    phase_index(1,:)=floor(1000*sigTimestamps)'+1;
    phase_index(2,:)=phase_index(1,:)+1;
    invalid_index=union(find(phase_index(1,:)<1),find(phase_index(2,:)>length(phase_sf)));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    
    
%     temp_diff1=phase_sf(phase_index(2,:))-phase_sf(phase_index(1,:));
%     temp_diff2=phase_sf(phase_index(2,:))-phase_sf(phase_index(2,:)+1);
%     valid_index=find(abs(temp_diff1)>0.000001&temp_diff1<0.4);
%     valid_index=union(intersect(find(temp_diff1<-2),find(temp_diff2<0&temp_diff2>-0.1)),valid_index);
%     valid_index=union(find(temp_diff1<-2),valid_index);
% 
%     valid_index=sort(valid_index);
%     sigTimestamps=sigTimestamps(valid_index);
%     phase_index=phase_index(:,valid_index);
    

%     invalid_index=intersect(find(phase_sf(phase_index(1,:))==0),find(phase_sf(phase_index(2,:))==0));
%     sigTimestamps(invalid_index)=[];
%     phase_index(:,invalid_index)=[];
%     


    invalid_index=find(abs((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:))))<0.000001);
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
% 
%     invalid_index=find((phase_sf(phase_index(2,:))-phase_sf(phase_index(1,:)))>1);
%     sigTimestamps(invalid_index)=[];
%     phase_index(:,invalid_index)=[];
%     
%     invalid_index=find((phase_sf(phase_index(2,:))-phase_sf(phase_index(1,:)))<-1&(phase_sf(phase_index(2,:))-phase_sf(phase_index(2,:)+1))<-1);
%     sigTimestamps(invalid_index)=[];
%     phase_index(:,invalid_index)=[];
% 

    
    spike_phase=zeros(1,length(sigTimestamps))-10;
    
%     special_index=sort(intersect(find(phase_sf(phase_index(1,:))>2),find(phase_sf(phase_index(2,:))<-2)));
    special_index=sort(find((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:)))>0));
    Temp_all_index=1:length(sigTimestamps);
    ordinary_index=setdiff(Temp_all_index,special_index);


    phase_sf=phase_sf+pi;
    if ~isempty(ordinary_index)
    Temp_a=phase_sf(phase_index(2,ordinary_index))-phase_sf(phase_index(1,ordinary_index));
    Temp_b=1000*sigTimestamps(ordinary_index)'-phase_index(1,ordinary_index)+1;
    Temp_c=phase_sf(phase_index(1,ordinary_index));
    
    spike_phase(ordinary_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    end
    
    if ~isempty(special_index)
    Temp_a=phase_sf(phase_index(2,special_index))+2*pi-phase_sf(phase_index(1,special_index));
    Temp_b=1000*sigTimestamps(special_index)'-phase_index(1,special_index)+1;
    Temp_c=phase_sf(phase_index(1,special_index));
   
    spike_phase(special_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    
    
    
    
       for i=1:length(special_index)
           if spike_phase(special_index(i))>2*pi
              spike_phase(special_index(i))=spike_phase(special_index(i))-2*pi;
           end
       end
   end

   spike_phase=spike_phase-pi;
   cicular_sigFile.Timestamps=sigTimestamps;
   
   if ~isempty(sigTimestamps)
      cicular_sigFile.Data=360*(spike_phase+pi)/2/pi;
  else
      cicular_sigFile.Data=[];
   
  end


   
