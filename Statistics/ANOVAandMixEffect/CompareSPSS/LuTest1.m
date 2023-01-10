LFP=[8.3008	8.30078	8.10548	7.8125	7.91016 7.3242	7.61718	7.51952	7.22654]';
Cell=[9.53332	9.52668	10.15332	8.67328	9.48006 5.52666	5.72	4.22668	5.24002]';

Y=[Cell;LFP];
S=repmat([1 2 3 4 5 1 2 3 4 5]',2,1);
F1=[zeros(size(Cell));ones(size(LFP))];%%%%F1=0 Cell;F1=1 LFP
F2=repmat([1 1 1 1 1 2 2 2 2 2]',2,1);    %%%%F2=1 AE;F2=2 REM
FactName={'CellLFP','AeRem'};
stats = rm_anova2(Y(:),S(:),F1(:),F2(:),FactName)

LFP=[8.3008	8.30078	8.10548	7.8125	7.3242	7.61718	7.51952	7.22654];
Cell=[9.53332	9.52668	10.15332	8.67328	5.52666	5.72	4.22668	5.24002];

Y=[LFP;Cell];
S=repmat([1 2 3 4 1 2 3 4],2,1);
F1=[zeros(size(LFP));ones(size(Cell))];%%%%F1=0 LFP;F1=1 Cell
F2=repmat([1 1 1 1 2 2 2 2],2,1);    %%%%F2=1 AE;F2=2 REM
FactName={'LFPCell','AeRem'};
stats = rm_anova2(Y(:),S(:),F1(:),F2(:),FactName)

[P,T,STATS,TERMS]=anovan(Y(:),{F1(:) F2(:)},'model',[0 1;1 0;1 1;],'sstype',3);
% [c,m] = multcompare(STATS,'dimension',[1 2],'alpha',0.05)


[p, table] = anova_rm(LFP, displayopt)

