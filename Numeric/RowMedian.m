
function a=RowMedian(a)


valid=1:length(a(:,1));


if length(valid)==1
   a=a(valid,:);
else
   a=median(a(valid,:));

end

