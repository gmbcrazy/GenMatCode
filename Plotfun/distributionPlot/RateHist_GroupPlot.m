function varargout=RateHist_GroupPlot(X,RateAll,Color,varargin)

%%%%This is designed for ratehistogram plot, repeat or non-repeat measures;
%%%%output{1} a is for figure legend
%%%%output{2} Outstats is the statistics


if nargin==4
   
   Param=varargin{1};
   if isfield(Param,'Marker')
   else
      for i=1:length(RateAll)
      Param.Marker{i}='o';
      end
   end

   
if Param.statisP==1
   if ~isfield(Param,'PlotType')
      Param.PlotType=2;       
   end
   if isfield(Param,'ANOVAstats')
      Outstats=Param.ANOVAstats;
   else
      Outstats=RateHist_Stats(RateAll,Param);
   end
Ytick=Param.Ytick;
Ystep=(max(Ytick)-min(Ytick))/40;
hold on;
if strcmp(Param.SigPlot,'Anova')
   if isfield(Param,'Crit_p')
      crit_p=Param.Crit_p;
   else
      [h, crit_p, adj_p]=fdr_bh(Outstats.Anova.p,Param.Q,'pdep','yes');

   end
   if Param.PlotType~=6&&Param.PlotType~=3
      for i=1:length(Outstats.Anova.p)
          if Outstats.Anova.p(i)<=crit_p
             plot(X(i),max(Ytick)-Ystep,'k.');hold on;
          end
      end
   else
      %%%%%%%%Blue Shed for P Value
      colorShip=[0,0,0.501960813999176;0.0184331797063351,0.0184331797063351,0.598355472087860;0.0368663594126701,0.0368663594126701,0.694750189781189;0.0552995391190052,0.0552995391190052,0.791144847869873;0.0737327188253403,0.0737327188253403,0.887539565563202;0.0921659022569656,0.0921659022569656,0.983934223651886;0.236607149243355,0.236607149243355,1;0.406250000000000,0.406250000000000,1;0.575892865657806,0.575892865657806,1;0.745535731315613,0.745535731315613,1;0.915178596973419,0.915178596973419,1];
      %%%%%% 
      logP=log10(Outstats.Anova.p);
      [~,EdgePvalue]=discretize([-2:0.1:0],size(colorShip,1)-1);
      [colorPvalueI,~]=discretize(logP,EdgePvalue);
      colorPvalueI(isnan(colorPvalueI))=1;
% %       for i=1:length(Outstats.Anova.p)
% % %           if Outstats.Anova.p(i)<=crit_p
% %              plot(X(i),max(Ytick)-Ystep,'.','color',colorShip(colorPvalueI(i),:),'markersize',3);hold on;
% % %           end
% %       end
      TempXStep=mean(diff(X));
      barplotLu(X-TempXStep/2,max(Ytick)-Ystep,TempXStep,Ystep,colorShip(colorPvalueI,:),1)
   end
elseif strcmp(Param.SigPlot,'Ttest')
    if isfield(Param,'Crit_p')
      crit_p=Param.Crit_p;
       else
    [h, crit_p, adj_p]=fdr_bh(Outstats.ttestP.Ppair(:),Param.Q,'pdep','yes');
       end
    for iGroup=1:length(RateAll)
        Index=sum(Outstats.ttestP.GroupPair==iGroup,2);
        pTemp=Outstats.ttestP.Ppair(Index==1,:);
        Sig=sum(pTemp<=crit_p,1);
        if length(RateAll)==2
           sigColor=[0.1 0.1 0.1];
        else
           sigColor=Color(iGroup,:);
        end
        if length(RateAll)==2&&iGroup==2
            break
        end


        if size(Outstats.ttestP.Ppair,1)~=1

           if sum(Sig)>0
              plot(X(Sig==(length(RateAll)-1)),zeros(size(X(Sig==(length(RateAll)-1))))+max(Ytick)-(iGroup-1)*Ystep,'.','color',sigColor,'markersize',6);hold on;
           end
        else
        plot(X(Sig==1),zeros(size(X(Sig==1)))+max(Ytick)-(iGroup-1)*Ystep,'.','color',sigColor,'markersize',6);hold on;
 
        
        end
    end

