function LuFontStandard(varargin)

if nargin==0
   g=gcf;
   titleSize=10;
   AxesLabelSize=8;
   OtherSize=8;

elseif nargin==1
   g=varargin{1};
   titleSize=10;
   AxesLabelSize=8;
   OtherSize=8;

elseif nargin==2
   g=varargin{1};
   titleSize=varargin{2}(1);
   AxesLabelSize=varargin{2}(2);
   OtherSize=varargin{2}(3);

end


% gcaCh=findobj('Type','Text');

% gcfCh=get(gcf,'children');
% set(gcfCh,'fontsize',titleSize,'fontname','Times new roman');
% set(gca,'fontsize',titleSize,'fontname','Times new roman')
% 
% for i=1:length(gcfCh) 
%     set(get(gcfCh(i),'ylabel'),'fontsize',OtherSize,'fontname','Times new roman');
%     set(get(gcfCh(i),'xlabel'),'fontsize',OtherSize,'fontname','Times new roman');
% % %     set(get(gcfCh(i)),'fontsize',8,'fontname','Times new roman');
% 
% end
% gcaCh=findobj('Type','Figure');
% for i=1:length(gcaCh) 
% %    if findstr(class(gcaCh(i)),'Text')
%       gcaCh(i).FontSize=titleSize;
%       gcaCh(i).FontName='Times new roman';
% %    end
% 
% % %     set(get(gcfCh(i)),'fontsize',8,'fontname','Times new roman');
% %     set(get(gcfCh(i),'text'),'fontsize',10,'fontname','Times new roman');
% 
% end


gcaCh=findobj('Type','Axes');
for i=1:length(gcaCh) 
      gcaCh(i).FontSize=OtherSize;
      gcaCh(i).FontName='Times new roman';

      gcaCh(i).XLabel.FontSize=AxesLabelSize;
      gcaCh(i).XLabel.FontName='Times new roman';

      gcaCh(i).YLabel.FontSize=AxesLabelSize;
      gcaCh(i).YLabel.FontName='Times new roman';

      gcaCh(i).ZLabel.FontSize=AxesLabelSize;
      gcaCh(i).ZLabel.FontName='Times new roman';

      gcaCh(i).Title.FontSize=titleSize;
      gcaCh(i).Title.FontName='Times new roman';


end

% gcaCh=get(gca,'children');
gcaCh=findobj('Type','Text');
for i=1:length(gcaCh) 
%    if findstr(class(gcaCh(i)),'Text')
      gcaCh(i).FontSize=OtherSize;
      gcaCh(i).FontName='Times new roman';
%    end

% %     set(get(gcfCh(i)),'fontsize',8,'fontname','Times new roman');
%     set(get(gcfCh(i),'text'),'fontsize',10,'fontname','Times new roman');

end

