clear all
Filename='F:\Lu Data\Mouse011\step3\LDL\27052013\NaviReward-M11-270513005.smr';

timerange=[0;1000];
Chan=8;
freq=1000;

[Data]=smr_cont(Filename,Chan,timerange);


filter_order=700;
[sf,thetamax_ts]=FilterTheta(Data.Data(1:100000),freq,filter_order);

% figure;
% plot(Data.Data(1000:5000));
% hold on;
% plot(sf(1000:5000),'r')
% 


[sf_theta,thetamaxts_ts,norm_tsf,norm_phase_sf]=ThetaNormalize(Data.Data(1:100000),freq,filter_order);






filter_order=75;
[sf,RMS_gamma,norm_gsf,gammamax_ts]=FilterGamma(Data.Data(1:100000),freq,filter_order)


filter_order=30;
[sf,RMS_ripple,norm_rsf,ripplemax_ts,ripplemax_ts_p,ripplestart_ts,rippleover_ts]=FilterRipple(Data.Data(1:100000),freq,filter_order);






range=4000:40000
subplot(4,1,1)
plot(sf(range));
subplot(4,1,2)
plot(norm_tsf(range));
subplot(4,1,3)
plot(norm_phase_sf(range));
subplot(4,1,3)
plot(norm_phase_sf(range));