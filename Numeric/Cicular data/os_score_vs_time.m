function [score,time]=os_score_vs_time(path_name,sig,timerange,window_length,step,fre_band)

[n, time_ts_all] = nex_ts(path_name,sig);


step_num=floor((diff(timerange)-window_length)/step);
time=(timerange(1)+window_length/2):step:timerange(1)+window_length/2+step*(step_num-1);

for j=1:step_num
    t_s=timerange(1)+step*(j-1);
    t_e=t_s+window_length;
    time_ts=time_ts_all(find(time_ts_all>=t_s&time_ts_all<t_e));
% time_ts=ts_sws_sig053a';
time_ts=time_ts*1000;


iTrialLength=1000000000;        %Suppose we have a sampling frequency of 1 Khz. We choose a trial length of 1000000ms.
fc=1000;

fmax=fre_band(2);
fmin=fre_band(1);
w=2^(floor(max(log2(3*fc/fmin),log2(fc/4)))+1);
sgm_fast=min(2,134/(1.5*fmax))*fc/1000.0;

sgm_slow=2*134/(1.5*fmin)*fc/1000.0;


ach = ComputeClassicCC_DD(w,iTrialLength,time_ts,time_ts,0);
s1=smoothts(ach,'g',2*w,sgm_fast);
s2=smoothts(ach,'g',2*w,sgm_slow);
% plot(s1);hold on;plot(s2,'r.');

i=w+1;
slope=10;
t_left=1;
while i>1
    slope=(s2(i)-s2(i-1))*w/s2(w+1);
    if slope<=tan(pi*10/180)
       t_left=i;
       break
   end
       i=i-1;
 
end

t_right=w+1-t_left+w+1;

s1(t_left:t_right)=s1(t_left);


Y = fft(s1,length(s1));
f = 1000*(0:w)/length(s1);
Y=abs(Y(1:length(f)));


score(j)=max(Y(find(f>fmin&f<fmax)))/mean(Y);
end







