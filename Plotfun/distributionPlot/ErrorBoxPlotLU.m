function stats=ErrorBoxPlotLU(varargin)
%%%%%ErrorBoxPlotLU(x,data,dataColor)
%%%%%plot multi boxplot data; data is cell variables;

%%%%%x=varargin{1}; x axis data;
%%%%%data=varargin{2}; data could be a matrix with data(:,i) as a group of
%%%%%data corresponds to x(i); or data could be a cell where data{i}
%%%%%corresponds to x(i)

x=varargin{1};
data=varargin{2};


if ~iscell(data)

   for ii=1:size(data,2)
       dataT{ii}=data(:,ii); 
   end
   data=dataT;
   clear dataT;
end

[x,xi]=sort(x);
data=data(xi);

   colorPlot=varargin{3};
%    GroupPair=[];
%    SavePath=[];           

   if nargin==3
   SavePath=[];           
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
%    GroupPair=[];
%    SavePath=[];           

   elseif nargin==4
   SavePath=varargin{4};
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
   elseif nargin==5
   SavePath=varargin{4};
   GroupPair=varargin{5};
   RGroupID=1:length(x);   %%%repeated groupID;
   elseif nargin==6
   SavePath=varargin{4};
   GroupPair=varargin{5};
   RGroupID=varargin{6};   %%%repeated groupID;
   else
       
   end



if size(colorPlot,1)==1
   colorPlot=repmat(colorPlot,length(x),1);
end

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

if ~isfield(GroupPair,'GroupName')
   for i=1:length(x) 
       GroupPair.GroupName{i}=['group' num2str(i)];
   end
end
GName=GroupPair.GroupName;


   if isempty(GroupPair.Pair)
   for i=1:length(x) 
       for j=(i+1):length(x)
           GroupPair.Pair=[GroupPair.Pair [i;j]];
       end
   end
      
   end
    Group=[];
     Data=[];
         deltaX=median(diff(x));

    for ii=1:length(data)
        Group=[Group(:);zeros(length(data{ii}),1)+ii];
        Data=[Data;data{ii}(:)];
        Num(ii)=sum(Group==ii);
        xTemp{ii}(1:Num(ii),1)=(randn(1,length(data{ii})))*deltaX/40+x(ii);
        yTemp{ii}(1:Num(ii),1)=data{ii}(:);
            if GroupPair.SamplePlot==1

        plot(xTemp{ii}(1:Num(ii)),yTemp{ii}(1:Num(ii)),'color',[0.6 0.6 0.6],'linestyle','none','marker','.','markersize',2);
        hold on;  
        
%         end
           end
%     end
    end
    RGroup=unique(RGroupID);

    
   if GroupPair.SamplePlot==1&&GroupPair.SamplePairedPlot~=0
           
         for ig=1:size(GroupPair.Pair,2)
       ig1=GroupPair.Pair(1,ig);
       ig2=GroupPair.Pair(2,ig);
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

    
    for i=1:length(x)
    
%     boxplot(data{i}(:),x(i)+0.1,'notch','off','color',colorPlot(i,:),'symbol','','boxstyle','filled','positions',x(i)+0.1);hold on;
    boxplot(data{i}(:),x(i)+0.3,'notch','off','color',colorPlot(i,:),'symbol','','boxstyle','outline','positions',x(i)+0.3);hold on;

set(gca,'tickdir','out','FontUnits','points','xtick',[],'yticklabel',[],'xlim',[min(x)-0.7 max(x)+0.7],'xticklabel',{'' '' '' '' ''},'xtick',x,'box','off','fontsize',12,'color',[1 1 1],'xcolor',[0 0 0],'ycolor',[0 0 0],'linewidth',0.5);

