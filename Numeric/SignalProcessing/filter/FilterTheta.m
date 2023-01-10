function [sf,thetamax_ts]=FilterTheta(x,freq,filterorder)
         lowf=4;
         highf=12;
%          freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);


% filterorder=700;
[sf,filtwts] = eegfilt(x(:)',freq,lowf,highf,0,filterorder,0);






			thetamax_ts = [];
			max_theta = min(sf);
			threshold = 1/8 * max_theta;
			
			len_theta = length(sf);
			
			flag_over = 0;
			flag1 = 0;
			flag2 = 0;
			
			for j=1:len_theta
                
                if ~flag_over && (sf(j) < threshold)
                    flag_over = 1;
                    flag1 = 1;
                    p_start = j;
                end
                if flag_over && (sf(j) > threshold)
                    flag_over = 0;
                    flag2 = 1;
                    p_end = j;
                end
                if flag1 && flag2
                    [ad_max,p_max] = min(sf(p_start:p_end));
                    thetamax_ts=[thetamax_ts,p_max+p_start-1];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
            
            thetamax_ts=(thetamax_ts-1)/freq;

        
        
        
        
        
        
        
        
        
        
        
        
        
   

