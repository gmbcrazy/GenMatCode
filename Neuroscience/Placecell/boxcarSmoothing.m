
% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Load the box template
box = boxcarTemplate2D();
map(isnan(map))=0;
% Size of map
[numRows,numCols] = size(map);

sMap = zeros(numRows,numCols);

for ii = 1:numRows
    for jj = 1:numCols
        
        for k = 1:5
            % Phase index shift
            sii = k-3;
            % Phase index
            rowInd = ii+sii;
            % Boundary check
            if rowInd<1
                rowInd = 1;
            end
            if rowInd>numRows
                rowInd = numRows;
            end
            
            for l = 1:5
                % Position index shift
                sjj = l-3;
                % Position index
                colInd = jj+sjj;
                % Boundary check
                if colInd<1
                    colInd = 1;
                end
                if colInd>numCols
                    colInd = numCols;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(rowInd,colInd) * box(k,l);
            end
        end
    end
end
   

% Gaussian boxcar template 5 x 5
function box = boxcarTemplate2D()

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];

box = single(box);
   

% pointY    Y-coordinate(s) for the point(s) to check
function n = insideCircle(cx, cy, radius, pointX, pointY)

radius = radius^2;
dist = (pointX-cx).^2 + (pointY-cy).^2;
n = single(length(dist(dist <= radius)));



