%%%% sent select variables to matlab, ts and wf
[adfreq, n, ts, nf, sig] = nex_wf('E:\cell report\my paper_nature\paper graph1\graph1\xk128\lab02-xk128-103005005.nex', 'sig053a_wf');
[n, ts] = nex_ts('E:\cell report\my paper_nature\paper graph1\graph1\xk128\lab02-xk128-103005005-f.nex', 'scsig053ats');
chn=4; %%%% tetrode:4 stereotrode:2
no=2;  %%%%%% select one spike channel. 
% sig =sig083a_wf;   %%%%%%%%%input
% ts = scsig083ats;   %%%%%%%%%input
[m n] = size(sig);

%n=16730;

m=fix(m/chn);
sig=sig((no-1)*m+1:no*m,:);  %%%%%%%%%%%% 

a=max(sig);%%%%
b=min(sig);
srate=0.618;
for i=1:n
    rate=abs(a(i)/b(i));
    while rate>srate
        sig(:,i)=sig(:,i)-0.001;
        a(i)=a(i)-0.001;
        b(i)=b(i)-0.001;
        rate=abs(a(i)/b(i));
    end
    while rate<srate
        sig(:,i)=sig(:,i)+0.001;
        a(i)=a(i)+0.001;
        b(i)=b(i)+0.001;
        rate=abs(a(i)/b(i));
    end
end
mmax = max(max(sig));
mmin = min(min(sig));
plus=mean(sig(1,:));
ampl=-mmin+0.04;
sig=sig/ampl;
plus_vector=sig(1,:);
plus_o=mean(plus_vector);
std_o=std(plus_vector);
plus_vector(find(abs(plus_vector-plus_o)>2*std_o))=[];
plus_o=mean(plus_vector);
sig=sig-plus_o;


lw=round(22050*ts(n));
wavedata=zeros(1,lw);
%clear sig065a_wf;
for ii=1:n-1
    position=round(22050*ts(ii));
%     for jj=1:m
%         wavedata(position+jj)=sig(jj,ii);
        wavedata(position+1:position+m)=sig(1:m,ii);
%     end
end

wavwrite(wavedata,22050,16,'E:\cell report\my paper_nature\paper graph1\graph1\xk128\file05_sig053a.wav'); 



[adfreq, n, ts, fn, ad] = nex_cont('E:\cell report\my paper_nature\paper graph1\graph1\xk128\lab02-xk128-103005005-f.nex', 'AD27ripple_ad_000');
% output FP
wavedata=ad;
% a=min(ad);
% a=abs(a);
% b=max(ad);
% b=abs(b);
% s=[a b];
% rate=max(s);
% wavedata=0.9*ad/rate;

wavwrite(wavedata,1000,16,'E:\cell report\my paper_nature\paper graph1\graph1\xk128\file05_try.wav');