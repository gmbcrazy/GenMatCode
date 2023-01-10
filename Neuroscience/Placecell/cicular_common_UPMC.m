function cicular_sigFile=cicular_common_UPMC(path_name,sig,AD_name,timerange)


if iscell(sig)
    Spikes=[];
    for i=1:length(sig)
    [n, Spikestemp] = nex_ts2(path_name, sig{i});
     Spikes=[Spikes;Spikestemp(:)];
    
    end
    Spikes=sort(Spikes);
    n=length(Spikes);
elseif ischar(sig)
[n, Spikes] = nex_ts2(path_name, sig);
else
    Spikes=sig;
end


Spikes=Spikes(:);
     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;Spikes(timerange(1,i)<Spikes&Spikes<timerange(2,i))];
     end
Spikes=temp_sig;







[nvar, names, types] = nex_info2(path_name);
names=cellstr(names);

AD_type=[];
for i=1:nvar
    AD_ref=strcmp(names{i},AD_name);
% % % % %     if temp_data==1
% % % % %        data_type=types(i);
% % % % %     end
    if AD_ref==1
       AD_type=types(i);
    end
end

if isempty(AD_type);
       'there is no corresponding sig or wave or wavenormalize in the file'
       path_name
     cicular_sigFile.Wave_name=AD_name;
     cicular_sigFile.Sig_name=sig;
     cicular_sigFile.path_name=path_name;
     
     cicular_sigFile.Timestamps=[];
     cicular_sigFile.Data=[];
     cicular_sigFile.Spike_origin=[];
     cicular_sigFile.TimeSpan=timerange;
     cicular_sigFile.RefTimestamps=[];

       return;

end

Ref_Timestamps=[];
for i=1:nvar
    if sum(findstr(AD_name,'theta'))~=0
       temp_data=strcmp(names{i},[AD_name(1:4),'theta_maxts_all']);
       if temp_data==1
          [n, Ref_Timestamps]=nex_ts(path_name,[AD_name(1:4),'theta_maxts_all']);
       end
   elseif sum(findstr(AD_name,'gamma'))~=0
          temp_data=strcmp(names{i},[AD_name(1:4),'gamma_maxts']);
       if temp_data==1
          [n, Ref_Timestamps]=nex_ts(path_name,[AD_name(1:4),'gamma_maxts']);
       end
   else
       
   end
end



 
 
    if ~isempty(Ref_Timestamps)
     temp_Ref_TS=[];
        for i=1:length(timerange(1,:))
            temp_Ref_TS=[temp_Ref_TS Ref_Timestamps(find(timerange(1,i)<Ref_Timestamps&Ref_Timestamps<timerange(2,i)))];
      
        end
         RefTimestamps=temp_Ref_TS;
         clear temp_Ref_TS
     else
         RefTimestamps=[];
    end
     cicular_sigFile.Wave_name=AD_name;
     cicular_sigFile.Sig_name=sig;
     cicular_sigFile.path_name=path_name;
     cicular_sigFile.RefTimestamps=RefTimestamps';

% % %      [n, sigTimestamps]=nex_ts(path_name,sig);
% % %      temp_sig=[];
% % %      for i=1:length(timerange(1,:))
% % %          temp_sig=[temp_sig;sigTimestamps(find(timerange(1,i)<sigTimestamps&sigTimestamps<timerange(2,i)))'];
% % %      end
    sigTimestamps=Spikes(:);
    
    clear temp_sig

    cicular_sigFile.Spike_origin=sigTimestamps;

    [adfreq, n, ts, fn, ADData] = nex_cont(path_name,AD_name);

    cicular_sigFile.TimeSpan=length(ADData)/1000;
    analytic_sf=hilbert(smooth(ADData,3));
    phase_sf=angle(analytic_sf);
    phase_sf=phase_sf(:);
    analytic_sf=analytic_sf(:);
    
    phase_index(1,:)=floor(1000*sigTimestamps')+1;
    phase_index(2,:)=phase_index(1,:)+1;
    invalid_index=union(find(phase_index(1,:)<1),find(phase_index(2,:)>length(phase_sf)));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    
%     


    invalid_index=find(abs((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:))))<0.000001);
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
% 
    
    spike_phase=zeros(1,length(sigTimestamps))-10;
    
%     special_index=sort(intersect(find(phase_sf(phase_index(1,:))>2),find(phase_sf(phase_index(2,:))<-2)));
    special_index=sort(find((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:)))>0));
    Temp_all_index=1:length(sigTimestamps);
    ordinary_index=setdiff(Temp_all_index,special_index);


    phase_sf=phase_sf+pi;
    if ~isempty(ordinary_index)
    Temp_a=phase_sf(phase_index(2,ordinary_index))-phase_sf(phase_index(1,ordinary_index));
    Temp_b=1000*sigTimestamps(ordinary_index)-phase_index(1,ordinary_index)'+1;
    Temp_c=phase_sf(phase_index(1,ordinary_index));
    
    Temp_a=Temp_a(:);
    Temp_b=Temp_b(:);
    Temp_c=Temp_c(:);

    spike_phase(ordinary_index)=Temp_a.*Temp_b+Temp_c;
    clear Temp_a Temp_b Temp_c
    end
    
    if ~isempty(special_index)
    Temp_a=phase_sf(phase_index(2,special_index))+2*pi-phase_sf(phase_index(1,special_index));
    Temp_b=1000*sigTimestamps(special_index)-phase_index(1,special_index)'+1;
    Temp_c=phase_sf(phase_index(1,special_index));
   
    Temp_a=Temp_a(:);
    Temp_b=Temp_b(:);
    Temp_c=Temp_c(:);

    spike_phase(special_index)=Temp_a.*Temp_b+Temp_c;
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


   
