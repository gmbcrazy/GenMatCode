function y=cicular_write(data,timestamps,interval,path,filename)

data1=cicular_transfer(data,interval);
if ~isempty(data1)
cic_end=max(data1);
    for i=1:cic_end
        q=find(data1==i);
        if ~isempty(q)
           a=timestamps(q)*1000000.0;
           s=[[path] ['\',filename,num2str(i),'.nts']];
           Mat2NlxTS(s,a',length(a));
        end
    end

else 

    return
end
    




    
   