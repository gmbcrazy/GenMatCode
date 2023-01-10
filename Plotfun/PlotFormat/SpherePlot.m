function SpherePlot(Center,radius,colorP,nodeSizePercentage)

%%%%plot Sphere at Center, Center(:,1) x axis; Center(:,2)  y axis; Center(:,3) z axis
theta = linspace(0,2*pi,50);
phi = linspace(-pi/2,pi/2,50);
[theta,phi] = meshgrid(theta,phi);
if size(colorP,1)==1
   colorP=repmat(colorP,max(size(Center)),1);
end

if length(nodeSizePercentage)==1
   nodeSizePercentage=repmat(nodeSizePercentage,max(size(Center)),1);
end

if size(Center,2)==2
   Center=[Center zeros(size(Center,1),1)];
end
% [xs,ys,zs] = sph2cart(theta,phi,radius);

for i=1:size(Center,1)
    [xs,ys,zs] = sph2cart(theta,phi,radius*nodeSizePercentage(i));
    surf(xs+Center(i,1),ys+Center(i,2),zs+Center(i,3),'facecolor',colorP(i,:),'linestyle','none','facealpha',1);hold on
%    view(3), camlight, lighting gouraud
% set(gca,'facelighting',[])
% light('position',[Center(i,1:2)+3*radius radius*0.1],'style','local');
end
% view([0,0,1]), camlight, lighting gouraud
hold off
% light('position',[6 6 3],'style','local')
% % light('position',[2 2 4],'style','infinite');
