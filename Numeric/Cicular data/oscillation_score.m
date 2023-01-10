function score=oscillation_score(spike,band,fc)

[m,n]=size(spike);
if m~=1
spike=spike';
end
spike=spike*1000;

iTrialLength=1000000000;        %Suppose we have a sampling frequency of 1 Khz. We choose a trial length of 4000 ms.

fmax=band(2);
fmin=band(1);
w=2^(floor(max(log2(3*fc/fmin),log2(fc/4)))+1);
sgm_fast=min(2,134/(1.5*fmax))*fc/1000.0;

sgm_slow=2*134/(1.5*fmin)*fc/1000.0;


ach = ComputeClassicCC_DD(w,iTrialLength,spike,spike,1);
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
f = fc*(0:w)/length(s1);
Y=abs(Y(1:length(f)));


score=max(Y(find(f>fmin&f<fmax)))/mean(Y);
