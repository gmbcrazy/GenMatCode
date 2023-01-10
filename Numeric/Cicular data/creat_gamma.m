close all
sss=1:20;
for i=1:length(sss)
    if sss(i)<10
    filename=['E:\brust theta\lab02\xk128\final_two_days\0',num2str(sss(i)),'.nex'];


sig053a(i).final=cicular_common(filename,'scsig053ats','AD15gamma_normalized_ad_000',[0;1800]);
sig029a(i).final=cicular_common(filename,'scsig029ats','AD15gamma_normalized_ad_000',[0;1800]);
sig041a(i).final=cicular_common(filename,'scsig041ats','AD21gamma_normalized_ad_000',[0;1800]);
sig045a(i).final=cicular_common(filename,'scsig045ats','AD27gamma_normalized_ad_000',[0;1800]);


sig041b(i).final=cicular_common(filename,'scsig041bts','AD21gamma_normalized_ad_000',[0;1800]);
sig041c(i).final=cicular_common(filename,'scsig041cts','AD21gamma_normalized_ad_000',[0;1800]);
sig041d(i).final=cicular_common(filename,'scsig041dts','AD21gamma_normalized_ad_000',[0;1800]);
sig041e(i).final=cicular_common(filename,'scsig041ets','AD21gamma_normalized_ad_000',[0;1800]);
sig045b(i).final=cicular_common(filename,'scsig045bts','AD27gamma_normalized_ad_000',[0;1800]);
sig045c(i).final=cicular_common(filename,'scsig045cts','AD27gamma_normalized_ad_000',[0;1800]);
sig053b(i).final=cicular_common(filename,'scsig053bts','AD27gamma_normalized_ad_000',[0;1800]);
sig085a(i).final=cicular_common(filename,'scsig085ats','AD27gamma_normalized_ad_000',[0;1800]);
sig085b(i).final=cicular_common(filename,'scsig085bts','AD27gamma_normalized_ad_000',[0;1800]);
sig085c(i).final=cicular_common(filename,'scsig085cts','AD27gamma_normalized_ad_000',[0;1800]);
sig085d(i).final=cicular_common(filename,'scsig085dts','AD27gamma_normalized_ad_000',[0;1800]);
sig085e(i).final=cicular_common(filename,'scsig085ets','AD27gamma_normalized_ad_000',[0;1800]);

