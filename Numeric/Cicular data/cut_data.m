function [data_x,data_y,q]=cut_data(data_cic,data_ts,fore_end,back_end)
%data is a struct data that we need data.Data and data.Timestamps
%q is the index of data_x in data.Timestamps,and q+1 is also the index of data_y in data.Timestamps
m=diff(data_ts);
q=find(m<back_end&m>fore_end);
data_x=data_cic(q);
data_y=data_cic(q+1);
