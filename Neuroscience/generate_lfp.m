n=size(AD27_ad_000);
y=zeros(n(1),2);
y(:,1)=AD27_ad_000;
%y(:,2)=AD03ripple_ad_000;
y(:,2)=AD27theta_ad_000;
s=size(y);

a=max(y(:,1));%%%%
b=min(y(:,1));
if abs(a)>abs(b)
    ratio=abs(a);
else
    ratio=abs(b);
end
ratio=0.8/ratio;
for i=1:s(1)
    y(i,1)=ratio*y(i,1);
end

a=max(y(:,2));%%%%
b=min(y(:,2));
if abs(a)>abs(b)
    ratio=abs(a);
else
    ratio=abs(b);
end
ratio=0.8/ratio;
for i=1:s(1)
    y(i,2)=ratio*y(i,2);
end
%wavwrite(y,1000,16,'d:\ripple-03.wav');
wavwrite(y,1000,16,'e:\data\theta27-1.wav');