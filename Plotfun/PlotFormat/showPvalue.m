function y=showPvalue(x,m)

if isnan(x)
   y='nan';
   return
end
format long
if (m-1)>0
    t='0.';
   for i=1:(m-1)
       t=[t '0'];
   end
   t=[t '1'];
   ex=str2num(t);
   if ex>x
      y=['<' t];
      return;
   end
end
    

yy=x-floor(x);
yyy=floor(x);
if m==0
   y=num2str(yyy);
else
    if yy==0
       
        yy=num2str(zeros(1,m));
        y=['=' num2str(yyy) '.' yy];

    else
        yy=num2str(yy);
        if length(yy)<(3+m-1)
            
           y=['=' yy repmat('0',1,m-length(yy)+2)];
        else
           y=['=' num2str(yyy) '.' yy(3:3+m-1)];

        end
    end
end
format short
    
