function MultiViolinLu(x,Data,Color,varargin)

if nargin<4
Param.ShowMean=true;
Param.Alpha=0.2;
Param.EdgeColor=[1 1 1];
Param.ShowMedian=false;
else
Param=varargin{1};
   
end
for i=1:length(x)
    a(i)=Violin(Data{i},x(i),'ShowNotches',false,'ViolinAlpha',Param.Alpha,'ViolinColor',Color(i,:),'MedianColor',Color(i,:),'ShowMean',Param.ShowMean,'BoxColor',Color(i,:));
    a(i).ScatterPlot.SizeData=6;
    hold on;
end
