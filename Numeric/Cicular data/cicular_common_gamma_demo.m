

%%%%%%%%%%%%%%%%%25b and 25c is one cell        49a and 49c is one cell
%%%%%%%%%%%%%%%%%85a and 85c is one cell        85b and 85c is one cell
  
close all
sss=0:14;
for i=1:length(sss)
    if sss(i)<10
    filename=['H:\lab01-45-101706\final\lab01-45-10170600',num2str(sss(i)),'-f.nex'];



sig009a_gamma(i).final=cicular_common_gamma(filename,'scsig009ats','AD05gamma_ad_000',[0;1800]);
sig025a_gamma(i).final=cicular_common_gamma(filename,'scsig025ats','AD13gamma_ad_000',[0;1800]);
sig025b_gamma(i).final=cicular_common_gamma(filename,'scsig025bts','AD13gamma_ad_000',[0;1800]);
sig025c_gamma(i).final=cicular_common_gamma(filename,'scsig025cts','AD13gamma_ad_000',[0;1800]);
sig029a_gamma(i).final=cicular_common_gamma(filename,'scsig029ats','AD15gamma_ad_000',[0;1800]);
sig029b_gamma(i).final=cicular_common_gamma(filename,'scsig029bts','AD15gamma_ad_000',[0;1800]);
sig037a_gamma(i).final=cicular_common_gamma(filename,'scsig037ats','AD20gamma_ad_000',[0;1800]);
sig049a_gamma(i).final=cicular_common_gamma(filename,'scsig049ats','AD26gamma_ad_000',[0;1800]);
sig049b_gamma(i).final=cicular_common_gamma(filename,'scsig049bts','AD26gamma_ad_000',[0;1800]);
sig049c_gamma(i).final=cicular_common_gamma(filename,'scsig049cts','AD26gamma_ad_000',[0;1800]);
sig069a_gamma(i).final=cicular_common_gamma(filename,'scsig069ats','AD35gamma_ad_000',[0;1800]);
sig085a_gamma(i).final=cicular_common_gamma(filename,'scsig085ats','AD43gamma_ad_000',[0;1800]);
sig085b_gamma(i).final=cicular_common_gamma(filename,'scsig085bts','AD43gamma_ad_000',[0;1800]);
sig085c_gamma(i).final=cicular_common_gamma(filename,'scsig085cts','AD43gamma_ad_000',[0;1800]);
sig089a_gamma(i).final=cicular_common_gamma(filename,'scsig089ats','AD45gamma_ad_000',[0;1800]);

else
    
    filename=['H:\lab01-45-101706\final\lab01-45-1017060',num2str(sss(i)),'-f.nex'];
    
sig009a_gamma(i).final=cicular_common_gamma(filename,'scsig009ats','AD05gamma_ad_000',[0;1800]);
sig025a_gamma(i).final=cicular_common_gamma(filename,'scsig025ats','AD13gamma_ad_000',[0;1800]);
sig025b_gamma(i).final=cicular_common_gamma(filename,'scsig025bts','AD13gamma_ad_000',[0;1800]);
sig025c_gamma(i).final=cicular_common_gamma(filename,'scsig025cts','AD13gamma_ad_000',[0;1800]);
sig029a_gamma(i).final=cicular_common_gamma(filename,'scsig029ats','AD15gamma_ad_000',[0;1800]);
sig029b_gamma(i).final=cicular_common_gamma(filename,'scsig029bts','AD15gamma_ad_000',[0;1800]);
sig037a_gamma(i).final=cicular_common_gamma(filename,'scsig037ats','AD20gamma_ad_000',[0;1800]);
sig049a_gamma(i).final=cicular_common_gamma(filename,'scsig049ats','AD26gamma_ad_000',[0;1800]);
sig049b_gamma(i).final=cicular_common_gamma(filename,'scsig049bts','AD26gamma_ad_000',[0;1800]);
sig049c_gamma(i).final=cicular_common_gamma(filename,'scsig049cts','AD26gamma_ad_000',[0;1800]);
sig069a_gamma(i).final=cicular_common_gamma(filename,'scsig069ats','AD35gamma_ad_000',[0;1800]);
sig085a_gamma(i).final=cicular_common_gamma(filename,'scsig085ats','AD43gamma_ad_000',[0;1800]);
sig085b_gamma(i).final=cicular_common_gamma(filename,'scsig085bts','AD43gamma_ad_000',[0;1800]);
sig085c_gamma(i).final=cicular_common_gamma(filename,'scsig085cts','AD43gamma_ad_000',[0;1800]);
sig089a_gamma(i).final=cicular_common_gamma(filename,'scsig089ats','AD45gamma_ad_000',[0;1800]);


