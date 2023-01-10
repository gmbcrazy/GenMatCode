function power_f=power_spectral(temp_x,temp_l)
%temp_x,temp_y are two signals,the result c refers to the co-spectrum,and q refers to the quadrature spectrum
%algorithm is based on the book "spectral analysis of economic time series" writen by C.W.J. Granger in 1964 published by princeton university press

        temp_m=length(temp_l);
        temp_n=length(temp_x);
        temp_mean_x=mean(temp_x);
        temp_y=temp_x;
        temp_mean_y=mean(temp_y);

        for k=0:(temp_m-1)
            Temp_x=temp_y(1:(temp_n-k));
            Temp_y=temp_x((k+1):temp_n);
            Cxy(k+1)=sum((Temp_x-temp_mean_y).*(Temp_y-temp_mean_x))/(temp_n-k);

        end
        
        
        for j=0:(temp_m-1)
            L(j+1)=  (Cxy(1)+sum(2*Cxy(2:temp_m).*cos(pi/temp_m*j.*[1:(temp_m-1)]))+Cxy(temp_m)*cos(pi*j))/2/pi;
            
        end
% using Tukey-Hanning weights
% smooth      
        L_left=[L(2),L(1:(temp_m-1))];
        L_right=[L(2:temp_m),L(temp_m-1)];
        
        power_f=0.25*L_left+0.5*L+0.25*L_right;
        
