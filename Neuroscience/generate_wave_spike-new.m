%%%% sent select variables to matlab, ts and wf

chn=4; %%%% tetrode:4 stereotrode:2
no=3;  %%%%%% select one spike channel. 
sig = sig049a_wf;   %%%%%%%%%input waveform
ts = sig049a_wf_ts;   %%%%%%%%%input timestamps
[m n] = size(sig);

%n=20000;

m=fix(m/chn);
sig=sig((no-1)*m+1:no*m,:);  %%%%%%%%%%%% 
a=max(sig);%%%%max of every waveform
pmax=max(a);%max of all waveform
b=abs(min(sig));%max of every waveform
nmax=max(b);%min of all waveform
if pmax>nmax
    rate=0.8/pmax;
    for i=1:n
        sig(:,i)=rate*sig(:,i);
    end
else
    rate=0.8/nmax;
    for i=1:n
        sig(:,i)=rate*sig(:,i);
    end
end


lw=round(22050*ts(n));
wavedata=zeros(1,lw);
%clear sig065a_wf;
for ii=1:n-1
    position=round(22050*ts(ii));
    for jj=1:m
        wavedata(position+jj)=sig(jj,ii);
    end
end
wavwrite(wavedata,22050,16,'d:\130608008-49a.wav'); 


