function a=MultiPolarDensity(Phase,Radius,XYBin,ComColor,varargin)   

if nargin==5
   Param=varargin{1};
   Clim=Param.Clim;
else
   Clim=[0 1];
end
 XYBin=XYBin(:);
if isnumeric(Phase)
    xx=cos(Phase).*Radius;
    yy=sin(Phase).*Radius;
    H = hist2dLU([xx(:),yy(:)],XYBin,XYBin);
    PolarD=SmoothDec(H,[4,4]);
    
    AlphaTemp=PolarD;
    Scale=max(max(AlphaTemp))-min(min(AlphaTemp));
    AlphaTemp=(AlphaTemp-min(min(AlphaTemp)))/Scale;
    AlphaTemp=AlphaTemp/nansum(nansum(AlphaTemp));
    AlphaTemp=(AlphaTemp-Clim(1))/diff(Clim);
%     AlphaTemp(AlphaTemp<=Clim(1))=0;
    AlphaTemp(AlphaTemp>=1)=1;
    a=surf(XYBin,XYBin,AlphaTemp,'facecolor',ComColor(1,:));grid off

    a.AlphaData = AlphaTemp;    % set vertex transparencies
    a.FaceAlpha = 'flat';
    a.EdgeAlpha=0;
    hold on;
else
    for i=1:length(Phase)
        a(i)=MultiPolarDensity(Phase{i},Radius{i},XYBin,ComColor(i,:),Param);
    end
end


% % set(gca,'ThetaTick',[90 180 270 360],'RTick',[0:60:180],'RLim',[0 180])
% % set(gca,'ThetaTickLabel',{'\pi/2','\pi','-\pi/2','0'})
if nargin==5
t=(-1)^0.5;
if isfield(Param,'RTick')
   for i=1:length(Param.RTick)
       LimM=Param.RTick(i);
       zz = LimM*exp(t*linspace(0, 2*pi, 201));
       plot(real(zz), imag(zz),'color',[220 220 220]/255,'linewidth',1);
       
   end
   plot([-LimM LimM], [0 0],'color',[220 220 220]/255,'linewidth',1);
   plot([0 0],[-LimM LimM],'color',[220 220 220]/255,'linewidth',1);

end
end

% if isfield(Param,'ThetaTickLabel')
%     text(LimM, 0, '0','horizontalalignment','left','fontsize',10,'fontname','Times New Roman','fontweight','bold'); 
%     text(0, LimM, '\pi/2','horizontalalignment','center','verticalalignment','bottom','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
%     text(-LimM, 0,'\pi','horizontalalignment','right','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
%     text(0, -LimM,'-\pi/2','horizontalalignment','center','verticalalignment','top','fontsize',10,'fontname','Times New Roman','fontweight','bold');
% end

    barX=linspace(LimM*3/4,LimM*1.1,20);
    AlphaTemp=repmat(linspace(0,1,20),2,1);
    barY=[LimM*0.95 LimM*1.0];

if  isnumeric(Phase)
    d=surf(barX,barY,repmat(barX,2,1),'facecolor',ComColor(1,:)); 
    d.AlphaData = AlphaTemp;    % set vertex transparencies
    d.FaceAlpha = 'flat';
    d.EdgeAlpha=0;
else
    for i=1:length(Phase)
    d=surf(barX,barY+(i-1)*0.05*LimM,repmat(barX,2,1),'facecolor',ComColor(i,:)); 
    d.AlphaData = AlphaTemp;    % set vertex transparencies
    d.FaceAlpha = 'flat';
    d.EdgeAlpha=0;
    end
end
%     text(barX(1)-LimM*0.01,LimM*1.05,showNum(Clim(1),2),'horizontalalignment','right','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
%     text(barX(end)+LimM*0.01,LimM*1.05,showNum(Clim(2),2),'horizontalalignment','left','fontsize',10,'fontname','Times New Roman','fontweight','bold');  


    set(gca,'xlim',[-LimM LimM]*1.2,'ylim',[-LimM LimM]*1.2);
    set(gca,'view',[0 90],'Visible','off')



