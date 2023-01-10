function [Data,time]=rate_histogram_kernel(path_filename,data_name,timerange,bin_width,step,kernel_parameter)
%path_filename should be a string like 'E:\experiment\lab03-04-072005006.nex'%
%timerange=[timestart;timeend]%eg.[122 533;221 466];
% kernel_parameter.form='EXP';
% kernel_parameter.sigma=0.001;
% kernel_parameter.TimeStampResolution=0.001;


[nvar, names, types] = nex_info2(path_filename);

for i=1:nvar
    if strncmp(names(i,:),data_name,length(data_name))
       Variable=types(i);
       break
    end
end


[Data,time]=RateHist(path_filename,data_name,timerange,bin_width);

% 
    if (Variable==0)||(Variable==1)                %%%%%%%%%%%%event variable
       
       [kernel,norm,m_idx] = makeKernel65(kernel_parameter.form,kernel_parameter.sigma,kernel_parameter.TimeStampResolution);
       rate_f=conv(kernel,Data);
       index_s=m_idx;
       index=index_s:(index_s+length(Data)-1);
       rate_f=rate_f(index);
       Data=rate_f;
       clear rate_f;
    end


