function r = fieldMotionCohere(MotionVector,ConstrainMap)

l=size(MotionVector,1);
l=sqrt(l);
MotionmapX=MotionVector(:,1);
MotionmapY=MotionVector(:,2);

MotionmapX=reshape(MotionmapX,l,l);
MotionmapY=reshape(MotionmapY,l,l);

MotionmapX(isnan(ConstrainMap))=nan;
MotionmapY(isnan(ConstrainMap))=nan;

[n,m] = size(MotionmapX);
tmp = zeros(n*m,2);
k=0;
Index=0;
for y = 1:n
    for x = 1:m
        k = k + 1;
        % Consider a 3x3box from top left to bottom right
        xstart = max([1,x-1]);
        ystart = max([1,y-1]);
        xend = min([m x+1]);
        yend = min([n y+1]);
        
        Xtemp=MotionmapX(ystart:yend,xstart:xend);
        
        
        % check that the 8pixel periphery is not empty(NaN)
        nn = sum(sum(isfinite(MotionmapX(ystart:yend,xstart:xend)))) - isfinite(MotionmapX(y,x));
        % if it's not empty :
        if (nn > 0)
            t1=[MotionmapX(y,x) MotionmapY(y,x)];
            if sum(abs(t1))==0
               continue 
            end
            t2=MotionmapX(ystart:yend,xstart:xend);
            t2=t2(:);
            t3=MotionmapY(ystart:yend,xstart:xend);
            t3=t3(:);
            
            t4=[t2 t3];
            t1=repmat(t1,length(t2),1);
            
            Temp=nansum((t1.*t4),2)./sqrt(sum(t1.*t1,2))./sqrt(sum(t4.*t4,2));
            Index(k)=sum(Temp(isfinite(Temp)))-1;
            Index(k)=Index(k)/nn;
            
        else
            Index(k) = NaN;    
        end
    end
end
Index(Index<=0)=[];
if ~isempty(Index)
r=nanmean(Index);
else
  r=0;
end

