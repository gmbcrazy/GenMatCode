        Original_data=zeros(1,10000);
%      Original_data=0.9*sin((1:10000)/19);
      Original_data=Original_data+random('Normal',0,1,1,10000);
%       Original_data(find(Original_data<=0))=[];
%       Original_data=cumsum(Original_data);
%   
%       Original_data=sin(Original_data(1,1:10000)*2*pi)+random('Normal',0,0.5,1,10000);
      

     Original_data(2,:)=zeros(1,10000);
    
     rand1=random('Normal',0,0.8,1,length(Original_data));
     rand2=random('Normal',0,0.8,1,length(Original_data));

    for i=13:length(Original_data)
        Original_data(2,i)=0.6*Original_data(1,i-8)+0.6*Original_data(1,i-12)-0.9*Original_data(2,i-1)+rand1(i);
    end        
    M=[];
    bin_width=[1];
    for j=1:length(bin_width)
        Data_length=floor(length(Original_data(1,:))/bin_width(j));
        Data=zeros(2,Data_length);
        for k=1:Data_length
            temp_s=(k-1)*bin_width(j)+1;temp_e=k*bin_width(j);
            Data(1,k)=mean(Original_data(1,temp_s:temp_e));
            Data(2,k)=mean(Original_data(2,temp_s:temp_e));
        end
        fs=1000/bin_width(j);
        MORDER_band=[1;ceil(50/bin_width(j))];
        NFFT=512;
        fre_band=[0;fs/2];
        Temp=causality_try1to1(Data,fre_band,fs,NFFT,MORDER_band);
        C_uncondition(j).C=Temp.F1to2;
        Fre(j).F=Temp.F;
        M=[M,Temp.MORDER];
        
    end
    figure;
    for j=1:length(bin_width)
        subplot(length(bin_width),1,j);plot(Fre(j).F,C_uncondition(j).C);
         set(gca,'xlim',[0 250]);set(gca,'ylim',[0 2])
    end

   
       figure;
   subplot(2,1,1);plot([1000:2000].*0.001,Original_data(1,1000:2000));ylabel('Channel1');xlabel('Time');
   subplot(2,1,2);plot([1000:2000].*0.001,Original_data(2,1000:2000));ylabel('Channel2');xlabel('Time');

%     for i=4:length(Original_data)
%         Original_data(3,i)=0.5*Original_data(3,i-1)+rand2(i)+0.3*Original_data(1,i-2);
% %     end        
%     MORDER_band=[1:120];
%     MORDER_band=[MORDER_band;MORDER_band];
%     
% figure;
% imagesc(Fre,MORDER_band(1,:),C);axis xy;colorbar;ylabel('Model Order');xlabel('Frequency');
%    figure;
%    [x,y]=meshgrid(Fre,MORDER_band(1,:)); 
% surf(x,y,C)
%  set(gca,'xlim',[min(MORDER_band(1,:)),max(MORDER_band(1,:))]);set(gca,'xlim',[min(Fre),max(Fre)]);
%    ylabel('Model Order');xlabel('Frequency');zlabel('Causality');
   