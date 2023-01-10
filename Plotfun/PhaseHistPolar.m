function varargout=PhaseHistPolar(RadData,varargin)   

%%%%varargin{1} number of bins
%%%%varargin{2} radius length for plot
%%%%varargin{3} color for plot
RadData(isnan(RadData))=[];

if nargin==1
   NumBin=20;
   LimM=1;
   colorPlot=[1 0 0];
   Param.Pshow=1;
elseif nargin==2
   NumBin=varargin{1};
   LimM=1;
   colorPlot=[1 0 0];
      Param.Pshow=1;

elseif nargin==3
   NumBin=varargin{1};
   LimM=varargin{2};
     colorPlot=[1 0 0];
        Param.Pshow=1;

elseif nargin==4
   NumBin=varargin{1};
   LimM=varargin{2};
   colorPlot=varargin{3};
   Param.Pshow=1;
elseif nargin==5
   NumBin=varargin{1};
   LimM=varargin{2};
   colorPlot=varargin{3};
   Param=varargin{4};

else
  
end
    BinW=2*pi/NumBin;
    Prefer=circ_mean(RadData(:));
    t=(-1)^0.5;
    
    [pval,~] = circ_rtest(RadData(:));
    
    x=-pi:BinW:pi;
    RadData=[-pi;RadData(:);pi];
    Temp=histc(RadData,x);
    Temp(end)=[];
    Temp(1)=Temp(1)-1;
    x=x+BinW/2;
    x(end)=[];
    x=x(:);
    Temp=Temp(:);
    z = Temp/sum(Temp).*exp(t*x);
    z(end+1)=z(1);
    
    if nargout==2
%        z(end)=[];
       z = Temp.*exp(t*x);
       z(end+1)=z(1);

        [varargout{1},varargout{2}]=cart2pol(real(z),imag(z));
        varargout{1}=[x(:);x(1)];
     return
     end

    
    LimM=max(LimM,max(abs(z)));
    while LimM<max(abs(z))
          LimM=LimM+LimM; 
    end
    Prefer=LimM*exp(t*Prefer);

        zz = LimM*exp(t*linspace(0, 2*pi, 101));
        
    if nargout<=1
        plot(real(zz), imag(zz),'k-',[0 0], [-LimM LimM], 'k:',[-LimM LimM],[0 0],'k:');
    
    hold on;
    plot(real(z), imag(z),'color',colorPlot);
    plot([0 real(Prefer)],[0 imag(Prefer)],'color',colorPlot,'linewidth',2);
    
    hold off;

    
    set(gca,'xlim',[-LimM LimM],'ylim',[-LimM LimM],'box','off');
%     axis square;
    set(gca,'box','off')
    set(gca,'xtick',[],'ycolor',[0.99 0.99 0.99])
    set(gca,'ytick',[],'xcolor',[0.99 0.99 0.99])
    text(LimM+LimM/10, 0, '0'); text(-LimM/5, LimM+LimM/10, '\pi/2');  text(-LimM-LimM/5, 0, '\pi');  text(-LimM/10, -LimM-LimM/10, '-\pi/2');
    
    if Param.Pshow==1
    text(LimM-LimM/3, LimM-LimM/5, ['p' showPvalue(pval,3)]);
    end
    
    if nargout==1
    varargout{1}=gca;
    end

    end

    
    