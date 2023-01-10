for i=1:5
for j=1:18
    t=(i-1)*18+j;
    [cicular_sigFile(t).Data,cicular_sigFile(t).Timestamps]=cicular_num(theta(i).Timestamps,sig(j).Timestamps);
    figure(t);hist(cicular_sigFile(t).Data,36);
end
end



for i=1:6
    j=4;
    t=i;
    [cicular_sigFile(t).Data,cicular_sigFile(t).Timestamps]=cicular_num(theta(i).Timestamps,sig(j).Timestamps);
    figure(t);hist(cicular_sigFile(t).Data,36);
    
end
