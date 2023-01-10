% clear all;close all
path_filename='E:\my program\causality\causality threhold\lab04-niu405-160608000-f.nex';
path_filename='D:\ZZ_Day12_20120826_DLS_done.nex'
timerange=[605;665];
CausalityParameter.MORDER_band=[10;10];  %%%%order of prediction model
CausalityParameter.fre_band=[0;250];     %%%%frequency band to compute
CausalityParameter.NFFT=512;             %%%%NFFT
CausalityParameter.fs=1000;              %%%%sampling rate
CausalityParameter.downsample=2;         %%%%downsampling rate

% 
Data_name(1).Name='scsig079U_1';
Data_name(2).Name='scsig077U_2';
% 
% % [Data]=smrORnex_cont(path_filename,Data_name(1).Name,timerange);


causality_theta=Causality_Pair(path_filename,Data_name,timerange,CausalityParameter);
figure;plot(causality_theta.F,causality_theta.I1to2,'b',causality_theta.F,causality_theta.I2to1,'r');
