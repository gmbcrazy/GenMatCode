function [sf,RMS_gamma,norm_gsf,gammamax_ts]=FilterGamma(data,freq,filterorder)
         lowf=30;
         highf=80;
%          freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);


% filterorder=75;


[sf,filtwts] = eegfilt(data(:)',freq,lowf,highf,0,filterorder,0);

            
            
            
            len_g=length(sf);
            
            
             i=1;
             tic;
             while i<(length(sf)-24)
                  temp_sf_p=sf(i:(i+24));
                  sf_p(i)=(mean(temp_sf_p.*temp_sf_p)).^0.5;
                  i=i+1;
             end
             toc;
             
             
             ave_p=mean(sf_p);
             sd_p2=2*std(sf_p);         %2sd above the average power was set as threthold
             mark_gamma=zeros(1,len_g);
             norm_gsf(1:len_g)=zeros(1,len_g);
             norm_phase_gsf=zeros(1,len_g);
             RMS_gamma=[zeros(1,12),sf_p,zeros(1,13)];
 
             
             
          temp_gamma_n_index=find((sf_p-ave_p)>sd_p2);
          for i=1:length(temp_gamma_n_index)
              mark_gamma(temp_gamma_n_index(i):(temp_gamma_n_index(i)+24))=1;
          end
          norm_gsf(find(mark_gamma==1))=sf(find(mark_gamma==1));
          
          
          
          
          
          
			gammamax_ts = [];
			max_gamma = min(norm_gsf);
			threshold = 1/8 * max_gamma;
			
			len_gamma = length(sf);
			
			flag_over = 0;
			flag1 = 0;
			flag2 = 0;
			
			for j=1:len_gamma
                
                if ~flag_over && (norm_gsf(j) < threshold)
                    flag_over = 1;
                    flag1 = 1;
                    p_start = j;
                end
                if flag_over && (norm_gsf(j) > threshold)
                    flag_over = 0;
                    flag2 = 1;
                    p_end = j;
                end
                if flag1 && flag2
                    [ad_max,p_max] = min(norm_gsf(p_start:p_end));
                    gammamax_ts=[gammamax_ts,p_max+p_start-1];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
            
            gammamax_ts=(gammamax_ts-1)/freq;

          
          
          
          
          
          
          
          
          
          
          

