function [AP,TS,npw,wave]=APextractPlot2(filePlx,Neuron,Timerange,varargin)

%%%%%Reading Data of Hailan Group


%%%%%read the action potential from .Plx
%%%%%Neuron is a string in .Nex corresponding to .Plx file

if nargin>3
   Plot=1;
   colorPlot=varargin{1};
else
   Plot=0;
end

if iscell(Neuron)
    numUnit=length(Neuron);
    
    for i=1:length(Neuron)
    channel(i)=str2num(Neuron{i}(7:8));
    unit(i)=findstr(Neuron{i}(9),'abcdefghijklmnopqrstuvwxyz');

    end
else
    numUnit=1;
    channel=str2num(Neuron(7:8));
    unit=findstr(Neuron(9),'abcdefghijklmnopqrstuvwxyz');

end



clear wave wave1 wave2 n npw ts
AP=[];
TS=[];
for j=1:numUnit
APTemp=[];

for i=1:4
%      [n(i), npw(i), ts{i}, wave{i}] = plx_waves_v_Lu(filePlx, channel(j)-1+i, unit(j));

    [n(i), npw(i), ts{i}, wave{i}] = plx_waves_v(filePlx, channel(j)-1+i, unit(j));
    if n(i)~=0
       APTemp=[APTemp wave{i}];
    end

end
   AP=[AP;APTemp];
   TS=[TS;ts{1}];


end

TS=TS(:);
TempIndex=[];
for i=1:length(Timerange(1,:))
    TempIndex=[TempIndex;find(TS>=Timerange(1,i)&TS<=Timerange(2,i))];
end
AP=AP(TempIndex,:);
TS=TS(TempIndex,:);

for i=1:4
    wave{i}=wave{i}(TempIndex,:);
end


Xedge_blank_left=0.05;
Xedge_blank_right=0.05;
format short
XInterval=0.01;
XIndividual=4;
XWidth=(1-XInterval*(XIndividual-1)-Xedge_blank_left-Xedge_blank_right)/XIndividual;

Yedge_blank_low=0.05;
Yedge_blank_above=0.05;
YIndividual=1;

YInterval=0.1;
YWidth=(1-Yedge_blank_low-Yedge_blank_above-YInterval*(YIndividual-1))/YIndividual;

if Plot==1
for i=1:4
    temp_x=Xedge_blank_left+(i-1)*(XInterval+XWidth);
    temp_y=Yedge_blank_low;  
    subplot('position',[temp_x,temp_y,XWidth,YWidth]);
error_area(1:npw,mean(wave{i}),std(wave{i}),colorPlot,0.4,1);
    
set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
set(gca,'xlim',[1 npw(i)],'ylim',[-0.3 0.5],'box','off','xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99],'fontsize',12);
end
end
