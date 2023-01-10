## MANOVA for a randomized block design (example courtesy of Michael Friendly:
##  See ?Soils for description of the data set)

soils.mod <- lm(cbind(pH,N,Dens,P,Ca,Mg,K,Na,Conduc) ~ Block + Contour*Depth, 
    data=Soils)
Manova(soils.mod)

## a multivariate linear model for repeated-measures data
## See ?OBrienKaiser for a description of the data set used in this example.

phase <- factor(rep(c("pretest", "posttest", "followup"), c(5, 5, 5)),
    levels=c("pretest", "posttest", "followup"))
hour <- ordered(rep(1:5, 3))
idata <- data.frame(phase, hour)
idata

mod.ok <- lm(cbind(pre.1, pre.2, pre.3, pre.4, pre.5, 
                     post.1, post.2, post.3, post.4, post.5, 
                     fup.1, fup.2, fup.3, fup.4, fup.5) ~  treatment*gender, 
                data=OBrienKaiser)
(av.ok <- Anova(mod.ok, idata=idata, idesign=~phase*hour)) 

summary(av.ok, multivariate=FALSE)

## A "doubly multivariate" design with two  distinct repeated-measures variables
## (example courtesy of Michael Friendly)
## See ?WeightLoss for a description of the dataset.




Fre <- c(8.3008,8.30078,8.10548,7.8125,7.3242,7.61718,7.51952,7.22654,9.53332,9.52668,10.15332,8.67328,5.52666,5.72,4.22668,5.24002);
Fre1<-matrix(Fre,4,4)
#Mea1=matrix(c(1,1,0,0),4,1)
Mea1<-matrix(c("LFP","LFP","Cell","Cell"),4,1)
State1<-matrix(c("Ae","Rem","Ae","Rem"),4,1)

#State1=matrix(c(0,1,0,1),4,1)
Subject1=matrix(c(1,2,3,4),4,1)
#LFPCell <- c(rep(1, 8), rep(-1, 8))
#State <- c(rep(1,4), rep(-1,4), rep(1,4), rep(-1,4))
#Subject <- rep(1:4,4)

Fre1=cbind(Subject1,Fre1,State1,Mea1)
colnames(Fre1)<-c("Subject","LFPAe","LFPRem","CellAe","CellRem","State","Mea")

data1=data.frame(Fre1)
##data1=data.frame(Subject1,Fre1)

data
data1=data.frame(Subject,Fre,LFPCell,State)


Mea2 <- factor(rep(c("LFP", "Cell"), c(2,2)),
    levels=c("LFP", "Cell"))

State2 <- factor(c("Ae", "Rem","Ae", "Rem"),
    levels=c("Ae", "Rem"))
idata2=data.frame(Mea2,State2)


mod.ok <- lm(cbind(LFPAe,LFPRem,CellAe,CellRem) ~  Subject, 
                data=data1)

Anova(mod.ok)

av.ok <- Anova(mod.ok,type=3,idata=idata2, idesign=~Mea2*State2)

summary(av.ok, multivariate=TRUE)




mod.ok <- lm(Fre ~  LFPCell*State+Error(Subject/(LFPCell*State)), data=data1)

(Anova(mod.ok))
Anova(mod.ok,type=3,idata=data1$Subject,idesign=~data1$Subject*data1$LFPCell)

data2=data.frame(data1)

Mea1 <- factor(rep(c("LFP", "Cell"), c(2, 2)),
    levels=c("LFP", "Cell"))
sta1 <- factor(c("Ae","Rem","Ae","Rem"),
    levels=c("Ae", "Rem"))

imatrix <- matrix(c(
	1,0, -1, 0,
	1,0, 1, 0,
	0,1, 0, -1,
	0,1, 0, 1), 4, 4, byrow=TRUE)
colnames(imatrix) <- c("LFP", "Cell", "Ae", "Rem")
rownames(imatrix) <- colnames(data1)[-1]
(imatrix <- list(measure=imatrix[,1:2], month=imatrix[,3:4]))


#contrasts(data1$Subject) <- matrix(c(), ncol=2) 
wl.mod<-lm(cbind(LFPAe,LFPRem,CellAe,CellRem)~Subject1, data=data1)
Anova(wl.mod, type=3,imatrix=imatrix,test="Roy")




