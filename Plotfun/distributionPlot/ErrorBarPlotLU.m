function stats=ErrorBarPlotLU(x,y_mean,y_errorbar,PlotColor,PlotMode,varargin)


%%%Input:
%%%%%%%x,coordinates in x axis, 1*n dimension vector, n groups in total;
%%%%%%%y-mean, 1*n dimension vector for mean;
%%%%%%%y-errorbar, 1*n dimension vector for errorbar, could be std or ste;
%%%%Important:
%%%%%%%y-mean, could be cells data, in this case, y{i} includes all samples within group i; then let y_errorbar=[];

%%%%PlotColor, PlotColor(i,:) is color for group i data;
%%%%%%PlotMode=1; barPlot
%%%%%%PlotMode=2; DotPlot
%%%%%%PlotMode=3; AreaPlot
%%%%%%Datatype=varargin{1};  %%%%%%default 0, non-paired data; 1 for paired data
%%%%%%SavePath=varargin{2};  %%%%%%Path to save statis to a text file,[] for no saving
%%%%%%GroupPair=varargin{3};  %%%%%%pairs of groups for t-test
% % % % %    GroupPair.CorrName='fdr';    %%%%%FDR correction
% % % % %    GroupPair.Q=0.1;             %%%%%FDR q values
% % % % %    GroupPair.Pair=[];           %%%%%test group pair
                %%%%[1 1 2;3 4 4], would do 1-3, 1-4 and 2-4 comparisons;
                %%%%default [], in this case all possible group pairs would be compared.

% % % % %    GroupPair.SignY=2;    %%%%%%%%%an estimation at y axis for plot the 'significant sign'
% % % % %    GroupPair.Plot=1;     %%%%%%%%%1 for plot;0 for no plot with output statistics only
% % % % %    GroupPair.Std=1;      %%%%%%%%%1 using standard deviation as errorbar, 0 refers to standard error
% % % % %    GroupPair.SamplePlot=1; %%%%%%%%%1 plot individual sample; 0 No plot individuall sample
% % % % %    GroupPair.SamplePairedPlot=1; %%%%%%%%%1 using dash line for paired comparison sample;0 no dash line plot
% % % % %    GroupPair.LimY=[0 GroupPair.SignY*1.2]; %%%%Y axis limit in plot
% % % % %    GroupPair.Marker={'o'}; %%%%Plot Markers

%%%%%%RGroupID=varargin{4};  %%%%%%higher hirarchy of groupID, for repeat measures;
%%%%%%E.G. groupID is 1,2,3,4,5,6, corresponding to 1 1 1 2 2 2 for RGroupID,
%%%%%%so group 1 2 3 were repeated measured from a larger RGroup 1; while 4 5 6 were repeated measured from RGroup 2;
%%%%%%In this case, within the same RGroup, paired-ttest was used; between RGroup, non paired ttest was used;




if nargin==6
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=[];           
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==7
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==8
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=varargin{3};
   RGroupID=1:length(x);
elseif nargin==9
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=varargin{3};
   RGroupID=varargin{4};

else
   SavePath=[];           
   Datatype=0;
   GroupPair=[];
   RGroupID=1:length(x);

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

if isnumeric(PlotColor)
   barColor=PlotColor;
   barFaceColor=PlotColor;
elseif iscell(PlotColor)
   barColor=PlotColor{1};
   barFaceColor=PlotColor{2};

else
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
   GroupPair.Marker={'o'};

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
if isfield(GroupPair,'Marker')
   Marker=GroupPair.Marker;
else
   Marker={'o'};
end
if length(Marker)==1
   Marker=repmat(Marker,1,length(x));
end


if size(barColor,1)==1
   barColor=repmat(barColor,length(x),1);
end
if size(barFaceColor,1)==1
   barFaceColor=repmat(barFaceColor,length(x),1);
end

if (~iscell(y_mean))&&(~isstruct(y_mean))


if PlotMode==1
    for i=1:length(x)
        b=bar(x(i),y_mean(i),0.8,'facecolor',barFaceColor(i,:),'Edgecolor',barColor(i,:));hold on;
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));
    end
elseif PlotMode==2
        for i=1:length(x)
% %         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker','o','markersize',10);hold on
% %         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));

        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker',Marker{i},'markersize',5,'markerfacecolor',barFaceColor(i,:));hold on
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);

        
        
        end
%         plot(x,y_mean,'color',barColor(i,:),'linestyle','-');hold on

elseif PlotMode==3
       error_area(x,y_mean,y_errorbar,barColor(1,:),0.3,'-',1);hold on;
elseif PlotMode==4
        for i=1:length(x)
