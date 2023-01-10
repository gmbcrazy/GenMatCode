function SurfaceBrainLu(x,ColorF,alphaF,varargin)
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\LuBrainPlot\BrainSurfaceFileLu.mat');


if nargin==4
    AngRot=varargin{1};

%    AAL=varargin
else
    AngRot=[0 0];
end
% lobColor  = [204,26,128;0,153,230;128,51,204;51,230,153;230,102,26;255,145,247;230,230,51]/255;

[A1,A2,r]=cart2pol(surf.coord(1,:),surf.coord(2,:),surf.coord(3,:));
A1=A1+AngRot(1);
% A2=A2+AngRot(2);
[xx(1,:),xx(2,:),xx(3,:)]=pol2cart(A1,A2,r);

trisurf(surf.tri,xx(1,:)'+x(1),xx(2,:)'+x(2),xx(3,:)'+x(3),'facecolor',ColorF,'edgecolor','none','facealpha',alphaF)
