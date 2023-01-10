function p=stateSeqPlot(StateSeq,plotTs,ComColor)

%%%%%%%%%%plot example of sequence in a Markov way.

if isempty(plotTs)
   plotTs=1:length(StateSeq);
end

n=length(StateSeq);
Mat=zeros(n,n);
for i=1:(n-1)
    Mat(i,i+1)=1;
end
Count=zeros(n,1)+1;

% figure;
% subplotPosLu(PosMatX(1),0.9,1,1)
G = digraph(Mat);
p=plot(G,'Layout','force','EdgeColor',[0.7 0.7 0.7]);
for iN=1:n
highlight(p,iN,'NodeColor',ComColor(StateSeq(iN),:));
end
p.LineWidth=1;
p.MarkerSize=8;
p.EdgeColor=[0.7 0.7 0.7];
p.ArrowSize=8;
%         p.NodeColor=ComColor(1:Cnum,:);
p.EdgeAlpha=1;
p.XData=plotTs;
p.YData=Count/2;
%%%%%%%%%%%%%%%RasterPlot
p.NodeLabel=[];
% p.EdgeLabel=[];

timeShow=[plotTs(1)-0.1 plotTs(end)+0.1];

set(gca,'xlim',timeShow,'ylim',[0 1],'visible','off');
% % % papersizePX=[0 0 18 3];
% % % set(gcf, 'PaperUnits', 'centimeters');
% % % set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
% % % saveas(gcf,[FigSave 'ExStatePeriod_1Tran'],'tiff'); 
% % % saveas(gcf,[FigSave 'ExStatePeriod_1Tran.eps'],'epsc'); 
% % % saveas(gcf,[FigSave 'ExStatePeriod_1Tran'],'fig'); 
