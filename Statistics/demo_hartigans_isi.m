
nboot=1000;           %%%%%%%%%%%��test����shuffle��nbootָshuffle����.
path_filename='E:\research\data\lab01-21-091205\lab01-21-091205003-f.nex';

data_name='scsig089ats';
bin_width=0.0002;
isi_range=[0;0.02];  %%%%%%%%%%%isi��Χ,�÷�Χ����̫��,������0.02�뷶Χ��0.0002��bin�����ϣ��Ƚ���׼ȷ�Ĳ���Ƿ񵥷�
timerange=[1;1200];

[isi_num,isi_bin,isi_num_all]=ISI_1(path_filename,data_name,timerange,bin_width,isi_range);
temp=smoothts(isi_num,'b',9);%%%%%%%%%%%isiԭʼ���ݣ�����boxcar smooth֮��,9�����ڵ�������ƽ��,9�������Ҳ�Ǿ����ԱȽϴ���0.02�뷶Χ��0.0002��bin������.smooth��ԭ����,ԭʼisi�ֲ������⻬,�кܶ�α��,Ӱ���ж�.


figure;%%%%%%%%%%%%%%%%%%%%����smooth֮���isi�ֲ�ͼ
bar(temp)

[dip,p]=HartigansDipSignifTest(temp,nboot)   %%%%%%%%%%%%%%%%%%%%pֵԽ��˵��isi�ֲ�Խ��������ֲ�����ˣ� ripple2ϸ�������pֵԽСԽ�ã�����0.01�ʹﵽ�����ԡ�
