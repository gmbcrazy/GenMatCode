% function InFieldPhasePrecessionPlot(InFieldPos,InFieldPhase,BinNum,PosInt,PlotMode,varargin)
function InFieldPhasePrecessionPlot(PhaseFitParam,PlotModel,BinNum)
%%%%%%%Calculate Phase Precession for ignore the running direction

%%%%%%%Pos: Spike Position, if position is circular data, must be degree (0-360)
%%%%%%%Pos: Spike Phase
%%%%%%%PosInt: Interval of PlaceField Start and End
%%%%%%%PlotMode: 0 for no plot; 1 for scatter plot;2 for density plot;3 for both combined
PosInt=[0 1];
Pos=PhaseFitParam.Pos;
Phase=PhaseFitParam.Phase;

% Pos=InFieldPos;
% Phase=InFieldPhase;
% if nargin ==6
    
%    PhaseFitParam=varargin{1};
   a=PhaseFitParam.a;
   b=PhaseFitParam.b;
   rho=PhaseFitParam.rho;
   pval=PhaseFitParam.pval;
  
 Pos=[Pos(:);Pos(:)];
Phase=[Phase(:);Phase(:)+2*pi];

% else
%    [a,b,rho,pval]=GT_cic_linear_regressBuzsaki(Phase,Pos);
% end
% 


switch PlotModel
    case 0   

    case 1   
plot(Pos,Phase,'k.');
set(gca,'xlim',PosInt,'ylim',[-pi 3*pi]);
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});
hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

    case 2
 
        
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

H = hist2dLU([Pos(:),Phase(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
% a=surf(XYBin,XYBin,PolarD);grid off
imagesc(XBin,YBin,PolarD);colormap(jet)
axis xy
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});
hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');


    case 3
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

H = hist2dLU([Pos(:),Phase(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
% a=surf(XYBin,XYBin,PolarD);grid off
imagesc(XBin,YBin,PolarD);colormap(jet)
axis xy
colormap('cool');      

hold on;
plot(Pos,Phase,'k.');
set(gca,'xlim',PosInt,'ylim',[-pi 3*pi]);

set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});
hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

    otherwise
    disp('PlotModel must be 0,1,2,3');
end
 

        
        
        

