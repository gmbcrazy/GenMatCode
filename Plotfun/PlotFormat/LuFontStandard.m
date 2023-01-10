%%%%LuFontStandard
gcfCh=get(gcf,'children');
set(gcfCh,'fontsize',10,'fontname','Times new roman');
set(gca,'fontsize',10,'fontname','Times new roman')

for i=1:length(gcfCh) 
    set(get(gcfCh(i),'ylabel'),'fontsize',8,'fontname','Times new roman');
    set(get(gcfCh(i),'xlabel'),'fontsize',8,'fontname','Times new roman');
% %     set(get(gcfCh(i)),'fontsize',8,'fontname','Times new roman');
%     set(get(gcfCh(i),'text'),'fontsize',10,'fontname','Times new roman');

end
set(get(gca,'ylabel'),'fontsize',8,'fontname','Times new roman');
set(get(gca,'xlabel'),'fontsize',8,'fontname','Times new roman');
% % gcaCh=get(gca,'children');
% % for i=1:length(gcfCh) 
% %     gcaCh.Text.FontSize=8;
% %     gcaCh.Text.FontName='Times new roman';
% % % %     set(get(gcfCh(i)),'fontsize',8,'fontname','Times new roman');
% % %     set(get(gcfCh(i),'text'),'fontsize',10,'fontname','Times new roman');
% % 
% % end
% % set(get(gcf,'ylabel'),'fontsize',10,'fontname','Times new roman');

