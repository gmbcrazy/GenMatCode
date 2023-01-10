function [cicular_sig,cicular_timestamps,cicular_ripple_index]=cicular_num_ripple(wave,sig,ripple_normalize,normalize_range)         %set up cicular number of sig according to wave%


%normalize_range(1) is the start time of the normlize data of wave,normalize_range(2) is the end time of the normlize data of wave%
%if cicular_ripple_index(i)=j,it means that the ith spike belongs to the jth ripple wave%

t=sig;
tt=[];
ttt=[];
t(find(t<normalize_range(1)))=[];
t(find(t>normalize_range(2)))=[];


qq=floor(normalize_range(1)*1000);
mm=floor(normalize_range(2)*1000);




for i=1:length(wave)
    ripple_max=wave(i);
    startpoint=floor(ripple_max*1000);
    
    q=startpoint;
    while (~(ripple_normalize(q)==0&ripple_normalize(q+1)==0))&q<mm
          q=q+1;
    end
    ripple_end(i)=q/1000;
    
    
    
    
    q=startpoint;
    while (~(ripple_normalize(q)==0&ripple_normalize(q-1)==0))&q>qq
          q=q-1;
    end
    ripple_start(i)=q/1000;
end
  


for i=1:length(wave)-1
    invalidindex=find(ripple_end(i)<t&t<ripple_start(i+1));
    t(invalidindex)=[];
end









    m=length(wave);
    for i=1:length(t)
       for j=1:m
           if t(i)>=ripple_start(j)&t(i)<wave(j)
           tt(i)=180*(t(i)-ripple_start(j))/(wave(j)-ripple_start(j));
           ttt(i)=j;
              break
           elseif t(i)<=ripple_end(j)&t(i)>=wave(j)
              tt(i)=180*(t(i)-wave(j))/(ripple_end(j)-wave(j))+180;
               ttt(i)=j;
              break
           else
           tt(i)=-1;ttt(i)=-1;
           end
       end
    end

    
if tt==[]
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