        Original_data=zeros(1,30000);
%      Original_data=0.9*sin((1:10000)/19);
      Original_data=Original_data+random('Normal',0.03,0.02,1,30000);
      Original_data(find(Original_data<=0))=[];
      Original_data=cumsum(Original_data);
  
      Original_data=sin(Original_data(1,1:10000)*2*pi)+random('Normal',0,0.5,1,10000);
      

     Original_data(2,:)=zeros(1,10000);
    
     rand1=random('Normal',0,0.8,1,length(Original_data));
     rand2=random('Normal',0,0.8,1,length(Original_data));

    for i=13:length(Original_data)
        Original_data(2,i)=0.4*Original_data(1,i-3)-0.6*Original_data(1,i-8)+0.6*Original_data(1,i-12)-0.9*Original_data(2,i-1)+rand1(i);
    end        
   
       figure;
   subplot(2,1,1);plot([1000:2000].*0.001,Original_data(1,1000:2000));ylabel('Channel1');xlabel('Time');
   subplot(2,1,2);plot([1000:2000].*0.001,Original_data(2,1000:2000));ylabel('Channel2');xlabel('Time');

%     for i=4:length(Original_data)
%         Original_data(3,i)=0.5*Original_data(3,i-1)+rand2(i)+0.3*Original_data(1,i-2);
%     end        
    MORDER_band=[1:120];
    MORDER_band=[MORDER_band;MORDER_band];
    
    for i=1:length(MORDER_band)
    
    fs=1000;fre_band=[0;250];NFFT=512;
               Temp=causality_try1to1(Original_data,fre_band,fs,NFFT,MORDER_band(:,i));
               C_uncondition(i).C=Temp.Fx2y;
               Fre=Temp.F;
           end
           
C=[];
  for i=1:length(C_uncondition)

      C=[C;C_uncondition(i).C] ;
   end
figure;
imagesc(Fre,MORDER_band(1,:),C);axis xy;colorbar;ylabel('Model Order');xlabel('Frequency');
   figure;
   [x,y]=meshgrid(Fre,MORDER_band(1,:)); 
surf(x,y,C)
 set(gca,'xlim',[min(MORDER_band(1,:)),max(MORDER_band(1,:))]);set(gca,'xlim',[min(Fre),max(Fre)]);
   ylabel('Model Order');xlabel('Frequency');zlabel('Causality');
   