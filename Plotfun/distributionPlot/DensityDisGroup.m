function DensityDisGroup(DataGroup,DisX,GroupColor,PlotMode,varargin)

%%%%%%PlotMode=0; DensityDistribution Plot
%%%%%%PlotMode=1; Cummniative Plot

if nargin==4
   SavePath=[];           
   Param=[];
elseif nargin==5
   SavePath=varargin{1};  %%%%%%Save the stats to txt file
   Param=[];

elseif nargin==6
   SavePath=varargin{1};  %%%%%%Save the stats to txt file
   Param=varargin{2};
else
   SavePath=[];           
   Datatype=0;
   Param=[];
end


if isempty(Param)
   Param.SignY=0.5;
   Param.Plot=1;
   Param.Std=1;      %%%%%%%%%using standard deviation as errorbar
   Param.alpha=0.3; %%%%%%%%%Dash line for paired comparison sample
   Param.Normalized=0; %%%%%%%%%0 by counts;1 by percentage;
   
end


    
    if isstruct(DataGroup)
       y_mean=struct2cell(DataGroup);
    end
    
    for ii=1:length(DataGroup)
    tempMean(ii)=nanmean(DataGroup{ii});
% % %         if Param.Std==1
% % %     tempStd(ii)=nanstd(DataGroup{ii});
% % %         else
% % %     tempStd(ii)=ste(DataGroup{ii}(:));
% % %             
% % %         end
        
        if PlotMode==0
        if Param.Normalized==0
           m=histPlotLU(DataGroup{ii},DisX,GroupColor(ii,:),Param.alpha);
        else
           m=histPlotLUPerc(DataGroup{ii},DisX,GroupColor(ii,:),Param.alpha);
        end
           nboot=1000;
%            [dip, p_value, xlow,xup]=HartigansDipSignifTest(m,nboot);

        hold on;
        plot(repmat(tempMean(ii),1,2),[0 Param.SignY],'color',GroupColor(ii,:));
        else
           m=histc(DataGroup{ii},DisX);
           nboot=100;
%            [dip, p_value, xlow,xup]=HartigansDipSignifTest(m,nboot);

           y=cumsum(m)/sum(m);
           y=y(:);
           y=[0;y(1:end-1)];
           DisX=DisX(:);
%            plot(repmat(tempMean(ii),1,2),[0 1],'color',GroupColor(ii,:));

           plot(DisX,y,'color',GroupColor(ii,:),'linewidth',1);hold on;
        
        
        
        end
    end
    

    
    

end
% set(gca,'xlim',[x(1)-1 x(end)+1],'xtick',[]);