elseif strcmp(Param.SigPlot,'Ranktest')
       if isfield(Param,'Crit_p')
      crit_p=Param.Crit_p;
       else
    [h, crit_p, adj_p]=fdr_bh(Outstats.ttestP.PpairRank(:),Param.Q,'pdep','yes');
       end
    for iGroup=1:length(RateAll)
        Index=sum(Outstats.ttestP.GroupPair==iGroup,2);
        pTemp=Outstats.ttestP.PpairRank(Index==1,:);
        Sig=sum(pTemp<=crit_p,1);

        if length(RateAll)==2
           sigColor=[0.1 0.1 0.1];
        else
           sigColor=Color(iGroup,:);
        end
        if length(RateAll)==2&&iGroup==2
            break
        end

       
        if size(Outstats.ttestP.Ppair,1)~=1

           if sum(Sig)>0
              plot(X(Sig==(length(RateAll)-1)),zeros(size(X(Sig==(length(RateAll)-1))))+max(Ytick)-(iGroup-1)*Ystep,'.','color',sigColor,'markersize',6);hold on;
           end
        else
        plot(X(Sig==1),zeros(size(X(Sig==1)))+max(Ytick)-(iGroup-1)*Ystep,'.','color',sigColor,'markersize',6);hold on;
 
        
        end
     end
     
    
    
else
end

end

if Param.LegendShow&&~isempty(Param.Legend)
%    a =legend(a,Param.Legend);
     LX=mean(X);
     dfX=mean(diff(X));
    for jL=1:length(Param.Legend)
%         dfY=mean(diff(Ytick))/20;
        plot([LX+3*dfX LX+4*dfX],repmat(max(Ytick)-(jL-1+4)*Ystep,1,2),'color',Color(jL,:),'linewidth',1);
        hold on;
        text(LX+4.1*dfX,max(Ytick)-(jL-1+4)*Ystep,Param.Legend{jL},'fontsize',6,'horizontalalignment','left','verticalalignment','middle');
    end
end
%    set(gca,'ylim',[min(Ytick) max(Ytick)],'ytick',Ytick);
else
    
 

end
for i=1:length(RateAll)
    if size(RateAll{i},1)==length(X)
%     a(i)=error_area(X,nanmean(RateAll{i},2),ste(RateAll{i}'),Color(i,:),0.4);
    ErrorBarPlotLU(X,nanmean(RateAll{i},1),ste(RateAll{i}'),Color(i,:),Param.PlotType,Param.Marker{i},1);
    else
%     a(i)=error_area(X,nanmean(RateAll{i}),ste(RateAll{i}),Color(i,:),0.4);
    ErrorBarPlotLU(X,nanmean(RateAll{i}),ste(RateAll{i}),Color(i,:),Param.PlotType,Param.Marker{i},1);
    end
    hold on;
end

if nargout==1
   varargout{1}=1;
elseif nargout==2
   varargout{1}=1; 
   varargout{2}=Outstats;
else

end












%% 
function stats=ErrorBarPlotLU(x,y_mean,y_errorbar,barColor,PlotMode,Marker,varargin)

%%%%%%PlotMode=1; barPlot
%%%%%%PlotMode=2; DotPlot
%%%%%%PlotMode=3; AreaPlot
if nargin==7
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=[];           
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
%    Marker='o';
elseif nargin==8
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
%    Marker='o';

elseif nargin==9
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=varargin{3};
   RGroupID=1:length(x);
%    Marker='o';

elseif nargin==10
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=varargin{3};
   RGroupID=varargin{4};


else
   SavePath=[];           
   Datatype=0;
   GroupPair=[];
   RGroupID=1:length(x);
%    Marker='o';

end

%%%%%%%%In case of repeated measure, and multi sub groups.
x_step=diff(x);
if min(x_step)<max(x_step)   %%%%%%%%%%multi sub groups
   Index=find(x_step>min(x_step));
   x_IndexO=Index(:);
   x_IndexS=[1;x_IndexO(1:end)+1];
   x_IndexO=[x_IndexO;length(x)];
end
%%%%%%%%In case of repeated measure, and multi sub groups.

if isempty(GroupPair)
   GroupPair.CorrName='fdr';
   GroupPair.Q=0.1;
   GroupPair.Pair=[];
   GroupPair.SignY=2;
   GroupPair.Plot=1;
   GroupPair.Std=1;      %%%%%%%%%using standard deviation as errorbar
   GroupPair.SamplePlot=1; %%%%%%%%%Plot Individual Sample Point
   GroupPair.SamplePairedPlot=1; %%%%%%%%%Dash line for paired comparison sample
   GroupPair.LimY=[0 GroupPair.SignY*1.2];

end

   if isempty(GroupPair.Pair)
%    for i=1:length(x) 
%        for j=(i+1):length(x)
%            GroupPair.Pair=[GroupPair.Pair [i;j]];
%        end
%    end
      
   end


% if size(barColor,1)==1
%    barColor=repmat(barColor,length(x),1);
% end

if (~iscell(y_mean))&&(~isstruct(y_mean))

if PlotMode==0
   
   plot(x,y_mean,'color',barColor,'linestyle','-','linewidth',1);hold on


elseif PlotMode==1
    for i=1:length(x)
        b=bar(x(i),y_mean(i),0.8,'facecolor',barColor(i,:),'Edgecolor',barColor(i,:));hold on;
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));
    end
elseif PlotMode==2||PlotMode==4
        for i=1:length(x)
% %         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker','o','markersize',10);hold on
% %         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);

        if PlotMode==2
        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker',Marker,'markersize',2.5,'markerfacecolor',[1 1 1]);hold on
%         plot(x,y_mean,'color',barColor(i,:),'linestyle','-');hold on

        end
        
        if PlotMode==4
        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker',Marker,'markersize',3.5,'markerfacecolor',barColor(i,:));hold on

        end
        end

elseif PlotMode==3
       error_area(x,y_mean,y_errorbar,barColor,0.3,'-',1);hold on;
elseif PlotMode==5
%         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','-','marker',Marker{i},'markersize',5,'markerfacecolor',barFaceColor(i,:));hold on
%         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);
        plot(x,y_mean,'color',barColor,'linestyle','-','marker',Marker,'linewidth',0.5);
        plot(x,y_mean-y_errorbar,':','color',(barColor),'linewidth',0.2);
        plot(x,y_mean+y_errorbar,':','color',(barColor),'linewidth',0.2);
