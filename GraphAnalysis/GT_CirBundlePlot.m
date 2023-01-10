function varargout=GT_CirBundlePlot(Adj,Degree,ComColor,NodeName)

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
p.LineWidth=(weights-min([0.2,min(weights)])+0.1)*4;
% p.Marker='^';
Degree(isnan(Degree))=0;
p.MarkerSize=(Degree-min([0.2,min(Degree)])+0.1)*20;

% p.MarkerSize=abs(Degree)*400;

p.NodeLabel=[];
p.EdgeLabel=[];
p.XData=xi;
p.YData=yi;

LabelPos=[xi(:) yi(:)]*1.15;
for i=1:length(NodeName)
     if abs(AngP(i))>pi
    
%        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i)/pi*180)-180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
       a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)+90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    

    else
%        a= text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i))/pi*180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
       a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)-90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    

    end
end

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


