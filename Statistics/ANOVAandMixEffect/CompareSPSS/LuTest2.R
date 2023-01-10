Fre <- c(8.3008,8.30078,8.10548,7.8125,7.3242,7.61718,7.51952,7.22654,
9.53332,9.52668,10.15332,8.67328,5.52666,5.72,4.22668,5.24002);
LFPCell <- factor(c(rep("LFP", 8), rep("Cell", 8)))
State <- factor(c(rep("AE",4),rep("REM",4),rep("AE",4),rep("REM",4)))

matrix(Fre, ncol= 4, dimnames = list(paste("subj", 1:4), c("LFP.AE", "LFP.REM","Cell.AE", "Cell.REM")))        

Hays.df<-data.frame(rt=Fre,subj = factor(rep(paste("subj", 1:4, sep=""), 2)),
DaTYPE = factor(rep(rep(c("LFP", "Cell"), c(8, 8)))),
State = State)



summary(aov(rt ~ DaTYPE * State + Error(subj/(DaTYPE * State)), data=Hays.df))



mod.ok <- lm(rt ~ DaTYPE*State+Error(subj/DaTYPE*State)), data=Hays.df)
Anova(mod.ok,type=3,idata=Hays.df$subj)
