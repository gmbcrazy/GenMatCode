function circ_ErrorBarPlotLU(x,y_mean,y_errorbar,barColor,PlotMode,varargin)

%%%%%%PlotMode=1; barPlot
%%%%%%PlotMode=2; DotPlot
%%%%%%PlotMode=3; AreaPlot
if nargin==6
   Datatype=varargin{1};  %%%%%%Datatype=0, non-paired data; 1 for paired data
else
   Datatype=0;
end


if size(barColor,1)==1
   barColor=repmat(barColor,length(x),1);
end

if (~iscell(y_mean))&&(~isstruct(y_mean))


if PlotMode==1
    for i=1:length(x)
        b=bar(x(i),y_mean(i),0.8,'facecolor',barColor(i,:),'Edgecolor',barColor(i,:));hold on;
        
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));

    end
elseif PlotMode==2
        for i=1:length(x)
% %         plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker','o','markersize',10);hold on
% %         plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:));

        plot(x(i),y_mean(i),'color',barColor(i,:),'linestyle','none','marker','o','markersize',10,'markerfacecolor',barColor(i,:));hold on
        plot([x(i) x(i)],y_mean(i)+[-y_errorbar(i) y_errorbar(i)],'color',barColor(i,:),'linewidth',1);

        
        
        end
%         plot(x,y_mean,'color',barColor(i,:),'linestyle','-');hold on

elseif PlotMode==3
       error_area(x,y_mean,y_errorbar,barColor(1,:),0.5,'-',1);hold on;
else
end



else
    
    if isstruct(y_mean)
       y_mean=struct2cell(y_mean);
    end
    
    for ii=1:length(y_mean)
    tempMean(ii)=circ_mean(y_mean{ii});
    tempStd(ii)=circ_std(y_mean{ii});
    end
    
    deltaX=mean(diff(x));
    ErrorBarPlotLU(x+deltaX/8,tempMean,tempStd,barColor,PlotMode);hold on;

    for ii=1:length(y_mean)
        xTemp(:,ii)=(randn(1,length(y_mean{ii})))*deltaX/20+(ii);
        yTemp(:,ii)=y_mean{ii}(:);
        plot(xTemp(:,ii),yTemp(:,ii),'color',[0.6 0.6 0.6],'linestyle','none','marker','.','markersize',8);
        hold on;  
        end
    end

    if Datatype==1
       for i=1:size(xTemp,1)
           plot(xTemp(i,:),yTemp(i,:),'color',[0.6 0.6 0.6],'linestyle','-');
       end
    end
    
    
end
% set(gca,'xlim',[x(1)-1 x(end)+1],'xtick',[]);