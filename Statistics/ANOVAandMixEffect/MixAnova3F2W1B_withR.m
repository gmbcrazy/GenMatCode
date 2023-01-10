function ResultFile=MixAnova3F2W1B_withR(Data,Dependent,SavePath)

%%%%four dependents is for mix ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_MixAnova3F2W1B.mat'],'Data','Dependent');


RunRcode([Rfolder 'MixAnova3F2W1B.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\MixAnova3F2W1B.txt';
movefile(ResultFile,[SavePath '_MixAnova3F2W1B.txt']);

