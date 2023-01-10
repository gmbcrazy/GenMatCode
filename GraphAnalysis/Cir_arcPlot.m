function Cir_arcPlot(i1,i2,N,colorEdge,varargin)


if nargin==5
   Par=varargin{1};
   w=Par.Weight;
   PClim=Par.Clim;
   C1=Par.Color(1,:);
   C2=Par.Color(2,:);
elseif nargin==6
   CAll=varargin{2};
else
end
% n1=N-1;

DeltaTheta=2*pi/N;

Theta=[0:(N-1)]*DeltaTheta;

xi=cos(Theta);
yi=sin(Theta);
zi=zeros(size(xi));
Center=[xi(:) yi(:) zi(:)];

for ii=1:length(i1)
if abs(i2(ii)-i1(ii))<5
   [Px,Py]=arcPlot([xi(i2(ii)),yi(i2(ii))],[xi(i1(ii)),yi(i1(ii))],(abs(i2(ii)-i1(ii))/N)*1);
elseif abs(i2(ii)-i1(ii))>=5
   [Px,Py]=arcPlot([xi(i1(ii)),yi(i1(ii))],[xi(i2(ii)),yi(i2(ii))],(abs(i2(ii)-i1(ii))/N)*0.005);
else
    Px=xi([i1(ii),i2(ii)]);Py=yi([i1(ii),i2(ii)]);

end
if nargin==5
    if w(ii)>=PClim(2)
       colortemp=C2;
    elseif w(ii)<=PClim(1)
       colortemp=C1;
    else
       colortemp=(C2-C1)*(w(ii)-PClim(1))/diff(PClim)+C1;
    end
plot(Px,Py,'color',colortemp,'linewidth',1.5);hold on;
elseif nargin==6
plot(Px,Py,'color',CAll(ii,:),'linewidth',1.5);hold on;
else
plot(Px,Py,'color',colorEdge,'linewidth',1.5);hold on;
end

end
