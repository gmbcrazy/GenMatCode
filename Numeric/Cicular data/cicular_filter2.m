function output=cicular_filter2(path_filename,sig,AD,timerange,varargin)

%%%%%%%%%detect the
cicular_sigFile=cicular_common_paper(path_filename,sig,AD,timerange);
[adfreq, n, ts, fn, ADData] = nex_cont(path_filename,AD);
sigTimestamps=cicular_sigFile.Timestamps;
sigPhase=cicular_sigFile.Data;

if nargin == 7
ref=varargin{1};
ref_range=varargin{2};
fre=varargin{3};

        [n, ref] = nex_ts(path_filename,ref);
        need_index=[];
        for i=1:length(ref)
            ref_temp=ref(i)+ref_range;
            need_index=union(need_index,find(ref_temp(1)<=sigTimestamps&sigTimestamps<=ref_temp(2)));
        end

        sigTimestamps=sigTimestamps(need_index);
        sigPhase=sigPhase(need_index);
    elseif nargin == 5
        
        fre=varargin{1};
    elseif nargin == 4
        fre=1000;
    else
        'error input'
        return;
    end  




bin_width=1/fre;
step=bin_width;
bin_start=timerange(1,1):step:(timerange(1,1)+step*round((timerange(2,end)-timerange(1,1)-bin_width)/step));
bin_over=bin_start+bin_width;

time=bin_start+bin_width/2;


temp_data1=[sigTimestamps;timerange(1,1);(timerange(2,end)-bin_width)];
[temp_num,nonsense]=hist(temp_data1,length(bin_start));
temp_num(1)=temp_num(1)-1;temp_num(length(temp_num))=temp_num(length(temp_num))-1;
y=temp_num;
clear temp_num;



[b,a]=ellip(5,3,50,12/fre*2);
temp_sf=filtfilt(b,a,y);
[b,a]=ellip(5,3,50,4/fre*2,'high');
sf=filtfilt(b,a,temp_sf);% theta-based filter
sf=zscore(sf);

    analytic_sf=hilbert(smooth(sf,3));
    phase_sf=angle(analytic_sf);
    
    sig_sf_phase=phase_sf(floor(sigTimestamps)+1);
    invalid_index=find(sig_sf_phase>pi/2);
    sigTimestamps(invalid_index)=[];
    sigPhase(invalid_index)=[];
    sig_sf_phase(invalid_index)=[];
    
%  time_show=[1036;1044];
%     figure;
%     plot(time,sf);
%     hold on;
%     plot(time,y,'r')
%     set(gca,'xlim',time_show);
    
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
            
     TS=0.001*(thetamax_ts-1);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%thetamax_ts is the thetamax_ts-th time point of AD-type variable,but the time points should be thetamax_ts-1

% [n, ts_sig] = nex_ts(path_filename,sig);
% 
% sigIndex=floor(sigTimestamps*1000)+1;
% phaseTS=AD_phase(sigIndex);


     test_range=[-0.08;0.02];
     need_index=[];
     for i=1:length(TS)
         temp_test=TS(i)+test_range;
         test_index=find(sigTimestamps>=temp_test(1)&sigTimestamps<=temp_test(2));
         if isempty(test_index)
             TS(i)=-1;
         else
             need_index=[need_index;min(test_index)];
             
         end
     end
     
     TS=sigTimestamps(need_index);
     sigPhase=sigPhase(need_index);
     
output.Timestamps=TS;
output.Data=sigPhase;
output.Rate_hist=y;
output.filter_rate=sf;
output.time_rate=time;
output.ADData=ADData;
output.ADtime=0:0.001:(length(ADData)-1)*0.001;

%      timerange_show=[1038;1042];
%      figure;
%      subplot(3,1,1)
%      plot(output.time_rate,zscore(sf));
%      hold on;
%      plot(output.time_rate,phase_sf);
%      hold on;
%      plot(output.Timestamps,0,'r.');
%      set(gca,'xlim',timerange_show);
%      hold on;
%      plot(time,(output.Rate_hist)*10,'k:');set(gca,'xlim',timerange_show);
%      subplot(3,1,2)
%      plot(output.ADtime,output.ADData);set(gca,'xlim',timerange_show);
%      hold on;
%      subplot(3,1,3)
%      plot(output.Timestamps,output.Data,'r.');set(gca,'xlim',timerange_show);
% 
%   
% output;
% 

