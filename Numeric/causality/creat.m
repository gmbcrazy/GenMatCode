Data_name(1).Name='AD27';
Data_name(2).Name='AD34';
Data_name(3).Name='AD40';
% Data_name(4).Name='sig057a';

% Data_name(3).Name='AD34';
% % Data_name(4).Name='AD44';
m=12;
time_start=200:10:300;
time_over=time_start+10;
for i=1:length(time_start)
    timerange=[time_start(i),time_over(i)];
    for source_index=1:length(Data_name)
        for result_index=1:length(Data_name)
           if result_index~=source_index
              causality(i,source_index,result_index)=causality_file('E:\ripple\lab01-21-091205\lab01-21-091205002.nex',Data_name,source_index,result_index,m,timerange);
           else 
           causality(i,source_index,result_index)=0;
           end
        end
     end
end

    for source_index=1:length(Data_name)
        for result_index=1:length(Data_name)
            
%            if  result_index~=source_index
               figure;plot(causality(:,source_index,result_index));
%            else    
%            end
            
        end
    end
    
    
    
    
    m=12;
timerange=[200:220];
    for source_index=1:length(Data_name)
        for result_index=1:length(Data_name)
           if result_index~=source_index
              causality(source_index,result_index)=causality_file('E:\ripple\lab01-21-091205\lab01-21-091205002.nex',Data_name,source_index,result_index,m,timerange);
           else 
           causality(source_index,result_index)=0;
           end
        end
     end


     m=4;
     Data(1,:)=sin(0:0.01:40)*5;
     Data(2,:)=0;   
     for i=8:length(Data(1,:))
         Data(2,i)=Data(1,i-7)+1.2*Data(1,i-3)-0.3*Data(1,i-1)-Data(2,i-2);
     end
     Data(3,:)=random('Normal',0,1,1,length(Data(2,:)));
     
     causality_demo=causality_compute(Data,1,2,m)
     causality_demo=causality_compute(Data,1,3,m)
     causality_demo=causality_compute(Data,2,1,m)
     causality_demo=causality_compute(Data,2,3,m)
     causality_demo=causality_compute(Data,3,1,m)
     causality_demo=causality_compute(Data,3,2,m)
     
          m=12;
     
     start=200000;
      over=220000;
     Data(1,:)=AD27(start:over)';
     Data(2,:)=AD29(start:over)';
     Data(3,:)=AD34(start:over)';
     causality_demo=causality_compute(Data,1,2,m)
     causality_demo=causality_compute(Data,1,3,m)
     causality_demo=causality_compute(Data,2,1,m)
     causality_demo=causality_compute(Data,2,3,m)
     causality_demo=causality_compute(Data,3,1,m)
     causality_demo=causality_compute(Data,3,2,m)

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
Data_name(1).Name='sig057a';
Data_name(2).Name='sig087a';
Data_name(3).Name='sig083a';
Data_name(4).Name='sig089a';
Data_name(5).Name='sig039a';
Data_name(6).Name='sig075a';
Data_name(7).Name='sig079a';
Data_name(8).Name='sig093a';
% Data_name(9).Name='AD40'
    m=20;
timerange=[537;540];
    for source_index=1:length(Data_name)
        for result_index=1:length(Data_name)
           if result_index~=source_index
              causality_sws1(source_index,result_index)=causality_file('E:\ripple\lab01-21-091205\lab01-21-091205004.nex',Data_name,source_index,result_index,m,timerange);
           else 
           causality(source_index,result_index)=0;
           end
        end
     end

     
     figure;
     for i=1:length(Data_name)
         subplot(9,1,i);plot(all_data(i,:));
     end

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
          
Data_name(1).Name='sig057a';
Data_name(2).Name='sig087a';
Data_name(3).Name='sig083a';
Data_name(4).Name='sig089a';
Data_name(5).Name='sig039a';
Data_name(6).Name='sig075a';
Data_name(7).Name='sig079a';
Data_name(8).Name='sig093a';
% Data_name(9).Name='AD40'
    m=20;
timerange=[55;75];
    for source_index=1:length(Data_name)
        for result_index=1:length(Data_name)
            temp_Data(1).Name=Data_name(source_index).Name;
            temp_Data(2).Name=Data_name(result_index).Name;
          
           if result_index~=source_index
              causality_rem1(source_index,result_index)=causality_file('E:\ripple\lab01-21-091205\lab01-21-091205004.nex',temp_Data,1,2,m,timerange);
           else 
           causality(source_index,result_index)=0;
           end
        end
     end


     
     m=20;
    data(1,:)=AD27(30000:40000)';
    data(2,:)=AD29(30000:40000)';
    data(3,:)=AD34(30000:40000)';
    data(4,:)=AD40(30000:40000)';
    data(5,:)=AD44(30000:40000)';
 S=Power_cross_spectra(data,m);
 figure;
 for i=1:m
     subplot(m,1,i);imagesc(S(:,:,i));
         
 end
     
     
     
     
     
     
     