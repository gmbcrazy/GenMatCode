function NormalStatis=ErrorBarHierarchy(x,Data,xSubjID,PlotColor,nBoot,varargin)


%%%Input:
%%%%%%%x,coordinates in x axis, 1*n dimension vector, n groups in total;
%%%%%%%y-mean, 1*n dimension vector for mean;
%%%%%%%y-errorbar, 1*n dimension vector for errorbar, could be std or ste;
%%%%Important:
%%%%%%%y-mean, could be cells data, in this case, y{i} includes all samples within group i; then let y_errorbar=[];

%%%%PlotColor, PlotColor(i,:) is color for group i data;
%%%%nBoot, the number of resampling in bootstrap; if 0, no HierarchyTest will be made 
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




if isnumeric(PlotColor)
   barColor=PlotColor;
   barFaceColor=PlotColor;
elseif iscell(PlotColor)
   barColor=PlotColor{1};
   barFaceColor=PlotColor{2};

else
end

if size(barColor,1)==1
   barColor=repmat(barColor,length(x),1);
end
if size(barFaceColor,1)==1
   barFaceColor=repmat(barFaceColor,length(x),1);
end


%% GroupAll=unique(GroupID);
%% x=1:length(GroupAll);
x_step=mean(diff(x));



%%%%%%%%%%%Plot data at lower Hierarchy level  (each subj is a group)
GroupPairSubj=GroupPair;
% GroupPairSubj.SamplePlot=1; %%%%%%%%%Plot Individual Sample Point in SubGroupPlot if GroupPairSubj.SamplePlot=1
GroupPairSubj.SamplePairedPlot=0; %%%%%%%%%Dash line for paired comparison sample
GroupPairSubj.Marker={'.'};

for i=1:length(x)
    SubjSubGroup{i}=unique(xSubjID{i});
    subjGroupL(i)=length(SubjSubGroup{i});
    subGroup_x{i}=[1:subjGroupL(i)]*x_step/2/subjGroupL(i)+x(i)-x_step/2;
    for j=1:subjGroupL(i)
        subData{i}{j}=Data{i}(find(xSubjID{i}==SubjSubGroup{i}(j)));
    end
    PlotColorSubj=barColor(i,:).^0.5;
    ErrorBarPlotSimplePlot(subGroup_x{i},subData{i},[],PlotColorSubj,2,0,GroupPairSubj);
end
%%%%%%%%%%%Plot data at lower Hierarchy level  (each subj is a group)



%%%%%%%%%%%Plot data at higg Hierarchy level
GroupPairTemp=GroupPair;

GroupPairTemp.SamplePlot=0; %%%%%%%%%Do not plot sample for Group Comparison;
% if Datatype==1
GroupPairTemp.Plot=0;
GroupPairTemp.Marker={'o'};

% if 
NormalStatis=ErrorBarPlotLU(x+x_step/10,Data,[],PlotColor,2,Datatype,SavePath,GroupPairTemp,RGroupID);  %%%%Paired Data
% end
% % else
% % NormalStatis=ErrorBarPlotLU(x,Data,[],PlotColor,2,Datatype,SavePath,GroupPair,RGroupID);  %%%%UnPaired Data 
% end
%%%%%%%%%%%Plot data at higg Hierarchy level




if nBoot<=0
   HierarchyStatis=[];
else
   clear DataBootStrap;
   [ComGroup,ComGroupI]=unique(RGroupID);
   for iCom=1:length(ComGroup)
       BootStrapCom{iCom}=BootStrampHierarchy2L(xSubjID{ComGroupI(iCom)},nBoot,subjGroupL(ComGroupI(iCom)));       
   end
   for i=1:length(x)
       jCom=find(ComGroup==RGroupID(i));
       BootStrapX{i}=BootStrapCom{jCom};
       TempData1=Data{i}(:);
       DataBootStrap{i}=nanmean(TempData1(BootStrapX{i}),2);
   end
   
   GroupPairTemp.Marker={'^'};
   ErrorBarPlotSimplePlot(x+x_step/20,DataBootStrap,[],PlotColor,2,0,GroupPairTemp,RGroupID);

    
    
   TestType=[];
