function GammaField=GT_gammaThetaField(SpecTotal,FreRange,TimeRange,Th)

%%%%%%%SpecTotal is the GammaField from GT_SpecThetaAlign.m
%%%%%%%Find out region with > Th*Peak Power
%%%%%%%Peak Power is defined as 


% % % % % FreRange=[30 100];
% % % % % TimeRange=[-0.15 0];


F=SpecTotal.F;
T=SpecTotal.Range;


FInd=find(F>FreRange(1)&F<FreRange(2));
TInd=find(T>TimeRange(1)&T<TimeRange(2));

temp=zeros(size(SpecTotal.AlignS1));

temp(TInd,FInd)=SpecTotal.AlignS1(TInd,FInd);

PeakPower=max(max(temp));
Threshold=Th*PeakPower;

thNum=50;
thRateRatio=Th;
GammaField=PlaceFieldFind2D(temp,thRateRatio,thNum);

% [I1,I2]=find(temp>Threshold);
% plot(GammaField.IndX,GammaField.IndY,'r.');hold on;
% plot(GammaField.PeakIX,GammaField.PeakIY,'*')
% 

for ii=1:length(GammaField)
I1=GammaField(ii).IndX;
I2=GammaField(ii).IndY;

% plot(I1,I2,'go')



a=zeros(size(SpecTotal.AlignS1));
b=a;
b=a+nan;
for i=1:length(I1)
a(I1(i),I2(i))=1;
b(I1(i),I2(i))=1;
end

figure(1000);
[x,y]=meshgrid(T,F);
C=contour(x,y,a',1);
close(1000);

GammaField(ii).Contour=[C(1,2:end);C(2,2:end)]';
GammaField(ii).Matrix=b';
GammaField(ii).Power=(b.*SpecTotal.AlignS1)';

end
% % plot(C(1,:),C(2,:),'.')
% % 
% % 
% % 
% % figure;
% % imagesc(SpecTotal.Range,SpecTotal.F,log(SpecTotal.AlignS1'));
% % axis xy;set(gca,'ylim',FreRange,'xlim',[T(1) T(end)],'clim',[-2 1]);
% % axis xy;set(gca,'ylim',[0 100],'xlim',[T(1) T(end)],'clim',[-2 1]);
% % 
% % colormap(hot)
% % hold on;
% % plot(T(round(C(1,:))),F(round(C(2,:))),'.')