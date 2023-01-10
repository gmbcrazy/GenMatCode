function varargout=DirRate(DirSpike,DirBehavior,binNum)
%%%%%DirSpike is Motion Direction while spikes occures
%%%%%DirBehavior is Motion Direction of all behaviors

DirSpike(isnan(DirSpike))=[];
DirBehavior(isnan(DirBehavior))=[];


[t,r1]=PhaseHistPolar(DirSpike,binNum);   
[t,r2]=PhaseHistPolar(DirBehavior,binNum); 

r3=r1./r2;
r3(isnan(r3))=0;
r3(r2==0)=0;
r3(isinf(r3))=0;

stats = circ_stats(t,r3);
map=r3;
BinRad=t;

[pval,z] = circ_rtest(t,r3);
stats.p_Rayleigh=pval;
[pval,z] = circ_rtest(t,r3);
stats.z_Rayleigh=z;

varargout{1}=stats;
if nargout==1
else
   Data.BinTheta=t;
   Data.BinAcc=r3;
   varargout{2}=Data;
end
