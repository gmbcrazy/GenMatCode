
close all
sss=0:12;
for i=1:length(sss)
    if sss(i)<10
    filename=['E:\ripple\lab01-21-091205\final\lab01-21-09120500',num2str(sss(i)),'-f.nex'];

sig039a_ripple(i).final=cicular_common_ripple(filename,'scsig039ats','AD40ripple_ad_000',[0;1800]);
sig045a_ripple(i).final=cicular_common_ripple(filename,'scsig045ats','AD40ripple_ad_000',[0;1800]);
sig047a_ripple(i).final=cicular_common_ripple(filename,'scsig047ats','AD40ripple_ad_000',[0;1800]);
sig057a_ripple(i).final=cicular_common_ripple(filename,'scsig057ats','AD40ripple_ad_000',[0;1800]);
sig073a_ripple(i).final=cicular_common_ripple(filename,'scsig073ats','AD40ripple_ad_000',[0;1800]);
sig075a_ripple(i).final=cicular_common_ripple(filename,'scsig075ats','AD40ripple_ad_000',[0;1800]);
sig079a_ripple(i).final=cicular_common_ripple(filename,'scsig079ats','AD40ripple_ad_000',[0;1800]);
sig083a_ripple(i).final=cicular_common_ripple(filename,'scsig083ats','AD40ripple_ad_000',[0;1800]);
sig087a_ripple(i).final=cicular_common_ripple(filename,'scsig087ats','AD40ripple_ad_000',[0;1800]);
sig089a_ripple(i).final=cicular_common_ripple(filename,'scsig089ats','AD40ripple_ad_000',[0;1800]);
sig093a_ripple(i).final=cicular_common_ripple(filename,'scsig093ats','AD40ripple_ad_000',[0;1800]);


else
    
    filename=['E:\ripple\lab01-21-091205\final\lab01-21-0912050',num2str(sss(i)),'-f.nex'];
    

sig039a_ripple(i).final=cicular_common_ripple(filename,'scsig039ats','AD40ripple_ad_000',[0;1800]);
sig045a_ripple(i).final=cicular_common_ripple(filename,'scsig045ats','AD40ripple_ad_000',[0;1800]);
sig047a_ripple(i).final=cicular_common_ripple(filename,'scsig047ats','AD40ripple_ad_000',[0;1800]);
sig057a_ripple(i).final=cicular_common_ripple(filename,'scsig057ats','AD40ripple_ad_000',[0;1800]);
sig073a_ripple(i).final=cicular_common_ripple(filename,'scsig073ats','AD40ripple_ad_000',[0;1800]);
sig075a_ripple(i).final=cicular_common_ripple(filename,'scsig075ats','AD40ripple_ad_000',[0;1800]);
sig079a_ripple(i).final=cicular_common_ripple(filename,'scsig079ats','AD40ripple_ad_000',[0;1800]);
sig083a_ripple(i).final=cicular_common_ripple(filename,'scsig083ats','AD40ripple_ad_000',[0;1800]);
sig087a_ripple(i).final=cicular_common_ripple(filename,'scsig087ats','AD40ripple_ad_000',[0;1800]);
sig089a_ripple(i).final=cicular_common_ripple(filename,'scsig089ats','AD40ripple_ad_000',[0;1800]);
sig093a_ripple(i).final=cicular_common_ripple(filename,'scsig093ats','AD40ripple_ad_000',[0;1800]);



end


end
explore_theta(1).timerange=[600;900];;
explore_theta(2).timerange=[0;0];
explore_theta(3).timerange=[0;0];
explore_theta(4).timerange=[480;540];
explore_theta(5).timerange=[0;0];
explore_theta(6).timerange=[0;0];
explore_theta(7).timerange=[0;0];
explore_theta(8).timerange=[0;0];
explore_theta(9).timerange=[0;0];
explore_theta(10).timerange=[390 1086;600 1146];
explore_theta(11).timerange=[0;0];
explore_theta(12).timerange=[0;0];
explore_theta(13).timerange=[270 470;320 570];



