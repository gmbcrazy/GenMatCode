
function a=NonZeroRowAve(a)

Invalid=[];
for i=1:length(a(:,1))
    if sum(a(i,:))==0
       Invalid=[Invalid i];
    end
end

valid=setdiff(1:length(a(:,1)),Invalid);

if isempty(valid)
   valid=1:length(a(:,1));
end


if length(valid)==1
   a=a(valid,:);
else
   a=mean(a(valid,:));

end

