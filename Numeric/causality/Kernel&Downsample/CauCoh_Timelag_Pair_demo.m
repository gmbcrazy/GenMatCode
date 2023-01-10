clear all
data_name(1).Name='scsig053ats';
data_name(2).Name='AD27_ad_000';
timerange=[0;1800];
window_length=20;
step=5;
NFFT=512;
fre_band=[0;100];
MORDER_band=[22;22];
downsample=5;


filename='J:\6-xk128\103005\nex_1_finish\lab02-xk128-103005006-f.nex';
[cau,time]=Causality_vs_time_Pair(filename,data_name,timerange,window_length,step,NFFT,fre_band,MORDER_band,downsample);
% [Cxy,f,time]=cohere_vs_time2(filename,data_name,timerange,window_length,step,NFFT);
% f_index=find(f>=fre_band(1)&f<=fre_band(2));
cau_all1to2=[];
cau_all2to1=[];

for i=1:length(cau)
    cau_all1to2=[cau_all1to2,cau(i).Data.F1to2'];
    cau_all2to1=[cau_all2to1,cau(i).Data.F2to1'];

end
figure;
imagesc(time,cau(1).Data.F,cau_all1to2);axis xy;title('causality vs time 1 to 2');
set(gca,'ylim',[0 50])



figure;
imagesc(time,f,Cxy);axis([min(time) max(time) fre_band(1) fre_band(2)]);axis xy;title('coherence vs time');
[x,y]=meshgrid(time,f);
surf(x,y,Cxy);
set(get(gca,'children'),'edgealph',0)