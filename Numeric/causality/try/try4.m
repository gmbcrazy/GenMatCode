        Original_data=zeros(1,30000);
%      Original_data=0.9*sin((1:10000)/19);
      Original_data=Original_data+random('Normal',0.008,0.004,1,30000);
      Original_data(find(Original_data<=0))=[];
      Original_data=cumsum(Original_data);
  
      Original_data=sin(Original_data(1,1:10000)*2*pi)+random('Normal',0,0.5,1,10000);
      

     Original_data(2,:)=zeros(1,10000);
    
     rand1=random('Normal',0,0.5,1,length(Original_data));
     rand2=random('Normal',0,0.8,1,length(Original_data));

    for i=13:length(Original_data)
        Original_data(2,i)=0.5*Original_data(1,i-12)-0.9*Original_data(2,i-5)+rand1(i);
    end        
   
       figure;
   subplot(2,1,1);plot([1000:2000].*0.001,Original_data(1,1000:2000));ylabel('Channel1');xlabel('Time');
   subplot(2,1,2);plot([1000:2000].*0.001,Original_data(2,1000:2000));ylabel('Channel2');xlabel('Time');

 lowf=5;
highf=12;
freq=1000;
fz=freq/2;
[b,a]=ellip(6,3,50,highf/fz);

sf=filtfilt(b,a,Original_data(2,:));
[b,a]=ellip(6,3,50,lowf/fz,'high');

sf=filtfilt(b,a,sf);

			thetamax_ts = [];
			max_theta = min(sf);
			threshold = 1/8 * max_theta;
			
			len_theta = length(sf);
			
			flag_over = 0;
			flag1 = 0;
			flag2 = 0;
			
			for i=1:len_theta
                
                if ~flag_over & (sf(i) < threshold)
                    flag_over = 1;
                    flag1 = 1;
                    p_start = i;
                end
                if flag_over & (sf(i) > threshold)
                    flag_over = 0;
                    flag2 = 1;
                    p_end = i;
                end
                if flag1 & flag2
                    [ad_max,p_max] = max(sf(p_start:p_end));
                    thetamax_ts=[thetamax_ts,p_max+p_start-1];
                    flag1 = 0;
                    flag2 = 0;
                end
            end
        thetamax_ts_original=thetamax_ts*0.001;
        thetamax_ts=thetamax_ts_original;
        add_ts=[];
        for i=1:length(thetamax_ts)
add_ts=[add_ts,thetamax_ts(i)+random('Normal',0.01,0.05,1,15)-0.02];
end
thetamax_ts=add_ts;
thetamax_ts(find(diff(thetamax_ts)<0.0005))=[];
thetamax_ts(find(thetamax_ts<=0|thetamax_ts>=10))=[];
thetamax_ts=[0.001,thetamax_ts,9.999];
[bindata,temp]=hist(thetamax_ts,10000);
% bindata=bindata+random('Normal',0,0.1,1,length(bindata));

    M=[];
    bin_width=[1:2:50];
    for j=1:length(bin_width)
        Data_length=floor(length(Original_data(1,:))/bin_width(j));
        Data=zeros(2,Data_length);
        for k=1:Data_length
            temp_s=(k-1)*bin_width(j)+1;temp_e=k*bin_width(j);
            Data(1,k)=mean(Original_data(1,temp_s:temp_e));
            Data(2,k)=mean(Original_data(2,temp_s:temp_e));
        end
%         [Data(2,:),temp]=hist(thetamax_ts,Data_length);

        fs=1000/bin_width(j);
        MORDER_band=[1;ceil(50/bin_width(j))];
        NFFT=512;
        fre_band=[0;fs/2];
        Temp=causality_try1to1(Data,fre_band,fs,NFFT,MORDER_band);
        C_uncondition(j).C=Temp.Fx2y;
        Fre(j).F=Temp.F;
        M=[M,Temp.MORDER];
        
    end
    figure;
    for j=1:length(bin_width)
        subplot(length(bin_width),1,j);plot(Fre(j).F,C_uncondition(j).C);
         set(gca,'xlim',[0 250]);set(gca,'ylim',[0 5])
    end

   
       figure;
   subplot(2,1,1);plot([1000:2000].*0.001,Original_data(1,1000:2000));ylabel('Channel1');xlabel('Time');
   subplot(2,1,2);plot([1000:2000].*0.001,bindata(1000:2000));ylabel('Channel2');xlabel('Time');
figure;
plot(M,'r.')
%         
%     for i=2:length(Original_data)
%         Original_data(3,i)=0.5*Original_data(3,i-1)+Original_data(2,i-1)+rand2(i);
%     end        
%  lowf=6;
% highf=10;
% freq=1000;
% fz=freq/2;
% [b,a]=ellip(6,3,50,highf/fz);
% 
% sf=filtfilt(b,a,Original_data(2,:));
% [b,a]=ellip(6,3,50,lowf/fz,'high');
% 
% sf=filtfilt(b,a,sf);
% 
% 			thetamax_ts = [];
% 			max_theta = min(sf);
% 			threshold = 1/8 * max_theta;
% 			
% 			len_theta = length(sf);
% 			
% 			flag_over = 0;
% 			flag1 = 0;
% 			flag2 = 0;
% 			
% 			for i=1:len_theta
%                 
%                 if ~flag_over & (sf(i) < threshold)
%                     flag_over = 1;
%                     flag1 = 1;
%                     p_start = i;
%                 end
%                 if flag_over & (sf(i) > threshold)
%                     flag_over = 0;
%                     flag2 = 1;
%                     p_end = i;
%                 end
%                 if flag1 & flag2
%                     [ad_max,p_max] = min(sf(p_start:p_end));
%                     thetamax_ts=[thetamax_ts,p_max+p_start-1];
%                     flag1 = 0;
%                     flag2 = 0;
%                 end
%             end
%         thetamax_ts_original=thetamax_ts*0.001;
%         thetamax_ts=thetamax_ts_original;
%         add_ts=[];
%         for i=1:length(thetamax_ts)
% add_ts=[add_ts,thetamax_ts(i)+random('Normal',0.002,0.03,1,15)-0.007];
% end
% thetamax_ts=add_ts;
% thetamax_ts(find(diff(thetamax_ts)<0.0005))=[];
% thetamax_ts(find(thetamax_ts<=0|thetamax_ts>=10))=[];
% thetamax_ts=[0.001,thetamax_ts,9.999];
