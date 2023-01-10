function MultibarPlot(Data,Color,Xstart,Ystart,Xwidth,Ywidth)

for i=1:length(Data)
barplot(Xstart+(i-1)*Xwidth,Ystart,Xwidth,Ywidth,Color(Data(i),:),1);hold on;
end