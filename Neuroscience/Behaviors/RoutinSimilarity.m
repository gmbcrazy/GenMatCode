function [Prob Sample]=RoutinSimilarity(Routin,VectorSize)


RoutinSample=1;
Sample(1).Zone=' ';
Count(1)=0;
l=0;
for i=1:length(Routin)
    NeedI=RoutinDownSample(1:length(Routin(i).Xraw),VectorSize);
    X(i,:)=Routin(i).Xraw(NeedI);
    Y(i,:)=Routin(i).Yraw(NeedI);
plot(X(i,:),Y(i,:),'.-');hold on;
plot(X(i,1),Y(i,1),'r.');hold on;
plot(X(i,end),Y(i,end),'go');hold on;

end
plot(X',Y');hold on;

[coeff,score] = pca([X Y]);
[pcX,score,latentX,tsquared,explained] = pca(X,'Algorithm','eig','Centered','off','Economy','off');
[pcY,score,latentY,tsquared,explained] = pca(Y,'Algorithm','eig','Centered','off','Economy','off');
plot(pcX(:,1)*sqrt(latentX(1)),pcY(:,1)*sqrt(latentY(1)),'r','linewidth',4)
hold on;
plot(pcX(:,2)*sqrt(latentX(1)),pcY(:,2)*sqrt(latentY(1)),'g','linewidth',4)
hold on;
plot(pcX(:,2)*sqrt(latentX(2)),pcY(:,2)*sqrt(latentY(2)),'b','linewidth',4)

[pcY,score,latent,tsquare] = princomp(Y);
figure;
plot(zscore(X'),zscore(Y'));hold on;
hold on
plot(pcX(:,1),pcY(:,1),'linewidth',4)
figure;
plot(pc(1:100,1),pc(101:200,1))
figure;
plot(pc(1:100,2),pc(101:200,2))

RoutinX=mean(X);
RoutinY=mean(Y);

hold on
plot(RoutinX,RoutinY,'linewidth',4)
% 
% for i=1:length(Routin)
%     DistX(i,:)=(X(i,:)-RoutinX).^2;
%     DistY(i,:)=(Y(i,:)-RoutinY).^2;
%     Score(i)=sqrt((sum(DistX(i,:))+sum(DistY(i,:)))/SizeNeed);
% end
% 
% DistBarX=mean(sqrt(DistX+DistY));
% 
% RoutinOut=[RoutinX;RoutinY];
% 
% 
% Score=mean(Score);
% 




function Index=RoutinDownSample(Index,SizeNeed)


% for ii=1:10000000
%    if ii*SizeNeed<=Index(end)
%       continue
%    else
%       StepS=ii-1
%       break
%    end
% end
Step=(Index(end)-Index(1))/SizeNeed;


IndexN=Index(1):Step:Index(end);
Index=round(IndexN);

