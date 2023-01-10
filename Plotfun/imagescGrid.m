function imagescGrid(varargin)



if nargin==1
   z=varargin{1}; 
   x=1:size(z,2);
   y=1:size(z,1);

elseif nargin==3
   x=varargin{1};
   y=varargin{2};
   z=varargin{3}; 
else
    

end



imagesc(x,y,z);hold on

stepX=x(2)-x(1);
stepY=y(2)-y(1);
x=x-stepX/2;x=[x(:)' x(end)+stepX];
y=y-stepY/2;y=[y(:)' y(end)+stepY];
minX=min(x);minY=min(y);
maxX=max(x);maxY=max(y);

for i=1:length(x)
    plot([x(i) x(i)],[minY maxY],'k-');
 
end
for i=1:length(y)
    plot([minX maxX],[y(i) y(i)],'k-');
 
end