elseif PlotMode==6
%         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','-','marker',Marker{i},'markersize',5,'markerfacecolor',barFaceColor(i,:));hold on
%         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);
        plot(x,y_mean,'color',barColor,'linestyle','-','marker',Marker,'linewidth',0.5);
% %         plot(x,y_mean-y_errorbar,':','color',(barColor(i,:)),'linewidth',0.2);
% %         plot(x,y_mean+y_errorbar,':','color',(barColor(i,:)),'linewidth',0.2);

else
    
end

return;

else
    
    if isstruct(y_mean)
       y_mean=struct2cell(y_mean);
    end
    
    for ii=1:length(y_mean)
    tempMean(ii)=nanmean(y_mean{ii});
        if GroupPair.Std==1
    tempStd(ii)=nanstd(y_mean{ii});
        else
    tempStd(ii)=ste(y_mean{ii}(:));
            
        end
    end
    
%     deltaX=mean(diff(x));

    deltaX=mean(diff(x));

%     if Datatype~=0
    Group=[];
     Data=[];

    for ii=1:length(y_mean)
        Group=[Group(:);zeros(length(y_mean{ii}),1)+ii];
        Data=[Data;y_mean{ii}(:)];
        Num(ii)=sum(Group==ii);
        xTemp{ii}(1:Num(ii),1)=(randn(1,length(y_mean{ii})))*deltaX/40+x(ii);
        yTemp{ii}(1:Num(ii),1)=y_mean{ii}(:);
            if GroupPair.SamplePlot==1

        plot(xTemp{ii}(1:Num(ii)),yTemp{ii}(1:Num(ii)),'color',[0.6 0.6 0.6],'linestyle','none','marker','.','markersize',2);
        hold on;  
        
%         end
           end
%     end
    end
    
    RGroup=unique(RGroupID);
%     GroupG=[];
%     if length(RGroup)<length(y_mean)
%         clear yTemp;
%     for ii=1:length(RGroup)
%         tempRGI=find(RGroupID==RGroup(ii));
%         yTemp{ii}=[];
% 
%         for jj=1:length(tempRGI)
%             yTemp{ii}=[yTemp{ii} y_mean{tempRGI(jj)}];
% % %             GroupG=[GroupG(:);zeros(length(y_mean{ii}),1)+ii];
%         end
%         
% %         end
%     end
% %     end
%     end
    
    
    if Datatype~=0
       if GroupPair.SamplePlot==1&&GroupPair.SamplePairedPlot~=0
           
         for ig=1:size(GroupPair.Pair,2)
       ig1=GroupPair.Pair(1,ig);
       ig2=GroupPair.Pair(2,ig);
       if abs(ig1-ig2)==1
           if RGroupID(ig1)== RGroupID(ig2)
       for i=1:size(xTemp,1)
             if GroupPair.SamplePairedPlot==1
              for ixt=1:length(xTemp{ig1})
