function ResultFile=MixAnova5_withR(Data,Dependent,SavePath)

%%%%four dependents is for mix ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_MixAnova5.mat'],'Data','Dependent');


RunRcode([Rfolder 'MixAnova5R.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\mixANOVA5-RepeatedMeasures.txt';
movefile(ResultFile,[SavePath '_R_MixANOVA5.txt']);

