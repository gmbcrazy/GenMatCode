function FC_BrainEEGLu(ChanPos,AdjWeight,NodeWeight,Param)

%%%%Param, parameter for ploting;
% % % Param.Corr='Spearman';  %%%Type of correlation, see Matlab function corr for more details
% % % Param.Pth=0.05; %%%threshold of Pvalue
% % % Param.ColorMap=colorPNweak(5:end-4,:); %%%Color map for correlation link
% % % Param.NodeColor=repmat([0.8 0.8 0.8],6,1); %%%Color of Nodes for correlation link plot
% % % Param.Clim=[-0.6 0.6];    %%%Color Limit for Correlation  
% % % Param.Title='Pool All Sample'; %%Any title for label the figure
% % % Param.MarkerSize=8; %%%MarkerSize of scatter
% % % Param.EdgeColor=[0.6 0.6 0.6]; %%%
% % % Param.EdgeColor=[0.6 0.6 0.6]; %%%
% % % Param.EdgeTh; %%%
% % % Param.NodeTh; %%%

EdgeTh=Param.EdgeTh;
NodeTh=Param.NodeTh;


x=ChanPos.ColinCoord;
xstep=(max(x)-min(x))/8;
xrange=[min(x)-xstep;max(x)+xstep];
hold on;     
patch('Vertices',ChanPos.Cortex.vertices,'Faces',ChanPos.Cortex.faces,...
      'FaceColor',[0.5 0.5 0.5], 'FaceAlpha',0.05,'EdgeAlpha',0);    %%%%%%%%% Plot scalp map %%%%%%%%%
xlim(xrange(:,1))
ylim(xrange(:,2))
zlim(xrange(:,3))

   axis off;
   view([-90 90]);

if size(AdjWeight,2)==2
   EdgeList=AdjWeight;
else
   EdgeList=Adj2WeightList(AdjWeight,EdgeTh);
end
if isempty(EdgeList)
   disp('No Edge Detected');
   return;
end
if isfield(Param,'ScaleF')
   ScaleF=Param.ScaleF;
   EdgeList(:,3)=EdgeList(:,3)*ScaleF;
end





if isempty(NodeWeight)
NormAdj=zeros(size(AdjWeight));
for iEdge=1:size(EdgeList,1)
    NormAdj(EdgeList(iEdge,1),EdgeList(iEdge,2))=EdgeList(iEdge,3);
end
NormAdj=triu(NormAdj);
NormAdj=NormAdj+NormAdj';
Degree=sum(sum(NormAdj),1);
Degree=Degree/length(ChanPos.X);

else
Degree=NodeWeight;
end

if isfield(Param,'ColorMap')&&isfield(Param,'Clim')
Clim=Param.Clim;
ColorMapC=Param.ColorMap;
ClimN=size(ColorMapC,1);
ColorID=1:ClimN;
[B1,E1]=discretize(Clim,ClimN);
[ColorM1I,~] = discretize(EdgeList(:,3),E1);
EdgeColor=ColorMapC(ColorM1I,:);
else
    if isfield(Param,'EdgeColor')
       EdgeColor=Param.EdgeColor;
      if size(EdgeColor,1)==1
       EdgeColor=repmat(EdgeColor,size(EdgeList,1),1);  
      end
   else            %%%%%%%%%Red for positive link, Blue for Negative link
   EdgeColor=repmat([0.9 0.1 0.1],size(EdgeList,1),1); 
      if isempty(EdgeList)
         return
      end
      IndexN=find(EdgeList(:,3)<0);
      if ~isempty(IndexN)
         for i=1:length(IndexN)
             EdgeColor(IndexN(i),:)=[0.1 0.1 0.9];
         end
      end

end


end


N1=x(EdgeList(:,1),:);
N2=x(EdgeList(:,2),:);


hold on;
for i=1:size(EdgeList,1)
    plot3([N1(i,1) N2(i,1)],[N1(i,2) N2(i,2)],[N1(i,3) N2(i,3)],'color',EdgeColor(i,:),'linewidth',max(1,abs(EdgeList(i,3)))); 
end
    
NodeColor=ChanPos.LobColor(ChanPos.LobID(1,:),:);
NodeBrainEEGLu(ChanPos,Degree,NodeTh,NodeColor);

hold off;light;
 

