function varargout=MultiHist_GroupPlot(X,RateAll,Color,varargin)

%%%%%%output{1} a is for figure legend
%%%%%%output{2} Outstats is the statistics

Xstep=abs(mean(diff(X)));
InterGroupXstep=Xstep/10;
if nargin==4
   Param=varargin{1};
   if ~isfield(Param,'PlotType')
      Param.PlotType=2;       
   end
   if isfield(Param,'ANOVAstats')
      Outstats=Param.ANOVAstats;
   else
      Outstats=RateHist_Stats(RateAll,Param);
   end
Ytick=Param.Ytick;
Ystep=(max(Ytick)-min(Ytick))/20;
hold on;
if strcmp(Param.SigPlot,'Anova')
   [h, crit_p, adj_p]=fdr_bh(Outstats.Anova.p,Param.Q,'pdep','yes');
   for i=1:length(Outstats.Anova.p)
       if Outstats.Anova.p(i)<=crit_p
          plot(X(i),max(Ytick)-Ystep,'k*');hold on;
       end
   end

elseif strcmp(Param.SigPlot,'Ttest')
    [h, crit_p, adj_p]=fdr_bh(Outstats.ttestP.Ppair(:),Param.Q,'pdep','yes');

    for iGroup=1:length(RateAll)
        Index=sum(Outstats.ttestP.GroupPair==iGroup,2);
        pTemp=Outstats.ttestP.Ppair(Index==1,:);
        Sig=sum(pTemp<=crit_p,1);
        plot(X(Sig==(length(RateAll)-1)),zeros(size(X(Sig==(length(RateAll)-1))))+max(Ytick)-(iGroup+1)*Ystep,'.','color',Color(iGroup,:),'markersize',6);hold on;
    end

else
    
end

if Param.LegendShow&&~isempty(Param.Legend)
%    a =legend(a,Param.Legend);
     LX=max(X);
     dfX=mean(diff(X));
    for jL=1:length(Param.Legend)
%         dfY=mean(diff(Ytick))/20;
        plot([LX-3*dfX LX-2*dfX],repmat(max(Ytick)-(jL-1)*Ystep/2,1,2),'color',Color(jL,:),'linewidth',1);
        hold on;
        text(LX-(2-0.1)*dfX,max(Ytick)-(jL-1)*Ystep/2,Param.Legend{jL},'fontsize',6,'horizontalalignment','left','verticalalignment','middle');
    end
end
   set(gca,'ylim',[min(Ytick) max(Ytick)],'ytick',Ytick);
else
    
 

end
for i=1:length(RateAll)
    if size(RateAll{i},1)==length(X)
%     a(i)=error_area(X,nanmean(RateAll{i},2),ste(RateAll{i}'),Color(i,:),0.4);
    ErrorBarPlotLU(X+InterGroupXstep*(i-1),nanmean(RateAll{i},2),ste(RateAll{i}'),Color(i,:),Param.PlotType,1);

    else
%     a(i)=error_area(X,nanmean(RateAll{i}),ste(RateAll{i}),Color(i,:),0.4);
    ErrorBarPlotLU(X+InterGroupXstep*(i-1),nanmean(RateAll{i}),ste(RateAll{i}),Color(i,:),Param.PlotType,1);
    end
    hold on;
end

if nargout==1
   varargout{1}=a;
elseif nargout==2
   varargout{1}=a; 
   varargout{2}=Outstats;
else

end

