function stats=ErrorViolinHalf(x,y_data,PlotColor,varargin)

%%%%%%%%Violin plot modifed by Lu Zhang from Abby's version
%%%%%%%%Integrated Lu Zhang's statistics calculation for one way ANOVA, or 2-ways Repeated ANOVA or 2 ways Mixed-ANOVA
%%%%%%%%Pair-wise comparisons was done by t-test and rank test



%%%Input:
%%%%%%%x,coordinates in x axis, 1*n dimension vector, n groups in total;
%%%%%%%y-mean, 1*n dimension vector for mean;
%%%%%%%y-errorbar, 1*n dimension vector for errorbar, could be std or ste;
%%%%Important:
%%%%%%%y-mean, could be cells data, in this case, y{i} includes all samples
%%%%%%%withn group i;
%%%%%%%then let y_errorbar=[];

%%%%PlotColor, PlotColor(i,:) is color for group i data;
%%%%%%Datatype=varargin{1};  %%%%%%default 0, non-paired data; 1 for
%%%%%%existence of paired data (or repeated measures); Repeated group info.
%%%%%%is in RGroupID. 

%%%%%%SavePath=varargin{2};  %%%%%%[], save statis to a text file;

%%%%%%GroupPair=varargin{3};  %%%%%%pairs of groups for t-test
%%%%%%default [], in this case all possible group pairs would be compared.
%%%%%%GroupPair.ViolinLR is a 0-1 vector with n dimension, 0 refers to left
%%%%%%violin while 1 refers to right violin.
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
%%%%%%so group 1 2 3 were from a larger RGroup1; while 4 5 6 from RGroup2;
%%%%%%In this case, within the same RGroup, paired-ttest was used; between
%%%%%%RGroup, non paired ttest was used;



if nargin==4
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=[];           
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==5
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==6
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   SavePath=varargin{2};  %%%%%%Save the stats to txt file
   GroupPair=varargin{3};
   RGroupID=1:length(x);
elseif nargin==7
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
   GroupPair.Test='Ttest';
   GroupPair.Q=0.1;
   GroupPair.Pair=[];
   GroupPair.SignY=2;
   GroupPair.Plot=1;
   GroupPair.Std=0;      %%%%%%%%%using standard deviation as errorbar
   GroupPair.SamplePlot=1; %%%%%%%%%Plot Individual Sample Point
   GroupPair.SamplePairedPlot=1; %%%%%%%%%Dash line for paired comparison sample
   GroupPair.LimY=[0 GroupPair.SignY*1.2];
   GroupPair.Marker={'o'};
   GroupPair.ViolinLR=zeros(1,length(x));
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

if isfield(GroupPair,'MarkerSize')
   MarkerSize=GroupPair.MarkerSize;
else
   MarkerSize=6;
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

if (~iscell(y_data))&&(~isstruct(y_data))


else
    
    if isstruct(y_data)
       y_data=struct2cell(y_data);
    end
   
    
    %%%%%%%%%%%Violin Plot   
    for ii=1:length(y_data)
        
%         violinplot_half(y_data{ii}, x(ii), 'ViolinColorMat',barColor(ii,:));
        if GroupPair.ViolinLR(ii)==0
        Violin_halfLeft(y_data{ii}, x(ii), 'ViolinColor',barColor(ii,:),'EdgeColor',[1 1 1],'BoxColor',barColor(ii,:),'ShowData',false,'BoxWidth',0.05);
        else
        Violin_halfRight(y_data{ii}, x(ii), 'ViolinColor',barColor(ii,:),'EdgeColor',[1 1 1],'BoxColor',barColor(ii,:),'ShowData',false,'BoxWidth',0.05);
    
        end
        
        
    tempMean(ii)=nanmean(y_data{ii});
        if GroupPair.Std==1
    tempStd(ii)=nanstd(y_data{ii});
        else
    tempStd(ii)=ste(y_data{ii}(:));
            
        end
    end
    %%%%%%%%%%%Violin Plot   
 
    
    
    
%     deltaX=mean(diff(x));

    deltaX=mean(diff(x));

