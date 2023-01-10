function a=PolarDensity(Phase,Radius,XYBin,varargin)   

if nargin==4
   Param=varargin{1};
   Clim=Param.Clim;
else
   Clim=[0 1];
   Param.SamplePlot=0;
   LimM=max(XYBin);
end
 XYBin=XYBin(:);
% if isnumeric(Phase)
    xx=cos(Phase).*Radius;
    yy=sin(Phase).*Radius;
    H = hist2dLU([xx(:),yy(:)],XYBin,XYBin);
    PolarD=SmoothDec(H,[2,2]);
    PolarD=PolarD/sum(sum(PolarD));
    
%     AlphaTemp=PolarD;
%     Scale=max(max(AlphaTemp))-min(min(AlphaTemp));
%     AlphaTemp=(AlphaTemp-min(min(AlphaTemp)))/Scale;
%     AlphaTemp=AlphaTemp/nansum(nansum(AlphaTemp));
%     AlphaTemp=(AlphaTemp-Clim(1))/diff(Clim);
%     AlphaTemp(AlphaTemp>=1)=1;
    a=imagesc(XYBin,XYBin,PolarD);
    hold on;
%     set(a,'alphadata',(PolarD>=0.000001));

%     figure;
%     imagesc((PolarD>=0.000001))

if nargin==4
t=(-1)^0.5;
if isfield(Param,'RTick')
   for i=1:length(Param.RTick)
       LimM=Param.RTick(i);
       zz = LimM*exp(t*linspace(0, 2*pi, 201));
       plot(real(zz), imag(zz),'color',[220 220 220]/255,'linewidth',1);
       
   end
   plot([-LimM LimM], [0 0],'color',[220 220 220]/255,'linewidth',1);
   plot([0 0],[-LimM LimM],'color',[220 220 220]/255,'linewidth',1);
   
   LimMin=Param.RLim(1);
   LimMax=Param.RLim(2);
   AlphaMark=zeros(size(PolarD));
   for i=1:length(XYBin)
   for j=1:length(XYBin)
       [~,AlphaMark(i,j)]=cart2pol(XYBin(i),XYBin(j));
   end
   end
   AlphaMark(AlphaMark<LimMin|AlphaMark>LimMax)=nan;
   set(a,'alphadata',~isnan(AlphaMark));

end
end
hold on;
if Param.SamplePlot
   plot(xx,yy,'.'); 
end
% if isfield(Param,'ThetaTickLabel')
    text(LimM, 0, '0','horizontalalignment','left','fontsize',10,'fontname','Times New Roman','fontweight','bold'); 
    text(0, LimM, '\pi/2','horizontalalignment','center','verticalalignment','bottom','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
    text(-LimM, 0,'\pi','horizontalalignment','right','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
    text(0, -LimM,'-\pi/2','horizontalalignment','center','verticalalignment','top','fontsize',10,'fontname','Times New Roman','fontweight','bold');
% end

    barX=linspace(LimM*3/4,LimM*1.1,20);
    AlphaTemp=repmat(linspace(0,1,20),2,1);
    barY=[LimM*0.95 LimM*1.0];

%     text(barX(1)-LimM*0.01,LimM*1.05,showNum(Clim(1),2),'horizontalalignment','right','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
%     text(barX(end)+LimM*0.01,LimM*1.05,showNum(Clim(2),2),'horizontalalignment','left','fontsize',10,'fontname','Times New Roman','fontweight','bold');  


    set(gca,'xlim',[-LimM LimM]*1.2,'ylim',[-LimM LimM]*1.2);
%     set(gca,'view',[0 90],'Visible','off')
axis xy



