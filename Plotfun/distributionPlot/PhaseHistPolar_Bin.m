function varargout=PhaseHistPolar_Bin(RadDataBin,BinCount,varargin)   



%%%%varargin{1} radius length for plot
%%%%varargin{2} color for plot
%%%%varargin{3} PlotParameters P
%%%P.smoothN WindowSize for Gaussian Smoothing
%%%P.ShowMax show the max Direction or Not
%%%P.LineWidth
Pdefault.smoothN=1;
Pdefault.ShowMax=1;
Pdefault.LineWidth=1;
Pdefault.Text={'0','\pi/2','\pi','-\pi/2'};



BinCount(isnan(BinCount))=0;
BinCount(isinf(BinCount))=0;

if nargin==2
   LimM=1;
   colorPlot=[1 0 0];
   P=Pdefault;

elseif nargin==3
   LimM=varargin{1};
   colorPlot=[1 0 0];
   P=Pdefault;
elseif nargin==4
   LimM=varargin{1};
   colorPlot=varargin{2};
   P=Pdefault;

elseif nargin==5
   LimM=varargin{1};
   colorPlot=varargin{2};
   P=varargin{3};
end
   l=length(BinCount);
   
   if abs(RadDataBin(1)-RadDataBin(end))<0.0001
      BinCount=BinCount(1:(end-1));
      l=l-1;
   end
   Temp=[BinCount(:);BinCount(:);BinCount(:)];
   Temp=SmoothDec(Temp,P.smoothN);
   BinCount=Temp((l+1):(2*l));
   BinCount(end+1)=BinCount(1);
   RadDataBin(end+1)=RadDataBin(1);
%     Prefer=circ_mean(RadDataBin,BinCount);
    [~,I]=max(BinCount);
    Prefer=RadDataBin(I);

    t=(-1)^0.5;
    
%     [pval,~] = circ_rtest(RadData(:));
    
    x=RadDataBin;
    z=BinCount.*exp(t.*RadDataBin);    

    
    LimM=max(LimM,max(abs(z)));
    while LimM<max(abs(z))
          LimM=LimM+LimM; 
    end
    Prefer=max(BinCount)*exp(t*Prefer);

    zz = LimM*exp(t*linspace(0, 2*pi, 101));
        
    if nargout<=1
        plot(real(z), imag(z),'color',colorPlot,'linewidth',P.LineWidth);

    hold on;
    
    if P.ShowMax
    plot([0 real(Prefer)],[0 imag(Prefer)],'color',colorPlot,'linewidth',2);

    end
        plot(real(zz), imag(zz),'k-',[0 0], [-LimM LimM], 'k:',[-LimM LimM],[0 0],'k:');

    hold off;

    
    set(gca,'xlim',[-LimM LimM],'ylim',[-LimM LimM],'box','off');
%     axis square;
    set(gca,'box','off')
    set(gca,'xtick',[],'ycolor',[0.99 0.99 0.99])
    set(gca,'ytick',[],'xcolor',[0.99 0.99 0.99])
    
    if isfield(P,'Text')
    text(LimM, 0, P.Text{1},'horizontalalignment','left','fontsize',10,'fontname','Times New Roman','fontweight','bold'); 
    text(0, LimM, P.Text{2},'horizontalalignment','center','verticalalignment','bottom','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
    text(-LimM, 0, P.Text{3},'horizontalalignment','right','fontsize',10,'fontname','Times New Roman','fontweight','bold');  
    text(0, -LimM, P.Text{4},'horizontalalignment','center','verticalalignment','top','fontsize',10,'fontname','Times New Roman','fontweight','bold');
    end
%     text(LimM-LimM/3, LimM-LimM/5, ['p' showPvalue(pval,3)]);
    
    if nargout==1
    varargout{1}=gca;
    end

    end

    
    