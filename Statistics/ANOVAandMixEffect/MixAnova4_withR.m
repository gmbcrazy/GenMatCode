function ResultFile=MixAnova4_withR(Data,Dependent,SavePath)

%%%%four dependents is for mix ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_MixAnova4.mat'],'Data','Dependent');


RunRcode([Rfolder 'MixAnova4R.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\mixANOVA4-RepeatedMeasures.txt';
movefile(ResultFile,[SavePath '_R_MixANOVA4.txt']);

