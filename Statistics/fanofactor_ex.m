spike=exprnd(0.005,1,5000);  
spike(find(spike<0.0015))=[];
spike_timestamps(1)=0.02;
   for i=1:length(spike)
       spike_timestamps(i+1)=spike_timestamps(1)+sum(spike(1:i));
   end
   
   
   
   spike_timestamps(length(spike_timestamps))
   
 
   
   
t=0.001:0.001:0.03;

for i=1:length(t)
       y(i)=fanofactor(ts_ex_sig049a,t(i),[4180,4210]);
       
end 



plot(t,y,'*');
     
