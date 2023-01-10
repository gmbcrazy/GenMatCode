function Output=GT_PhasePrecessionPlotGroup(Pos,Phase,SpikeID,IDCluster,BinNum,PosInt,PlotMode,ColorP,varargin)
%%%%%%%Pos: Spike Position
%%%%%%%Pos: Spike Phase
%%%%%%%SpikeID: vector with same length of Spike Phase; which is an cluster ID, could be trial ID, could be Neuron ID, could be time period ID;
%%%%%%%IDCluster, IDCluster could be as unique(SpikeID);

%%%%%%%PosInt: Interval of PlaceField Start and End
%%%%%%%PlotMode: 0 for no plot; 1 for scatter plot;2 for density plot;3 for both combined


% % BinNum=40; 
% % IDCluster=unique(SpikeID);

Clim=[0 1];
if nargin==9
   Param=varargin{1};
else
   Param.xLeft=0.08;
   Param.xRight=0.06;
   Param.yTop=0.08;
   Param.yBottom=0.08;
   Param.xInt=0.04;
   Param.yInt=0.02;

end

switch PlotMode
    case 0   
         for i=1:length(IDCluster)
             Index=find(SpikeID==IDCluster(i));
             [a(i),b(i),rho(i),pval(i)]=GT_cic_linear_regressBuzsaki(Phase(Index),Pos(Index));
         end
    case 1
        for i=1:length(IDCluster)
            subplotLU(1,length(IDCluster),1,i,Param);

            Index=find(SpikeID==IDCluster(i));
            [a(i),b(i),rho(i),pval(i)]=GT_cic_linear_regressBuzsaki(Phase(Index),Pos(Index));
            x1=repmat(Pos(Index),2,1);
            x2=[Phase(Index);Phase(Index)+pi*2];

            plot(x1(:),x2(:),'.','color',ColorP(i,:));
            
            hold on;
%            plot([0 1],a(i)*[0 1]+b(i),'color',ColorP(i,:));
%            plot([0 1],a(i)*[0 1]+b(i)+2*pi,'color',ColorP(i,:));
%            plot([0 1],a(i)*[0 1]+b(i)+4*pi,'color',ColorP(i,:));
plot([0 1],a(i)*[0 1]+b(i),'k');
plot([0 1],a(i)*[0 1]+b(i)+2*pi,'k');
plot([0 1],a(i)*[0 1]+b(i)+4*pi,'k');

            set(gca,'xlim',PosInt,'ylim',[-pi 3*pi]);
            set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);

text(1,3*pi,[' r=' showNum(rho(i),2) ' p' showPvalue(pval(i),2)],'horizontalalignment','right','verticalalignment','bottom');
if i==1
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',{'-\pi','0','\pi','2\pi','3\pi'});
else
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',[]);

end
set(gca,'xticklabel',[],'yticklabel',[]);

axis xy

%             set(gca,'view',[0 90],'Visible','off')

        end

case 2
 
        
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

        for i=1:length(IDCluster)
            
            Index=find(SpikeID==IDCluster(i));
            [a(i),b(i),rho(i),pval(i)]=GT_cic_linear_regressBuzsaki(Phase(Index),Pos(Index));
            x1=repmat(Pos(Index),2,1);
            x2=[Phase(Index);Phase(Index)+pi*2];
   
H = hist2dLU([x1(:),x2(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
    AlphaTemp=PolarD;
    Scale=max(max(AlphaTemp))-min(min(AlphaTemp));
    AlphaTemp=(AlphaTemp-min(min(AlphaTemp)))/Scale;
    AlphaTemp=AlphaTemp/nansum(nansum(AlphaTemp));
    AlphaTemp=(AlphaTemp-Clim(1))/diff(Clim);
%     AlphaTemp(AlphaTemp<=Clim(1))=0;
    AlphaTemp(AlphaTemp>=1)=1;
    subplotLU(1,length(IDCluster),1,i,Param);
    ha=surf(XBin(:),YBin(:),AlphaTemp,'facecolor',ColorP(i,:));grid off

    ha.AlphaData = AlphaTemp;    % set vertex transparencies
    ha.FaceAlpha = 'flat';
    ha.EdgeAlpha=0;
    hold on;
% plot3([0 1],a(i)*[0 1]+b(i),[0 0],'k');
% plot3([0 1],a(i)*[0 1]+b(i)+2*pi,[0 0],'k');
% plot3([0 1],a(i)*[0 1]+b(i)+4*pi,[0 0],'k');
plot([0 1],a(i)*[0 1]+b(i),'k');
plot([0 1],a(i)*[0 1]+b(i)+2*pi,'k');
plot([0 1],a(i)*[0 1]+b(i)+4*pi,'k');

set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);
    set(gca,'view',[0 90],'Visible','off')
text(1,3*pi,[' r=' showNum(rho(i),2) ' p' showPvalue(pval(i),2)],'horizontalalignment','right','verticalalignment','bottom');
if i==1
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',{'-\pi','0','\pi','2\pi','3\pi'});
else
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',[]);

end
axis xy
        end

    case 3
        
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

        for i=1:length(IDCluster)
            
            Index=find(SpikeID==IDCluster(i));
            [a(i),b(i),rho(i),pval(i)]=GT_cic_linear_regressBuzsaki(Phase(Index),Pos(Index));
            x1=repmat(Pos(Index),2,1);
            x2=[Phase(Index);Phase(Index)+pi*2];
   
H = hist2dLU([x1(:),x2(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
    AlphaTemp=PolarD;
    Scale=max(max(AlphaTemp))-min(min(AlphaTemp));
    AlphaTemp=(AlphaTemp-min(min(AlphaTemp)))/Scale;
    AlphaTemp=AlphaTemp/nansum(nansum(AlphaTemp));
    AlphaTemp=(AlphaTemp-Clim(1))/diff(Clim);
%     AlphaTemp(AlphaTemp<=Clim(1))=0;
    AlphaTemp(AlphaTemp>=1)=1;
    subplotLU(1,length(IDCluster),1,i,Param);
    ha=surf(XBin(:),YBin(:),AlphaTemp,'facecolor',ColorP(i,:));grid off

    ha.AlphaData = AlphaTemp;    % set vertex transparencies
    ha.FaceAlpha = 'flat';
    ha.EdgeAlpha=0;
    hold on;

            plot(x1(:),x2(:),'k.');

plot([0 1],a(i)*[0 1]+b(i),'k');
plot([0 1],a(i)*[0 1]+b(i)+2*pi,'k');
plot([0 1],a(i)*[0 1]+b(i)+4*pi,'k');

set(gca,'xlim',PosInt,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)]);
    set(gca,'view',[0 90],'Visible','off')
text(1,3*pi,[' r=' showNum(rho(i),2) ' p' showPvalue(pval(i),2)],'horizontalalignment','right','verticalalignment','bottom');
if i==1
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',{'-\pi','0','\pi','2\pi','3\pi'});
else
set(gca,'xlim',[0 1],'xtick',[0 1],'xticklabel',{'Enter','Exit'},'yticklabel',[]);

end
axis xy


        end
    otherwise
    disp('PlotMode must be 0,1 or 2');
end

% % text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

 Output.a=a;
 Output.b=b;
 Output.rho=rho;
 Output.pval=pval;

