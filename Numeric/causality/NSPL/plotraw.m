function plotraw(h, eventdata, handles, varargin)

subplotnum=handles.FileInfo.drawchnno;

heigthtotalscaleinwin=0.8;
if subplotnum>0
    heigthperplotscaleinwin=heigthtotalscaleinwin/subplotnum;
else
    heigthperplotscaleinwin=heigthtotalscaleinwin;
end
leftperplot=0.07;
widthperplot=0.9;
heightperplot=heigthperplotscaleinwin*0.7;

if subplotnum==0
    plotpos=[leftperplot 0.2 widthperplot heigthperplotscaleinwin*0.95];
    subplot('Position',plotpos);
    set(gca,'XTick',[]);
    set(gca,'YTick',[]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTickLabel',[]);
    %set(gca,'Visible','off');
end

minx=handles.FileInfo.drawstx;
maxx=handles.FileInfo.drawstx+handles.FileInfo.drawdx;

minxp=round(minx*handles.RawData.fs);
maxxp=round(maxx*handles.RawData.fs);

if minxp<1
    minxp=1;
end

if maxxp>handles.RawData.totalpoint
    maxxp=handles.RawData.totalpoint;
end

IntervalP=floor((maxxp-minxp)/1600);%the 1600 is for the horizontal resolution of the screen;
if IntervalP<2
    IntervalP=2;
end
IntervalPminusOne=IntervalP-1;
TotalP=floor((maxxp-minxp)/IntervalP);

x(1:2:2*TotalP)=handles.RawData.xaxisv(minxp:IntervalP:minxp+(TotalP-1)*IntervalP);
x(2:2:2*TotalP)=handles.RawData.xaxisv(minxp:IntervalP:minxp+(TotalP-1)*IntervalP);

%==========================================================================
%draw the beginning and ending lines for selected data.

if handles.RawData.sttime>minx &handles.RawData.sttime<maxx
    xst=[handles.RawData.sttime handles.RawData.sttime];
else
    xst=[minx minx];
end
        
if handles.RawData.endtime>minx &handles.RawData.endtime<maxx
    xend=[handles.RawData.endtime handles.RawData.endtime];
else
    xend=[minx minx];
end
%==========================================================================

set(gca,'FontSize',11);

i=1;
for j=1:handles.RawData.chnno
    if handles.FileInfo.drawstatus(j)==1
        miny=handles.FileInfo.drawsty(j);
        maxy=handles.FileInfo.drawsty(j)+handles.FileInfo.drawdy(j);

        yst=[miny maxy];
        yend=[miny maxy];
        
        plotpos=[leftperplot heigthperplotscaleinwin*(subplotnum-i)+(1-heigthtotalscaleinwin) widthperplot heightperplot];
        subplot('Position',plotpos);
        
        y1=min(reshape(handles.RawData.data(minxp:minxp+TotalP*IntervalP-1,j),[IntervalP TotalP]));
        y2=max(reshape(handles.RawData.data(minxp:minxp+TotalP*IntervalP-1,j),[IntervalP TotalP]));
        
        y(1:2:2*TotalP)=y1(:);
        y(2:2:2*TotalP)=y2(:);
        
        plot(x,y, xst, yst, xend, yend);

        axis([minx maxx miny maxy]);
        i=i+1;
    end
end

set(gca,'XTickLabel',[]);
set(gca,'FontSize',11);
%        set(gca,'XTick',[0:2:14]);
set(gca,'XTickLabelMode','auto');