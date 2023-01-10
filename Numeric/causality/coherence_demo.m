bin_width=0.002;
step=2000;
com_num=100;
[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\09.nex','scsig045ats','AD27_ad_000',[0;1800],bin_width);

coherence(data,Ref,step,com_num,bin_width)




[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig045ats','AD27_ad_000',[874;980],bin_width);


[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig045ats','AD27_ad_000',[200;300],bin_width);


[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig045ats','AD27_ad_000',[1300;1400],bin_width);




[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig029ats','AD27_ad_000',[874;980],bin_width);


[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig029ats','AD27_ad_000',[200;300],bin_width);


[data,data_shuffle,f]=coherence_data_read('E:\research\data\xk128\final_two_days\11.nex','scsig029ats','AD27_ad_000',[1300;1400],bin_width);


R_1=zeros(1,2*length(Ref));
data_1=zeros(1,2*length(data));

R_1(1:2:2*length(Ref))=Ref;
R_1(2:2:2*length(Ref))=Ref;

data_1(1:2:2*length(data))=data;
data_1(2:2:2*length(data))=data;
[Cxy,f] = cohere(data_1,R_1,1024,2000,'linear');plot(f,Cxy);


Cxy=[];
% for i=1:195
%     start=(i-1)*1024+1;
%     over=i*1024;
%     [Cxy_temp,f_temp] = cohere(data(start:over),Ref(start:over),512,1000,'linear');
%     Cxy=[Cxy;Cxy_temp'];
% end
% q=mean(Cxy);
% plot(f_temp,q);


[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\06.nex','scsig045ats','AD27_ad_000',[485 860;585 910],0.001);


[Cxy,f]=coherence_data_read('E:\research\data\xk128\final_two_days\06.nex','scsig029ats','AD27_ad_000',[485 860;585 910],0.001);











[data,Ref]=coherence_data_read('E:\single theta\050622\050622plx\nex\lab01-17-062205002.nex','sig033a','AD17',[0;200],0.001);