end

    
    
    if ~isfield(GroupPair,'SignY')
       GroupPair.SignY=max(tempMean)+max(tempStd)*1.5;
    end
    if ~isfield(GroupPair,'LimY')
       GroupPair.LimY=[min(tempMean)-max(tempStd)*1.5 max(tempMean)+max(tempStd)*1.5];
    end

    ShowTemp(1,:)='                                                                        ';
  
    clear ANOVAtext;

        RGroup=unique(RGroupID);

   if length(RGroup)<length(RGroupID)
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
       if length(RGroup)==length(RGroupID)||length(RGroup)==1  %%%%%%oneway repeated Anova
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
       
           yTemp1=data{ii}(:);
           yTemp2=data{iii}(:);
           r1(igroup)=ii;
           c1(igroup)=iii;
           if RGroupID(ii)==RGroupID(iii)
              [p(igroup),~,Tstat{igroup}]=signrank(yTemp1,yTemp2);
              if sum(isnan(yTemp1))==length(yTemp1)||sum(isnan(yTemp2))==length(yTemp2)
                 TempText=[ GName{ii} '-' GName{iii},'Nan Values'];
                 ShowTemp(end+1,1:length(TempText))=TempText;
                 p(igroup)=nan;
                  continue;
              end
               TempText=[ GName{ii} '-' GName{iii},...
' ,signedrank=' num2str(Tstat{igroup}.signedrank) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           else
              if sum(isnan(yTemp1))==length(yTemp1)||sum(isnan(yTemp2))==length(yTemp2)
                 TempText=[ GName{ii} '-' GName{iii},'Nan Values'];
                 ShowTemp(end+1,1:length(TempText))=TempText;
                 p(igroup)=nan;

                  continue;
              end
% %              igroup
              [p(igroup),~,Tstat{igroup}]=ranksum(yTemp1,yTemp2);
                         TempText=[ GName{ii} '-' GName{iii},...
' ,ranksum=' num2str(Tstat{igroup}.ranksum) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           end
   end
   
   stats.p_Pair=p;
   stats.Rankstats=Tstat;

   
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
       
      TempText=['Multi-Compairson ' GroupPair.CorrName];
      ShowTemp(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      for iq=1:length(GroupPair.Q)
          TempText=[num2str(GroupPair.Q(iq)) ' ' num2str(crit_p(iq))];
          ShowTemp(end+1,1:length(TempText))=TempText;
      end
     
      if GroupPair.Plot==1
      
          for iii=1:length(data)
              res(iii) = prctile(data{iii}(:),[100]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point
          end
          LowShowY=max(res);
          
          iStep=abs(diff(GroupPair.Pair));
      
      for igroup=1:length(p)
         xP=x(GroupPair.Pair(:,igroup))+deltaX/8;
         xP(1)=xP(1)+deltaX/20;
         xP(2)=xP(2)-deltaX/20;

         yP=mean([GroupPair.SignY(:) LowShowY]);
         yP=yP+(iStep(igroup)-1)*abs(GroupPair.LimY(end)-LowShowY)/length(p)/2;
         yP=min([yP max(GroupPair.SignY)]);
         yP=zeros(size(xP))+yP;
          for iq=1:length(crit_p)
             if p(igroup)<=crit_p(iq)
%                  GroupPair.LimY
                deltaY=random('uniform',-abs(diff(GroupPair.LimY)/10),abs(diff(GroupPair.LimY)/10),1,1);
%                 LL=10;
%                 deltaY=[randperm(LL,1)-LL/5]*abs(diff(GroupPair.LimY)/80);
%                  deltaY=0;

                plot(xP,yP+deltaY,'k-');
%                 plot(mean(xP),yP+abs(diff(GroupPair.LimY))/20+deltaY,['k' sigSign{iq}],'markersize',6);
                text(mean(xP),mean(yP)+deltaY,sigSign{iq},'horizontalalignment','center','verticalalignment','baseline','fontsize',10,'fontname','Arial');
%                tempTextY=min([mean(yP)+deltaY,max(GroupPair.LimY)]);
%                text(mean(xP),tempTextY,sigSign{iq},'horizontalalignment','center','verticalalignment','baseline','fontsize',10,'fontname','times new roman');
           
                
                continue;
             end
          end
      end
      end
   end
      

         TempText='median , [25% 75%]';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(data)
          res = prctile(data{ii}(:),[25 50 75]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point

          TempText=[GName{ii} ' ' num2str(res(2)) ' [' num2str(res(1)) ',' num2str(res(3)) '] n=' num2str(length(data{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;

      end

   
         TempText='median , [25% 75%]';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(data)
          res = prctile(data{ii}(:),[25 50 75]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point
          TempText=[GName{ii} ' ' num2str(res(2)) ' [' num2str(res(1)) ',' num2str(res(3)) '] n=' num2str(length(data{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;

      end
   

% stats.p_Pair=p;
% stats.t_Pair=Tstat;
% stats.crit_p=crit_p;
    if ~isempty(SavePath)
       fileID = fopen(SavePath,'w');

       for i=1:length(ShowTemp(:,1))
           fprintf(fileID,'%s\r\n',deblank(ShowTemp(i,:)));
       end
% % writetable(D1,fileID);
       fclose(fileID);

    end
end
% set(gca,'xlim',[x(1)-1 x(end)+1],'xtick',[]);    
    
    
    
% xstep=x(2)-x(1);
% set(gca,'tickdir','out','FontUnits','points','xtick',[],'yticklabel',[],'xlim',[x(1)-xstep/2 x(end)+xstep/2],'xticklabel','xtick',x,'box','off','fontsize',12,'color',[1 1 1],'xcolor',[0 0 0],'ycolor',[0 0 0]);

