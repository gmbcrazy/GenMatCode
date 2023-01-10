function Output=PhasePrecessionPlot(Pos,Phase,BinNum,PosInt,PlotMode,LinearCirParam,NormParam)

%%%%%%%Calculate Phase Precession for ignore the running direction

%%%%%%%Pos: Spike Position, if position is circular data, must be degree (0-360)
%%%%%%%Pos: Spike Phase
%%%%%%%PosInt: Interval of PlaceField Start and End
%%%%%%%PlotMode: 0 for no plot; 1 for scatter plot;2 for density plot;3 for both combined
%%%%%%%LinearCirParam: 0 for linear position; 1 for circular position;
%%%%%%%NormParam: 0 for raw position for place field; 1 for normalized place field: starting with 0 end with 1;


switch LinearCirParam
    
    case 0     %%%%%%%%%%%%Linear Position
         ValidI=find(Pos>=PosInt(1)&&Pos<=PosInt(2));         
    case 1    
         if PosInt(1)<PosInt(2)
            ValidI=find(Pos>=PosInt(1)&Pos<=PosInt(2));
            PlaceL=diff(PosInt);
         else
            ValidI=find(Pos>=PosInt(1)|Pos<=PosInt(2));
            PlaceL=360-PosInt(1)+PosInt(2);
         end        
    otherwise
        
end

if isempty(ValidI)
    Output.a=nan;
    Output.b=nan;
    Output.rho=nan;
    Output.pval=nan;
    Output.Pos=Pos;
    Output.Phase=Phase;
    Output.FieldSize=nan;
    Output.InFieldTSNum=0;

    disp('no spiking in place field');
    return
end

Pos=Pos(ValidI);
Phase=Phase(ValidI);


if NormParam==1
switch LinearCirParam
    
    case 0     %%%%%%%%%%%%Linear Position
%          ValidI=find(Pos>=PosInt(1)&&Pos<=PosInt(2));
%          Pos=(Pos-PosInt(1))/PlaceL;
           PosIntLabel={num2str(PosInt(1)) num2str(PosInt(2))};

    case 1     %%%%%%%%%%%%Circular Linear Position
         if PosInt(1)<PosInt(2)
             Pos=(Pos-PosInt(1))/PlaceL;
%              PosIntLabel={num2str(PosInt(1)) num2str(PosInt(2))};
         else
%              PosIntLabel={num2str(PosInt(1)) num2str(PosInt(2))};
             I1=find(Pos>=PosInt(1));
             I2=find(Pos<PosInt(2));
            if ~isempty(I1)
             Pos(I1)=(Pos(I1)-PosInt(1))/PlaceL;
%              Pos(I1)=Pos(I1)-PosInt(1);

            end
            if ~isempty(I2)
             Pos(I2)=(360+Pos(I2)-PosInt(1))/PlaceL;
%              Pos(I2)=360+Pos(I2)-PosInt(1);
            end  
%             PosInt=[0 PlaceL];

         end
    otherwise
        
end
    PosInt=[0 1];
end
% PosInt=[0 PlaceL];
 PosIntLabel={'0' '1'};

[a,b,rho,pval]=GT_cic_linear_regressBuzsaki(Phase,Pos);
Output.Pos=Pos;
Output.Phase=Phase;
Output.FieldSize=PlaceL;
Output.InFieldTSNum=length(Pos);

while min(a*PosInt+b)<0
      b=b+2*pi;
end

Pos=[Pos(:);Pos(:)];
Phase=[Phase(:);Phase(:)+2*pi];
% % BinNum=40; 

switch PlotMode
    case 0   

    case 1   
plot(Pos,Phase,'k.');
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosIntLabel,'ylim',[-pi 3*pi]);
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosIntLabel,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});

hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(1,3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

    case 2
 
        
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

H = hist2dLU([Pos(:),Phase(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
% a=surf(XYBin,XYBin,PolarD);grid off
imagesc(XBin,YBin,PolarD);colormap(jet)
axis xy
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosIntLabel,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});
hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(PosInt(2),3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');


    case 3
step=diff(PosInt)/BinNum;        
XBin=PosInt(1):step:PosInt(2);
step=4*pi/BinNum/2;        
YBin=[-pi:step:3*pi];

H = hist2dLU([Pos(:),Phase(:)],XBin(:),YBin(:));
PolarD=SmoothDec(H,[4,4]);
    
% a=surf(XYBin,XYBin,PolarD);grid off
imagesc(XBin,YBin,PolarD);colormap(jet)
axis xy
colormap('cool');      

hold on;
plot(Pos,Phase,'k.');
set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosIntLabel,'ylim',[-pi 3*pi]);

set(gca,'xlim',PosInt,'xtick',PosInt,'xticklabel',PosIntLabel,'ylim',[-pi 3*pi],'ytick',[-pi:pi:(3*pi)],'yticklabel',{'0' '\pi' '2\pi' '3\pi' '4\pi'});
hold on;
plot(PosInt,a*PosInt+b,'k');
plot(PosInt,a*PosInt+b+2*pi,'k');
plot(PosInt,a*PosInt+b-2*pi,'k');
text(PosInt(2),3*pi,[' r=' showNum(rho,2) ' p' showPvalue(pval,2)],'horizontalalignment','right','verticalalignment','bottom');

    otherwise
    disp('PlotMode must be 0,1,2,3');
end
Output.a=a;
Output.b=b;
Output.rho=rho;
Output.pval=pval;
 
 

        
        
        

