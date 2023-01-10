function Output=GT_PhasePrecessionPlot(Pos,Phase,BinNum,PosInt,PlotMode)
%%%%%%%Pos: Spike Position
%%%%%%%Pos: Spike Phase
%%%%%%%PosInt: Interval of PlaceField Start and End
%%%%%%%PlotMode: 0 for scatter plot;1 for density plot;2 for both combined
[a,b,rho,pval]=GT_cic_linear_regressBuzsaki(Phase,Pos);

Pos=[Pos(:);Pos(:)];
Phase=[Phase(:);Phase(:)+2*pi];
% % BinNum=40; 

switch PlotMode
    case 0   

    case 1   
plot(Pos,Phase,'k.');
set(gca,'xlim',PosInt,'ylim',[-pi 3*pi]);
set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);
hold on;
plot([0 1],a*[0 1]+b,'k');
plot([0 1],a*[0 1]+b+2*pi,'k');
plot([0 1],a*[0 1]+b+4*pi,'k');
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
set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);
hold on;
plot([0 1],a*[0 1]+b,'k');
plot([0 1],a*[0 1]+b+2*pi,'k');
plot([0 1],a*[0 1]+b+4*pi,'k');
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

set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);
hold on;
plot([0 1],a*[0 1]+b,'k');
plot([0 1],a*[0 1]+b+2*pi,'k');
plot([0 1],a*[0 1]+b+4*pi,'k');
text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

    otherwise
    disp('PlotMode must be 0,1,2,3');
end
 Output.a=a;
 Output.b=b;
 Output.rho=rho;
 Output.pval=pval;