end


end


explore_gamma(1).timerange=[0;0];
explore_gamma(2).timerange=[0;0];
explore_gamma(3).timerange=[0;0];
explore_gamma(4).timerange=[287 811;295 828];
explore_gamma(5).timerange=[0;0];
explore_gamma(6).timerange=[0;0];
explore_gamma(7).timerange=[170 805 1274;194 819 1296];
explore_gamma(8).timerange=[0;0];
explore_gamma(9).timerange=[876 892 1022;881 903 1800];
explore_gamma(10).timerange=[0 471;400 488];
explore_gamma(11).timerange=[0;0];
explore_gamma(12).timerange=[0;0];
explore_gamma(13).timerange=[0;0];
explore_gamma(14).timerange=[0;0];
explore_gamma(15).timerange=[0;0];




rem_gamma(1).timerange=[0;0];
rem_gamma(2).timerange=[990 1300 1685;1015 1354 1722];
rem_gamma(3).timerange=[287 1032;409 1118];
rem_gamma(4).timerange=[0;0];
rem_gamma(5).timerange=[35 524 890;160 537 999];
rem_gamma(6).timerange=[0;0];
rem_gamma(7).timerange=[0;0];
rem_gamma(8).timerange=[1067;1146];
rem_gamma(9).timerange=[85;238];
rem_gamma(10).timerange=[0;0];
rem_gamma(11).timerange=[710 1101;752 1215];
rem_gamma(12).timerange=[460 1000;492 1122];
rem_gamma(13).timerange=[201 414 555 770;235 448 563 930];
rem_gamma(14).timerange=[385;454];
rem_gamma(15).timerange=[0;0];


sws(1).timerange=[1300;1500];
sws(2).timerange=[880 1187 1450;940 1261 1640];
sws(3).timerange=[230 480 860;270 585 1020];
sws(4).timerange=[1380 1580;1542 1744];
sws(5).timerange=[401 770;507 860];
sws(6).timerange=[0 319;147 425];
sws(7).timerange=[0;0];
sws(8).timerange=[786 937 1421;884 1052 1475];
sws(9).timerange=[335 560;495 835];
sws(10).timerange=[581 1760;980 1800];
sws(11).timerange=[0 470 806 1690;450 550 1077 1785];
sws(12).timerange=[40 309 1470;172 430 1800];
sws(13).timerange=[0 255 655 1044 1665;81 405 755 1340 1740];
sws(14).timerange=[0 180 540;120 335 778];
sws(15).timerange=[0;0];




sig009a_rem=wave_timerange(sig009a_gamma,rem_gamma,'theta');
sig009a_explore=wave_timerange(sig009a_gamma,explore_gamma,'theta');
sig009a_sws=wave_timerange(sig009a_gamma,sws,'theta');
[cic_rem_sig009a,ts_rem_sig009a]=mixall(sig009a_rem);
[cic_explore_sig009a,ts_explore_sig009a]=mixall(sig009a_explore);
[cic_sws_sig009a,ts_sws_sig009a]=mixall(sig009a_sws);
figure;
temp=cic_rem_sig009a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig009a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig009a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig009a','fig');





sig025a_rem=wave_timerange(sig025a_gamma,rem_gamma,'theta');
sig025a_explore=wave_timerange(sig025a_gamma,explore_gamma,'theta');
sig025a_sws=wave_timerange(sig025a_gamma,sws,'theta');
[cic_rem_sig025a,ts_rem_sig025a]=mixall(sig025a_rem);
[cic_explore_sig025a,ts_explore_sig025a]=mixall(sig025a_explore);
[cic_sws_sig025a,ts_sws_sig025a]=mixall(sig025a_sws);


