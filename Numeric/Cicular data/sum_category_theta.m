% function  [mean_phase,std_phase]=sum_category_theta(cic,hist_num)
function  [phase,data_skewness,data_kurtosis]=sum_category_theta(cic,hist_num)

proall=zeros(1,hist_num);
for i=1:length(cic)
  [count(i).data,value(i).data]=hist([cic(i).data,cic(i).data+360],hist_num);
  pro(i).data=2*count(i).data/sum(count(i).data);
  [mean_std,data_skewness(i),data_kurtosis(i)]=main_phase_interval(cic(i).data,30,12);
  phase(i)=mean_std(1);
  proall=proall+pro(i).data;
end
phase=mod(phase,360)';data_skewness=data_skewness';data_kurtosis=data_kurtosis';
proall=proall/length(cic);

subplot(2,1,1);
h_temp=bar(linspace(1.5,hist_num-0.5,hist_num),proall,'r');
set(h_temp,'LineStyle','none');
hold on

% set(patch,'LineStyle','none')

for i=1:length(cic)
h_temp=plot([1:hist_num],pro(i).data,'b');
set(h_temp,'LineWidth',2);
hold on
end

h1=gca;
set(h1,'XLimMode','man');
set(h1,'XTickMode','man');
set(h1,'XTickLabelMode','man');

set(h1,'XLim',[1 hist_num]);
set(h1,'XTick',[1 hist_num/2+0.5 hist_num]);
set(h1,'XTickLabel',['0  ';'360';'720']);


subplot(2,1,2);

x=linspace(-pi,3*pi,4*hist_num);
y=cos(x);
h_temp=plot([1:4*hist_num],y);
set(h_temp,'LineWidth',2);

h2=gca;
set(h2,'XLimMode','man');
set(h2,'XTickMode','man');
set(h2,'XTickLabelMode','man');

set(h2,'XLim',[1 4*hist_num]);
set(h2,'XTick',[1 2*hist_num+0.5 4*hist_num]);
set(h2,'XTickLabel',['0  ';'360';'720']);

mean_phase=mod(mean(phase),360);
std_phase=std(phase);

