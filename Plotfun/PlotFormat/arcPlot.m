function [Px,Py]=arcPlot(P1,P2,inc)
% % P1=[150,300]; P2=[500,600];
% hold on
P=P2-P1;
[ThC,C]=cart2pol(P(1),P(2));
f=inline('2*L*sin(Th/2)-C*Th','Th','L','C');
options=optimset('Display','off');
% inc=0.1;
% for inc=50:100:950
   L=C+inc;
   Th=fzero(f,sqrt(24*(1-C/L)),options,L,C);
   R=C/(2*sin(Th/2));
   [x,y]=pol2cart(ThC+(pi-Th)/2,R);
   CC=P1+[x,y];
   P=P1-CC;
   ThP1=cart2pol(P(1),P(2));
   [x,y]=pol2cart(linspace(ThP1,ThP1+Th),R);
% end
Px=x+CC(1);
Py=y+CC(2);
% plot(Px,Py); hold off
% daspect([1,1,1]); grid; hold off