% %    Temp=RGroupID(GroupPair.Pair);
% %    [ComGroup,ComGroupI]=unique(Temp(:));
% %    for iCom=1:length(ComGroup)
% %        BootStrapCom{iCom}=BootStrampHierarchy2L(xSubjID{ComGroupI(iCom)},nBoot,subjGroupL(ComGroupI(iCom)));       
% %    end
% %    TempData=
   for iTest=1:size(GroupPair.Pair,2)
% %        DataTest1=Data{GroupPair.Pair(1,iTest)}(:);
% %        DataTest2=Data{GroupPair.Pair(2,iTest)}(:);
% %     
       clear TempMean1 TempMean2 TempDiff
% %        I1=find(ComGroup==RGroupID(GroupPair.Pair(1,iTest)));
% %        I2=find(ComGroup==RGroupID(GroupPair.Pair(2,iTest)));
% %       
% %        TempMean1=nanmean(DataTest1(BootStrapCom{I1}),2);
% %        TempMean2=nanmean(DataTest2(BootStrapCom{I2}),2);
       
       TempMean1=DataBootStrap{GroupPair.Pair(1,iTest)};
       TempMean2=DataBootStrap{GroupPair.Pair(2,iTest)};

       if RGroupID(GroupPair.Pair(1,iTest))==RGroupID(GroupPair.Pair(2,iTest))   %%%%Paired Test
          TempDiff=TempMean1-TempMean2;
          clear P1
          P1(1)=sum(TempDiff>0)/nBoot;
%           P1(2)=sum(TempDiff<0)/nBoot;
          P1(2)=(1-P1(1));

          pPair(iTest)=min(P1)*2;
          TestType(iTest)=1;      %%%%Paired Test
       else %%%UnPaired Test
          clear pTemp
          [pTemp(1), ~] = get_direct_prob(TempMean1,TempMean2);
          [pTemp(2), ~] = get_direct_prob(TempMean2,TempMean1);
          pPair(iTest)=min(pTemp)*2;
          TestType(iTest)=0;      %%%%UnPaired Test
           
       end
   end
   
   pPair(pPair>1)=1;
   NormalStatis.pBoot=pPair;
   NormalStatis.BootPair=GroupPair.Pair;
   NormalStatis.BootType=TestType;   %%%%%Test Type


end

%%%%%%%%%Plot Significance
    ShowTemp(1,:)='                                                                        ';

  if strmatch(GroupPair.CorrName,'fdr')
      if isfield(GroupPair,'Crit_p')
         crit_p=GroupPair.Crit_p;
         crit_p(crit_p>0.05)=0.05;
          for iq=1:length(crit_p)
               sigSign{iq}=repmat('*',1,iq);
          end
      else
          for iq=1:length(GroupPair.Q)
              [h, crit_p(iq), adj_p]=fdr_bh(NormalStatis.pBoot,GroupPair.Q(iq),'pdep','yes');
          sigSign{iq}=repmat('*',1,iq);
          end
          crit_p(crit_p>0.05)=0.05;

          
      end
%       sigSign=sigSign(end:-1:1); 
      
      TempText=['Hierarchy Bootstramp Test' GroupPair.CorrName];
    for igroup=1:size(GroupPair.Pair,2)
         ii=GroupPair.Pair(1,igroup);
         iii=GroupPair.Pair(2,igroup);
       
           TempText=[ 'Group' num2str(ii) '-Group' num2str(iii),...
           ',p=' num2str(NormalStatis.pBoot(igroup))];
           ShowTemp(end+1,1:length(TempText))=TempText;


   end

      
      TempText=['Q Pth'];
      ShowTemp(end+1,1:length(TempText))=TempText;
      for iq=1:length(GroupPair.Q)
          TempText=[num2str(GroupPair.Q(iq)) ' ' num2str(crit_p(iq))];
          ShowTemp(end+1,1:length(TempText))=TempText;
      end
       if ~isempty(SavePath)
       fileID = fopen(SavePath,'a+');

       for i=1:length(ShowTemp(:,1))
           fprintf(fileID,'%s\r\n',deblank(ShowTemp(i,:)));
       end
