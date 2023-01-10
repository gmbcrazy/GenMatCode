function varargout=MarkovState_Plot(TransitionMatrix,CountsState,ComColor,Param)

%%%%%[G,p]=MarkovState_Plot(TransitionMatrix,ComColor,Param)
if isempty(TransitionMatrix)
   varargout{1}=[];
   varargout{2}=[];
   return;
end
TransitionMatrix(isnan(TransitionMatrix))=0;
X=squeeze(TransitionMatrix);
% X=TransitionMatrix;
n=size(X,1);
Degree=sum(sum(X),1)/sum(sum(X));
Degree=CountsState/sum(CountsState);

for i=1:size(X,1)
    X(i,:)=X(i,:)/sum(X(i,:)); 
end

G = digraph(X);
G.Edges.Weight(isnan(G.Edges.Weight))=0;
weights=G.Edges.Weight;
varargout{1}=G;
if nargout==2
% % figure;
p=plot(G,'Layout','force','EdgeColor',[0.5 0.5 0.5]);

if exist('ComColor')
   if size(ComColor,1)==1
      ComColor=repmat(ComColor,n,1);
   end
else
   ComColor=repmat([0 0 0],n,1);

end
% p.LineWidth=(weights-min(weights)+0.1)*15;
p.LineWidth=(weights-min([0.2,min(weights)])+0.01)*20;
% p.Marker='^';
p.MarkerSize=(Degree-min([0.2,min(Degree)])+0.01)*50;
p.EdgeLabel=showNum(weights,2);
p.NodeLabel=showNum(Degree,2);

% p.ArrowSize=weights*30;
% p.ArrowSize=mean(weights)*30;
p.ArrowSize=10;

varargout{2}=p;
set(gca,'xtick',[],'ytick',[],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99])

% highlight(p,[1:n],'NodeColor',ComColor(1:n,:));
for iN=1:n
highlight(p,iN,'NodeColor',ComColor(iN,:));
end
% axes('Color','none','XColor','none');
end
p.EdgeAlpha=1;
