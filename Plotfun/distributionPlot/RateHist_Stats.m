function Outstats=RateHist_Stats(RateAll,Param)

%%%%%%%RateAll is cell variable, RateAll{1} is a matrix, meansurements x time.
Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\GenMatCode\Statistics\ANOVAandMixEffect\R\';
% Param.Paired=1;
% Param.RepeatAnova=1; %%objects was repeated measured across time and
% group.   -> thus Param.TimeRepeatAnova==1&&Param.GroupRepeatAnova==1

% Param.TimeRepeatAnova==1;  %%within each group, same objects was repeated measured
% at different time points

% Param.GroupRepeatAnova==1; %%same objects was repeated measured across
% different groups.

Cnum=length(RateAll);
% % if Param.RepeatAnova==1
% %    Param.TimeRepeatAnova=1;
% %    Param.GroupRepeatAnova=1;
% % end

if Param.TimeRepeatAnova==1
   if ~isfield(Param,'TimeComparison')
      Param.TimeComparison=0;   %%%%%%Paired Test across time;
   end
end



if Param.TimeCol==0
         for i=1:Cnum
             RateAll{i}=RateAll{i}';
         end
end
if ~isfield(Param,'CorrName')
Param.Q=0.05;
Param.CorrName='fdr';   %%%methold for multi-compairson
end

        GgroupAll=[];
        Gbin=[];
        gSubject=[];
        DataAnova=[];
        TempSubjNum=0;
        for iCom=1:Cnum
            if Param.TimeRepeatAnova==1&&Param.GroupRepeatAnova==1
            DataAnova=[DataAnova;RateAll{iCom}];
            GgroupAll=[GgroupAll;zeros(size(RateAll{iCom}))+iCom];
            Gbin=[Gbin;repmat([1:size(RateAll{iCom},2)],size(RateAll{iCom},1),1)];
            gSubject=[gSubject;repmat([1:size(RateAll{iCom},1)]',1,size(RateAll{iCom},2),1)];
%             elseif Param.TimeRepeatAnova==1&&Param.GroupRepeatAnova==0
%             DataAnova=[DataAnova;RateAll{iCom}];
%             GgroupAll=[GgroupAll;zeros(size(RateAll{iCom}))+iCom];
%             Gbin=[Gbin;repmat([1:size(RateAll{iCom},1)]',1,size(RateAll{iCom},2))];
%             gSubject=[gSubject;repmat([1:size(RateAll{iCom},2)]+TempSubjNum,size(RateAll{iCom},1),1)];
%             TempSubjNum=max(gSubject(:));
            else
            temp1=RateAll{iCom};
            DataAnova=[DataAnova;temp1(:)];
             temp1=zeros(size(RateAll{iCom}))+iCom;
            GgroupAll=[GgroupAll;temp1(:)];
             temp1=repmat([1:size(RateAll{iCom},2)],size(RateAll{iCom},1),1);
            Gbin=[Gbin;temp1(:)];
            temp1=repmat([1:size(RateAll{iCom},1)]',1,size(RateAll{iCom},2),1);
            gSubject=[gSubject;temp1(:)];
            TempSubjNum=max(gSubject(:));
 
            end
            
           
        end 
DataAnova=DataAnova(:);
gSession=Gbin(:);
gSubject=gSubject(:);
gDataType=GgroupAll(:);
save([Rfolder 'R_MultiRepeatAnova.mat'],'DataAnova','gSubject','gDataType','gSession','-v6');




  Ppair=[];
  ii=1;
  GroupPair=[];
     
  ShowPair='                                                                                                '; 

  if Param.TimeComparison==0
   if Param.Paired==1
  TempText=' Paired-ttest';
  else
  TempText=' NonPaired-ttest';
  end
  ShowPair(end+1,1:length(TempText))=TempText;
clear TempText

     %%%%%%%%%%%%Group comparison for each time point 

  for i=1:Cnum
         for j=i+1:Cnum
             for ti=1:size(RateAll{i},2)
                 clear TempText
                 if Param.Paired==1&&Param.RepeatAnova==1
                    [h,Ppair(ii,ti),~,tstat(ii,ti)]=ttest(RateAll{i}(:,ti),RateAll{j}(:,ti));
                    [PpairRank(ii,ti),h,Rankstat(ii,ti)]=signrank(RateAll{i}(:,ti),RateAll{j}(:,ti));
               
                 else
                    [h,Ppair(ii,ti),~,tstat(ii,ti)]=ttest2(RateAll{i}(:,ti),RateAll{j}(:,ti));
                    [PpairRank(ii,ti),h,Rankstat(ii,ti)]=ranksum(RateAll{i}(:,ti),RateAll{j}(:,ti));

                 end
                TempText=[Param.BinName ' ' num2str(Param.Bin(ti))  ',Group' num2str(i) '-Group' num2str(j) ' ,t' num2str(tstat(ii,ti).df) '=' num2str(tstat(ii,ti).tstat) ', p=' num2str(Ppair(ii,ti))];
                tempSS1=fieldnames(Rankstat(ii,ti));
                tempSS1=tempSS1{1};
                tempSS2=getfield(Rankstat(ii,ti),tempSS1);

                TempText=[TempText,',' tempSS1 '=' num2str(tempSS2) ', p=' num2str(PpairRank(ii,ti))];

                ShowPair(end+1,1:length(TempText))=TempText;

                 clear TempText;
             end
             ii=ii+1;
             GroupPair=[GroupPair;[i j]];
         end
  end
     %%%%%%%%%%%%Group comparison for each time point 

  else
      
     %%%%%%%%%%%%Group comparison for each time point 
      TempText='Group Comparison for Each Time Point';
      ShowPair(end+1,1:length(TempText))=TempText;

      
        for i=1:Cnum
         for j=i+1:Cnum
             for ti=1:size(RateAll{i},2)
                 clear TempText
                 if Param.Paired==1&&Param.RepeatAnova==1
                    [h,Ppair(ii,ti),~,tstat(ii,ti)]=ttest(RateAll{i}(:,ti),RateAll{j}(:,ti));
                    [PpairRank(ii,ti),h,Rankstat(ii,ti)]=signrank(RateAll{i}(:,ti),RateAll{j}(:,ti));
               
                 else
                    [h,Ppair(ii,ti),~,tstat(ii,ti)]=ttest2(RateAll{i}(:,ti),RateAll{j}(:,ti));
                    [PpairRank(ii,ti),h,Rankstat(ii,ti)]=ranksum(RateAll{i}(:,ti),RateAll{j}(:,ti));

                 end
                TempText=[Param.BinName ' ' num2str(Param.Bin(ti))  ',Group' num2str(i) '-Group' num2str(j) ' ,t' num2str(tstat(ii,ti).df) '=' num2str(tstat(ii,ti).tstat) ', p=' num2str(Ppair(ii,ti))];
                tempSS1=fieldnames(Rankstat(ii,ti));
                tempSS1=tempSS1{1};
                tempSS2=getfield(Rankstat(ii,ti),tempSS1);

                TempText=[TempText,',' tempSS1 '=' num2str(tempSS2) ', p=' num2str(PpairRank(ii,ti))];

                ShowPair(end+1,1:length(TempText))=TempText;

                 clear TempText;
             end
             ii=ii+1;
             GroupPair=[GroupPair;[i j]];
         end
  end
     %%%%%%%%%%%%Group comparison for each time point 

      
     %%%%%%%%%%%%Time comparison for each Group 
  
      TempText='Time Paired-ttest';
      ShowPair(end+1,1:length(TempText))=TempText;
clear TempText

    for i=1:Cnum
        for ti=1:size(RateAll{i},2)
            for tj=ti+1:size(RateAll{i},2)
              [h,Ppair(ii,i),~,tstat(ii,i)]=ttest(RateAll{i}(:,ti),RateAll{i}(:,tj));
              [PpairRank(ii,i),h,zRankstat]=signrank(RateAll{i}(:,ti),RateAll{i}(:,tj),'method','exact');
                tempSS1=fieldnames(zRankstat);
                tempSS1=tempSS1{1};
                tempSS2=getfield(zRankstat,tempSS1);


              
                TempText=['Group' num2str(i) ' ' Param.BinName ' ' num2str(Param.Bin(ti)) '-' Param.BinName ' ' num2str(Param.Bin(tj)) ,...
' ,t' num2str(tstat(ii,i).df) '=' num2str(tstat(ii,i).tstat) ', p=' num2str(Ppair(ii,i))...
];

                TempText=[TempText,',' tempSS1 '=' num2str(tempSS2) ', p=' num2str(PpairRank(ii,i))];

           ShowPair(end+1,1:length(TempText))=TempText;
                 ii=ii+1;
               GroupPair=[GroupPair;[ti tj]];

            end   
                 
        end
    end
     
     %%%%%%%%%%%%Time comparison for each Group 

  end
     
 Show(1,:)='                                                                        ';

     
if Param.TimeRepeatAnova==1&&Param.GroupRepeatAnova==1
%%%%%%%using R script for anova;
RunRcode([Rfolder 'anovaR.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\my program\normal\Workingtemp\ANOVA-RepeatedMeasures.txt';
movefile(ResultFile,[Param.PathSave '_R_RepeatAnova.txt']);

% % % ResultFile=RepAnova2_withR(Data,Dependent,SavePath)


      TempText=' ';
      Show(end+1,1:length(TempText))=TempText;
      clear TempText

    
    TempText='One Way ANOVA RepeatMeasures';
    Show(end+1,1:length(TempText))=TempText;
    for ti=1:size(RateAll{i},2)
        temp=[];
        for iCom=1:Cnum
            temp=[temp RateAll{iCom}(:,ti)];
        end 
       [ptemp,table{ti}]=anova_rm(temp,'off');
        pAnova(ti)=ptemp(1);
% %        [p, table{ti}, Astats] = anova_rm(yTemp,'off');

       TempText=[Param.BinName ' ' num2str(Param.Bin(ti)) ' Session Effect:', 'F', num2str(table{ti}{2,3}) ',' num2str(table{ti}{4,3}) '=' num2str(table{ti}{2,5}) ,', P=',num2str(table{ti}{2,6})];
       Show(end+1,1:length(TempText))=TempText;
    end
     
elseif Param.TimeRepeatAnova==1&&Param.GroupRepeatAnova==0
     [ptemp,table]=anova_rm(RateAll,'off');
% %      [ptemp,table]=anova_rm(RateAll);
     TempText='Two Way Mixed-ANOVA';
     Show(end+1,1:length(TempText))=TempText;

     TempText=[Param.BinName , ' effect, F', num2str(table{2,3}) ',' num2str(table{4,3}) '=' num2str(table{2,5}) ,', P=',num2str(table{2,6})];
     Show(end+1,1:length(TempText))=TempText;

     TempText=['Group effect, F', num2str(table{3,3}) ',' num2str(table{4,3}) '=' num2str(table{3,5}) ,', P=',num2str(table{3,6})];
     Show(end+1,1:length(TempText))=TempText;

     TempText=['Interaction effect, F', num2str(table{4,3}) ',' num2str(table{4,3}) '=' num2str(table{4,5}) ,', P=',num2str(table{4,6})];
     Show(end+1,1:length(TempText))=TempText;
     
      clear table;
      TempText=' ';
      Show(end+1,1:length(TempText))=TempText;

            TempText=' ';
      Show(end+1,1:length(TempText))=TempText;

      TempText='One Way ANOVA for Individual Session';
      Show(end+1,1:length(TempText))=TempText;

        group=[];
        for iCom=1:Cnum
            group=[group;zeros(size(RateAll{iCom}(:,ti)))+iCom];
        end 

    for ti=1:size(RateAll{i},2)
        temp=[];
        for iCom=1:Cnum
            temp=[temp;RateAll{iCom}(:,ti)];
        end 
       [ptemp,table{ti},~]=anova1(temp,group,'off');
       pAnova(ti)=ptemp(1);
       TempText=[Param.BinName ' ' num2str(Param.Bin(ti)) ' , ' 'F', num2str(table{ti}{2,3}) ',' num2str(table{ti}{3,3}) '=' num2str(table{ti}{2,5}) ,', P=',num2str(table{ti}{2,6})];
       Show(end+1,1:length(TempText))=TempText;

    end

  
else
      clear table
      TempText=' ';
      Show(end+1,1:length(TempText))=TempText;

     [~,table,~,~]=anovan(DataAnova(:),{gSession gDataType},'model','interaction','display','off');
     TempText='Two Way ANOVA';
     Show(end+1,1:length(TempText))=TempText;
     
     TempText=[Param.BinName , ' effect, F', num2str(table{2,3}) ',' num2str(table{5,3}) '=' num2str(table{2,6}) ,', P=',num2str(table{2,7})];
     Show(end+1,1:length(TempText))=TempText;

     TempText=['Group effect, F', num2str(table{3,3}) ',' num2str(table{5,3}) '=' num2str(table{3,6}) ,', P=',num2str(table{3,7})];
     Show(end+1,1:length(TempText))=TempText;

     TempText=['Interaction effect, F', num2str(table{4,3}) ',' num2str(table{5,3}) '=' num2str(table{4,6}) ,', P=',num2str(table{4,7})];
     Show(end+1,1:length(TempText))=TempText;
      TempText=' ';
      Show(end+1,1:length(TempText))=TempText;

    
     TempText='One Way ANOVA for Individual Session';
     Show(end+1,1:length(TempText))=TempText;

        group=[];
        for iCom=1:Cnum
            group=[group;zeros(size(RateAll{iCom}(:,ti)))+iCom];
        end 

    for ti=1:size(RateAll{i},2)
        temp=[];
        for iCom=1:Cnum
            temp=[temp;RateAll{iCom}(:,ti)];
        end 
       [ptemp,table{ti},~]=anova1(temp,group,'off');
       pAnova(ti)=ptemp(1);
       TempText=[Param.BinName ' ' num2str(Param.Bin(ti)) ' , ' 'F', num2str(table{ti}{2,3}) ',' num2str(table{ti}{3,3}) '=' num2str(table{ti}{2,5}) ,', P=',num2str(table{ti}{2,6})];
       Show(end+1,1:length(TempText))=TempText;

    end

 
end
 
 
 Outstats.ttestP.Ppair=Ppair;
 Outstats.ttestP.tstat=tstat;
 Outstats.ttestP.PpairRank=PpairRank;
 Outstats.ttestP.Rankstat=Rankstat;
 Outstats.ttestP.GroupPair=GroupPair;
  
 Outstats.Anova.p=pAnova;
 Outstats.Anova.table=table;
 
 
 
 
 if strmatch(Param.CorrName,'fdr')
    clear sigSign
    for iq=1:length(Param.Q)
    [h, crit_p(iq), adj_p]=fdr_bh(pAnova,Param.Q(iq),'pdep','yes');
     sigSign{iq}=repmat('*',1,iq);
    end
    
      TempText=['Multi-Compairson Anova ' Param.CorrName];
      Show(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      Show(end+1,1:length(TempText))=TempText;
      for iq=1:length(Param.Q)
          TempText=[num2str(Param.Q(iq)) ' ' num2str(crit_p(iq))];
          Show(end+1,1:length(TempText))=TempText;
      end

    clear sigSign
    for iq=1:length(Param.Q)
    [h, crit_p(iq), adj_p]=fdr_bh(Ppair,Param.Q(iq),'pdep','yes');
     sigSign{iq}=repmat('*',1,iq);
    end

      TempText=['Multi-Compairson Paired ' Param.CorrName];
      ShowPair(end+1,1:length(TempText))=TempText;
      TempText=['Q Pth'];
      ShowPair(end+1,1:length(TempText))=TempText;
      for iq=1:length(Param.Q)
          TempText=[num2str(Param.Q(iq)) ' ' num2str(crit_p(iq))];
          ShowPair(end+1,1:length(TempText))=TempText;
      end
 
 end
 
 
     if isfield(Param,'PathSave')
       if Param.RepeatAnova==1 %%%%using R for first level anova 
           %%%%%thus a .txt was created; here appending rest context to an
           %%%%%existing .txt file
          fileID = fopen([Param.PathSave '_R_RepeatAnova.txt'],'a');
       else %%%%%%%creat a new .txt file
          fileID = fopen([Param.PathSave '_R_RepeatAnova.txt'],'w');
       
       end
%        fseek(fileID,0,'eof');
%        fseek(fid,20,'bof');
%        fgetl(fid)
       
       
       for i=1:length(Show(:,1))
           fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
       end
       for i=1:length(ShowPair(:,1))
           fprintf(fileID,'%s\r\n',deblank(ShowPair(i,:)));
       end

% % writetable(D1,fileID);
       fclose(fileID);

    end

 
% %  a=1;



