function [cicular_sig,cicular_timestamps,cicular_ripple_index]=cicular_num_ripple2(sig,ripple_top,ripple_start,ripple_over)         %set up cicular number of sig according to wave%
t=sig;
tt=[];
ttt=[];



for i=1:length(ripple_top)-1
    invalidindex=find(ripple_over(i)<t&t<ripple_start(i+1));
    t(invalidindex)=[];
end


    ripple_m=length(ripple_top);
    for i=1:length(t)
       for j=1:ripple_m
           if t(i)>=ripple_start(j)&t(i)<ripple_top(j)
           tt(i)=180*(t(i)-ripple_start(j))/(ripple_top(j)-ripple_start(j));
           ttt(i)=j;
              break
           elseif t(i)<=ripple_over(j)&t(i)>=ripple_top(j)
              tt(i)=180*(t(i)-ripple_top(j))/(ripple_over(j)-ripple_top(j))+180;
               ttt(i)=j;
              break
           else
           tt(i)=-1;ttt(i)=-1;
           end
       end
    end

    
if isempty(tt)
    tt=[];
    t=[];
    ttt=[];
else   
invalidindex=find(tt==-1);
t(invalidindex)=[];
tt(invalidindex)=[];
ttt(invalidindex)=[];
end

cicular_sig=tt;
cicular_timestamps=t;
cicular_ripple_index=ttt;