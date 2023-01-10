        clear all
%      Original_data=0.9*sin((1:10000)/19);
     Original_data=random('Normal',0,1,1,10000);
     Original_data(2,:)=zeros(1,10000);
     Original_data(3,:)=zeros(1,10000);
    
     rand1=random('Normal',0,0.8,1,length(Original_data));
     rand2=random('Normal',0,0.8,1,length(Original_data));

    for i=4:length(Original_data)
        Original_data(2,i)=0.4*Original_data(1,i-3)-0.3*Original_data(2,i-1)+rand1(i);
    end        
   
    
    for i=4:length(Original_data)
        Original_data(3,i)=0.5*Original_data(3,i-1)+rand2(i)+0.3*Original_data(1,i-2);
    end        
    
    
    
    fs=1000;fre_band=[0;250];NFFT=512;MORDER_band=[15;15];
    for i=1:3
        for j=i:3
            if i~=j
               Data(1,:)=Original_data(i,:);Data(2,:)=Original_data(j,:);
               Temp=causality_try1to1(Data,fre_band,fs,NFFT,MORDER_band);
               C_uncondition(i,j).C=Temp.F1to2;
               C_uncondition(j,i).C=Temp.F2to1;
               Fre=Temp.F;
           end
       end
   end
   
   
   
C_condition=causality_try_condition(Original_data,fre_band,fs,NFFT,MORDER_band);
   
   figure;
  for i=1:3
      for j=1:3
          subplot(3,3,(i-1)*3+j);
            if i~=j
            plot(Fre,C_uncondition(i,j).C);hold on;plot(Fre,C_condition.Fy2x(i,j).Causality,'r');set(gca,'xlim',[min(Fre),max(Fre)]);
            end
       end
   end
   

   

   
   