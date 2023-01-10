function stats=ErrorBarPlotSimplePlot(x,y_mean,y_errorbar,PlotColor,PlotMode,varargin)


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
   GroupPair=[];
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==7
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   GroupPair=varargin{2};
   RGroupID=1:length(x);   %%%repeated groupID;
elseif nargin==8
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
   GroupPair=varargin{2};
   RGroupID=varargin{3};

else
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

        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker',Marker{i},'markersize',2,'markerfacecolor',barFaceColor(i,:));hold on
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);

        end

elseif PlotMode==3
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

   
   
   end
      

   
   

end
