function ResultFile=MixAnova2F1W1B_withR(Data,Dependent,SavePath)

%%%%four dependents is for mix ANOVA in each coloum of Dependent;
%%%%Dependent(:,end) is the subject coloum;


Rfolder = 'C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\';
save([Rfolder 'R_MixAnova2F1W1B.mat'],'Data','Dependent','-V6');


RunRcode([Rfolder 'MixAnova2F1W1B.R'],'C:\Program Files\R\R-3.5.0\bin')
ResultFile='C:\Users\lzhang481\ToolboxAndScript\MyGenMat\Statistics\ANOVAandMixEffect\R\MixAnova2F1W1B.txt';
movefile(ResultFile,[SavePath '_MixAnova2F1W1B.txt']);

