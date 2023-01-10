function [nFieldsA,fieldPropA,fieldBinsA]=Compute_placefield_map(aMap,p,aColAxis, aRowAxis)


% Maximum rate in the rate map
peakRate = nanmax(nanmax(aMap));
% Calculate the number of fields in the adaptive smoothed map
[nFieldsA,fieldPropA,fieldBinsA] = placefield(aMap,p.lowestFieldRate,p.fieldTreshold, p.minNumBins, aColAxis, aRowAxis);




function [nFields,fieldProp,fieldBins] = placefield(map, lowestFieldRate, fieldTreshold, minNumBins, colAxis,rowAxis)

if length(colAxis) < 2 || length(rowAxis) < 2
    nFields = 0;
    fieldProp = [];
    fieldBins = [];
    return
end

binWidth = rowAxis(2) - rowAxis(1);


% Counter for the number of fields
nFields = 0;
% Field properties will be stored in this struct array
fieldProp = [];

% Holds the bin numbers
% 1: row bins
% 2: col bins
fieldBins = cell(100,2);

% Allocate memory to the arrays
[numRow,numCol] = size(map);
% Array that contain the bins of the map this algorithm has visited
visited = zeros(numRow,numCol);
nanInd = isnan(map);
visited(nanInd) = 1;

globalPeak = nanmax(nanmax(map));

visited(map<globalPeak*fieldTreshold) = 1;

% Go as long as there are unvisited parts of the map left
while ~prod(prod(visited))
    
    visited2 = visited;
    
    % Find the current maximum
    [peak,r] = max(map);
    [peak,pCol] = max(peak);
    
    % Check if peak rate is high enough
    if peak < lowestFieldRate
        break;
    end
    
    pCol = pCol(1);
    pRow = r(pCol);
    
    binCounter = 1;
    binsRow = zeros(numRow*numCol,1);
    binsCol = zeros(numRow*numCol,1);
    
    % Array that will contain the bin positions to the current placefield
    binsRow(binCounter) = pRow;
    binsCol(binCounter) = pCol;
    visited2(pRow,pCol)=1;% Julie 24.10.2012 This is necessary so that the peak pixel is not considered again, as a neighbour of neighbouring pixels
    % otherwise the peak pixel is considered twice -> important for place
    % field properties !!!
    
    visited2(map<fieldTreshold*peak) = 1;
    current = 0;
    
    while current < binCounter
        current = current + 1;
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)-1, binsCol(current), numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current)+1, binsCol(current), numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current), binsCol(current)-1, numRow, numCol);
        [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, binsRow(current), binsCol(current)+1, numRow, numCol);
    end
    
    binsRow = binsRow(1:binCounter);
    binsCol = binsCol(1:binCounter);
    
    if isempty(binsRow)
        binsRow = pRow;
        binsCol = pCol;
    end

    if length(binsRow) >= minNumBins % Minimum size of a placefield
        nFields = nFields + 1;
        fieldBins{nFields,1} = binsRow;
        fieldBins{nFields,2} = binsCol;
        % Find centre of mass (com)
        comX = 0;
        comY = 0;
        % Total rate
        R = 0;
        %Coordinates are weighted by the value in the rate map
        for ii = 1:length(binsRow)
            R = R + map(binsRow(ii),binsCol(ii));
            comX = comX + map(binsRow(ii),binsCol(ii)) * rowAxis(binsRow(ii));
            comY = comY + map(binsRow(ii),binsCol(ii)) * colAxis(binsCol(ii));
        end
        
%         %%%%%%%%%%%%%%%%%%%%
%         % Julie : these lines seem to be FALSE... We propose an alternative
%         % using a vectorized place field
%         % 24.10.2012
%         % Average rate in field
%         avgRate = nanmean(nanmean(map(binsRow,binsCol)));
%         % Peak rate in field
%         peakRate = nanmax(nanmax(map(binsRow,binsCol)));
%         %%%%%%
        field_vectorized=[];
        for i=1:binCounter
            field_vectorized=[field_vectorized map(binsRow(i),binsCol(i))];
        end
        % Average rate in field
        avgRate = nanmean(nanmean(field_vectorized));
        % Peak rate in field
        peakRate = nanmax(nanmax(field_vectorized));
        
        % Size of field
        fieldSize = length(binsRow) * binWidth^2;
        % Put the field properties in the struct array
        % Julie : x, y are the barycenter coordinates (center of mass)
        fieldProp = [fieldProp; struct('x',comY/R,'y',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize)];% 
        %be careful the X/Y inversion is normal, because comY correspond to Columns, and so to the
        % x-axis
    end
    visited(binsRow,binsCol) = 1;
    map(visited == 1) = 0;
end

fieldBins = fieldBins(1:nFields,:);

function [visited2, binsRow, binsCol, binCounter] = checkNeighbours2(visited2, binsRow, binsCol, binCounter, cRow, cCol, numRow, numCol)

if cRow < 1 || cRow > numRow || cCol < 1 || cCol > numCol
    return
end

if visited2(cRow, cCol)
    % Bin has been checked before
    return
end

binCounter = binCounter + 1;
binsRow(binCounter) = cRow;
binsCol(binCounter) = cCol;
visited2(cRow, cCol) = 1;