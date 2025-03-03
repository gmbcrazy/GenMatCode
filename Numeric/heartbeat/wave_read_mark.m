function [ts,wave,time]=wave_read_mark(path_file)
%%%%%%%%%demo
%[ts,wave,time]=wave_read_mark('D:\my program\heartbeat\test.txt');
%%%%%%%%%demo
tic
q=fopen(path_file);
wave=[];
time=[];
i=1;
fseek(q,0,1);over_file=ftell(q);fseek(q,0,-1);

while ftell(q)<over_file
     tline= str2num(fgets(q,17));
     wave(i)=tline(1,2);
     time(i)=tline(1,1);
     fseek(q,2,0);
%      wave=[wave;tline(1,2)];
%      time=[time;tline(1,1)];
i=i+1;
 end
     
     fclose(q);
toc
tic
diff_data=diff(wave);     
temp_p=find(diff_data>0.05);
for i=1:length(temp_p)
    temp_q=temp_p(i);
    temp_point=temp_q;
    while temp_point>0
          if diff_data(temp_point)>0
              temp_point=temp_point-1;
          else
              break
          end
      end
     [temp_data,point(i)]=min(wave((temp_point-5):(temp_point+5)));
     point(i)=temp_point-8+point(i)-1;
        
end
toc
ts=time(point);



    