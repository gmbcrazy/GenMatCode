% Mehdi 05092016 :Comments added.
% This is to measure similarity of two vectorMap maps:
%
% In case 2 (which is the less biased one), it measures:
%     Index = sum(v1 .* v2 ) ./ sum(abs(v1) .* abs(v2))
%     where vi=[xi1 yi1; .. ;xin yin]
function Index = VectorSmility(MapVector1,MapVector2,NormalizeIndex)


docProduct = MapVector1.*MapVector2;
docProduct = sum(docProduct,2);

switch NormalizeIndex
    
    case 0   % No normalization
        
        Index = sum(docProduct);
        Index = Index/length(find(docProduct~=0));
        
    case 1   % Normalizd by the first VectorMap
        
        temp1 = MapVector1.*MapVector1;
        temp1 = sum(temp1,2);
        Index = docProduct./temp1;
        Index(isnan(Index)) = 0;
        Index = sum(Index);
        Index = Index/length(find(docProduct~=0));

    case 2   % Normalizd by both of the VectorMap using weighted average
        
        temp1 = MapVector1.*MapVector1;
        temp1 = sum(temp1,2);
        temp2 = MapVector2.*MapVector2;
        temp2 = sum(temp2,2);
        weighted = sqrt(temp1).*sqrt(temp2);
        weighted(isnan(weighted)) = 0;
        Index = docProduct./sqrt(temp1)./sqrt(temp2);
        Index(isnan(Index)) = 0;
        Index = sum(sum(Index.*weighted))/sum(sum(weighted)); % no need for two sum, both are nx1
        
    case 3   % Normalizd by the first_VectorMap^0.5
        
        temp1 = MapVector1.*MapVector1;
        temp1 = sum(temp1,2);
        Index = docProduct./sqrt(temp1);
        Index(isnan(Index)) = 0;
        Index = sum(Index);
        Index = Index/length(find(docProduct~=0));
       
end