else
    
    filename=['E:\brust theta\lab02\xk128\final_two_days\',num2str(sss(i)),'.nex'];
    
sig053a(i).final=cicular_common(filename,'scsig053ats','AD15gamma_normalized_ad_000',[0;1800]);
sig029a(i).final=cicular_common(filename,'scsig029ats','AD15gamma_normalized_ad_000',[0;1800]);
sig041a(i).final=cicular_common(filename,'scsig041ats','AD21gamma_normalized_ad_000',[0;1800]);
sig045a(i).final=cicular_common(filename,'scsig045ats','AD27gamma_normalized_ad_000',[0;1800]);


sig041b(i).final=cicular_common(filename,'scsig041bts','AD21gamma_normalized_ad_000',[0;1800]);
sig041c(i).final=cicular_common(filename,'scsig041cts','AD21gamma_normalized_ad_000',[0;1800]);
sig041d(i).final=cicular_common(filename,'scsig041dts','AD21gamma_normalized_ad_000',[0;1800]);
sig041e(i).final=cicular_common(filename,'scsig041ets','AD21gamma_normalized_ad_000',[0;1800]);
sig045b(i).final=cicular_common(filename,'scsig045bts','AD27gamma_normalized_ad_000',[0;1800]);
sig045c(i).final=cicular_common(filename,'scsig045cts','AD27gamma_normalized_ad_000',[0;1800]);
sig053b(i).final=cicular_common(filename,'scsig053bts','AD27gamma_normalized_ad_000',[0;1800]);
sig085a(i).final=cicular_common(filename,'scsig085ats','AD27gamma_normalized_ad_000',[0;1800]);
sig085b(i).final=cicular_common(filename,'scsig085bts','AD27gamma_normalized_ad_000',[0;1800]);
sig085c(i).final=cicular_common(filename,'scsig085cts','AD27gamma_normalized_ad_000',[0;1800]);
sig085d(i).final=cicular_common(filename,'scsig085dts','AD27gamma_normalized_ad_000',[0;1800]);
sig085e(i).final=cicular_common(filename,'scsig085ets','AD27gamma_normalized_ad_000',[0;1800]);

end


end






explore(1).timerange=[0;0];
explore(2).timerange=[7,180;11,270];
explore(3).timerange=[0;0];
explore(4).timerange=[0;0];
explore(5).timerange=[0;0];
explore(6).timerange=[1055 1555 1705;1160 1618 1735];
explore(7).timerange=[33 124 190 358;55 180 330 375];
explore(8).timerange=[390 750 880 1055 1530;625 800 940 1130 1580];
explore(9).timerange=[0;0];
explore(10).timerange=[315 550;380 570];
explore(11).timerange=[0;0];
explore(12).timerange=[0;0];
explore(13).timerange=[0;0];
explore(14).timerange=[0;0];
explore(15).timerange=[0;0];
explore(16).timerange=[0;0];
explore(17).timerange=[0;0];
explore(18).timerange=[0;0];
explore(19).timerange=[0;0];
explore(20).timerange=[0;0];



rem(1).timerange=[0;0];
rem(2).timerange=[1080;1160];
rem(3).timerange=[270 810;312 890];
rem(4).timerange=[401 983 1050;411 1000 1219];
rem(5).timerange=[82 619 1160 1445 1720;105 644 1182 1488 1797];
rem(6).timerange=[0 485 860;14 545 910];
rem(7).timerange=[1400;1420];
rem(8).timerange=[0;0];
rem(9).timerange=[0;0];
rem(10).timerange=[0;0];
rem(11).timerange=[647 874 1558;667 980 1570];
rem(12).timerange=[96;112];
rem(13).timerange=[0;0];
rem(14).timerange=[0;0];
rem(15).timerange=[0;0];
rem(16).timerange=[0;0];
rem(17).timerange=[0;0];
rem(18).timerange=[0;0];
rem(19).timerange=[0;0];
rem(20).timerange=[0;0];


sws(1).timerange=[0;0];
sws(2).timerange=[1196 1520 1640;1500 1582 1735];
sws(3).timerange=[10 344 640 925 1068 1163;210 540 726 1051 1128 1370];
sws(4).timerange=[696 1360 1600;950 1420 1800];
sws(5).timerange=[180 800;600 1150];
sws(6).timerange=[380 620;460 830];
sws(7).timerange=[0;0];
sws(8).timerange=[0;0];
sws(9).timerange=[950;1310];
sws(10).timerange=[1181;1780];
sws(11).timerange=[120 753 1150;610 800 1513];
sws(12).timerange=[0;0];
sws(13).timerange=[0;0];
sws(14).timerange=[0;0];
sws(15).timerange=[0;0];
sws(16).timerange=[0;0];
sws(17).timerange=[0;0];
sws(18).timerange=[0;0];
sws(19).timerange=[0;0];
sws(20).timerange=[0;0];


injection(1).timerange=[0;0];
injection(2).timerange=[0;0];
injection(3).timerange=[0;0];
injection(4).timerange=[0;0];
injection(5).timerange=[0;0];
injection(6).timerange=[0;0];
injection(7).timerange=[0;0];
injection(8).timerange=[0;0];
injection(9).timerange=[0;0];
injection(10).timerange=[0;0];
injection(11).timerange=[0;0];
injection(12).timerange=[540;1800];
injection(13).timerange=[0;1800];
injection(14).timerange=[0;1800];
injection(15).timerange=[0;1800];
injection(16).timerange=[0;0];
injection(17).timerange=[0;0];
injection(18).timerange=[0;0];
injection(19).timerange=[0;0];
injection(20).timerange=[0;0];




sig053a_rem=wave_timerange(sig053a,rem,'theta');
sig053a_explore=wave_timerange(sig053a,explore,'theta');
sig053a_sws=wave_timerange(sig053a,sws,'theta');
sig053a_injection=wave_timerange(sig053a,injection,'theta');
[cic_rem_sig053a,ts_rem_sig053a]=mixall(sig053a_rem);
[cic_explore_sig053a,ts_explore_sig053a]=mixall(sig053a_explore);
[cic_sws_sig053a,ts_sws_sig053a]=mixall(sig053a_sws);
[cic_injection_sig053a,ts_injection_sig053a]=mixall(sig053a_injection);
figure;
temp=cic_rem_sig053a;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig053a;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig053a;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig053a;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig053a_gamma','fig');



sig029a_rem=wave_timerange(sig029a,rem,'theta');
sig029a_explore=wave_timerange(sig029a,explore,'theta');
sig029a_sws=wave_timerange(sig029a,sws,'theta');
sig029a_injection=wave_timerange(sig029a,injection,'theta');
[cic_rem_sig029a,ts_rem_sig029a]=mixall(sig029a_rem);
[cic_explore_sig029a,ts_explore_sig029a]=mixall(sig029a_explore);
[cic_sws_sig029a,ts_sws_sig029a]=mixall(sig029a_sws);
[cic_injection_sig029a,ts_injection_sig029a]=mixall(sig029a_injection);
figure;
temp=cic_rem_sig029a;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig029a;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig029a;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig029a;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig029a_gamma','fig');

sig041a_rem=wave_timerange(sig041a,rem,'theta');
sig041a_explore=wave_timerange(sig041a,explore,'theta');
sig041a_sws=wave_timerange(sig041a,sws,'theta');
sig041a_injection=wave_timerange(sig041a,injection,'theta');
[cic_rem_sig041a,ts_rem_sig041a]=mixall(sig041a_rem);
[cic_explore_sig041a,ts_explore_sig041a]=mixall(sig041a_explore);
[cic_sws_sig041a,ts_sws_sig041a]=mixall(sig041a_sws);
[cic_injection_sig041a,ts_injection_sig041a]=mixall(sig041a_injection);
figure;
temp=cic_rem_sig041a;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig041a;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig041a;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig041a;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig041a_gamma','fig');


sig045a_rem=wave_timerange(sig045a,rem,'theta');
sig045a_explore=wave_timerange(sig045a,explore,'theta');
sig045a_sws=wave_timerange(sig045a,sws,'theta');
sig045a_injection=wave_timerange(sig045a,injection,'theta');
[cic_rem_sig045a,ts_rem_sig045a]=mixall(sig045a_rem);
[cic_explore_sig045a,ts_explore_sig045a]=mixall(sig045a_explore);
[cic_sws_sig045a,ts_sws_sig045a]=mixall(sig045a_sws);
[cic_injection_sig045a,ts_injection_sig045a]=mixall(sig045a_injection);
figure;
temp=cic_rem_sig045a;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig045a;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig045a;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig045a;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig045a_gamma','fig');






sig041b_rem=wave_timerange(sig041b,rem,'theta');
sig041b_explore=wave_timerange(sig041b,explore,'theta');
sig041b_sws=wave_timerange(sig041b,sws,'theta');
sig041b_injection=wave_timerange(sig041b,injection,'theta');
[cic_rem_sig041b,ts_rem_sig041b]=mixall(sig041b_rem);
[cic_explore_sig041b,ts_explore_sig041b]=mixall(sig041b_explore);
[cic_sws_sig041b,ts_sws_sig041b]=mixall(sig041b_sws);
[cic_injection_sig041b,ts_injection_sig041b]=mixall(sig041b_injection);
figure;
temp=cic_rem_sig041b;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig041b;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig041b;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig041b;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig041b_gamma','fig');





sig041c_rem=wave_timerange(sig041c,rem,'theta');
sig041c_explore=wave_timerange(sig041c,explore,'theta');
sig041c_sws=wave_timerange(sig041c,sws,'theta');
sig041c_injection=wave_timerange(sig041c,injection,'theta');
[cic_rem_sig041c,ts_rem_sig041c]=mixall(sig041c_rem);
[cic_explore_sig041c,ts_explore_sig041c]=mixall(sig041c_explore);
[cic_sws_sig041c,ts_sws_sig041c]=mixall(sig041c_sws);
[cic_injection_sig041c,ts_injection_sig041c]=mixall(sig041c_injection);
figure;
temp=cic_rem_sig041c;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig041c;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig041c;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig041c;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig041c_gamma','fig');




sig041d_rem=wave_timerange(sig041d,rem,'theta');
sig041d_explore=wave_timerange(sig041d,explore,'theta');
sig041d_sws=wave_timerange(sig041d,sws,'theta');
sig041d_injection=wave_timerange(sig041d,injection,'theta');
[cic_rem_sig041d,ts_rem_sig041d]=mixall(sig041d_rem);
[cic_explore_sig041d,ts_explore_sig041d]=mixall(sig041d_explore);
[cic_sws_sig041d,ts_sws_sig041d]=mixall(sig041d_sws);
[cic_injection_sig041d,ts_injection_sig041d]=mixall(sig041d_injection);
figure;
temp=cic_rem_sig041d;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig041d;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig041d;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig041d;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig041d_gamma','fig');




sig041e_rem=wave_timerange(sig041e,rem,'theta');
sig041e_explore=wave_timerange(sig041e,explore,'theta');
sig041e_sws=wave_timerange(sig041e,sws,'theta');
sig041e_injection=wave_timerange(sig041e,injection,'theta');
[cic_rem_sig041e,ts_rem_sig041e]=mixall(sig041e_rem);
[cic_explore_sig041e,ts_explore_sig041e]=mixall(sig041e_explore);
[cic_sws_sig041e,ts_sws_sig041e]=mixall(sig041e_sws);
[cic_injection_sig041e,ts_injection_sig041e]=mixall(sig041e_injection);
figure;
temp=cic_rem_sig041e;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig041e;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig041e;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig041e;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig041e_gamma','fig');






sig045b_rem=wave_timerange(sig045b,rem,'theta');
sig045b_explore=wave_timerange(sig045b,explore,'theta');
sig045b_sws=wave_timerange(sig045b,sws,'theta');
sig045b_injection=wave_timerange(sig045b,injection,'theta');
[cic_rem_sig045b,ts_rem_sig045b]=mixall(sig045b_rem);
[cic_explore_sig045b,ts_explore_sig045b]=mixall(sig045b_explore);
[cic_sws_sig045b,ts_sws_sig045b]=mixall(sig045b_sws);
[cic_injection_sig045b,ts_injection_sig045b]=mixall(sig045b_injection);
figure;
temp=cic_rem_sig045b;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig045b;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig045b;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig045b;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig045b_gamma','fig');








sig045c_rem=wave_timerange(sig045c,rem,'theta');
sig045c_explore=wave_timerange(sig045c,explore,'theta');
sig045c_sws=wave_timerange(sig045c,sws,'theta');
sig045c_injection=wave_timerange(sig045c,injection,'theta');
[cic_rem_sig045c,ts_rem_sig045c]=mixall(sig045c_rem);
[cic_explore_sig045c,ts_explore_sig045c]=mixall(sig045c_explore);
[cic_sws_sig045c,ts_sws_sig045c]=mixall(sig045c_sws);
[cic_injection_sig045c,ts_injection_sig045c]=mixall(sig045c_injection);
figure;
temp=cic_rem_sig045c;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig045c;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig045c;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig045c;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig045c_gamma','fig');







sig053b_rem=wave_timerange(sig053b,rem,'theta');
sig053b_explore=wave_timerange(sig053b,explore,'theta');
sig053b_sws=wave_timerange(sig053b,sws,'theta');
sig053b_injection=wave_timerange(sig053b,injection,'theta');
[cic_rem_sig053b,ts_rem_sig053b]=mixall(sig053b_rem);
[cic_explore_sig053b,ts_explore_sig053b]=mixall(sig053b_explore);
[cic_sws_sig053b,ts_sws_sig053b]=mixall(sig053b_sws);
[cic_injection_sig053b,ts_injection_sig053b]=mixall(sig053b_injection);
figure;
temp=cic_rem_sig053b;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig053b;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig053b;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig053b;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig053b_gamma','fig');









sig085a_rem=wave_timerange(sig085a,rem,'theta');
sig085a_explore=wave_timerange(sig085a,explore,'theta');
sig085a_sws=wave_timerange(sig085a,sws,'theta');
sig085a_injection=wave_timerange(sig085a,injection,'theta');
[cic_rem_sig085a,ts_rem_sig085a]=mixall(sig085a_rem);
[cic_explore_sig085a,ts_explore_sig085a]=mixall(sig085a_explore);
[cic_sws_sig085a,ts_sws_sig085a]=mixall(sig085a_sws);
[cic_injection_sig085a,ts_injection_sig085a]=mixall(sig085a_injection);
figure;
temp=cic_rem_sig085a;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig085a;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig085a;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig085a;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig085a_gamma','fig');





sig085b_rem=wave_timerange(sig085b,rem,'theta');
sig085b_explore=wave_timerange(sig085b,explore,'theta');
sig085b_sws=wave_timerange(sig085b,sws,'theta');
sig085b_injection=wave_timerange(sig085b,injection,'theta');
[cic_rem_sig085b,ts_rem_sig085b]=mixall(sig085b_rem);
[cic_explore_sig085b,ts_explore_sig085b]=mixall(sig085b_explore);
[cic_sws_sig085b,ts_sws_sig085b]=mixall(sig085b_sws);
[cic_injection_sig085b,ts_injection_sig085b]=mixall(sig085b_injection);
figure;
temp=cic_rem_sig085b;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig085b;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig085b;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig085b;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig085b_gamma','fig');






sig085c_rem=wave_timerange(sig085c,rem,'theta');
sig085c_explore=wave_timerange(sig085c,explore,'theta');
sig085c_sws=wave_timerange(sig085c,sws,'theta');
sig085c_injection=wave_timerange(sig085c,injection,'theta');
[cic_rem_sig085c,ts_rem_sig085c]=mixall(sig085c_rem);
[cic_explore_sig085c,ts_explore_sig085c]=mixall(sig085c_explore);
[cic_sws_sig085c,ts_sws_sig085c]=mixall(sig085c_sws);
[cic_injection_sig085c,ts_injection_sig085c]=mixall(sig085c_injection);
figure;
temp=cic_rem_sig085c;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig085c;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig085c;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig085c;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig085c_gamma','fig');







sig085d_rem=wave_timerange(sig085d,rem,'theta');
sig085d_explore=wave_timerange(sig085d,explore,'theta');
sig085d_sws=wave_timerange(sig085d,sws,'theta');
sig085d_injection=wave_timerange(sig085d,injection,'theta');
[cic_rem_sig085d,ts_rem_sig085d]=mixall(sig085d_rem);
[cic_explore_sig085d,ts_explore_sig085d]=mixall(sig085d_explore);
[cic_sws_sig085d,ts_sws_sig085d]=mixall(sig085d_sws);
[cic_injection_sig085d,ts_injection_sig085d]=mixall(sig085d_injection);
figure;
temp=cic_rem_sig085d;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig085d;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig085d;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig085d;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig085d_gamma','fig');




sig085e_rem=wave_timerange(sig085e,rem,'theta');
sig085e_explore=wave_timerange(sig085e,explore,'theta');
sig085e_sws=wave_timerange(sig085e,sws,'theta');
sig085e_injection=wave_timerange(sig085e,injection,'theta');
[cic_rem_sig085e,ts_rem_sig085e]=mixall(sig085e_rem);
[cic_explore_sig085e,ts_explore_sig085e]=mixall(sig085e_explore);
[cic_sws_sig085e,ts_sws_sig085e]=mixall(sig085e_sws);
[cic_injection_sig085e,ts_injection_sig085e]=mixall(sig085e_injection);
figure;
temp=cic_rem_sig085e;
subplot(4,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig085e;
subplot(4,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig085e;
subplot(4,1,3);hist([temp,temp+360],80);title('sws');
temp=cic_injection_sig085e;
subplot(4,1,4);hist([temp,temp+360],80);title('injection');
saveas(gca,'E:\brust theta\lab02\xk128\final_two_days\sig085e_gamma','fig');





save('E:\brust theta\lab02\xk128\final_two_days\data_gamma')
clear all