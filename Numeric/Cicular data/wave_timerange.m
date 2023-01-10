function y=wave_timerange(cicular_sigFile,waveduration,waveType)
%waveduration could be rem_theta as follow
%rem_theta(1).timerange=[178;393];
%rem_theta(2).timerange=[245,629,1024;303,673,1173];
%rem_theta(3).timerange=[0;1];
%rem_theta(4).timerange=[0;1];

circle_end=length(waveduration);
for i=1:circle_end
    waveTimes(i)=length(waveduration(i).timerange(1,:));
end


if strcmp(waveType,'theta');
   for i=1:circle_end
       a(i).timerange=waveduration(i).timerange;
       a(i).Sig_name=cicular_sigFile(i).final.Sig_name;
       a(i).Wave_name=cicular_sigFile(i).final.Wave_name;
       a(i).filename=cicular_sigFile(i).final.filename;
       q=[];
       or_q=[];
       ref_q=[];
       for j=1:waveTimes(i)
           qqq=cicular_sigFile(i).final.Timestamps;
           qq=find(qqq>=waveduration(i).timerange(1,j)&qqq<=waveduration(i).timerange(2,j));
           q=[q;qq];
           
           
           or_qqq=cicular_sigFile(i).final.Spike_origin;
           or_qq=find(or_qqq>=waveduration(i).timerange(1,j)&or_qqq<=waveduration(i).timerange(2,j));
           or_q=[or_q;or_qq];
           
%            ref_qqq=cicular_sigFile(i).final.RefTimestamps;
%            ref_qq=find(ref_qqq>=waveduration(i).timerange(1,j)&ref_qqq<=waveduration(i).timerange(2,j));
%            ref_q=[ref_q;ref_qq];
        
           

           
       end
       a(i).Timestamps=cicular_sigFile(i).final.Timestamps(q);
       a(i).Data=cicular_sigFile(i).final.Data(q);
        a(i).Spike_origin=cicular_sigFile(i).final.Spike_origin(or_q);
        a(i).TimeSpan=cicular_sigFile(i).final.TimeSpan;
%         a(i).RefTimestamps=cicular_sigFile(i).final.RefTimestamps(ref_q);
%       a(i).TimeSpan=1800;

   end

elseif strcmp(waveType,'AD_theta');
       for i=1:circle_end
       a(i).timerange=waveduration(i).timerange;
       a(i).AD_need_name=cicular_sigFile(i).final.AD_need_name;
       a(i).Wave_name=cicular_sigFile(i).final.Wave_name;
       a(i).filename=cicular_sigFile(i).final.filename;
       q=[];
       for j=1:waveTimes(i)
           qqq=cicular_sigFile(i).final.Timestamps;
           qq=find(qqq>=waveduration(i).timerange(1,j)&qqq<=waveduration(i).timerange(2,j))';
           q=[q;qq];
           
           

           
       end
       a(i).Timestamps=cicular_sigFile(i).final.Timestamps(q);
       a(i).Data=cicular_sigFile(i).final.Data(q);
        a(i).Theta_phase=cicular_sigFile(i).final.Theta_phase(q);
        a(i).TimeSpan=cicular_sigFile(i).final.TimeSpan;
%       a(i).TimeSpan=1800;

   end

    
elseif strcmp(waveType,'ripple');
       
       for i=1:circle_end
           q=[];
           a(i).timerange=waveduration(i).timerange;
           a(i).Wave_name=cicular_sigFile(i).final.Wave_name;
           a(i).Sig_name=cicular_sigFile(i).final.Sig_name;
           a(i).filename=cicular_sigFile(i).final.filename;
           for j=1:waveTimes(i)
               qqq=cicular_sigFile(i).final.Timestamps;
               qq=find(qqq>=waveduration(i).timerange(1,j)&qqq<=waveduration(i).timerange(2,j));
               q=[q;qq];
               
           or_qqq=cicular_sigFile(i).final.Spike_origin;
           or_qq=find(or_qqq>=waveduration(i).timerange(1,j)&or_qqq<=waveduration(i).timerange(2,j));
           or_q=[or_q;or_qq];

           end
           a(i).Timestamps=cicular_sigFile(i).final.Timestamps(q);
           a(i).Data=cicular_sigFile(i).final.Data(q);
           a(i).rippleindex=cicular_sigFile(i).final.rippleindex(q);
           a(i).Spike_origin=cicular_sigFile(i).final.Spike_origin(or_q);
           a(i).TimeSpan=cicular_sigFile(i).final.TimeSpan;
%          a(i).TimeSpan=1800;
       
                    if ~isempty(a(i).rippleindex)
                        m=max(a(i).rippleindex);
                    else 
                        m=0;
                    end
                    a(i).ripple_start_index=[];
                    a(i).ripple_end_index=[];
                    a(i).ripple_count=[];
 
                    for j=1:m
                        q=find(a(i).rippleindex==j);    
                        if ~isempty(q);
                            a(i).ripple_start_index=[a(i).ripple_start_index;min(q)];
                            a(i).ripple_end_index=[a(i).ripple_end_index;max(q)];
                            a(i).ripple_count=[a(i).ripple_count;length(q)];
    
                        end
                    end
       end


    
    
    
    
    
else
    'waveType should be theta or ripple!!'
end

y=a;