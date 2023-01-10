function pth=CircBundlePlot(Data,P,varargin)

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');
if ischar(Data)
load(Data);
sig=sign(Z_wei);
if isfield(P,'correction')
  switch P.correction
      case 'fdr'
          pth=Thfdr_Pmatrix(pval_meta,P.pth)+0.0000001;
      case 'bf'
          l=size(sig,1);
          pth=P.pth/l/(l-1)*2;
      otherwise
             pth=P.pth;
  end
else
  pth=P.pth;
end

sig(pval_meta>pth)=0;
% if nargin==2
%    IndexInterest=varargin{1};
%    NonIndex=setdiff(1:size(sig,1),IndexInterest);
%    sig(NonIndex,:)=0;
%    sig(:,NonIndex)=0;
% end

else
    sig=Data;    %%%%%%Data is adjcent matrix
    pth=-1;
end
% % sig=abs(sig);
% % % [numric,txt,raw]=xlsread('D:\FMRI\AAL\AALDescri.xlsx',[1 4 5]);
% % % RegionName=raw(:,1);
% % % LobleID=numric(:,3);
% % % LobleName=raw(:,4);
load('Z:\Users\LuZhang\AAL\LuAAL.mat')
[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
RegionName=RegionName(Index);
sig=sig(Index,Index);


if P.PlotAll~=1
   Index=find(nansum(abs(sig))>0);
   sig=sig(Index,Index);
   LobleName=LobleName(Index);
   RegionName=RegionName(Index);
   LobleID=LobleID(Index);
end
sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

n=size(sigP,1);
n1=n;

DeltaTheta=2*pi/(n1);

Theta=[0:(n-1)]*DeltaTheta;

xi=cos(Theta);
yi=sin(Theta);
zi=zeros(size(xi));
Center=[xi(:) yi(:) zi(:)];

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
hold on
% figure;
if isfield(P,'Map')
   Cir_arcPlot(i1,i2,n,[],P.Map);
elseif isfield(P,'CAll')
   Cir_arcPlot(i1,i2,n,[],[],P.CAll);
elseif isfield(P,'Pcolor')
   Cir_arcPlot(i1,i2,n,P.Pcolor);
else
   Cir_arcPlot(i1,i2,n,[255 102 102]/255);
end
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link


%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link
[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
hold on
if isfield(P,'Map')
   Cir_arcPlot(i1,i2,n,[],P.Map);
elseif isfield(P,'Ncolor')
   Cir_arcPlot(i1,i2,n,P.Ncolor);
else
   Cir_arcPlot(i1,i2,n,[102 237 243]/255);
end

% Cir_arcPlot(i1,i2,n,[102 107 243]/255);

%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link
colorNL=[0.8 0.1 0.5;0 0.6 0.9;0.5 0.2 0.8;0.2 0.9 0.6;0.9 0.4 0.1;1 0.57 0.97;0.9 0.9 0.2];
% a=colormap;
NL=max(LobleID);
% StepC=size(a,1)/(NL+1);
% colorNL=a(4:StepC:size(a,1),:);
% colorNL=colorNL(1:NL,:);

colorP=zeros(n,3);
for i=1:NL
    Temp=find(LobleID==i);
    colorP(Temp,:)=repmat(colorNL(i,:),length(Temp),1);
end

r=0.03;
Nodedegree=nansum(abs(sig));
nodeSizePercentage=(min(Nodedegree,10)+3)/12;
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
    
        a=text(xi(i),yi(i),RegionName{i},'fontsize',4.5,'rotation',((Theta(i)/pi*180)-180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    

    else
       a= text(xi(i),yi(i),RegionName{i},'fontsize',4.5,'rotation',((Theta1(i))/pi*180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
  
    end
    
    if Nodedegree(i)>=3
        set(a,'fontsize',6.5,'fontweight','bold','fontname','Times New Roman')
    end
%     text(xx,yy,RegionName{i},'fontsize',6,'rotation',0,'HorizontalAlignment','center');    
%    if abs(sin(Theta(i)))
%        
%    end
% text(xi(i)+r,sign(yi(i))*abs(y(i))+2*,RegionName{i},'fontsize',6,'rotation',0)    

end
end
set(gca,'xlim',[-1.2 1.2],'ylim',[-1.2 1.2])

