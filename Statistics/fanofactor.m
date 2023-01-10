function y=fanofactor(sig,T,timerange)
%fano factor F(T)=var(N(T))/mean(N(T))
%here we divid timerange of sig into several nonoverlapping windows ,and the length of
%which is T
 
for i=1:floor((timerange(2)-timerange(1))/T)
    N(i)=length(find(sig>=(timerange(1)+(i-1)*T)&sig<(timerange(1)+i*T)));
end

y=std(N)^2/mean(N);
