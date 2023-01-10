
function [lme0,pcoeff,Coeff]=PairMixLinearSubjRF(DataCal,Subj,DataName,Param) 
%%%%%%%%%Plot All pair of scatter plot from DataCal, mixed-linear model was
%%%%%%%%%used to fit the data, Subj is considered as random effect.
%%%%%%%%%Correlation Link Plot using the -log(Pvalue) as strength to plot the link
%%%%%%%%%Pvalue,represented by pcoeff here show the test whether slop of the model is zero.


%%%%DataCal, input Matrix, with sample x variables
%%%%DataName, cell variable, DataName{i} is the name of ith variable, corresponding
%%%%to DataCal(:,i)

%%%%Param, parameter for ploting;
% % % Param.Corr='Spearman';  %%%Type of correlation, see Matlab function corr for more details
% % % Param.Pth=0.05; %%%threshold of Pvalue
% % % Param.ColorMap=colorPNweak(5:end-4,:); %%%Color map for correlation link
% % % Param.NodeColor=repmat([0.8 0.8 0.8],6,1); %%%Color of Nodes for correlation link plot
% % % Param.Clim=[-0.6 0.6];    %%%Color Limit for Correlation  
% % % Param.Title='Pool All Sample'; %%Any title for label the figure
% % % Param.MarkerSize=8; %%%MarkerSize of scatter
% % % Param.SubjColor=TempColor(1:5:64,:); %%%Color represented individual subjects.

Pth=Param.Pth;
Param.ColorMap;
NodeColor=Param.NodeColor;

P.xLeft=0.08;
P.xRight=0.02;
P.yTop=0.02;
P.yBottom=0.08;
P.xInt=0.06;
P.yInt=0.06;

if isnumeric(Subj) 
   for isub=1:length(Subj)
       SubjStr{isub}=['S' num2str(Subj(isub))];
   end
elseif iscell(Subj)
   if isnumeric(Subj{1})
   for isub=1:length(Subj)
       SubjStr{isub}=['S' num2str(Subj{isub})];
   end
   else
     for isub=1:length(Subj)
        SubjStr{isub}=['S' Subj{isub}];
     end
     
   end
else
    error('Subj needs to be cell array string or numbers');
end





       
    tbl = cell2table([table2cell(array2table(DataCal)) SubjStr(:)],'VariableNames',[DataName 'Subj']);

% %                iNode=1;
% %                jNode=6;

%     lme = fitlme(tbl,'Firing ~ Speed * Spa + (Speed|CellI)');
    Coeff=zeros(length(DataName),length(DataName));
    pCoeff=eye(length(DataName));
    Interept=Coeff;
    for iNode=1:length(DataName)
    for jNode=iNode+1:length(DataName)
        testText=[DataName{jNode} ' ~ ' DataName{iNode} ' + (1|Subj)'];
        
        lme0{iNode,jNode} = fitlme(tbl,testText);
        temp=getfield(getfield(lme0{iNode,jNode},'Coefficients'),'pValue');
        pCoeff(iNode,jNode)=temp(2);
        temp=getfield(getfield(lme0{iNode,jNode},'Coefficients'),'Estimate');
        Coeff(iNode,jNode)=temp(2);   
        Interept(iNode,jNode)=temp(1);   

    end
    end
       Coeff=Coeff+Coeff';
       pCoeff=pCoeff+pCoeff';
%        Param.Clim=max(nanmax(-log10(abs(pCoeff))))*[-1 1];
%        Param.Clim=[-2 2];
       figure;
       hold on
       subplot('position',[0.6 0.6 0.38 0.38]);
       adj=sign(Coeff).*(-log10(pCoeff)).*[pCoeff<Pth];
       color1=Param.ColorMap;
       [G,pN,Ang]=GT_CirBundleHeatPlotLastNodeTop(adj,[],NodeColor,DataName,color1,Param.Clim);
       pN.LineWidth=2;
       pN.MarkerSize=12;
       
       pN.EdgeColor;
       RSmapleMat=2.2;
       EdgeNode=G.Edges.EndNodes;
       EdgeColor=pN.EdgeColor;
       text(-1,1,[Param.Title ', n = ' num2str(length(DataCal(:,1)))],'fontsize',14,'fontname','times new roman','horizontalalignment','right','verticalalignment','bottom');
    
    
       for iNode=1:length(DataName)
           for jNode=iNode+1:length(DataName)
              subplotLU(size(DataCal,2)-1,size(DataCal,2)-1,jNode-1,iNode,P);

              
              gscatterLU(DataCal(:,iNode),DataCal(:,jNode),SubjStr,Param.SubjColor,'o',Param.MarkerSize);

           if jNode==size(DataCal,2)

           xlabel(DataName{iNode},'fontsize',12,'fontname','Times new roman');
           else
           set(gca,'xticklabel',[])    
           end
           
           if iNode==1
           ylabel(DataName{jNode},'fontsize',12,'fontname','Times new roman');
           else
           set(gca,'yticklabel',[])    

           end

              
               Param.NodeColor=[0.1 0.1 0.1];
               Param.Marker='cycle';
