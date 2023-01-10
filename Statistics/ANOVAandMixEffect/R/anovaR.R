rm(list=ls())
library(R.matlab)
Temp1=readMat("C:/Users/lzhang481/ToolboxAndScript/MyGenMat/Statistics/ANOVAandMixEffect/R/R_MultiRepeatAnova.mat");
DataAnova=unlist(Temp1$DataAnova);
gSubject=factor(unlist(Temp1$gSubject));
gDataType=factor(unlist(Temp1$gDataType));
gSession=factor(unlist(Temp1$gSession));
Data.Anova<-data.frame(rt=as.vector(DataAnova),gSubject,gSession,gDataType)
A=summary(aov(rt ~ gSession*gDataType + Error(gSubject/(gSession*gDataType)), data=Data.Anova));
sink("C:/Users/lzhang481/ToolboxAndScript/MyGenMat/Statistics/ANOVAandMixEffect/R/ANOVA-RepeatedMeasures.txt");print(A);sink(); 
