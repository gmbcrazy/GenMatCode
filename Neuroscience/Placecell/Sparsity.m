function  data= Sparsity(map, posPDF)

% Mean firing rate
posPDF=posPDF./nansum(nansum(posPDF));

meanrate=nansum(nansum(map.*posPDF));

data=meanrate^2/nansum(nansum(posPDF.*map.^2));

% % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % Mean firing rate
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % information
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % meanrate = nansum(nansum( map .* posPDF ));
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % [i1, i2] = find( (map>0) & (posPDF>0) );  % the limit of x*log(x) as x->0 is 0 
% % % % % % % % % % % % % % % % % % % % % if ~isempty(i1)
% % % % % % % % % % % % % % % % % % % % %     akksum = 0;
% % % % % % % % % % % % % % % % % % % % %     for i = 1:length(i1);
% % % % % % % % % % % % % % % % % % % % %         ii1 = i1(i);
% % % % % % % % % % % % % % % % % % % % %         ii2 = i2(i);
% % % % % % % % % % % % % % % % % % % % %         % Julie : it seems that this formula is incorrect (it lack
% % % % % % % % % % % % % % % % % % % % %         % '/meanrate)
% % % % % % % % % % % % % % % % % % % % %         % see mapstat function
% % % % % % % % % % % % % % % % % % % % % %         akksum = akksum + posPDF(ii1,ii2) * map(ii1,ii2) * log2( map(ii1,ii2) / meanrate ); 
% % % % % % % % % % % % % % % % % % % % %         akksum = akksum + posPDF(ii1,ii2) * (map(ii1,ii2)/meanrate) * log2( map(ii1,ii2) / meanrate ); 
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % %     information = akksum;
% % % % % % % % % % % % % % % % % % % % % else
% % % % % % % % % % % % % % % % % % % % %     information = NaN;
% % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % information