%                    plot(xTemp{ig1}(ixt),yTemp{ig1}(i,x_IndexS(ixt):x_IndexO(ixt)),'color',[0.6 0.6 0.6],'linestyle',':');
%                    plot(xTemp{ig1}(ixt),yTemp{ig1}(i,x_IndexS(ixt):x_IndexO(ixt)),'color',[0.6 0.6 0.6],'linestyle',':');
                   plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.2);
                   
                   
              end
             elseif GroupPair.SamplePairedPlot==2
              %%%%%%%%%%red line for increasing;blue line for decreasing;
              for ixt=1:length(xTemp{ig1})
                  if xTemp{ig1}(ixt)<xTemp{ig2}(ixt)
                     if yTemp{ig1}(ixt)<yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[1 0.5 0.5],'linestyle','-','linewidth',0.2);
                     elseif yTemp{ig1}(ixt)>yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.5 0.5 1],'linestyle','-','linewidth',0.2);
                     else
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.2);

                     end
                  else
                      
                     if yTemp{ig1}(ixt)>yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[1 0.5 0.5],'linestyle','-','linewidth',0.2);
                     elseif yTemp{ig1}(ixt)<yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.5 0.5 1],'linestyle','-','linewidth',0.2);
                     else
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.2);

                     end
                   
                  end
              end
              %%%%%%%%%%red line for increasing;blue line for decreasing;
             end
%                plot(xTemp(i,:),yTemp(i,:),'color',[0.6 0.6 0.6],'linestyle',':');
       end
       end
       end
         end
       end
    end
    
    
    ErrorBarPlotLU(x+deltaX/8,tempMean,tempStd,barColor,PlotMode);hold on;
    return;
    if ~isfield(GroupPair,'SignY')
       GroupPair.SignY=max(tempMean)+max(tempStd)*1.5;
    end
    if ~isfield(GroupPair,'LimY')
       GroupPair.LimY=[min(tempMean)-max(tempStd)*1.5 max(tempMean)+max(tempStd)*1.5];
    end

    return;

    ShowTemp(1,:)='                                                                        ';
  
    clear ANOVAtext;

   if Datatype==1
%        zTemp=yTemp;
%       for iNan=1:length(zTemp)
%           nanI=find(sum(isnan(zTemp{iNan}),2)>0);
%           zTemp{iNan}(nanI,:)=[];
%       end
%       [p, table, Astats] = anova_rm(zTemp,'off');

      %%%%%%%%regroup the the same group but different measurements together
      for iR=1:length(RGroup)
          igroupI=find(RGroupID==RGroup(iR));
          for irr=1:length(igroupI)
              zTemp{iR}(:,irr)=yTemp{igroupI(irr)}; 
          end
          
      end
     %%%%%%%%regroup the the same group but different measurements together

      %%%%%%%in case of missing value 
      for iNan=1:length(zTemp)
          nanI=find(sum(isnan(zTemp{iNan}),2)>0);
          zTemp{iNan}(nanI,:)=[];
      end
      %%%%%%%in case of missing value 

      [p, table, Astats] = anova_rm(zTemp,'off');

      
      
       clear ANOVAstat
       if length(RGroup)==length(y_mean)|length(RGroup)==1 %%%%%%oneway repeated Anova
           ANOVAtext=['Session Effect:', 'F', num2str(table{2,3}) ',' num2str(table{4,3}) '=' num2str(table{2,5}) ,' P=',num2str(table{2,6})];
           stats.ANOVAname='One Way ANOVA RepeatMeasures ';

       else %%%%%%Mixed Anova with One Way repeated Measures
           stats.ANOVAname='Mixed Anova repeated Measures';
           ANOVAtext{1}=['Session Effect:', 'F', num2str(table{2,3}) ',' num2str(table{6,3}) '=' num2str(table{2,5}) ,' P=',num2str(table{2,6})];
           ANOVAtext{2}=['Group Effect:', 'F', num2str(table{3,3}) ',' num2str(table{5,3}) '=' num2str(table{3,5}) ,' P=',num2str(table{3,6})];
           ANOVAtext{3}=['Interaction:', 'F', num2str(table{4,3}) ',' num2str(table{6,3}) '=' num2str(table{4,5}) ,' P=',num2str(table{4,6})];

       end
       %        ANOVAstat{2,1}=['Genotype Effect:', 'F', num2str(table{2,3}) ',' num2str(table{6,3}) '=' num2str(table{3,5}) ,' P=',num2str(table{3,6})];
