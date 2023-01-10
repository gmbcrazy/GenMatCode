function cicular_sigFile=cicular_filter(path_filename,sig,AD,timerange,ref,ref_range,fre)

[n, ref] = nex_ts(path_filename,ref);

[y,time]=rate_histogram(path_filename,sig,[0;1800],1/fre,1/fre);

[b,a]=ellip(5,3,50,12/fre*2);
temp_sf=filtfilt(b,a,y);
[b,a]=ellip(5,3,50,4/fre*2,'high');
sf=filtfilt(b,a,temp_sf);% theta-based filter
sf=zscore(sf);
% clear y temp_sf
			thetamax_ts = [];
			max_theta = max(sf);
			threshold = 1;
			
			len_theta = length(sf);
			
			flag_over = 0;
			flag1 = 0;
			flag2 = 0;
			
			for i=1:len_theta
                
                if ~flag_over & (sf(i) > threshold)
                    flag_over = 1;
                    flag1 = 1;
                    p_start = i;
                end
                if flag_over & (sf(i) < threshold)
                    flag_over = 0;
                    flag2 = 1;
                    p_end = i;
                end
                if flag1 & flag2
                    [ad_max,p_max] = max(sf(p_start:p_end));
                    thetamax_ts=[thetamax_ts,p_max+p_start-1];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
            
       sigTimestamps=0.001*(thetamax_ts-1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%thetamax_ts is the thetamax_ts-th time point of AD-type variable,but the time points should be thetamax_ts-1

            
     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;sigTimestamps(find(timerange(1,i)<sigTimestamps&sigTimestamps<timerange(2,i)))];
     end
     sigTimestamps=temp_sig;
     
    
    
    need_index=[];
for i=1:length(ref)
    ref_temp=ref(i)+ref_range;
    need_index=union(need_index,find(ref_temp(1)<=sigTimestamps&sigTimestamps<=ref_temp(2)));
end

sigTimestamps=sigTimestamps(need_index);


[n, ts_sig] = nex_ts(path_filename,sig);

     test_range=[-0.04;0.04]
     for i=1:length(sigTimestamps)
         temp_test=sigTimestamps(i)+test_range;
         test_index=find(ts_sig>=temp_test(1)&ts_sig<=temp_test(2));
         if isempty(test_index)
             sigTimestamps(i)=-1;
         end
     end
     sigTimestamps(find(sigTimestamps==-1))=[];
     



    [adfreq, n, ts, fn, ADData] = nex_cont(path_filename,AD);



    cicular_sigFile.TimeSpan=length(ADData)/1000;
    analytic_sf=hilbert(smooth(ADData,3));
    phase_sf=angle(analytic_sf);

    
    phase_index(1,:)=floor(1000*sigTimestamps)+1;
    phase_index(2,:)=phase_index(1,:)+1;
    invalid_index=union(find(phase_index(1,:)<1),find(phase_index(2,:)>length(phase_sf)));
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    

    invalid_index=find(abs((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:))))<0.000001);
    sigTimestamps(invalid_index)=[];
    phase_index(:,invalid_index)=[];
    
    spike_phase=zeros(1,length(sigTimestamps))-10;
    
    special_index=sort(find((phase_sf(phase_index(1,:))-phase_sf(phase_index(2,:)))>0));
    Temp_all_index=1:length(sigTimestamps);
    ordinary_index=setdiff(Temp_all_index,special_index);


    phase_sf=phase_sf+pi;
    if ~isempty(ordinary_index)
    Temp_a=phase_sf(phase_index(2,ordinary_index))-phase_sf(phase_index(1,ordinary_index));
    Temp_b=1000*sigTimestamps(ordinary_index)-phase_index(1,ordinary_index)+1;
    Temp_c=phase_sf(phase_index(1,ordinary_index));
    
    spike_phase(ordinary_index)=Temp_a.*Temp_b'+Temp_c;
    clear Temp_a Temp_b Temp_c
    end
    
    if ~isempty(special_index)
    Temp_a=phase_sf(phase_index(2,special_index))+2*pi-phase_sf(phase_index(1,special_index));
    Temp_b=1000*sigTimestamps(special_index)-phase_index(1,special_index)+1;
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
   cicular_sigFile.Timestamps=sigTimestamps';
   
   if ~isempty(sigTimestamps)
      cicular_sigFile.Data=360*(spike_phase+pi)/2/pi;
  else
      cicular_sigFile.Data=[];
   
  end
  
%      timerange_show=[575;578];
%      figure;
%      subplot(3,1,1)
%      plot(time,sf);
%      hold on;
%      plot(sigTimestamps,0,'r.');set(gca,'xlim',timerange_show);
%      hold on;
%      plot(time,zscore(y),'k:');set(gca,'xlim',timerange_show);
%      subplot(3,1,2)
%      plot(0:0.001:(length(ADData)-1)*0.001,ADData);set(gca,'xlim',timerange_show);
%      hold on;
%      subplot(3,1,3)
% 
%      plot(cicular_sigFile.Timestamps,cicular_sigFile.Data,'r.');set(gca,'xlim',timerange_show);
% 
%   
%   a;


