 function [Period,thetaDeltaR,t]=BK_ThetaPeriodDect(signal,Freq)

%%%%Detect theta period based on theta(5-10Hz)/delta(2-4Hz) > n_t_pf_h=4; 
%%%%2s-length sliding windows was applied, 6s is minimal duration of theta
%%%%period;

%          freq=1000;
%          fz=freq/2;
%          [b,a]=ellip(6,3,50,highf/500);
%          sf=filtfilt(b,a,x);
%          [b,a]=ellip(6,3,50,lowf/500,'high');
%          sf=filtfilt(b,a,sf);
tic
timeWin=2; %%%%%%%%%%%2s
timeWinI=round(timeWin*Freq);
PeriodTh=3*timeWin;



        theta_lowf=5;
        theta_highf=10;
        delta_lowf=2;
        delta_highf=4;
        n_t_pf_h=3;



        len_t=length(signal);
        norm_tsf=zeros(1,len_t);
        max_tsf=max(signal);
        min_tsf=min(signal);
        level_tsf=0;
        norm_tsf(1:len_t)=level_tsf;
    
        shift_step=round(Freq/10);
        shfit_time=shift_step/Freq;
        give_up_length=timeWinI*2;    %abandon the theta wave whose length is smaller than give_up_length
        shift_num=floor((length(signal)-timeWinI)/shift_step);
        mark_theta=zeros(1,shift_num);
%         for jj=1:shift_num
%             sta_jj=(jj-1)*shift_step+1;
%             fin_jj=sta_jj+timeWinI;
%             Y_theta=signal(sta_jj:fin_jj);
%             
%             temp_NFFT=1024;
%             window=temp_NFFT;
% 
%             h = spectrum.welch('Hamming',window);
%             hpsd = psd(h,Y_theta,'NFFT',temp_NFFT,'Fs',Freq);
%             power=hpsd.Data(:);
%             fre_oscillation=hpsd.Frequencies;
% 
%             %     temp_base=temp_Fs/temp_NFFT;
%             %     temp_low_1=ceil(5/temp_base)+1;
%             %     temp_high_1=floor(10/temp_base)+1;
%             %     temp_low_2=ceil(2/temp_base)+1;
%             %     temp_high_2=floor(4/temp_base)+1;
%             theta_pow_index=find(theta_lowf<=fre_oscillation&theta_highf>=fre_oscillation);
%             delta_pow_index=find(delta_lowf<=fre_oscillation&delta_highf>=fre_oscillation);
% 
%             %     if (sum(Power_theta(temp_low_1:temp_high_1))/sum(Power_theta(temp_low_2:temp_high_2))>n_t_pf_h)
%             %         mark_theta(jj)=1;
%             %     end
%             thetaDeltaR(jj)=sum(power(theta_pow_index))/sum(power(delta_pow_index));
%             
%         end
        nfft=1024;
        window=timeWinI;
        noverlap=round(window*9/10);
        [s,f,t] = spectrogram(signal,window,noverlap,nfft,Freq);
        Snorm=abs(s);
         theta_pow_index=find(theta_lowf<=f&theta_highf>=f);
         delta_pow_index=find(delta_lowf<=f&delta_highf>=f);
         thetaP=sum(Snorm(theta_pow_index,:),1);
         deltaP=sum(Snorm(delta_pow_index,:),1);

%         thetaDeltaR=smoothts(thetaP./deltaP,'b',20);
%         thetaDeltaR=smoothts(thetaP./deltaP,'g',20);

        
        
%         thetaDeltaR=smoothts(thetaDeltaR,'g',5,0.65);
        thetaDeltaR=thetaP./deltaP;

        mark_theta=thetaDeltaR>n_t_pf_h;
        Period=MarkToPeriod(mark_theta);
        if isempty(Period)
           return
        end
%         Period(1,:)=(Period(1,:)-1)*shift_step/Freq;
%         Period(2,:)=Period(2,:)*shift_step/Freq+timeWin;
        Period(1,:)=t(Period(1,:));
        Period(2,:)=t(Period(2,:));

        Duration=Period(2,:)-Period(1,:);
        
% %         Period=Period(:,Duration>PeriodTh);
        
toc  
        
        


         

