function Rxx = adjustMap(Rxx,radius,centreRadius,oDist)

% Sets the bins of the map outside the radius to NaN
Rxx(oDist>radius) = NaN;
Rxx(oDist<=centreRadius) = NaN;

