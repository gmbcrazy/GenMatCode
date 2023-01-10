function cic=cic_ripple_vs_time2(path_name,sig,AD_name,timerange,window_length,step,Normlize_p)

 cicular_data=cicular_common_ripple(path_name,sig,AD_name,timerange);

if isempty(cicular_data.Data)
cic.Density=[];
cic.Prefer=[];
cic.Level=[];
cic.P=[];
cic.K=[];
cic.Time=[];
cic.Phase_sample=[];
    
    return
end

step_num=floor((diff(timerange)-window_length)/step);
time=(timerange(1)+window_length/2):step:timerange(1)+window_length/2+step*(step_num-1);
P=ones(1,step_num);
prefer=zeros(1,step_num);
cic_density=zeros(72,step_num);
level=zeros(1,step_num);
k=zeros(1,step_num);

if Normlize_p==1
    for i=1:step_num
    
    temp_s=timerange(1)+(i-1)*step;
    temp_e=temp_s+window_length;
    temp_data=cicular_data.Data(find(cicular_data.Timestamps>=temp_s&cicular_data.Timestamps<temp_e));
    if ~isempty(temp_data)
    [prefer(i),level(i),mean_length,P(i),k(i)]=phase_lock_comput(temp_data);

    [density,phase_sample]=phase_fit(k(i),36,prefer(i));

    cic_density(:,i)=density';
    end
    end
    cic.Phase_sample=phase_sample;
else
    for i=1:step_num
    
    temp_s=timerange(1)+(i-1)*step;
    temp_e=temp_s+window_length;
    temp_data=cicular_data.Data(find(cicular_data.Timestamps>=temp_s&cicular_data.Timestamps<temp_e));
    if ~isempty(temp_data)
        temp_data=[temp_data,0,360];
        [density_temp,q]=hist(temp_data,36);
        density_temp(1)=density_temp(1)-1;density_temp(length(density_temp))=density_temp(length(density_temp))-1;
        cic_density(:,i)=[density_temp,density_temp]';
    end
    end
end



cic.Density=cic_density;
cic.Prefer=prefer;
cic.Level=level;
cic.P=P;
cic.K=k;
cic.Time=time;
% cic.Phase_sample=phase_sample;