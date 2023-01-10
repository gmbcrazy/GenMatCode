function polar_errorArea(rbin,R,Rstd,color,alpha,LimM,varargin)

%%%%%%%Making errorbar plot in area style in either Polar axis or Cart axis
%%%%%%%Created by Lu Zhang 4th Sept, 2017

%%%%%%%varargin{1} Averaged Vector Ang in Radius
%%%%%%%varargin{2} 1 default to plot in Polar Axis; others to plot in cart
%%%%%%%Axis using error_area.m

%%%%R:Mean Vector Length in Each circular bin
%%%%Rstd:Std Vector Length in Each circular bin
%%%%rbin: Bin center in radius for each circular bin
%%%%color: colors of plot
%%%%alpha: transparenncy of area plot
%%%%LimM: Maximal Limit of the R-axis in Polar Plot or Y-axis in Cart Plot

%%%%%%%%%%error_bar Plot in Polar Axis
if nargin==7
   MeanP=varargin{1};
   PolarPlot=1;
elseif nargin==8
   MeanP=varargin{1};
   PolarPlot=varargin{2};
else
   PolarPlot=1;
 

end


    
X=rbin(:);
Y=R(:);
Ystd=Rstd(:);
Yabove=Y+Ystd(:);
Ylow=Y-Ystd(:);


if PolarPlot==1;  % % % % % % %     plot in Polar Axis
% % % %     plot in Polar Axis

[X1,Y1]=pol2cart(X(:),Yabove(:));
[X2,Y2]=pol2cart(X(:),Ylow(:));
% % [x,y]=pol2cart(X(:),Y(:));
xtemp=[X1(1);X1(1:end);fliplr([X2(1:end);X2(end)])];
ytemp=[Y1(1);Y1;fliplr([Y2;Y2(end)])];

if alpha>0
b=fill(xtemp,ytemp,color,'facealpha',alpha,'LineStyle','none');
end
hold on;
hold on;
if X(1)==X(end)
   X=X(1:end-1);
   Y=Y(1:end-1);
end

P.smoothN=1;
P.LineWidth=1;
P.Text={'0','\pi/2','\pi','-\pi/2'};

if nargin==7
    P.ShowMax=0;
    PhaseHistPolar_Bin(X,Y,LimM,color,P);  hold on;
    plot([0 cos(MeanP)*LimM],[0 sin(MeanP)*LimM],'color',color,'linewidth',1);

else
        P.ShowMax=1;
        PhaseHistPolar_Bin(X,Y,LimM,color,P);  

end
% % % % % % %     plot in Polar Axis
% % % % % % %     plot in Polar Axis

% % % % % % %     plot in cart Axis
% % % % % % %     plot in cart Axis

else
    
    if X(1)==X(end)
       X(end)=[];
       Y(end)=[];
       Ystd(end)=[];
    end
    
    X=[X;X+2*pi];
    Y=[Y;Y];
    Ystd=[Ystd;Ystd];
X(end+1)=X(end)+X(2)-X(1);
Y(end+1)=Y(1);
Ystd(end+1)=Ystd(1);

error_area(X,Y,Ystd,color,alpha);

% hold on;
% plot([pi pi],[0 LimM],'k:');
% plot([pi*3 pi*3],[0 LimM],'k:');
% 
set(gca,'ylim',[0 LimM],'xlim',[0 4*pi],'xtick',[0:4]*pi,'ytick',[0 LimM/2 LimM],'box','off','xticklabel',{'0','180','360','540','720'});
% % % % % % %     plot in cart Axis
% % % % % % %     plot in cart Axis

end








