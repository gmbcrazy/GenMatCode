function y=showNum(x,m)

if isnan(x)
   y='NAN';
   return
end

if size(x,1)>1||size(x,2)>1
   y={size(x)};
for i=1:size(x,1)
    for j=1:size(x,2)
        y{i,j}=showNum(x(i,j),m);
    end
end
    return
end
x=round(x*10^m)/(10^m);

if x>=0
   
else
   y=showNum(abs(x),m);
   y=['-' y];
   return
end
% if (m-1)>0
%     t='0.';
%    for i=1:(m-1)
%        t=[t '0'];
%    end
%    t=[t '1'];
%    ex=str2num(t);
%    if ex>x
%       y=['<' t];
%       return;
%    end
% end

yy=x-floor(x);


yyy=floor(x);
if m==0
   y=num2str(yyy);
else
    if yy==0
       
        yy=num2str(zeros(1,m));
        y=[num2str(yyy) '.'];
%         y=deblank([num2str(yyy) '.' yy]);
        for j=1:m
            y=[y '0']; 
        end
        
        
    else
        temp=[];
           for j=1:m
               temp=[temp '0'];
           end
        if yy>(1-0.1^m)
           y=[num2str(yyy+1) '.' temp];
        else
        yy=[num2str(yy) temp];
        y=[num2str(yyy) '.' yy(3:3+m-1)];
        end
    end
end
    
