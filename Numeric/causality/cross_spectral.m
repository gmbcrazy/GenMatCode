function [c,q]=cross_spectral(temp_x,temp_y,temp_l)
%temp_x,temp_y are two signals,the result c refers to the co-spectrum,and q refers to the quadrature spectrum
%algorithm is based on the book "spectral analysis of economic time series" writen by C.W.J. Granger in 1964 published by princeton university press

        temp_m=length(temp_l);
        temp_n=length(temp_x);
        temp_mean_x=mean(temp_x);
        temp_mean_y=mean(temp_y);
        for k=0:(temp_m-1)
            Temp_x=temp_x(1:(temp_n-k));
            Temp_y=temp_y((k+1):temp_n);
            Cyx(k+1)=sum((Temp_x-temp_mean_x).*(Temp_y-temp_mean_y))/(temp_n-k);
            
            
            Temp_x=temp_y(1:(temp_n-k));
            Temp_y=temp_x((k+1):temp_n);
            Cxy(k+1)=sum((Temp_x-temp_mean_y).*(Temp_y-temp_mean_x))/(temp_n-k);

        end
        
        
%         for j=0:(temp_m-1)
%             c(j+1)=temp_l(1)*(Cxy(1)+Cyx(1))/4/pi+sum(temp_l(2:temp_m).*(Cxy(2:temp_m)+Cyx(2:temp_m)).*cos(pi*j*(1:(temp_m-1))/(temp_m-1)))/2/pi;
%             
%             q(j+1)=sum(temp_l(2:temp_m).*(Cxy(2:temp_m)-Cyx(2:temp_m)).*sin(pi*j*(1:(temp_m-1))/(temp_m-1)))/2/pi;
%         end



% % using Tukey-Hanning weights

        for j=0:(temp_m-1)
           Lc(j+1)=(Cxy(1)+sum((Cxy((2:temp_m-1))+Cyx((2:temp_m-1))).*cos(pi*[1:temp_m-2]*j/(temp_m-1)))+0.5*(Cxy(temp_m)+Cyx(temp_m))*cos(pi*j))/2/pi;
           Lq(j+1)=(sum((Cxy(2:temp_m-1)-Cyx(2:temp_m-1)).*sin(pi*[1:temp_m-2]*j/(temp_m-1)))+0.5*(Cxy(temp_m)-Cyx(temp_m))*sin(pi*j)/2);
        end
% % using Tukey-Hanning weights

% % smooth      

        Lc=[Lc(2),Lc,Lc(temp_m-1)];
        Lq=[-Lq(2),Lq,-Lq(temp_m-1)];
        
        c1=Lc(1:(length(Lc)-2));
        c2=Lc(2:(length(Lc)-1));
        c3=Lc(3:(length(Lc)));
        c=0.25*c1+0.5*c2+0.25*c3;
        
        q1=Lq(1:(length(Lq)-2));
        q2=Lq(2:(length(Lq)-1));
        q3=Lq(3:(length(Lq)));
        q=0.25*q1+0.5*q2+0.25*q3;
% % smooth      