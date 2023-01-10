function [width_index,duration_index]=wave_width_exp(wave)


%%%%%%%%%1/e negative peak was chosen as the threshold
[tough,n]=min(wave);
[peak,m]=max(wave(n:length(wave)));
duration_index=m+1;
clear m n peak tough

[m,n]=min(wave);
while n==length(wave)||n==1
    wave(n)=0;
    [m,n]=min(wave);
    if n==length(wave)||n==1
        width_index=-1;
        return
    end
end
tv=m/exp(1);

i=n-1;
%while i>1&wave(i)<m/2
while i>1&&wave(i)<tv
    i=i-1;
end



start1=i+1;
if wave(i)>wave(i+1);
   start_patch=abs((tv-wave(i+1))/(wave(i)-wave(i+1)));
else
   width_index=-1;
   return
end


i=n+1;
while i<(length(wave)-1)&&wave(i)<tv
    i=i+1;
end

end1=i-1;
if wave(i-1)<wave(i);
   end_patch=abs((tv-wave(i-1))/(wave(i)-wave(i-1)));
else
   width_index=-1;
   return
end



width_index=end1-start1+start_patch+end_patch+1;




