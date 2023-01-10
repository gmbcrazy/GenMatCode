function [REV_final,rss,UC_original,REV_final_smooth,rss_smooth,AIC_final,Model_Order_original]=OrderUC_kal(bin_x,KalmanInput)


UC_original=3.^(-10:1:(-1));
Model_Order_original=[1:1:20];


for UC_i=1:length(UC_original)
    for Model_i=1:length(Model_Order_original)
tic 
UC=UC_original(UC_i);
p=Model_Order_original(Model_i);

KalmanInput.MOP=[0 p 0];
MOP=KalmanInput.MOP;
Mode=KalmanInput.Mode;
V0=KalmanInput.V0;
Z0=eye(p)*0.001;
W=KalmanInput.W;

[x,e,Kalman,Q2] = mvaar(bin_x',p,UC,4);  
[z,e,REV,ESU,V,Z,SPUR,z_smooth] = amarma_smooth(bin_x', Mode, MOP, UC, x(35,:), Z0, V0, W);     

% [z,e,REV(i),ESU,V,Z,SPUR] = amarma(bin_x, Mode, MOP, UC, x(i,:), Z0, V0, W); 
rss_i=sum(e.*e);
rss_smooth_i=sum((z_smooth.e).*(z_smooth.e));
REV_smooth=z_smooth.REV;
% [S(i).Power,F]=mode2spec(z,[],F,e,fre);
%  
%     T=0:(1/fre):((length(z)-1)/fre);

%     [pLFP(:,i),f]=psd(bin_x,NFFT,1000,Window_length,Num_overlap,'linear');
%     [pTS(:,i),f]=psd(bin_y,NFFT,1000,Window_length,Num_overlap,'linear');
%     [Coh(:,i),f_coh]=cohere(bin_x,bin_y,NFFT,1000,Window_length,Num_overlap,'linear');
    
toc

rss(UC_i,Model_i)=mean(rss_i);
rss_smooth(UC_i,Model_i)=mean(rss_smooth_i);

AIC_final(UC_i,Model_i)=2*p+length(rss_i)*log(rss_smooth(UC_i,Model_i));
REV_final(UC_i,Model_i)=mean(REV);
REV_final_smooth(UC_i,Model_i)=mean(REV_smooth);
clear rss_i rss_smooth_i REV_smooth

    end
end




% Power.LFP=pLFP;
% Power.Coh=Coh;
% Power.TS=pTS;
% Power.class=class_data;
% Power.Ts_num=Ts_num;

% figure;imagesc(f,1:length(class_data),log(pLFP'));axis xy;set(gca,'xlim',[0 100]);
% figure;plot(f,mean(log(pLFP')));axis xy;set(gca,'xlim',[0 100]);
% figure;plot(f,mean(log(pTS')));axis xy;set(gca,'xlim',[0 100]);