%        ANOVAstat{2,1}=['Interaction Effect:', 'F', num2str(table{4,3}) ',' num2str(table{6,3}) '=' num2str(table{4,5}) ,' P=',num2str(table{4,6})];
    stats.p_ANOVA=p;
    stats.table_ANOVA=table;
    stats.stats_ANOVA=Astats;
    clear p

   else
    [p,table, Astats] = anova1(Data,Group,'off');
     ANOVAtext=['Session Effect:', 'F', num2str(table{2,3}) ',' num2str(table{3,3}) '=' num2str(table{2,5}) ,' P=',num2str(table{2,6})];

    stats.ANOVAname='One Way ANOVA';
    stats.p_ANOVA=p;
    stats.table_ANOVA=table;
    stats.stats_ANOVA=Astats;
    clear p
   end
   TempText=stats.ANOVAname;
   ShowTemp(end+1,1:length(TempText))=TempText;
   if iscell(ANOVAtext)
   for iA=1:length(ANOVAtext) 
   TempText=ANOVAtext{iA};
   ShowTemp(end+1,1:length(TempText))=TempText;
   end
   
   else
   TempText=ANOVAtext;
   ShowTemp(end+1,1:length(TempText))=TempText;

       
   end
   TempText=' ';
   ShowTemp(end+1,1:length(TempText))=TempText;
   TempText='Pairwise Comparison';
   ShowTemp(end+1,1:length(TempText))=TempText;

   
   for igroup=1:size(GroupPair.Pair,2)
       ii=GroupPair.Pair(1,igroup);
       iii=GroupPair.Pair(2,igroup);
       
           yTemp1=y_mean{ii}(:);
           yTemp2=y_mean{iii}(:);
           r1(igroup)=ii;
           c1(igroup)=iii;
           if RGroupID(ii)==RGroupID(iii)
              [~,p(igroup),~,Tstat(igroup)]=ttest(yTemp1,yTemp2);
               TempText=[ 'Group' num2str(ii) '-Group' num2str(iii),...
' ,t' num2str(Tstat(igroup).df) '=' num2str(Tstat(igroup).tstat) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           else
              [~,p(igroup),~,Tstat(igroup)]=ttest2(yTemp1,yTemp2);
                         TempText=[ 'Group' num2str(ii) '-Group' num2str(iii),...
' ,t' num2str(Tstat(igroup).df) '=' num2str(Tstat(igroup).tstat) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           end
   end
   
   if strmatch(GroupPair.CorrName,'fdr')
      if isfield(GroupPair,'Crit_p')
         crit_p=GroupPair.Crit_p;
         crit_p(crit_p>0.05)=0.05;
          for iq=1:length(crit_p)
               sigSign{iq}=repmat('*',1,iq);
          end
      else
          for iq=1:length(GroupPair.Q)
              [h, crit_p(iq), adj_p]=fdr_bh(p,GroupPair.Q(iq),'pdep','yes');
          sigSign{iq}=repmat('*',1,iq);
          end
          crit_p(crit_p>0.05)=0.05;

          
      end
%       sigSign=sigSign(end:-1:1); 
      
      TempText=['Multi-Compairson ' GroupPair.CorrName];
      ShowTemp(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      for iq=1:length(GroupPair.Q)
          TempText=[num2str(GroupPair.Q(iq)) ' ' num2str(crit_p(iq))];
          ShowTemp(end+1,1:length(TempText))=TempText;
      end
     
      if GroupPair.Plot==1
      iStep=abs(diff(GroupPair.Pair));
      for igroup=1:length(p)
         xP=x(GroupPair.Pair(:,igroup))+deltaX/8;
         xP(1)=xP(1)+deltaX/20;
         xP(2)=xP(2)-deltaX/20;

         yP=GroupPair.SignY+(iStep(igroup)-1)*abs(diff(GroupPair.LimY))/20;
         yP=zeros(size(xP))+yP;
          for iq=1:length(crit_p)
             if p(igroup)<=crit_p(iq)
%                  GroupPair.LimY
                deltaY=random('norm',0,abs(diff(GroupPair.LimY)/80),1,1);
                plot(xP,yP+deltaY,'k-');
                plot(mean(xP),yP+abs(diff(GroupPair.LimY))/100+deltaY,['k' sigSign{iq}]);
                continue;
             end
          end
      end
      end
   end
      

   
   
         TempText='mean � sd';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(y_mean)

          TempText=['Group' num2str(ii) ' ' num2str(nanmean(y_mean{ii}(:))) ' � ' num2str(nanstd(y_mean{ii}(:))) ' n=' num2str(length(y_mean{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;

      end
   

stats.p_Pair=p;
stats.t_Pair=Tstat;
stats.crit_p=crit_p;
    if ~isempty(SavePath)
       fileID = fopen(SavePath,'w');

       for i=1:length(ShowTemp(:,1))
           fprintf(fileID,'%s\r\n',deblank(ShowTemp(i,:)));
       end
% % writetable(D1,fileID);
       fclose(fileID);

    end
end

