function y=showPerc(x,m)

if ~iscell(x)
    if length(x)>1
       for j=1:length(x)
        y{j}=showPerc(x(j),m);
       end
    else
x=x*100;
y=showNum(x,m);
y=[y '%'];

    
    end
else
    for j=1:length(x)
        y{j}=showPerc(x{j},m);
    end
end
