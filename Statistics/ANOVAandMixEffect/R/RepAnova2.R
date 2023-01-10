rm(list=ls())
library(R.matlab)
Temp1=readMat("C:/Users/lzhang481/ToolboxAndScript/MyGenMat/Statistics/ANOVAandMixEffect/R/R_RepAnova2.mat");
DataAnova=unlist(Temp1$Data);
g1=factor(unlist(Temp1$Dependent[,1]));
g2=factor(unlist(Temp1$Dependent[,2]));
gS=factor(unlist(Temp1$Dependent[,3]));
Data.Anova<-data.frame(rt=as.vector(DataAnova),gS,g1,g2)
A=summary(aov(rt ~ g1*g2+ Error(gS/(g1*g2)), data=Data.Anova));
sink("C:/Users/lzhang481/ToolboxAndScript/MyGenMat/Statistics/ANOVAandMixEffect/R/RepANOVA2.txt");print(A);sink();