KalmanInput.UC=0.001;
KalmanInput.Mode=[11 1];
KalmanInput.Mode=[0 0];

KalmanInput.V0=0.1;
p=25;
Z0=eye(p);
V0=0.001;
KalmanInput.MOP=[0 p 0];
KalmanInput.Z0=eye(p)*0.01;
KalmanInput.UC=0.0001;
KalmanInput.p=p;
KalmanInput.W=nan;
clear S class_data F T
F=[0:1:250];
fre=1000;
timerange=[155.5;158.5];
timerange=[154;160];
time_plot=[156.2;158.2];
signame='sig049a';
adname='AD09';

% bin_y=bin_y+random('norm',0,std(bin_y)*0.2,1,length(bin_y));
% 
% [S,F,T]=spec_kal('E:\research\data\lab04-niu405-160608\lab04-niu405-130608010-aligned.nex','sig049a',KalmanInput,fre,timerange,F);
path_filename='E:\research\data\lab04-niu405-160608\lab04-niu405-130608010-aligned.nex';
% timerange=[1125.68;1128.68];
% path_filename='E:\research\data\xk128\04-f.nex';
[bin_x,T]=rate_historam(path_filename,adname,timerange,0.001,0.001);
[bin_y,T]=rate_historam(path_filename,signame,timerange,0.001,0.001);
% [S,F,T]=spec_kal(path_filename,'AD27_ad_000',KalmanInput,fre,timerange,F);
% [S_sig,F,T]=spec_kal(path_filename,'scsig053ats',KalmanInput,fre,timerange,F);

signame='sig049a';
adname='AD09';

[REV_final,rss,UC_original,REV_final_smooth,rss_smooth,AIC_final,Model_Order_original]=OrderUC_kal(bin_x,KalmanInput);
[x,y]=meshgrid(UC_original,Model_Order_original);
surf(UC_original,Model_Order_original,abs(REV_final'));axis xy;
min_REV=min(min(REV_final));
[m,n]=find(REV_final==min_REV);
order=Model_Order_original(n)
UC_original(m)

[bin_x,T]=rate_historam(path_filename,adname,timerange,0.001,0.001);
[bin_y,T]=rate_historam(path_filename,signame,timerange,0.001,0.001);
[S,F,T]=spec_kal(path_filename,adname,KalmanInput,fre,timerange,F);
[S_sig,F,T]=spec_kal(path_filename,signame,KalmanInput,fre,timerange,F);

figure;
subplot(4,1,1);
plot(T,bin_x);set(gca,'xlim',[min(time_plot) max(time_plot)])
subplot(4,1,2);
plot(T,bin_y);set(gca,'xlim',[min(time_plot) max(time_plot)])
subplot(4,1,3);
imagesc(T,F,smoothts(log(abs(S.Power))','b',3));axis xy;set(gca,'xlim',[min(time_plot) max(time_plot)])
subplot(4,1,4);
imagesc(T,F,smoothts(log(abs(S_sig.Power))','b',3));axis xy;set(gca,'xlim',[min(time_plot) max(time_plot)])

figure;
subplot(3,1,1);
plot(T,bin_y);set(gca,'xlim',[min(time_plot) max(time_plot)])
subplot(3,1,2);
plot(T,bin_x);set(gca,'xlim',[min(time_plot) max(time_plot)])
subplot(3,1,3);
imagesc(T,F,smoothts(log(abs(S.Power))','b',9));axis xy
set(gca,'ylim',[0 250],'xlim',[min(time_plot) max(time_plot)])
% imagesc(T,F,smoothts(log(abs(S.Power))','b',9));axis xy
% 
% [M,LEN] = size([bin_x;bin_y]);		%number of channels, total signal length
% L = M*M*p;
% UC=0.01;
% Kalman=struct('F',eye(L),'H',zeros(M,L),'G',zeros(L,M),'x',zeros(L,1),'Kp',eye(L),'Q1',eye(L)*UC,'Q2',eye(M),'ye',zeros(M,1));
% 
% [x,e,Kalman,Q2] = mvaar([bin_x;bin_y]',p,KalmanInput.UC,0,Kalman);
% NFFT=500;Fs=1000;
% channel_num=2;
% % causality=causality_try1to1([bin_x;bin_y],[0 500],Fs,500,[30;30]);
% 
% causality=kal2spec(x,Q2,channel_num,p,NFFT,Fs);
% 
% figure;
% subplot(5,1,1)
% imagesc(T,causality.F,causality.Coh_cau');axis xy;
% subplot(5,1,2)
% imagesc(T,causality.F,log(abs(causality.S1')));axis xy;
% subplot(5,1,3)
% imagesc(T,causality.F,log(abs(causality.S2')));axis xy;
% subplot(5,1,4)
% imagesc(T,causality.F,causality.I1to2');axis xy;
% subplot(5,1,5)
% imagesc(T,causality.F,causality.I2to1');axis xy;
