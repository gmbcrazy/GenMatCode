function Conti = VectorContinuity(MapVector1,NormalizeIndex)
% 
%
X = MapVector1(:,1);
Y = MapVector1(:,2);

IndexO = 1:length(X);
IndexO = IndexO(:);
l = round(length(MapVector1(:,1))^0.5);


[ty,tx] = meshgrid(1:l,1:l);
close

tx = tx(:);
ty = ty(:);
XX = zeros();
YY = zeros();

for i = 1:length(X)    
    XX(tx(i),ty(i)) = X(i);
    YY(tx(i),ty(i)) = Y(i);
end

YY = YY(:,l:-1:1);
[tx,ty] = meshgrid(1:l,1:l);

IndexF = setdiff(IndexO,intersect(find(XX(:)==0),find(YY(:)==0))); % toolbox matlab ops
X1 = zeros(size(XX));
Y1 = zeros(size(YY));
tx = tx(:);
ty = ty(:);

for i = 1:length(IndexF)
    
    YP = tx(IndexF(i));
    XP = ty(IndexF(i));
    
    vx = XX(XP,YP);
    vy = YY(XP,YP);
    
    if vx ~= 0
        Ystep = abs(vx)/vx;
    else
        Ystep = 0;
    end
    
    if vy ~= 0
        Xstep = abs(vy)/vy;
    else
        Xstep = 0;
    end
       
    XP1 = XP+Xstep;
    YP1 = YP+Ystep;  

    if XP1>l || XP1<=0
       XP1 = XP;
    end
    
    if YP1>l || YP1<=0
       YP1 = YP;
    end
    
    if abs(XP-XP1)>abs(YP-YP1)
       YP1 = YP;
    elseif abs(XP-XP1)==abs(YP-YP1)
    else
       XP1 = XP;
    end
    
    X1(XP,YP) = XX(XP1,YP1);
    Y1(XP,YP) = YY(XP1,YP1);

end

% % figure
% % set(1,'WindowStyle','Docked');
% % subplot(2,1,1)
% % hold on
% % quiver(tx,ty,XX(:),YY(:),1,'r','linewidth',0.5); % toolbox matlab specgraph
% % set(gca,'xlim',[0 l],'ylim',[0 l])
% % subplot(2,1,2)
% % quiver(tx,ty,X1(:),Y1(:),1,'r','linewidth',0.5); % toolbox matlab specgraph
% % set(gca,'xlim',[0 l],'ylim',[0 l])

V = [XX(:) YY(:)];
V1 = [X1(:) Y1(:)];

docProduct = V.*V1;
docProduct = sqrt(sum(docProduct,2));

switch NormalizeIndex
    
    case 0        

        Conti = docProduct;
        Conti(isnan(Conti)) = 0;
        Conti = mean(Conti);
        
    case 1
        
        temp1 = V.*V;
        temp1 = sum(temp1,2);
        weighted = sqrt(temp1);
        weighted(isnan(weighted)) = 0;
        weighted = weighted/sum(weighted);
        Conti = docProduct;
        Conti(isnan(Conti)) = 0;
        Conti = sum(Conti.*weighted);
        
    case 2
        
        temp2 = V1.*V1;
        temp2 = sum(temp2,2);
        weighted = sqrt(temp2);
        weighted(isnan(weighted)) = 0;
        weighted = weighted/sum(weighted);

        Conti = docProduct;
        Conti(isnan(Conti)) = 0;
        Conti = sum(Conti.*weighted);
        
    case 3
        
        temp1 = V.*V;
        temp1 = sum(temp1,2);
        temp2 = V1.*V1;
        temp2 = sum(temp2,2);
        weighted = sqrt(temp1).*sqrt(temp2);
        weighted(isnan(weighted)) = 0;
        weighted = weighted/sum(weighted);
        
        Conti = docProduct;
        Conti(isnan(Conti)) = 0;
        Conti = sum(Conti.*weighted);

end

 Conti = abs(Conti);