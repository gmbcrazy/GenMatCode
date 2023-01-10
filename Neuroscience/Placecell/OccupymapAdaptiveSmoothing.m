function [posPdf, rowAxis, colAxis] = OccupymapAdaptiveSmoothing(posx, posy,...
                         xStart,yStart,xEnd,yEnd, sampleTime,...
                                        p, shape, center_arena_x,...
                                            center_arena_y)   
% [map, posPdf, rowAxis, colAxis] = ratemapAdaptiveSmoothing(posx, posy,
%       spkx, spky, xStart, xLength, yStart, yLength, sampleTime, p, shape)
%
% Calculates an adaptive smoothed rate map as described in "Skaggs et al
% 1996 - Theta Phase Precession in Hippocampal Neuronal Population and the
% Compression of Temporal Sequences"
%
% Input arguments
%
% posx          x-coordinate for all the position samples in the recording
% posy          y-coordinate for all the position samples in the recording
%
%
% xStart        Minimum x-coordinate for the path
%
% yStart        Minimum y-coordinate for the path
%
% xLength       Length of the arena in the x-direction [cm](for cylinder 
%               this equals the diameter)
% yLength       Length of the arena in the y-direction [cm] (for cylinder
%               this equals the diameter)
% sampleTime    Sample duarion. For Axona it is 0.02 sec, for NeuraLynx it
%               is 0.04 sec
%
% p             Parameter list with p.binWidth and p.alpha value
%
% shape         Shape of the box. Square box = 1, Cylinder = 2.
% %               1 dim: shape. 1 = box, 2 = cylinder, 3 = linear track
%                 2 dim: Side length or diameter of the arena.
%
% Output variables
%
% map           The adaptive smoothed map
%
% posPdf        The position probability density function
%
%
% Version 1.0
% 13. Jan. 2010
%
% Version 1.1   Optimalization for speed by Jan Christian Meyer.
% 20. Jan. 2012
%
% (c) Raymond Skjerpeng, KI/CBM, NTNU, 2010.


xLength = xEnd-xStart;
yLength = yEnd-yStart;

% Number of bins in each direction of the map
numColBins = ceil(xLength/p.binWidth);
numRowBins = ceil(yLength/p.binWidth);

rowAxis = zeros(numRowBins,1);
for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end
colAxis = zeros(numColBins, 1);
for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end

maxBins = max([numColBins, numRowBins]);

map = zeros(numRowBins, numColBins);
posPdf = zeros(numRowBins, numColBins);


binPosX = (xStart+p.binWidth/2);

if shape(1) == 1
    %'ratemapAdaptiveSmoothing'
    %tic

    % Overall clue:
    %     - grow circle from r=1:maxBins (mult. of binWidth), tracking inside
    %     - stop at smallest rad. such that r>=alpha/samples*sqrt(spikes)
    % Todo: - calc. distances once, relativize to multiples of binWidth
    %       - bucketsort results, this will eliminate the repeated counting
    %         of the circle interior
    radsqs = ((1:maxBins)*p.binWidth) .^ 2;
    for ii = 1:numColBins
        dist_sample_xdir = (posx-binPosX).^2;
        dist_spike_xdir = (spkx-binPosX).^2;

        binPosY = (yStart + p.binWidth/2);

        for jj = 1:numRowBins
            % Calculate sample and spike distances from bin center
            dist_sample = dist_sample_xdir + (posy-binPosY).^2;
            dist_spike = dist_spike_xdir + (spky-binPosY).^2;

             % Grow circle in increments of binWidth 
             for r = 1:maxBins
                n = length(dist_sample(dist_sample <= radsqs(r)));
                s = length(dist_spike(dist_spike <= radsqs(r)));

                if r >= p.alphaValue/(n*sqrt(s))
                    break;
                end
             end
 
            % Set the rate for this bin
            map(jj,ii) = s/(n*sampleTime);
            posPdf(jj,ii) = n*sampleTime;
            binPosY = binPosY + p.binWidth;
        end
        binPosX = binPosX + p.binWidth;
    end 
    %toc
else
    for ii = 1:numColBins
        
        
        binPosY = (yStart + p.binWidth/2);
        for jj = 1:numRowBins
            currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
            if currentPosition > shape(2)/2
                map(numRowBins-jj+1,ii) = NaN;
                posPdf(numRowBins-jj+1,ii) = NaN;
            else
                n = 0;
                s = 0;
                for r = 1:maxBins
                    % Set the current radius of the circle
                    radius = r * p.binWidth;
                    % Number of samples inside the circle
                    n = insideCircle(binPosX, binPosY, radius, posx, posy);
                    % Number of spikes inside the circle

                    if r >= p.alphaValue/(n*sqrt(s))         
                        break;
                    end

                end
                % Set the rate for this bin
                posPdf(jj,ii) = n*sampleTime;
                
            end
            binPosY = binPosY + p.binWidth;
        end 

        binPosX = binPosX + p.binWidth;
    end
end

posPdf = posPdf / nansum(nansum(posPdf));



% Calculate how many points lies inside the circle
%
% cx        X-coordinate for the circle centre
% cy        Y-coordinate for the circle centre
% radius    Radius for the circle
% pointX    X-coordinate(s) for the point(s) to check
% pointY    Y-coordinate(s) for the point(s) to check
function n = insideCircle(cx, cy, radius, pointX, pointY)

radius = radius^2;
dist = (pointX-cx).^2 + (pointY-cy).^2;
n = single(length(dist(dist <= radius)));



function cmap = getCmap()

% Set the number of colors to scale the image with
numLevels = 256;

% set the colormap using the jet color map (The jet colormap is associated 
% with an astrophysical fluid jet simulation from the National Center for 
% Supercomputer Applications.)
cmap = colormap(jet(numLevels));