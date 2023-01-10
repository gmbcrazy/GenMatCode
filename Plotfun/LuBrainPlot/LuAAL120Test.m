
for i=1:120
    Index=find(BORDER_V==ROI1(i).ID);
    Coord(1:3,i)=median(BORDER_XYZ(:,Index),2);
end

SpherePlot(Coord',2,[1 0 0],zeros(120,1)+1);
view([0,0,1]), camlight, lighting gouraud
XYZ=BORDER_XYZ;
x=XYZ(1,:);
y=XYZ(2,:);
z=XYZ(3,:);
scatter(X,Y,3,Z)%散点图
figure
[X,Y,Z]=griddata(x,y,z,linspace(0,100)',linspace(0,100),'v4');%插值
pcolor(X,Y,Z);shading interp%伪彩色图
figure,contourf(X,Y,Z) %等高线图
figure,surfc(X,Y,Z)%三维曲面

sLim(1,:)=min(surf.coord');
sLim(2,:)=max(surf.coord');

AALim(1,:)=min(XYZ');
AALim(2,:)=max(XYZ');
diff(AALim)
c=diff(sLim)./diff(AALim);
XYZnew=[XYZ-repmat(min(XYZ')',1,size(XYZ,2))].*repmat(c',1,size(XYZ,2))+repmat(min(surf.coord')',1,size(XYZ,2));
for i=1:120
    Index=find(BORDER_V==ROI1(i).ID);
    Coord(1:3,i)=mean(XYZnew(:,Index),2);
end
Coord(3,:)=Coord(3,:)+5;
subplot('position',[0 0 1 1])
    trisurf(surf.tri,surf.coord(1,:)',surf.coord(2,:)',surf.coord(3,:)','facecolor','b','edgecolor','none','facealpha',0.03)
    hold on;
SpherePlot(Coord',3,[1 0 0],zeros(120,1)+1);
view([0,0,1]), 
grid off
    view([0 0 1]);grid off;set(gca,'ylim',[-105 75],'zlim',[-77 83],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99],'zcolor',[0.99 0.99 0.99])
camlight, lighting gouraud
    % [x,y]=meshgrid(1:15,1:15);



tri = delaunay(x,y);
z = peaks(15);
trisurf(tri,x,y,z,'facecolor','blue','edgecolor','none','facealpha',0.1);grid off



index1=find(Z>=43);
[X,Y,Z]=griddata(x(index1),y(index1),z(index1),linspace(10,82)',linspace(11,100),'v4');%插值



figure,surf(X,Y,Z)%三维曲面
surfc(XYZ(1,:)',XYZ(2,:)',XYZ(3,:)',XYZ/255)
hold off
light('position',[6 6 3],'style','local')
