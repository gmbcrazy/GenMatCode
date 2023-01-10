 function [sf_theta,thetamax_ts,norm_tsf,norm_phase_sf]=ThetaNormalize(signal,Freq)

        
         lowf=4;
         highf=12;
%          freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);


filterorder=700;
[sf_theta,filtwts] = eegfilt(signal(:)',Freq,lowf,highf,0,filterorder,0);



        theta_lowf=5;
        theta_highf=10;
        delta_lowf=2;
        delta_highf=4;
        n_t_pf_h=4;



        len_t=length(sf_theta);
        norm_tsf=zeros(1,len_t);
        max_tsf=max(sf_theta);
        min_tsf=min(sf_theta);
        level_tsf=0;
        norm_tsf(1:len_t)=level_tsf;
    
        shift_step=400;
        give_up_length=4000;    %abandon the theta wave whose length is smaller than give_up_length
        shift_num=floor((length(sf_theta)-2000)/shift_step);
        mark_theta=zeros(1,shift_num);
        for jj=1:shift_num
            sta_jj=(jj-1)*shift_step+1;
            fin_jj=sta_jj+2000;
            Y_theta=signal(sta_jj:fin_jj);
            
            temp_NFFT=1024;
            window=temp_NFFT;

            h = spectrum.welch('Hamming',window);
            hpsd = psd(h,Y_theta,'NFFT',temp_NFFT,'Fs',Freq);
            power=hpsd.Data(:);
            fre_oscillation=hpsd.Frequencies;

            %     temp_base=temp_Fs/temp_NFFT;
            %     temp_low_1=ceil(5/temp_base)+1;
            %     temp_high_1=floor(10/temp_base)+1;
            %     temp_low_2=ceil(2/temp_base)+1;
            %     temp_high_2=floor(4/temp_base)+1;
            theta_pow_index=find(theta_lowf<=fre_oscillation&theta_highf>=fre_oscillation);
            delta_pow_index=find(delta_lowf<=fre_oscillation&delta_highf>=fre_oscillation);

            %     if (sum(Power_theta(temp_low_1:temp_high_1))/sum(Power_theta(temp_low_2:temp_high_2))>n_t_pf_h)
            %         mark_theta(jj)=1;
            %     end
             if sum(power(theta_pow_index))/sum(power(delta_pow_index))>n_t_pf_h
                 mark_theta(jj)=1;
            end
        end



TEMP_length_standard=(give_up_length-2000)/shift_step+1;


mark_theta_for=mark_theta;
i=1;
while i<shift_num
      if mark_theta_for(i)==1
         temp_jj=i;
         while mark_theta_for(i)==1&&i<shift_num
            i=i+1;
         end
         
         
         if i-temp_jj<TEMP_length_standard+2
            t=i;
             while mark_theta_for(t)==0&&t<shift_num
                   t=t+1;
               end
               if t-i>2
                  mark_theta_for(temp_jj:i)=0;
                  i=t;
               else 
                   tt=t;
                   while mark_theta_for(tt)==1&&tt<shift_num
                       tt=tt+1;
                   end
                   if tt-t>=TEMP_length_standard
                       mark_theta_for(i:t)=1;
                       i=tt;
                   end
                  
               end 
               
              
          end
         

     else
         i=i+1;
     end
 end
      

 mark_theta_back=mark_theta;
 i=shift_num;
while i>1
      if mark_theta_back(i)==1
         temp_jj=i;
         while mark_theta_back(i)==1&&i>1
            i=i-1;
         end
         
         
         if temp_jj-i<TEMP_length_standard+2
            t=i;
             while mark_theta_back(t)==0&&t>1
                   t=t-1;
               end
               if i-t>2
                  mark_theta_back(i:temp_jj)=0;
                  i=t;
               else 
                   tt=t;
                   while mark_theta_back(tt)==1&&tt>1
                       tt=tt-1;
                   end
                   if t-tt>=TEMP_length_standard
                       mark_theta_back(t:i)=1;
                       i=tt;
                   end
                  
               end 
               
              
          end
         

     else
         i=i-1;
     end
 end

 
 mark_theta_index=union(find(mark_theta_for==1),find(mark_theta_back==1));
 mark_theta=zeros(1,shift_num);
 mark_theta(mark_theta_index)=1;
     

analytic_sf=hilbert(sf_theta);

phase_sf=angle(analytic_sf);
norm_phase_sf=zeros(1,len_t);


TEMP_theta_validindex=find(mark_theta==1);
for j=1:length(TEMP_theta_validindex)
norm_tsf(((TEMP_theta_validindex(j)-1)*shift_step+1):((TEMP_theta_validindex(j)-1)*shift_step+2000))=sf_theta(((TEMP_theta_validindex(j)-1)*shift_step+1):((TEMP_theta_validindex(j)-1)*shift_step+2000));
norm_phase_sf(((TEMP_theta_validindex(j)-1)*shift_step+1):((TEMP_theta_validindex(j)-1)*shift_step+2000))=phase_sf(((TEMP_theta_validindex(j)-1)*shift_step+1):((TEMP_theta_validindex(j)-1)*shift_step+2000));

end    
         thetamax_ts=[];
         for j=1:len_t
             if j==1&&norm_phase_sf(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j==len_t&&norm_phase_sf(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j~=1&&j~=len_t
                 if (norm_phase_sf(j-1)-norm_phase_sf(j))>6.0&&(norm_phase_sf(j+1)-norm_phase_sf(j))>0
                     thetamax_ts=[thetamax_ts,j-1+(pi-norm_phase_sf(j-1))/((pi-norm_phase_sf(j-1))+(pi+norm_phase_sf(j)))];

                 end
             else
                 
             end
         end
         
         
thetamax_ts=(thetamax_ts-1)/Freq;

         
         
         

