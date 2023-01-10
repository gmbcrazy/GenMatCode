
path_filename=''
timerange=[1560;1570];
path_filename='I:\6-xk128\103005\nex_1\finish\lab02-xk128-103005006-f.nex';
AD_name='AD27_ad_000';
reference_name='AD27theta_maxts_f';

% 
% timerange=[436;466];
% path_filename='E:\research\data\lab04-niu405-160608\lab04-niu405-160608004-f.nex';
% AD_name='AD09_ad_000';
% reference_name='AD09theta_maxts_f';
% 
% 
% path_filename=''
% timerange=[1070;1170];
% 
% timerange=[200;900];
% 
% path_filename='E:\research\data\xk128\04-f.nex';
% AD_name='AD27_ad_000';
% reference_name='AD27theta_maxts_f';
% timerange=[1070;1200];
% timerange=[1070;1200];
% timerange=[1070;1200];
% 

half_show_range=0.5;
fre_range=[10;200];
band_width=5;
band_step=2;
fre=(fre_range(1)+band_width/2):band_step:fre_range(2);
[Power_all,lag_time,filterAD_all,power_AD]=Spec_theta(path_filename,AD_name,reference_name,timerange,fre_range,band_width,band_step,half_show_range);
% plot(filterAD_all(1,40000:42000));
% hold on;plot(power_AD(1,40000:42000).^0.5,'r')
% imagesc(log(power_AD))
imagesc(lag_time,fre,log((Power_all)));axis xy

imagesc(lag_time,fre,((Power_all)));axis xy


% 






% figure;
% subplot(2,1,1);
% plot(T,bin_x);set(gca,'xlim',[min(time_plot) max(time_plot)])
% % subplot(4,1,2);
% % plot(T,bin_y);set(gca,'xlim',[min(time_plot) max(time_plot)])
% subplot(2,1,2);
% imagesc(T,F,smoothts(log(abs(S.Power))','b',15));axis xy;set(gca,'xlim',[min(time_plot) max(time_plot)],'ylim',[0 250])
% % subplot(3,1,3);
% 
% 





% 
% 
% 
% 
% 
% 
% KalmanInput.Mode=[0 0];
% KalmanInput.V0=0.001;
% p=18;
% KalmanInput.MOP=[0 p 0];
% KalmanInput.Z0=eye(p)*0.1;
% KalmanInput.UC=0.01;
% KalmanInput.p=p;
% KalmanInput.W=nan;
% clear S class_data F T
% F=[20:1:200];
% fre=1000;
% 
% 
% timerange=[1555;1615];
% path_filename='E:\research\data\xk128\06-f.nex';
% AD_name='AD27_ad_000';
% reference_name='AD27theta_maxts_f';
% 
% 
% 
% 
% timerange=[436;466];
% path_filename='E:\research\data\lab04-niu405-160608\lab04-niu405-160608004-f.nex';
% AD_name='AD09_ad_000';
% reference_name='AD09theta_maxts_f';
% % timerange=[1125.68;1128.68];
% % path_filename='E:\research\data\xk128\04-f.nex';
% 
% 
% [bin_x,T]=rate_historam(path_filename,AD_name,timerange,0.001,0.001);
% [ref,T]=rate_historam(path_filename,reference_name,timerange,0.001,0.001);
% [raster,time,ts_origin]=perievent_raster_file(path_filename,AD_name,reference_name,timerange,0.001,[-0.4;0.4]);
% 
% hf_num=400;
% ref_index=find(ref>0);
% start_index=ref_index-hf_num;
% over_index=ref_index+hf_num;
% 
% invalid1=find(start_index<=15);
% invalid2=find(over_index>(length(bin_x)-15));
% invalid=union(invalid1,invalid2);
% 
% start_index(invalid)=[];
% over_index(invalid)=[];
% 
% 
% [S,F,T]=spec_kal(path_filename,AD_name,KalmanInput,fre,timerange,F);
% S_smooth=smoothts(abs(S.Power),'b',9);
% 
% power_all=zeros(length(F),2*hf_num+1);
% for i=1:length(start_index)
%     power_all=power_all+(S_smooth(start_index(i):over_index(i),:)');  
% end
% 
% power_all=power_all/length(start_index);
% 
% figure
% imagesc(-400:400,F,smoothts(log(power_all),'b',9));axis xy
% 
% hold on;
% 
% plot(time*1000,mean(raster)*500+100,'color',[1 0 0],'linewidth',4)
% % set(gca,'color',[1 1 1],'xcolor',[1 1 1],'ycolor',[1 1 1],'ylim',[30 200],'ytick',[100 150 200],'clim',[-12 0]);
