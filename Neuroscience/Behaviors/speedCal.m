function v = speedCal(Input,t)

if size(Input,2)==2
   x=Input(:,1);
   y=Input(:,2);
   
elseif size(Input,2)==1
   x=Input(:,1);
   y=zeros(size(Input));
else
   'Input Data should be T*1, or T*2 size; Time samples in rows'

end
N = length(x);
M = length(t);

if N < M
    x = x(1:N);
    y = y(1:N);
    t = t(1:N);
end
if N > M
    x = x(1:M);
    y = y(1:M);
    t = t(1:M);
end

v = zeros(min([N,M]),1,'single');

v=sqrt((diff(y(:)).^2+diff(x(:)).^2))./diff(t(:));
v=[v(:);0];

