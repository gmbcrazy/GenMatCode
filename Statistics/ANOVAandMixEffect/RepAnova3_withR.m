function ResultFile=RepAnova3_withR(Data,Dependent,SavePath)

%%%%two dependents is for repeat ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_RepAnova3.mat'],'Data','Dependent','-v6');


RunRcode([Rfolder 'RepAnova3.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\RepANOVA3.txt';
movefile(ResultFile,[SavePath '_R_RepANOVA3.txt']);