rem_theta(1).timerange=[0;0];
rem_theta(2).timerange=[0;0];
rem_theta(3).timerange=[180;290];
rem_theta(4).timerange=[0;88];
rem_theta(5).timerange=[670 1100;755 1136];
rem_theta(6).timerange=[620;668];
rem_theta(7).timerange=[395 1120;490 1162];
rem_theta(8).timerange=[395 710;458 810];
rem_theta(9).timerange=[170 820;206 940];
rem_theta(10).timerange=[0;0];
rem_theta(11).timerange=[935;1008];
rem_theta(12).timerange=[306 830 925;376 888 960];
rem_theta(13).timerange=[0;0];

sws(1).timerange=[0;0];
sws(2).timerange=[250,670;420,800];
sws(3).timerange=[0,360,660,900,1065;150,600,780,1000,1200];
sws(4).timerange=[1050;1150];
sws(5).timerange=[280,788;650,1050];
sws(6).timerange=[90,403,530;280,500,600];
sws(7).timerange=[60,540,780;380,750,960];
sws(8).timerange=[140,510,900;226,670,1020];
sws(9).timerange=[230,440,570,1075;365,530,700,1150];
sws(10).timerange=[0;0];
sws(11).timerange=[840;910];
sws(12).timerange=[90,420;260,760];
sws(13).timerange=[0;0];

sig039a_rem=wave_timerange(sig039a_ripple,rem_theta,'theta');
sig039a_explore=wave_timerange(sig039a_ripple,explore_theta,'theta');
sig039a_sws=wave_timerange(sig039a_ripple,sws,'theta');
[cic_rem_sig039a,ts_rem_sig039a]=mixall(sig039a_rem);
[cic_explore_sig039a,ts_explore_sig039a]=mixall(sig039a_explore);
[cic_sws_sig039a,ts_sws_sig039a]=mixall(sig039a_sws);
figure;
temp=cic_rem_sig039a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig039a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig039a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');


sig045a_rem=wave_timerange(sig045a_ripple,rem_theta,'theta');
sig045a_explore=wave_timerange(sig045a_ripple,explore_theta,'theta');
sig045a_sws=wave_timerange(sig045a_ripple,sws,'theta');
[cic_rem_sig045a,ts_rem_sig045a]=mixall(sig045a_rem);
[cic_explore_sig045a,ts_explore_sig045a]=mixall(sig045a_explore);
[cic_sws_sig045a,ts_sws_sig045a]=mixall(sig045a_sws);
figure;
temp=cic_rem_sig045a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig045a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig045a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');



sig047a_rem=wave_timerange(sig047a_ripple,rem_theta,'theta');
sig047a_explore=wave_timerange(sig047a_ripple,explore_theta,'theta');
sig047a_sws=wave_timerange(sig047a_ripple,sws,'theta');
[cic_rem_sig047a,ts_rem_sig047a]=mixall(sig047a_rem);
[cic_explore_sig047a,ts_explore_sig047a]=mixall(sig047a_explore);
[cic_sws_sig047a,ts_sws_sig047a]=mixall(sig047a_sws);
figure;
temp=cic_rem_sig047a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig047a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig047a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');



sig057a_rem=wave_timerange(sig057a_ripple,rem_theta,'theta');
sig057a_explore=wave_timerange(sig057a_ripple,explore_theta,'theta');
sig057a_sws=wave_timerange(sig057a_ripple,sws,'theta');
[cic_rem_sig057a,ts_rem_sig057a]=mixall(sig057a_rem);
[cic_explore_sig057a,ts_explore_sig057a]=mixall(sig057a_explore);
[cic_sws_sig057a,ts_sws_sig057a]=mixall(sig057a_sws);
figure;
temp=cic_rem_sig057a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig057a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig057a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');



sig073a_rem=wave_timerange(sig073a_ripple,rem_theta,'theta');
sig073a_explore=wave_timerange(sig073a_ripple,explore_theta,'theta');
sig073a_sws=wave_timerange(sig073a_ripple,sws,'theta');
[cic_rem_sig073a,ts_rem_sig073a]=mixall(sig073a_rem);
[cic_explore_sig073a,ts_explore_sig073a]=mixall(sig073a_explore);
[cic_sws_sig073a,ts_sws_sig073a]=mixall(sig073a_sws);
figure;
temp=cic_rem_sig073a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig073a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig073a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');



