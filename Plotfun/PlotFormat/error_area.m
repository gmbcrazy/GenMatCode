function a=error_area(X,Y,barlength,color,alpha,varargin)

X=X(:);
Y=Y(:);
barlength=barlength(:);

if nargin==6
linestyle=varargin{1};
linewidth=1;

elseif nargin==7
linestyle=varargin{1};
linewidth=varargin{2};
else
    linestyle='-';
    linewidth=1;
end
% Y=Y-barlength;
% YY=2*barlength;
% YYY=[Y YY];
% 
% area(X,YYY);hold on;
% fid=get(gca,'child');
% set(fid(1),'facecolor',color);
% fid1=get(fid(1),'child');
% set(fid1,'facealpha',alpha,'edgealpha',0);
% 
% 
% fid=get(gca,'child');
% set(fid(2),'facecolor',color);
% fid1=get(fid(2),'child');
% set(fid1,'facealpha',0,'edgealpha',0);
% 
% hold on;
% plot(X,Y+barlength,'color',color)

% fill([X X(end:1)],[Y Y(end:1)+YY(end:1)],[1 0.3 0.3])

Yabove=Y+barlength;
Ylow=Y-barlength;
X=X';
Yabove=Yabove';
Ylow=Ylow';

if alpha>0
b=fill([X(1) X(1:end) fliplr([X(1:end) X(end)])],[Yabove(1) Yabove fliplr([Ylow Ylow(end)])],color);
    set(b,'facealpha',alpha,'linestyle','none');

end
hold on;
a=plot(X,Y,'color',color,'linewidth',linewidth);
% a=plot(X,Y,'color',color);

% % % h=get(gca,'children')
% % if nargin>6
%     set(a,'linestyle',linestyle,'linewidth',linewidth)

% %     set(h(end),'facealpha',alpha,'linestyle','none');
% %     set(h(1),'linestyle',linestyle,'linewidth',linewidth);
% % 
% % else
% %     set(h(end),'facealpha',alpha,'linestyle','none');
% %     set(h(1),'linestyle','-','linewidth',linewidth);
% % 
% % end
% % 


