function [mean_phase,std_phase]=sum_category_theta_maxbin(cic,hist_num)

for i=1:length(cic)
    [cic_num,cic_value]=hist(bottom_climax_change(cic(i).data));
    [cic_temp,cic_index]=max(cic_num);
    
    cic_needed(i)=cic_value(cic_index);
    
    if cic_needed(i)<180
        cic_needed(i)=cic_needed(i)+360;
    end
    
    
end


mean_phase=mean(cic_needed);
std_phase=std(cic_needed);