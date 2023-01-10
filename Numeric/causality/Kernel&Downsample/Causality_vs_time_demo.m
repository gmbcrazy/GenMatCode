clear all
data_name(1).Name='scsig053ats';
data_name(2).Name='AD27_ad_000';
timerange=[0;1800];
window_length=20;
step=5;

path_filename='J:\6-xk128\103005\nex_1_finish\lab02-xk128-103005006-f.nex';

CausalityParameter.MORDER_band=[10;10];
CausalityParameter.fre_band=[0;50];
CausalityParameter.NFFT=512;
CausalityParameter.fs=1000;
CausalityParameter.downsample=10;

[cau,time]=Causality_vs_time_Pair(path_filename,data_name,timerange,window_length,step,CausalityParameter);
cau_all1to2=[];
cau_all2to1=[];

for i=1:length(cau)
    cau_all1to2=[cau_all1to2,cau(i).Data.I1to2'];
    cau_all2to1=[cau_all2to1,cau(i).Data.I2to1'];

end
figure;
subplot(2,1,1);imagesc(time,cau(1).Data.F,cau_all1to2);axis xy;title('causality vs time 1 to 2');
subplot(2,1,2);imagesc(time,cau(1).Data.F,cau_all2to1);axis xy;title('causality vs time 2 to 1');

