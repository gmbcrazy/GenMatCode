n=116;
n1=n-1;

DeltaTheta=2*pi/n1;

Theta=[0:(n-1)]*DeltaTheta;

xi=cos(Theta);
yi=sin(Theta);
zi=zeros(size(xi));
Center=[xi(:) yi(:) zi(:)];
% a=plot(xi,yi,'ro','markersize',6,'markerfacecolor','r')

r=0.1;
colorP=[1 0 0];
SpherePlot(Center,r,colorP)
view([0,0,1])
camlight, lighting gouraud
i=9;j=13;
hold on
% figure;
if abs(j-i)<n/2
   [Px,Py]=arcPlot([xi(j),yi(j)],[xi(i),yi(i)],abs(j-i)/n*0.1);
elseif abs(j-i)>=n/2
   [Px,Py]=arcPlot([xi(i),yi(i)],[xi(j),yi(j)],abs(j-i)/n*0.1);
else
    Px=xi([i,j]);Py=yi([i,j]);

end
plot(Px,Py,'g-')

grid off
set(gca,'box','off')