sig075a_rem=wave_timerange(sig075a_ripple,rem_theta,'theta');
sig075a_explore=wave_timerange(sig075a_ripple,explore_theta,'theta');
sig075a_sws=wave_timerange(sig075a_ripple,sws,'theta');
[cic_rem_sig075a,ts_rem_sig075a]=mixall(sig075a_rem);
[cic_explore_sig075a,ts_explore_sig075a]=mixall(sig075a_explore);
[cic_sws_sig075a,ts_sws_sig075a]=mixall(sig075a_sws);
figure;
temp=cic_rem_sig075a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig075a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig075a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');



sig079a_rem=wave_timerange(sig079a_ripple,rem_theta,'theta');
sig079a_explore=wave_timerange(sig079a_ripple,explore_theta,'theta');
sig079a_sws=wave_timerange(sig079a_ripple,sws,'theta');
[cic_rem_sig079a,ts_rem_sig079a]=mixall(sig079a_rem);
[cic_explore_sig079a,ts_explore_sig079a]=mixall(sig079a_explore);
[cic_sws_sig079a,ts_sws_sig079a]=mixall(sig079a_sws);
figure;
temp=cic_rem_sig079a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig079a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig079a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');




sig083a_rem=wave_timerange(sig083a_ripple,rem_theta,'theta');
sig083a_explore=wave_timerange(sig083a_ripple,explore_theta,'theta');
sig083a_sws=wave_timerange(sig083a_ripple,sws,'theta');
[cic_rem_sig083a,ts_rem_sig083a]=mixall(sig083a_rem);
[cic_explore_sig083a,ts_explore_sig083a]=mixall(sig083a_explore);
[cic_sws_sig083a,ts_sws_sig083a]=mixall(sig083a_sws);
figure;
temp=cic_rem_sig083a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig083a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig083a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');




sig087a_rem=wave_timerange(sig087a_ripple,rem_theta,'theta');
sig087a_explore=wave_timerange(sig087a_ripple,explore_theta,'theta');
sig087a_sws=wave_timerange(sig087a_ripple,sws,'theta');
[cic_rem_sig087a,ts_rem_sig087a]=mixall(sig087a_rem);
[cic_explore_sig087a,ts_explore_sig087a]=mixall(sig087a_explore);
[cic_sws_sig087a,ts_sws_sig087a]=mixall(sig087a_sws);
figure;
temp=cic_rem_sig087a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig087a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig087a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');




sig089a_rem=wave_timerange(sig089a_ripple,rem_theta,'theta');
sig089a_explore=wave_timerange(sig089a_ripple,explore_theta,'theta');
sig089a_sws=wave_timerange(sig089a_ripple,sws,'theta');
[cic_rem_sig089a,ts_rem_sig089a]=mixall(sig089a_rem);
[cic_explore_sig089a,ts_explore_sig089a]=mixall(sig089a_explore);
[cic_sws_sig089a,ts_sws_sig089a]=mixall(sig089a_sws);
figure;
temp=cic_rem_sig089a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig089a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig089a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');




sig093a_rem=wave_timerange(sig093a_ripple,rem_theta,'theta');
sig093a_explore=wave_timerange(sig093a_ripple,explore_theta,'theta');
sig093a_sws=wave_timerange(sig093a_ripple,sws,'theta');
[cic_rem_sig093a,ts_rem_sig093a]=mixall(sig093a_rem);
[cic_explore_sig093a,ts_explore_sig093a]=mixall(sig093a_explore);
[cic_sws_sig093a,ts_sws_sig093a]=mixall(sig093a_sws);
figure;
temp=cic_rem_sig093a;
subplot(3,1,1);hist([temp,temp+360],80);title('rem');
temp=cic_explore_sig093a;
subplot(3,1,2);hist([temp,temp+360],80);title('explore');
temp=cic_sws_sig093a;
subplot(3,1,3);hist([temp,temp+360],80);title('sws');