% % writetable(D1,fileID);
       fclose(fileID);

    end
  
      if GroupPair.Plot==1
          for iii=1:length(Data)
              res(iii) = prctile(Data{iii}(:),[100]);  %%%%25 percentage, 50 percentage(median) and 75 percentage point
          end
          LowShowY=max(res);
          

      iStep=abs(diff(GroupPair.Pair));

      for igroup=1:length(NormalStatis.pBoot)
         xP=x(GroupPair.Pair(:,igroup))+x_step/8;
         xP(1)=xP(1)+x_step/20;
         xP(2)=xP(2)-x_step/20;

% %          yP=GroupPair.SignY+(iStep(igroup)-1)*abs(diff(GroupPair.LimY))/20;
% %          yP=zeros(size(xP))+yP;
         
         
         yP=mean([GroupPair.SignY(:);LowShowY]);
         yP=yP+(iStep(igroup)-1)*abs(GroupPair.LimY(end)-LowShowY)/length(NormalStatis.pBoot)/2;
         yP=min([yP max(GroupPair.SignY)]);
         yP=zeros(size(xP))+yP;
         

         

          for iq=1:length(crit_p)
             if NormalStatis.pBoot(igroup)<=crit_p(iq)
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


%%%%%%%%%Plot Significance


set(gca,'xlim',[0 length(x)+0.5],'xtick',x,'ylim',GroupPair.LimY);


end



 








function [ p_test, p_joint_matrix] = get_direct_prob(sample1,sample2 )
%get_direct_prob Returns the direct probability of items from sample2 being
%greater than or equal to those from sample1. 
%   Sample1 and Sample2 are two bootstrapped samples and this function
%   directly computes the probability of items from sample 2 being greater
%   than or equal to those from sample1. Since the bootstrapped samples are
%   themselves posterior distributions, this is a way of computing a
%   Bayesian probability. The joint matrix can also be returned to compute
%   directly upon.

%First, we want to find the ranges over which we need to build the
%probability distributions.
joint_low_val = min([min(sample1) min(sample2)]);
joint_high_val = max([max(sample1) max(sample2)]);

%Now set up a matrix with axis between these extreme values for which we
%will calculate the probabilities.

p_joint_matrix = zeros(100,100);
p_axis = linspace(joint_low_val,joint_high_val,100);
edge_shift = (p_axis(2) - p_axis(1))/2;
p_axis_edges = p_axis - edge_shift;
p_axis_edges = [p_axis_edges (joint_high_val + edge_shift)];

%Calculate probabilities using histcounts for edges.

p_sample1 = histcounts(sample1,p_axis_edges)/length(sample1);
p_sample2 = histcounts(sample2,p_axis_edges)/length(sample2);

%Now, calculate the joint probability matrix:

for i = 1:size(p_joint_matrix,1)
    for j = 1:size(p_joint_matrix,2)
        p_joint_matrix(i,j) = p_sample1(i)*p_sample2(j);
    end
end

p_joint_matrix = p_joint_matrix/sum(sum(p_joint_matrix));

p_test = sum(sum(triu(p_joint_matrix)));

end


function IndexBoot=BootStrampHierarchy2L(Subj,nBoot,varargin)



SubjG=unique(Subj);
if nargin==2
   nTrial=length(SubjG);
elseif nargin==3
   nTrial=varargin{1};
else
    
end



for i=1:length(SubjG)
    I1=find(Subj==SubjG(i));
    TrialNumSubj(i)=length(I1);
    TrialGSubj{i}=I1;    %%%%%%%%%%RowIndex for each subj;
end

for iBoot=1:nBoot

    SubjBoot=randi(length(SubjG),nTrial,1);
    for i=1:length(SubjBoot)
        jSubj=SubjBoot(i);
        jTrialNum=TrialNumSubj(jSubj);
        TrialBoot(iBoot,i)=TrialGSubj{jSubj}(randi(jTrialNum,1,1)); %%%%%%%for each Subj, at most nBoot times would achieved for level 2
    end
    
end

IndexBoot=TrialBoot;
end