rm(list=ls())
library(R.matlab)
Temp1=readMat("C:/Users/lzhang481/ToolboxAndScript/GenMatCode/Statistics/ANOVAandMixEffect/R/R_RepAnova3.mat");
DataAnova=unlist(Temp1$Data);
g1=factor(unlist(Temp1$Dependent[,1]));
g2=factor(unlist(Temp1$Dependent[,2]));
g3=factor(unlist(Temp1$Dependent[,3]));
gS=factor(unlist(Temp1$Dependent[,4]));
Data.Anova<-data.frame(rt=as.vector(DataAnova),gS,g1,g2,g3)
A=summary(aov(rt ~ g1*g2*g3+ Error(gS/(g1*g2*g3)), data=Data.Anova));
sink("C:/Users/lzhang481/ToolboxAndScript/GenMatCode/Statistics/ANOVAandMixEffect/R/RepANOVA3.txt");print(A);sink();