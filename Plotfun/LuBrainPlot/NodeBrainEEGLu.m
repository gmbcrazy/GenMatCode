function NodeBrainEEGLu(ChanPos,ChanWeight,NodeTh,Color)



if isempty(ChanWeight)
   ChanWeight=ones(length(ChanPos.X),1); 
end



% x(:,1)=ChanPos.Y;
% x(:,2)=ChanPos.X;
% x(:,3)=ChanPos.Z;

x=ChanPos.ColinCoord;


xstep=(max(x)-min(x))/10;
xrange=[min(x)-xstep;max(x)+xstep];


radius=mean(nanmax(x)-nanmin(x))/10;


if size(Color,1)==1
   Color=repmat(Color,length(ChanWeight),1);
elseif size(Color,1)==0
   Color=repmat([0.6 0.6 0.6],length(ChanWeight),1);
else
    
end

% % if AppNode==1
% %    x(:,1)=x(:,1)-100; 
% % end
% % 
   
SpherePlot(x,radius,Color,ChanWeight);
    
Index=find(ChanWeight>=NodeTh);
for i=1:length(Index)
    text(x(Index(i),1)-1,x(Index(i),2),x(Index(i),3),ChanPos.labels{Index(i)});
end
    