sig025b_rem=wave_timerange(sig025b_gamma,rem_gamma,'theta');
sig025b_explore=wave_timerange(sig025b_gamma,explore_gamma,'theta');
sig025b_sws=wave_timerange(sig025b_gamma,sws,'theta');
[cic_rem_sig025b,ts_rem_sig025b]=mixall(sig025b_rem);
[cic_explore_sig025b,ts_explore_sig025b]=mixall(sig025b_explore);
[cic_sws_sig025b,ts_sws_sig025b]=mixall(sig025b_sws);



sig025c_rem=wave_timerange(sig025c_gamma,rem_gamma,'theta');
sig025c_explore=wave_timerange(sig025c_gamma,explore_gamma,'theta');
sig025c_sws=wave_timerange(sig025c_gamma,sws,'theta');
[cic_rem_sig025c,ts_rem_sig025c]=mixall(sig025c_rem);
[cic_explore_sig025c,ts_explore_sig025c]=mixall(sig025c_explore);
[cic_sws_sig025c,ts_sws_sig025c]=mixall(sig025c_sws);

figure;
temp=[cic_rem_sig025a,cic_rem_sig025c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig025a,cic_explore_sig025c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig025a,cic_sws_sig025c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig025a','fig');




figure;
temp=[cic_rem_sig025b,cic_rem_sig025c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig025b,cic_explore_sig025c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig025b,cic_sws_sig025c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig025b','fig');








sig029a_rem=wave_timerange(sig029a_gamma,rem_gamma,'theta');
sig029a_explore=wave_timerange(sig029a_gamma,explore_gamma,'theta');
sig029a_sws=wave_timerange(sig029a_gamma,sws,'theta');
[cic_rem_sig029a,ts_rem_sig029a]=mixall(sig029a_rem);
[cic_explore_sig029a,ts_explore_sig029a]=mixall(sig029a_explore);
[cic_sws_sig029a,ts_sws_sig029a]=mixall(sig029a_sws);
figure;
temp=cic_rem_sig029a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig029a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig029a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig029a','fig');





sig029b_rem=wave_timerange(sig029b_gamma,rem_gamma,'theta');
sig029b_explore=wave_timerange(sig029b_gamma,explore_gamma,'theta');
sig029b_sws=wave_timerange(sig029b_gamma,sws,'theta');
[cic_rem_sig029b,ts_rem_sig029b]=mixall(sig029b_rem);
[cic_explore_sig029b,ts_explore_sig029b]=mixall(sig029b_explore);
[cic_sws_sig029b,ts_sws_sig029b]=mixall(sig029b_sws);
figure;
temp=cic_rem_sig029b;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig029b;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig029b;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig029b','fig');


sig037a_rem=wave_timerange(sig037a_gamma,rem_gamma,'theta');
sig037a_explore=wave_timerange(sig037a_gamma,explore_gamma,'theta');
sig037a_sws=wave_timerange(sig037a_gamma,sws,'theta');
[cic_rem_sig037a,ts_rem_sig037a]=mixall(sig037a_rem);
[cic_explore_sig037a,ts_explore_sig037a]=mixall(sig037a_explore);
[cic_sws_sig037a,ts_sws_sig037a]=mixall(sig037a_sws);
figure;
temp=cic_rem_sig037a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig037a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig037a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig037a','fig');




sig049a_rem=wave_timerange(sig049a_gamma,rem_gamma,'theta');
sig049a_explore=wave_timerange(sig049a_gamma,explore_gamma,'theta');
sig049a_sws=wave_timerange(sig049a_gamma,sws,'theta');
[cic_rem_sig049a,ts_rem_sig049a]=mixall(sig049a_rem);
[cic_explore_sig049a,ts_explore_sig049a]=mixall(sig049a_explore);
[cic_sws_sig049a,ts_sws_sig049a]=mixall(sig049a_sws);


sig049b_rem=wave_timerange(sig049b_gamma,rem_gamma,'theta');
sig049b_explore=wave_timerange(sig049b_gamma,explore_gamma,'theta');
sig049b_sws=wave_timerange(sig049b_gamma,sws,'theta');
[cic_rem_sig049b,ts_rem_sig049b]=mixall(sig049b_rem);
[cic_explore_sig049b,ts_explore_sig049b]=mixall(sig049b_explore);
[cic_sws_sig049b,ts_sws_sig049b]=mixall(sig049b_sws);



sig049c_rem=wave_timerange(sig049c_gamma,rem_gamma,'theta');
sig049c_explore=wave_timerange(sig049c_gamma,explore_gamma,'theta');
sig049c_sws=wave_timerange(sig049c_gamma,sws,'theta');
[cic_rem_sig049c,ts_rem_sig049c]=mixall(sig049c_rem);
[cic_explore_sig049c,ts_explore_sig049c]=mixall(sig049c_explore);
[cic_sws_sig049c,ts_sws_sig049c]=mixall(sig049c_sws);

figure;
temp=[cic_rem_sig049a,cic_rem_sig049c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig049a,cic_explore_sig049c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig049a,cic_sws_sig049c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig049a','fig');




figure;
temp=[cic_rem_sig049b,cic_rem_sig049c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig049b,cic_explore_sig049c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig049b,cic_sws_sig049c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig049b','fig');



sig069a_rem=wave_timerange(sig069a_gamma,rem_gamma,'theta');
sig069a_explore=wave_timerange(sig069a_gamma,explore_gamma,'theta');
sig069a_sws=wave_timerange(sig069a_gamma,sws,'theta');
[cic_rem_sig069a,ts_rem_sig069a]=mixall(sig069a_rem);
[cic_explore_sig069a,ts_explore_sig069a]=mixall(sig069a_explore);
[cic_sws_sig069a,ts_sws_sig069a]=mixall(sig069a_sws);
figure;
temp=cic_rem_sig069a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig069a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig069a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig069a','fig');


sig085a_rem=wave_timerange(sig085a_gamma,rem_gamma,'theta');
sig085a_explore=wave_timerange(sig085a_gamma,explore_gamma,'theta');
sig085a_sws=wave_timerange(sig085a_gamma,sws,'theta');
[cic_rem_sig085a,ts_rem_sig085a]=mixall(sig085a_rem);
[cic_explore_sig085a,ts_explore_sig085a]=mixall(sig085a_explore);
[cic_sws_sig085a,ts_sws_sig085a]=mixall(sig085a_sws);


sig085b_rem=wave_timerange(sig085b_gamma,rem_gamma,'theta');
sig085b_explore=wave_timerange(sig085b_gamma,explore_gamma,'theta');
sig085b_sws=wave_timerange(sig085b_gamma,sws,'theta');
[cic_rem_sig085b,ts_rem_sig085b]=mixall(sig085b_rem);
[cic_explore_sig085b,ts_explore_sig085b]=mixall(sig085b_explore);
[cic_sws_sig085b,ts_sws_sig085b]=mixall(sig085b_sws);



sig085c_rem=wave_timerange(sig085c_gamma,rem_gamma,'theta');
sig085c_explore=wave_timerange(sig085c_gamma,explore_gamma,'theta');
sig085c_sws=wave_timerange(sig085c_gamma,sws,'theta');
[cic_rem_sig085c,ts_rem_sig085c]=mixall(sig085c_rem);
[cic_explore_sig085c,ts_explore_sig085c]=mixall(sig085c_explore);
[cic_sws_sig085c,ts_sws_sig085c]=mixall(sig085c_sws);

figure;
temp=[cic_rem_sig085a,cic_rem_sig085c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig085a,cic_explore_sig085c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig085a,cic_sws_sig085c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig085a','fig');




figure;
temp=[cic_rem_sig085b,cic_rem_sig085c];
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=[cic_explore_sig085b,cic_explore_sig085c];
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=[cic_sws_sig085b,cic_sws_sig085c];
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig085b','fig');



sig089a_rem=wave_timerange(sig089a_gamma,rem_gamma,'theta');
sig089a_explore=wave_timerange(sig089a_gamma,explore_gamma,'theta');
sig089a_sws=wave_timerange(sig089a_gamma,sws,'theta');
[cic_rem_sig089a,ts_rem_sig089a]=mixall(sig089a_rem);
[cic_explore_sig089a,ts_explore_sig089a]=mixall(sig089a_explore);
[cic_sws_sig089a,ts_sws_sig089a]=mixall(sig089a_sws);
figure;
temp=cic_rem_sig089a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem')
temp=cic_explore_sig089a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore')
temp=cic_sws_sig089a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws')
%saveas(gca,'H:\lab01-45-101706\final\sig089a','fig');



%save('H:\lab01-45-101706\final\data')
% clear all
