
nboot=1000;           %%%%%%%%%%%该test基于shuffle，nboot指shuffle次数.
path_filename='E:\research\data\lab01-21-091205\lab01-21-091205003-f.nex';

data_name='scsig089ats';
bin_width=0.0002;
isi_range=[0;0.02];  %%%%%%%%%%%isi范围,该范围不能太大,经测试0.02秒范围，0.0002秒bin宽的组合，比较能准确的测出是否单峰
timerange=[1;1200];

[isi_num,isi_bin,isi_num_all]=ISI_1(path_filename,data_name,timerange,bin_width,isi_range);
temp=smoothts(isi_num,'b',9);%%%%%%%%%%%isi原始数据，经过boxcar smooth之后,9个窗口的数据作平均,9这个参数也是经测试比较搭配0.02秒范围，0.0002秒bin宽的组合.smooth的原因是,原始isi分布不够光滑,有很多伪峰,影响判断.


figure;%%%%%%%%%%%%%%%%%%%%画出smooth之后的isi分布图
bar(temp)

[dip,p]=HartigansDipSignifTest(temp,nboot)   %%%%%%%%%%%%%%%%%%%%p值越大，说明isi分布越靠近单峰分布，因此， ripple2细胞的这个p值越小越好，比如0.01就达到显著性。