%     if Datatype~=0
    Group=[];
     Data=[];

    
    RGroup=unique(RGroupID);
    
    
    GroupPair2=GroupPair;
    GroupPair2.Marker=Marker;

    if ~isfield(GroupPair,'SignY')
       GroupPair.SignY=max(tempMean)+max(tempStd)*1.5;
    end
    if ~isfield(GroupPair,'LimY')
       GroupPair.LimY=[min(tempMean)-max(tempStd)*1.5 max(tempMean)+max(tempStd)*1.5];
    end

    
    
    %%%%%%Following are for statistics.
    
    
    
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
       if length(RGroup)==length(y_data)|length(RGroup)==1 %%%%%%oneway repeated Anova
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

   %%%%%%%%%%Using t-test
   for igroup=1:size(GroupPair.Pair,2)
       ii=GroupPair.Pair(1,igroup);
       iii=GroupPair.Pair(2,igroup);
       
           yTemp1=y_data{ii}(:);
           yTemp2=y_data{iii}(:);
           r1(igroup)=ii;
           c1(igroup)=iii;
           if RGroupID(ii)==RGroupID(iii)
              [~,p(igroup),~,Tstat(igroup)]=ttest(yTemp1,yTemp2);
               TempText=[GName{ii} '-' GName{iii},...
' ,t' num2str(Tstat(igroup).df) '=' num2str(Tstat(igroup).tstat) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           else
              [~,p(igroup),~,Tstat(igroup)]=ttest2(yTemp1,yTemp2);
                         TempText=[ GName{ii} '-' GName{iii},...
' ,t' num2str(Tstat(igroup).df) '=' num2str(Tstat(igroup).tstat) ',p=' num2str(p(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           end
   end
   %%%%%%%%%%Using t-test
stats.p_Pair=p;
stats.t_Pair=Tstat;
stats.PairGroup=GroupPair.Pair;
             for iq=1:length(GroupPair.Q)
                 [h, crit_pT(iq), adj_p]=fdr_bh(p,GroupPair.Q(iq),'pdep','yes');
             end
   stats.pTTestFDRth=crit_pT;
      TempText=['Multi-Compairson ' GroupPair.CorrName 'Ttest'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      for iq=1:length(GroupPair.Q)
          TempText=[num2str(GroupPair.Q(iq)) ' ' num2str(crit_pT(iq))];
          ShowTemp(end+1,1:length(TempText))=TempText;
      end

      
      
      
      
   %%%%%%%%%%Using rank-test
   for igroup=1:size(GroupPair.Pair,2)
       ii=GroupPair.Pair(1,igroup);
       iii=GroupPair.Pair(2,igroup);
       
           yTemp1=y_data{ii}(:);
           yTemp2=y_data{iii}(:);
           r1(igroup)=ii;
           c1(igroup)=iii;
           if RGroupID(ii)==RGroupID(iii)
              [pRank(igroup),~,Rankstat(igroup)]=signrank(yTemp1,yTemp2);
              if sum(isnan(yTemp1))==length(yTemp1)||sum(isnan(yTemp2))==length(yTemp2)
                 TempText=[ GName{ii} '-' GName{iii},'Nan Values'];
                 ShowTemp(end+1,1:length(TempText))=TempText;
                 pRank(igroup)=nan;
                  continue;
              end
               TempText=[ GName{ii} '-' GName{iii},...
' ,signedrank=' num2str(Rankstat(igroup).signedrank) ',p=' num2str(pRank(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           else
              if sum(isnan(yTemp1))==length(yTemp1)||sum(isnan(yTemp2))==length(yTemp2)
                 TempText=[ GName{ii} '-' GName{iii},'Nan Values'];
                 ShowTemp(end+1,1:length(TempText))=TempText;
                 pRank(igroup)=nan;

                  continue;
              end

              [pRank(igroup),~,Rankstat(igroup)]=ranksum(yTemp1,yTemp2);
                         TempText=[ GName{ii} '-' GName{iii},...
' ,ranksum=' num2str(Rankstat(igroup).ranksum) ',p=' num2str(pRank(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;

           end
   end
   %%%%%%%%%%Using rank-test

   stats.pRank=pRank;
   stats.Rankstats=Rankstat;
             for iq=1:length(GroupPair.Q)
                 [h, crit_pRank(iq), adj_p]=fdr_bh(pRank,GroupPair.Q(iq),'pdep','yes');
             end
   stats.pRankFDRth=crit_pRank;
         TempText=['Multi-Compairson ' GroupPair.CorrName 'RankTest'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      for iq=1:length(GroupPair.Q)
          TempText=[num2str(GroupPair.Q(iq)) ' ' num2str(crit_pRank(iq))];
          ShowTemp(end+1,1:length(TempText))=TempText;
      end

   
   if strmatch(GroupPair.Test,'Ttest')
       
      crit_pNeed=crit_pT;
      pNeed=stats.p_Pair;
   elseif strmatch(GroupPair.Test,'Ranktest')
      crit_pNeed=crit_pRank;
      pNeed=stats.pRank;

   else
      disp('GroupPair.Test should be either Ttest or Ranktest;here using Ttest for FDR correction'); 
      crit_pNeed=crit_pT;
      pNeed=stats.p_Pair;

   end
       
   
   if strmatch(GroupPair.CorrName,'fdr')
      if isfield(GroupPair,'Crit_p')
         crit_p=GroupPair.Crit_p;
         crit_p(crit_p>0.05)=0.05;
          for iq=1:length(crit_p)
               sigSign{iq}=repmat('*',1,iq);
          end
      else
          crit_p=crit_pNeed;
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
          for iii=1:length(y_data)
              res(iii) = prctile(y_data{iii}(:),[80]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point
          end
          LowShowY=max(res);
          

      iStep=abs(diff(GroupPair.Pair));
      for igroup=1:length(p)
         xP=x(GroupPair.Pair(:,igroup));
         xP(1)=xP(1)+deltaX/40;
         xP(2)=xP(2)-deltaX/40;

% %          yP=GroupPair.SignY+(iStep(igroup)-1)*abs(diff(GroupPair.LimY))/20;
% %          yP=zeros(size(xP))+yP;
         
         yP=mean([GroupPair.SignY(:);LowShowY]);
         yP=yP+(iStep(igroup)-1)*abs(GroupPair.LimY(end)-LowShowY)/length(p)/2;
         yP=min([yP max(GroupPair.SignY)]);
         yP=zeros(size(xP))+yP;

          for iq=1:length(crit_p)
             if pNeed(igroup)<=crit_p(iq)
%                  GroupPair.LimY
                deltaY=random('norm',0,abs(diff(GroupPair.LimY)/20),1,1);
                plot(xP,yP+deltaY,'k-');
%                 plot(mean(xP),yP+abs(diff(GroupPair.LimY))/100+deltaY,['k' sigSign{iq}]);
%                  text(mean(xP),mean(yP)+deltaY,sigSign{iq},'horizontalalignment','center','verticalalignment','baseline','fontsize',10,'fontname','Arial');

                continue;
             end
          end
      end
      end
   end
      

   
   
         TempText='mean ± sd';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(y_data)

          TempText=[GName{ii} ' ' num2str(nanmean(y_data{ii}(:))) ' ± ' num2str(nanstd(y_data{ii}(:))) ' n=' num2str(length(y_data{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;
         

      end
   
               TempText='mean ± sem';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(y_data)

          TempText=[GName{ii} ' ' num2str(nanmean(y_data{ii}(:))) ' ± ' num2str(ste(y_data{ii}(:))) ' n=' num2str(length(y_data{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;
         

      end

      
               TempText='median , [25% 75%]';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(y_data)
          res = prctile(y_data{ii}(:),[25 50 75]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point

          TempText=[GName{ii} ' ' num2str(res(2)) ' [' num2str(res(1)) ',' num2str(res(3)) '] n=' num2str(length(y_data{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;

      end

      

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
end



function [violins,plotinfo] = violinplot_half(data, cats, varargin)
%Violinplots plots violin plots of some data and categories
%   VIOLINPLOT(DATA) plots a violin of a double vector DATA
%
%   VIOLINPLOT(DATAMATRIX) plots violins for each column in
%   DATAMATRIX.
%
%   VIOLINPLOT(TABLE), VIOLINPLOT(STRUCT), VIOLINPLOT(DATASET)
%   plots violins for each column in TABLE, each field in STRUCT, and
%   each variable in DATASET. The violins are labeled according to
%   the table/dataset variable name or the struct field name.
%
%   VIOLINPLOT(DATAMATRIX, CATEGORYNAMES) plots violins for each
%   column in DATAMATRIX and labels them according to the names in the
%   cell-of-strings CATEGORYNAMES.
%
%   VIOLINPLOT(DATA, CATEGORIES) where double vector DATA and vector
%   CATEGORIES are of equal length; plots violins for each category in
%   DATA.
%
%   violins = VIOLINPLOT(...) returns an object array of
%   <a href="matlab:help('Violin')">Violin</a> objects.
%
%   VIOLINPLOT(..., 'PARAM1', val1, 'PARAM2', val2, ...)
%   specifies optional name/value pairs for all violins:
%     'Width'        Width of the violin in axis space.
%                    Defaults to 0.3
%     'Bandwidth'    Bandwidth of the kernel density estimate.
%                    Should be between 10% and 40% of the data range.
%     'ViolinColor'  Fill color of the violin area and data points.
%                    Defaults to the next default color cycle.
%     'ViolinAlpha'  Transparency of the violin area and data points.
%                    Defaults to 0.3.
%     'EdgeColor'    Color of the violin area outline.
%                    Defaults to [0.5 0.5 0.5]
%     'BoxColor'     Color of the box, whiskers, and the outlines of
%                    the median point and the notch indicators.
%                    Defaults to [0.5 0.5 0.5]
%     'MedianColor'  Fill color of the median and notch indicators.
%                    Defaults to [1 1 1]
%     'ShowData'     Whether to show data points.
%                    Defaults to true
%     'ShowNotches'  Whether to show notch indicators.
%                    Defaults to false
%     'ShowMean'     Whether to show mean indicator
%                    Defaults to false
%     'GroupOrder'   Cell of category names in order to be plotted.
%                    Defaults to alphabetical ordering
%
% Copyright (c) 2016, Bastian Bechtold
% This code is released under the terms of the BSD 3-clause license
%
% -----------
% HALF VIOLIN
% edited from original function 'violinplot', to support half violin plots.
% run comparison to original function to verify changes. 
% currently ONLY tested using STRUCTURE data input. half violins are dependent
% on the order of the numeric fields in the structure. non-numeric fields
% will be ignored.
%
%       data.(field1) data.(field2)     data.(field3) data.(field4)   etc
% 
%   add field 'xlabels' to your input structure to specify the xlabels to
%   display below your half violins! you can either have one entry per
%   group of half violins, or one entry per half violin.
%       data.xlabels = {'timepoint1' 'timepoint2'}
%       data.xlabels = {'time1group1', 'time1group2', 'time2group1', ...
%       'time1group2'};
%
%   add field 'legendlabels' to your input structure to specify labels for
%   a legend. only 2 legend fields are supported - one for each side of the
%   half violin plots. if labels names are not specified, a legend wil not
%   be plotted. 
%       data.legendlabels = {'group1', 'group2'}
%
%   added additional name/pair options as detailed below
%     'BandwidthScale'  Set the scale of the bandwidth for the kernel
%                       density estimate. Should be between 0.1 and 0.4 
%                       (10%-40%). The datarange will be automatically
%                       calculated for each data field. 
%                       Bandwidth = (bandwidthscale)*range(data.(field))
%
%     'ViolinColorMat'  Pass in a matrix of RGB color values. Each row will
%                       correspond to the color of the violin. 
%                       # rows should equal # data fields
%
% ALP 11/9/21

    hascategories = exist('cats','var') && not(isempty(cats));
    
    %parse the optional grouporder argument 
    %if it exists parse the categories order 
    % but also delete it from the arguments passed to Violin
    grouporder = {};
    idx=find(strcmp(varargin, 'GroupOrder'));
    if ~isempty(idx) && numel(varargin)>idx
        if iscell(varargin{idx+1})
            grouporder = varargin{idx+1};
            varargin(idx:idx+1)=[];
        else
            error('Second argument of ''GroupOrder'' optional arg must be a cell of category names')
        end
    end
    
    %if bandwidth scale
    idx = find(strcmp(varargin, 'BandWidthScale')); 
    if ~isempty(idx) && numel(varargin) > idx
        scaleval = varargin{idx+1}; 
        varargin(idx:idx+1) = [];
    end
    
    %if input color
    idx = find(strcmp(varargin, 'ViolinColorMat')); 
    if ~isempty(idx) && numel(varargin) > idx
        colors = varargin{idx+1}; 
        varargin(idx:idx+1) = [];
    end

    % tabular data
    if isa(data, 'dataset') || isstruct(data) || istable(data)
        if isa(data, 'dataset')
            colnames = data.Properties.VarNames;
        elseif istable(data)
            colnames = data.Properties.VariableNames;
        elseif isstruct(data)
            colnames = fieldnames(data);
        end
        catnames = {};
        for n=1:length(colnames)
            if isnumeric(data.(colnames{n}))
                catnames = [catnames colnames{n}];
            end
        end
        for n=1:length(catnames)
            thisData = data.(catnames{n});
            if exist('scaleval', 'var') %ALP 2/3/22 calculate the bandwidth if desired
                bandwidth = scaleval*range(thisData); 
                varargin = [varargin {'Bandwidth'}, {bandwidth}];
            end
            violins(n) = Violin_half(thisData, n, varargin{:});
            plotinfo{n} = catnames{n}; %sanity check for you to make sure your data plotted in the correct order
        end
        
        %%% alp 11/9/21 to deal with adding xlabels. you can either specify
        %%% one label for each group of 2 violins, or have a label for each
        %%% half violin
        if isfield(data, 'xlabels')
            xlabels = data.xlabels; 
        else
            xlabels = catnames; 
        end
        if length(xlabels) == length(catnames)/2
            xtickvect = 1:1:length(catnames)/2; 
        else
            xticks = [0.8; 1.2]; %seems like a good distance to prevent text overlap
            xticks = repmat(xticks, [1 length(catnames)/2]); 
            addvect = [0:1:length(catnames)/2-1; 0:1:length(catnames)/2-1];
            xtickvect = xticks+addvect; 
            xtickvect = reshape(xtickvect, [1, length(catnames)]);
        end
    
        set(gca, 'XTick', xtickvect, 'XTickLabels', xlabels);
        
        % alp 11/9/21 add support for a legend if desired
        if isfield(data, 'legendlabels')
            legend([violins(end-1).ViolinPlot violins(end).ViolinPlot], data.legendlabels{:})
            %legend('Location', 'best')
            legend('boxoff')
        end
        
        %%% alp 2/3/22 add support for changing the color
        if exist('colors', 'var')
            for n = 1:length(violins)
                violins(n).ViolinColor = colors(n,:);
            end
        end

    % 1D data, one category for each data point
    elseif hascategories && numel(data) == numel(cats)

        if isempty(grouporder)
            cats = categorical(cats);
        else
            cats = categorical(cats, grouporder);
        end

        catnames = (unique(cats)); % this ignores categories without any data
        catnames_labels = {};
        for n = 1:length(catnames)
            thisCat = catnames(n);
            catnames_labels{n} = char(thisCat);
            thisData = data(cats == thisCat);
            violins(n) = Violin_half(thisData, n, varargin{:});
        end
        set(gca, 'XTick', 1:1:length(catnames), 'XTickLabels', catnames_labels);

    % 1D data, no categories
    elseif not(hascategories) && isvector(data)
        violins = Violin_half(data, 1, varargin{:});
        set(gca, 'XTick', 1);

    % 2D data with or without categories
    elseif ismatrix(data)
        for n=1:size(data, 2)
            thisData = data(:, n);
            violins(n) = Violin_half(thisData, n, varargin{:});
        end
        set(gca, 'XTick', 1:size(data, 2));
        if hascategories && length(cats) == size(data, 2)
            set(gca, 'XTickLabels', cats);
        end

    end
    
    %alp 11/9/21 cuz prettier i think
    set(gca, 'TickDir', 'out')
end


