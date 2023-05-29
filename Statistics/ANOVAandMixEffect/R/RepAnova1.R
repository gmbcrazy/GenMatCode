rm(list=ls())
library(R.matlab)
Temp1=readMat("C:/Users/lzhang481/ToolboxAndScript/GenMatCode/Statistics/ANOVAandMixEffect/R/R_RepAnova1.mat");
DataAnova=unlist(Temp1$Data);
g1=factor(unlist(Temp1$Dependent[,1]));
gS=factor(unlist(Temp1$Dependent[,2]));


Data.Anova<-data.frame(rt=as.vector(DataAnova),gS,g1)
A=summary(aov(rt ~ g1 + Error(gS/(g1)), data=Data.Anova));
sink("C:/Users/lzhang481/ToolboxAndScript/GenMatCode/Statistics/ANOVAandMixEffect/R/repeatANOVA1.txt");print(A);sink(); 