% %    Param.MarkerSize=2;
% %    Param.Rtype='pearson';
               Param.xLim=[min(DataCal(:,jNode)) max(DataCal(:,jNode))];
               Param.yLim=[min(DataCal(:,iNode)) max(DataCal(:,iNode))];
               Param.xLabel=[];
               Param.yLabel=[];
           
           temp1=repmat([iNode jNode],size(EdgeNode,1),1);
           I=find(sum(abs(temp1-EdgeNode),2)==0);
           if ~isempty(I)
              colorDot=EdgeColor(I,:);
           else
              colorDot=[0.6 0.6 0.6];
              continue;
           end
           x=[min(DataCal(:,iNode)) max(DataCal(:,iNode))]';
           y=[[1 1]' x]*[Interept(iNode,jNode);Coeff(iNode,jNode)];

           hold on;
% %            Param.EdgeColor=colorDot;
% %            plot(x,y,'-','color',colorDot,'linewidth',2); 
           plot(DataCal(:,iNode),predict(lme0{iNode,jNode}),'-','color',colorDot,'LineWidth',1)

           
            end
        end
           
  
end


function [G,p,varargout]=GT_CirBundleHeatPlotLastNodeTop(Adj,Degree,ComColor,NodeName,ColorMapC,Clim)

Dim1=size(Adj,1);
temp1M=ones(Dim1)/Dim1;
temp1C=ones(size(Degree))/Dim1;

[G,p,AngP]=GT_CirBundlePlotLastNodeTop(Adj,Degree,ComColor,NodeName);
clear temp1M temp1C;

M1=G.Edges.Weight;
M1(M1>Clim(2))=Clim(2);
M1(M1<Clim(1))=Clim(1);

ClimN=size(ColorMapC,1);
ColorID=1:ClimN;
% % Clim=[-0.1 0.1];
% % ClimN=10;
[B1,E1]=discretize(Clim,ClimN);
% % X=[-0.3 0.05 0.01 0.09 0.02 -0.03 0.01]
[ColorM1I,~] = discretize(M1,E1);
% [ColorC1I,~] = discretize(C1,E1);
% ColorM2I=reshape(ColorM1I,[Dim1,Dim1]);


for i=1:ClimN
      [s] = find(ColorM1I==ColorID(i));
     if ~isempty(s)
       Gtemp = digraph(G.Edges(s,:),G.Nodes);
       highlight(p,Gtemp,'edgecolor',ColorMapC(ColorM1I(s(1)),:));
     end
     
     
     
     
end


% AngRotate=pi/2-AngP(end);
% 
% AngP=AngP+AngRotate;
if nargout==3
    varargout{1}=AngP;
end

% p.XData=cos(AngP);
% p.YData=sin(AngP);

p.NodeLabel=NodeName;
end

function varargout=GT_CirBundlePlotLastNodeTop(Adj,Degree,ComColor,NodeName)

%%%%%[G,p]=MarkovState_Plot(Adj,ComColor,Param)
if isempty(Adj)
   varargout{1}=[];
   varargout{2}=[];
   return;
end

Adj=triu(Adj,1);

[i1,i2,Edgeweight]=find(Adj);

Adj(isnan(Adj))=0;
X=squeeze(Adj);
% X=Adj;
n=size(X,1);
AngDiff=2*pi/(size(Adj,2));

AngP=[0:(size(Adj,2)-1)]*AngDiff;


%%%%%%%%Make the last Node at top of graph
AngRotate=pi/2-0.01-AngP(end);
AngP=AngP+AngRotate;
%%%%%%%%Make the last Node at top of graph


xi=cos(AngP);
yi=sin(AngP);
% zi=zeros(size(xi));


XX=X+X';
if isempty(Degree)
Degree=sum(abs(X),2)/sum(sum(abs(X)));
% Degree=Degree/sum(Degree);
end

for i=1:size(X,1)
    X(i,:)=X(i,:)/sum(X(i,:)); 
end

G = digraph(i1,i2,(Edgeweight),length(Degree));
G.Edges.Weight(isnan(G.Edges.Weight))=0;
weights=abs(G.Edges.Weight);
varargout{1}=G;
if nargout==2||nargout==3
% % figure;
p=plot(G,'Layout','force','EdgeColor',[0.5 0.5 0.5],'ArrowSize',5);

if exist('ComColor')
   if size(ComColor,1)==1
      ComColor=repmat(ComColor,n,1);
   end
else
   ComColor=repmat([0 0 0],n,1);

end
% p.LineWidth=(weights-min(weights)+0.1)*15;
% p.LineWidth=(weights-min([0.2,min(weights)])+0.1)*4;  %%%%%%%%Previously used;

tempweights=(weights-0.1)*2;
tempweights(tempweights<=0)=0.1;
p.LineWidth=tempweights+1;

% p.Marker='^';
Degree(isnan(Degree))=0;
p.MarkerSize=(Degree-min([0.2,min(Degree)])+0.1)*20;

% p.MarkerSize=abs(Degree)*400;

p.NodeLabel=[];
p.EdgeLabel=[];
p.XData=xi;
p.YData=yi;

LabelPos=[xi(:) yi(:)]*1.15;
% for i=1:length(NodeName)
%      if abs(AngP(i))>pi
%     
% %        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i)/pi*180)-180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
%        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)+90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
% 
%     else
% %        a= text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i))/pi*180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
%        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)-90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
% 
%     end
% end

varargout{2}=p;
set(gca,'xlim',[-1.2 1.2],'ylim',[-1.2 1.2],'xtick',[],'ytick',[],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99])

% highlight(p,[1:n],'NodeColor',ComColor(1:n,:));
for iN=1:n
highlight(p,iN,'NodeColor',ComColor(iN,:));
end
% axes('Color','none','XColor','none');
end
p.EdgeAlpha=1;
p.ArrowSize=0;

% AdjUp=triu(Adj,1);
% [i1Up,i2Up,EdgeweightUp]=find(AdjUp);
% 
% G1=digraph(i1Up,i2Up,EdgeweightUp);
varargout{1}=G;

% % highlight(p,G1,'EdgeColor',[0.7 0.7 0.7]);
varargout{2}=p;
varargout{3}=AngP;
end