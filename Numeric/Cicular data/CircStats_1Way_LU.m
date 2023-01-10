function stats = CircStats_1Way_LU(angles,SavePath)

%%%%%%angles is cell structure, each cell is a group data;

if nargin==1
   SavePath=[]; 
end

circData=[];
group=[];
for i=1:length(angles)
    circData=[circData;angles{i}(:)]; 
    group=[group;repmat(i,length(angles{i}),1)];
    Cmean(i)=(circ_mean(angles{i}));
    Cstd(i)=(circ_std(angles{i}));
    
%     Cmean(i)=circ_rad2ang(circ_mean(angles{i}));
%     Cstd(i)=circ_rad2ang(circ_std(angles{i}));

end

% Cmean(Cmean<0)=360+Cmean(Cmean<0);
% [p,F] = CircularANOVA(circData,group,method);
 [pval, table] = circ_wwtest(circData,group);
 
    stats.ANOVAname='Parametric Watson-Williams multi-sample test for equal means';
    stats.p_ANOVA=pval;
    stats.table_ANOVA=table;

   ANOVAtext=['Session Effect:', 'F', num2str(table{2,2}) ',' num2str(table{3,2}) '=' num2str(table{2,5}) ,' P=',num2str(table{2,6})];
   
   ShowTemp(1,:)='                                                                        ';


   TempText=stats.ANOVAname;
   ShowTemp(end+1,1:length(TempText))=TempText;
   TempText=ANOVAtext;
   ShowTemp(end+1,1:length(TempText))=TempText;


    
    
iiii=1;
   for ii=1:length(angles)
       for iii=(ii+1):length(angles)    
           yTemp1=angles{ii}(:);
           yTemp2=angles{iii}(:);
           r1(iiii)=ii;
           c1(iiii)=iii;
              [p(iiii),Tempstat{iiii}]=circ_wwtest([yTemp1;yTemp2],[zeros(size(yTemp1));zeros(size(yTemp2))+1]);
           TempText=[ 'Group' num2str(ii) '-Group' num2str(iii),...
' ,F' num2str(Tempstat{iiii}{2,2}) ',' num2str(Tempstat{iiii}{3,2}) '=' num2str(Tempstat{iiii}{2,5}) ',p=' num2str(p(iiii))];
           ShowTemp(end+1,1:length(TempText))=TempText;
iiii=iiii+1;
       end
   end
         TempText='mean ± sd in radius';

         ShowTemp(end+1,1:length(TempText))=TempText;

      for ii=1:length(angles)

          TempText=['Group' num2str(ii) ' ' num2str(Cmean(ii)) ' ± ' num2str(Cstd(ii)) ' n=' num2str(length(angles{ii}))];
          ShowTemp(end+1,1:length(TempText))=TempText;

      end
   

stats.p_Pair=p;
stats.f_Pair=Tempstat;

    if ~isempty(SavePath)
       fileID = fopen(SavePath,'w');

       for i=1:length(ShowTemp(:,1))
           fprintf(fileID,'%s\r\n',deblank(ShowTemp(i,:)));
       end
% % writetable(D1,fileID);
       fclose(fileID);

    end