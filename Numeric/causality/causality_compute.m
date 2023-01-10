function causality=causality_compute(Data,source_row,result_row,m)

Data_temp=Data;
V1=Q_m_basic(Data_temp,result_row,m);
Data_temp(source_row,:)=[];

if source_row>result_row
   V2=Q_m_basic(Data_temp,result_row,m);
elseif source_row<result_row
   V2=Q_m_basic(Data_temp,result_row-1,m);
else
end

causality=1-(V1/V2);