% %         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker','o','markersize',10);hold on
% %         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));

        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker',Marker{i},'markersize',5,'markerfacecolor',barFaceColor(i,:));hold on
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);

        
        
        end
        plot(x,y_mean,'color',barColor(i,:),'linestyle','-');hold on

       
elseif PlotMode==5
%         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','-','marker',Marker{i},'markersize',5,'markerfacecolor',barFaceColor(i,:));hold on
%         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);
        plot(x,y_mean,'color',barColor(i,:),'linewidth',1);
        plot(x,y_mean-y_errorbar,'color',sqrt(barColor(i,:)),'linewidth',0.5);
        plot(x,y_mean+y_errorbar,'color',sqrt(barColor(i,:)),'linewidth',0.5);

else
end



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
                   plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.4);
                   
                   
              end
             elseif GroupPair.SamplePairedPlot==2
              %%%%%%%%%%red line for increasing;blue line for decreasing;
              for ixt=1:length(xTemp{ig1})
                  if xTemp{ig1}(ixt)<xTemp{ig2}(ixt)
                     if yTemp{ig1}(ixt)<yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[1 0.5 0.5],'linestyle','-','linewidth',0.4);
                     elseif yTemp{ig1}(ixt)>yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.5 0.5 1],'linestyle','-','linewidth',0.4);
                     else
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.4);

                     end
                  else
                      
                     if yTemp{ig1}(ixt)>yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[1 0.5 0.5],'linestyle','-','linewidth',0.4);
                     elseif yTemp{ig1}(ixt)<yTemp{ig2}(ixt)
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.5 0.5 1],'linestyle','-','linewidth',0.4);
                     else
                         plot([xTemp{ig1}(ixt) xTemp{ig2}(ixt)],[yTemp{ig1}(ixt) yTemp{ig2}(ixt)],'color',[0.6 0.6 0.6],'linestyle','-','linewidth',0.4);

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
    
    GroupPair2=GroupPair;
    GroupPair2.Marker=Marker;

    ErrorBarPlotLU(x+deltaX/8,tempMean,tempStd,PlotColor,PlotMode,Datatype,[],GroupPair2);hold on;
    if ~isfield(GroupPair,'SignY')
       GroupPair.SignY=max(tempMean)+max(tempStd)*1.5;
    end
    if ~isfield(GroupPair,'LimY')
       GroupPair.LimY=[min(tempMean)-max(tempStd)*1.5 max(tempMean)+max(tempStd)*1.5];
    end

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
               TempText=[ GName{ii} '-' GName{iii},...
' ,t' num2str(Tstat(igroup).df) '=' num2str(Tstat(igroup).tstat) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           else
              [~,p(igroup),~,Tstat(igroup)]=ttest2(yTemp1,yTemp2);
                         TempText=[ GName{ii} '-' GName{iii},...
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
          for iii=1:length(y_mean)
              res(iii) = prctile(y_mean{iii}(:),[100]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point
          end
          LowShowY=max(res);
          

      iStep=abs(diff(GroupPair.Pair));

      for igroup=1:length(p)
         xP=x(GroupPair.Pair(:,igroup))+deltaX/8;
         xP(1)=xP(1)+deltaX/20;
         xP(2)=xP(2)-deltaX/20;

% %          yP=GroupPair.SignY+(iStep(igroup)-1)*abs(diff(GroupPair.LimY))/20;
% %          yP=zeros(size(xP))+yP;
         
         
         yP=mean([GroupPair.SignY(:);LowShowY]);
         yP=yP+(iStep(igroup)-1)*abs(GroupPair.LimY(end)-LowShowY)/length(p)/2;
         yP=min([yP max(GroupPair.SignY)]);
         yP=zeros(size(xP))+yP;
         

         

          for iq=1:length(crit_p)
             if p(igroup)<=crit_p(iq)
%                  GroupPair.LimY
%                 deltaY=random('norm',0,abs(diff(GroupPair.LimY)/80),1,1);
                deltaY=random('uniform',-abs(diff(GroupPair.LimY)/10),abs(diff(GroupPair.LimY)/10),1,1);

                plot(xP,yP+deltaY,'k-');
%                 plot(mean(xP),yP+abs(diff(GroupPair.LimY))/100+deltaY,['k' sigSign{iq}]);
%                  text(mean(xP),mean(yP)+deltaY,sigSign{iq},'horizontalalignment','center','verticalalignment','baseline','fontsize',10,'fontname','time new roman');

                continue;
             end
          end
      end
      end
   end
      

   
   
         TempText='mean ± sd';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(y_mean)

          TempText=[GName{ii} ' ' num2str(nanmean(y_mean{ii}(:))) ' ± ' num2str(nanstd(y_mean{ii}(:))) ' n=' num2str(length(y_mean{ii}))];
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
% set(gca,'xlim',[x(1)-1 x(end)+1],'xtick',[]);