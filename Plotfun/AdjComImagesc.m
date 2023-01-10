function AdjComImagesc(data,CT,varargin)

CTall=unique(CT);

if nargin==2
    for i=1:length(CTall)
        ComColor(i,:)=[0.01 0.01 0.01];
    end
elseif nargin==3
    if size(varargin{1},1)==1
        for i=1:length(CTall)
        ComColor(i,:)=varargin{1};
        end
    else
        ComColor=varargin{1};
    end
else
end

[a,b]=sort(CT);
for i=1:length(CTall)
    numCT(i)=sum(CT==CTall(i));
end
temp=[0 numCT];
tempS=cumsum(temp);
tempO=tempS(2:end);
imagesc(data(b,b));hold on
for i=1:length(CTall)
    plot([tempS(i)+0.5 tempO(i)+0.5 tempO(i)+0.5 tempS(i)+0.5 tempS(i)+0.5],[tempS(i)+0.5 tempS(i)+0.5 tempO(i)+0.5 tempO(i)+0.5 tempS(i)+0.5],'color',ComColor(i,:),'linewidth',2);hold on
end

% load('C:\Users\lzhang481\ToolboxAndScript\my program\normal\LUplot\Color\colormapSave.mat','colorPN')
% colormap(colorPN);
% temp=colorbar;
% set(temp,'position',[0.97 0.22 0.02 0.52],'box','on','xtick',[],'ytick',[-0.2:0.2:1],'yticklabel',[],'ycolor','k')
% set(gca,'clim',[-1 1],'xtick',[],'ytick',[]);
% set(get(gca,'parent'),'color','w');
% papersizePX=[0 0 10.5 10];
