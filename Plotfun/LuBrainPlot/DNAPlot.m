t=1:10000;
tt=t/1000;


S1=[cos(tt);sin(tt);t/max(t)*2];
S2=[cos(tt+pi);sin(tt+pi);t/max(t)*2];
% % % 
figure;
plot3(S1(1,:),S1(2,:),S1(3,:));
hold on;
plot3(S2(1,:),S2(2,:),S2(3,:),'r');

for i=1:500:size(S1,2)
    plot3([S1(1,i) S2(1,i)],[S1(2,i) S2(2,i)],[S1(3,i) S2(3,i)],'g')
end

S11=S1(:,1:200:size(S1,2));
S22=S2(:,1:200:size(S1,2));
Num=size(S22,2);
r1=abs(random('norm',1,0.4,Num,1));
r2=abs(random('norm',1,0.4,Num,1));

SpherePlot(S11',0.1,[1,0,0],r1);
hold on
SpherePlot(S22',0.1,[1,0,1],r2);
hold on
view([0,0,1]), camlight, lighting gouraud


[X,Y,Z] = cylinder(0.4,100);

for i=1:500:size(S1,2)
    Z(1,:)=
a=surf(X,Y,Z,'linestyle','none');
grid off
end