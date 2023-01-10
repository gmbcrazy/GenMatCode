function ResultFile=MixAnova3_withR(Data,Dependent,SavePath)

%%%%three dependents is for mix ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_MixAnova3.mat'],'Data','Dependent');


RunRcode([Rfolder 'MixAnova3R.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\mixANOVA3-RepeatedMeasures.txt';
movefile(ResultFile,[SavePath '_R_MixANOVA3.txt']);

