function [dataHist,dataHisttime]=GT_RateHist(Data,timerange,bin_width,DataType)

%%%%%%%%Lu Zhang 11/3/2017
%%%%%%%%generate FiringRate histogram from Timestamps (DataType=-1) or continous data(DataType=SamplingRate)
%%%%%%%%For continous data, output is still continous data with lower
%%%%%%%%samplingrate than original, depending on bin_width(in seconds)

if nargin<4
   DataType=-1; %%%%%%%%%%%spike train input data 
end

   ts_origin=[];
   bin_num=round(diff(timerange)/bin_width);
   switch DataType
       case 0
       
       case -1
               temp_s=timerange(1);
               temp_o=timerange(2);
               temp_ts=Data(find(Data>=temp_s&Data<temp_o));
               temp_ts=sort([temp_ts(:);temp_s;temp_o]);
%                ts_origin(i).data=temp_ts-RefTS(i);
               if isempty(temp_ts)
               
               else 
                   [dataHist(1,:),temp_n]=hist(temp_ts,bin_num);
                   dataHist(1,1)=dataHist(1,1)-1;
                   dataHist(1,length(dataHist(1,:)))=dataHist(1,length(dataHist(1,:)))-1;
                   
%                         end
                    
                    clear temp_index temp_ts temp_n
                end
             dataHisttime=(timerange(1)+bin_width/2):bin_width:(bin_width*(bin_num-1)+timerange(1)+bin_width/2);   
           
       otherwise
                  adfreq=DataType;
                  bin_width=max(1/adfreq,bin_width);
                  bin_num=round(diff(timerange)/bin_width);
                  dataHist=zeros(1,bin_num);

                  if   bin_width==1/adfreq
                      invalidIn=[];
                          s=1+floor((timerange(1)-DataTime(1))/bin_width);
                          o=s+bin_num-1;

                              dataHist(1,1:bin_num)=Data(s:o);

                  elseif bin_width>1/adfreq
                         invalidIn=[];
                         bin_width_num=round(bin_width*adfreq);
                         dataHist_temp_index=zeros(bin_width_num,bin_num);
                         dataHist_temp=zeros(bin_width_num,bin_num);
                         temp_s=floor((timerange(1)-DataTime(1))*adfreq)+1;
                         temp_o=temp_s+(bin_num-1)*bin_width_num;
                         dataHist_temp_index(1,:)=temp_s:bin_width_num:temp_o;
                         
                         dataHist_temp(1,:)=Data(dataHist_temp_index(1,:));
                            for j=2:bin_width_num
                                dataHist_temp_index(j,:)=dataHist_temp_index(j-1,:)+1;
                                dataHist_temp(j,:)=Data(dataHist_temp_index(j,:));
                            end
                          dataHist=mean(dataHist_temp);
                 
                       dataHist(invalidIn,:)=nan;
                       CorrectIn(invalidIn)=[];
                  else
                      'bin width should not be smaller than sampling period'
                  end      
                 
               dataHisttime=(timerange(1)+bin_width/2):bin_width:(bin_width*(bin_num-1)+timerange(1)+bin_width/2);  
           
           
   end
           
   
   

