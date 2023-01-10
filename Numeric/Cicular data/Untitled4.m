tt=ThetaNormalizeData(1).Vol;
normalize_range=[3,110];
q=floor(normalize_range(1)*1000);
mm=floor(normalize_range(2)*1000);
while  q<mm
         qq=q;
       if tt(q)==0
       
        
           
           while tt(q)==0
                 q=q+1;
           end
           
           qqq=q;
           tt(qq:qqq)=1;
           q1=[q1,qq];
           q2=[q2,qqq];
       end
      
       q=max(qqq,qq+1);
end







