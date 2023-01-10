function [G,p]=MarkovState_HeatStrPlot(StrTransM,StrCounts,HeatTransM,HeatCounts,ComColor,ColorMapC,Clim)

Dim1=size(HeatTransM,1);
temp1M=ones(Dim1)/Dim1;
temp1C=ones(size(HeatCounts))/Dim1;

[G,p]=MarkovState_Plot(StrTransM,StrCounts,ComColor);
clear temp1M temp1C;

M1=HeatTransM(:);
M1(M1>Clim(2))=Clim(2);
M1(M1<Clim(1))=Clim(1);
M2=reshape(M1,[Dim1,Dim1]);

C1=HeatCounts(:);
C1(C1>Clim(2))=Clim(2);
C1(C1<Clim(1))=Clim(1);
C2=C1;

ClimN=size(ColorMapC,1);
ColorID=1:ClimN;
% % Clim=[-0.1 0.1];
% % ClimN=10;
[B1,E1]=discretize(Clim,ClimN);
% % X=[-0.3 0.05 0.01 0.09 0.02 -0.03 0.01]
[ColorM1I,~] = discretize(M1,E1);
[ColorC1I,~] = discretize(C1,E1);
ColorM2I=reshape(ColorM1I,[Dim1,Dim1]);


for i=1:ClimN
      [s t] = find(ColorM2I==ColorID(i));
      temp=zeros(size(ColorM2I));
      temp=ColorM2I==ColorID(i);
     if ~isempty(s)
       Gtemp = digraph(temp);
       temp=temp';
       temp=temp(:);
       temp=find(temp==1);
       Edgelabeltemp=p.EdgeLabel;
       for il=1:length(temp)
           Edgelabeltemp{temp(il)}='';
       end
       p.EdgeLabel=Edgelabeltemp;

%        highlight(p,Gtemp,'edgecolor',[0.8 0.8 0.8],'linestyle',':','linewidth',0.1);
       highlight(p,Gtemp,'edgecolor',ColorMapC(ColorM2I(s(1),t(1)),:));

     end
     
     
     
     
end


p.NodeColor=ColorMapC(ColorC1I,:);
for i=1:Dim1
    p.NodeLabel{i}='';
end

       for i=1:Dim1
%               TempComColor(Ns(i),:)=[1 0 0];
%               hold on;plot(p.XData(Ns(i)),p.YData(Ns(i))+sqrt(p.MarkerSize(Ns(i)))/15,'*','color',[0.9 0 0])
%               hold on;plot(p.XData(Ns(i)),p.YData(Ns(i)),'ro','markersize',p.MarkerSize(Ns(i))+5,'linewidth',1)
         hold on;plot(p.XData(i),p.YData(i),'o','markersize',p.MarkerSize(i)+3,'linewidth',1,'color',ComColor(i,:))

               
%               TempComColor(Ns(i),:)=[0 0 1];
       end

     
