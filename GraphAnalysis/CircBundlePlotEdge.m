function CircBundlePlotEdge(EdgeMetaNeed,P)

sig=zeros(116,116);
% % i1=EdgeMetaNeed(:,1);
% % i2=EdgeMetaNeed(:,2);
% % 
% % for i=1:length(i1)
% %     sig(i1(i),i2(i))=1; 
% % end
% % sig=abs(sign(sig+sig'));

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');
% % % [numric,txt,raw]=xlsread('D:\FMRI\AAL\AALDescri.xlsx',[1 4 5]);
% % % RegionName=raw(:,1);
% % % LobleID=numric(:,3);
% % % LobleName=raw(:,4);
load('D:\FMRI\AAL\LuAAL.mat')
[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
sig=sig(Index,Index);
RegionName=RegionName(Index);
% i1=intersect(EdgeMetaNeed(:,1),Index)

for i=1:size(EdgeMetaNeed,1)
i1(i)=find(Index==EdgeMetaNeed(i,1));
i2(i)=find(Index==EdgeMetaNeed(i,2));
end

% i1=[i11;i22];
% i2=[i22;i11];
% Valid=find([i2-i1]>0);
% i1=i1(Valid);
% i2=i2(Valid);
% Valid=find([i2-i1]>0);
% i1=i1(Valid);
% i2=i2(Valid);



n=size(sig,1);
n1=n;

DeltaTheta=2*pi/(n1);

Theta=[0:(n-1)]*DeltaTheta;

xi=cos(Theta);
yi=sin(Theta);
zi=zeros(size(xi));
Center=[xi(:) yi(:) zi(:)];

hold on
% figure;
if isfield(P,'Map')
   Cir_arcPlot(i1,i2,n,[],P.Map);
elseif isfield(P,'CAll')
   Cir_arcPlot(i1,i2,n,[],[],P.CAll);
else
   Cir_arcPlot(i1,i2,n,[255 102 102]/255);
end



colorNL=[0.8 0.1 0.5;0 0.6 0.9;0.5 0.2 0.8;0.2 0.9 0.6;0.9 0.4 0.1;1 0.57 0.97;0.9 0.9 0.2];
% a=colormap;
NL=max(LobleID);
% StepC=size(a,1)/(NL+1);
% colorNL=a(4:StepC:size(a,1),:);
% colorNL=colorNL(1:NL,:);

colorP=zeros(n,3);
for iL=1:NL
    Temp=find(LobleID==iL);
    colorP(Temp,:)=repmat(colorNL(iL,:),length(Temp),1);
end

sig=zeros(116,116);

for i=1:length(i1)
    sig(i1(i),i2(i))=1;
end
sig=sign(sig+sig');


r=0.03;
Nodedegree=nansum(abs(sig));
nodeSizePercentage=(min(Nodedegree,10)+3)/8;
SpherePlot(Center,r,colorP,nodeSizePercentage);

P.label=1;
view([0,0,1])
% light('position',[5 5 5])
% camlight, lighting gouraud
set(gca,'box','off');grid off

if P.label==1
    xi=cos(Theta)*(1+6*r);
    yi=sin(Theta)*(1+6*r);

    Theta1=Theta;
    Theta1(Theta>pi)=Theta1(Theta>pi)-2*pi;
for i=1:length(RegionName)
    if abs(Theta1(i))>pi/2
    
        a=text(xi(i),yi(i),RegionName{i},'fontsize',5,'rotation',((Theta(i)/pi*180)-180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    

    else
       a= text(xi(i),yi(i),RegionName{i},'fontsize',5,'rotation',((Theta1(i))/pi*180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
  
    end
    
    if Nodedegree(i)>=3
        set(a,'fontsize',5,'fontweight','bold','fontname','Times New Roman')
    end
%     text(xx,yy,RegionName{i},'fontsize',6,'rotation',0,'HorizontalAlignment','center');    
%    if abs(sin(Theta(i)))
%        
%    end
% text(xi(i)+r,sign(yi(i))*abs(y(i))+2*,RegionName{i},'fontsize',6,'rotation',0)    

end
end
set(gca,'xlim',[-1.2 1.2],'ylim',[-1.2 1.2])

