% gridnessScore9_4(inputFile, outputFile)
% gridnessScore9_4(inputFile, outputFile, downSampleFrequency)
%
% This program calculates gridness score and a whole lot of other
% variables. Look at the output file for a complete list of variables. The
% program can also calculate expected grindessScore values by running a
% shuffling analysis. Please set the paramters in the parameter list in the
% start of the code according to your needs.
%
% NB 1!
% Recorded data must be converted with the databaseMaker program before it
% can be run with this program!
%
% NB 2!
% The mat file kongull.mat must be stored together with this program on
% kongull for it to run there.
%
%
%
%
% INPUT ARGUMENTS
%
% inputFile     Text file with information about the data to be analysed.
%               This must be an input file that you get from databaseMaker.
%               Look into that program for details.
%               Example: 'inputFile1.txt'
%
% outputFile    Name for the output file where the results will be written
%               to. Give it the extension .xls for the file to be associated
%               with MS Excell. Write the name in single quotes.
%               Example: 'Out1.xls'
%
%
% INPUT FILE
%
% NB! The program need to have the rat number as the last folder in the 
% session name. In the example under the rat number is 12051.
% In case of a circle shaped arena write circle for the shape and the
% diameter of the circle as the side length. Ex: shape circle 150. 
%
% Remember that the input file you make must be run through the 
% databaseMaker program, and the converted input file you get from that 
% program is the file you use as input to this program.
%
%
% INPUT FILE EXAMPLE
%
% Session N:\ainge\developmental data\12051\26110701
% Room room8
% Shape Box 100
% Tetrode 1
% Unit 1
% Unit 2
% ---
% Session N:\ainge\developmental data\12051\26110702
% Room room8
% Shape Box 100
% Tetrode 1
% Unit 1
% Unit 2
% Tetrode 3
% Unit 1
% Unit 4
% ---
%
%
% Version 1.0
% 21. Aug. 2009
%
% Version 1.1       Change the percentiles for the arc value from the 
% 25. Aug. 2009     higher end to the lower end
%
% Version 1.2       Added Dori's gridness mearsure.
% 27. Aug. 2009     
%
% Version 1.3       Added calculation of directional information and
% 27. Aug. 2009     Watson's U-square statistic.
%
% Version 1.4       Fixed bug with spike timestamps when combining sessions
% 31. Aug. 2009     
%
% Version 1.5       Added average rate
% 31. Aug. 2009  
%
% Version 1.6       Added option for downsampling number of spikes
% 02. Sep. 2009
%
% Version 1.7       Added plot of head direction maps. Added calculation of
% 18. Sep. 2009    the spacing in the perfect grid used in Dori's gridness
%                   calculation.
%
% Version 1.8       Bugfix of gridness spacing. 
% 21. Sep. 2009     
%
% Version 1.9       Small update on Dori's gridness score. New method
% 24. Sep. 2009     should give a higher value for grids.
%
% Version 2.0       Added calculation of spatial and angular stability. I.e
% 07. Oct. 2009     correlation of spatial rate between 2 halves of the
%                   session, and for angular stability the correlation of
%                   the angular rate between the halves. The expected
%                   values for these where also calculated using a Monte
%                   Carlo simulation.
%                   
% Version 2.1       Added calculation of the orientation of the grid.
% 08. Oct. 2009     
%                   
% Version 2.2       Added downsampled angular stability
% 15. Oct. 2009     
%                   
% Version 2.3       Added image of the grid orientation.
% 15. Oct. 2009  
%
% Version 3.0       Added new version of the gridness score calculation
% 03. Nov. 2009     where the central field is remvoved.
%                   Added gridness radius based on peak detection. Both
%                   with and without the centre field.
%                   Added option to set the maximum radius.
%                   Added option for how the gridness value is calculated.
%                   Added avarage firing rate for the whole session
%                   Added option for 2 different spike scramble methods.
%
% Version 3.1       Added number of fields detected in the correlogram to
% 03. Nov. 2009     the output file.
%
% Version 3.2       Added restriction to the random time shift in the
% 04. Nov. 2009     shuffling algorithm. The time shift can't be less than
%                   10 seconds from the start or the end of the session.
%
% Version 3.3       The peak based radius is now calculated as the median
% 04. Nov. 2009     distance to the located peaks and not the mean.
%                   Added more points to the calculation of the centre peak
%                   radius.
%                   Disk width is calculated as the distance between centre
%                   field radius and the maximum radius parameter setting.
%
% Version 3.4       Fixed bug in the central field radius calculation that
% 05. Nov. 2009     made the program crash in some cases.
%
% Version 3.5       Added calculation of mean vector length for the head
% 05. Nov. 2009     direction analysis.
%
% Version 3.6       Added calculation of the new gridness values and mean
% 05. Nov. 2009     vector length for downsampled data.
%                   Added calculation of expected mean vector length.
%                   Added calculation for arena coverage.
%                   Removed known compability issues for running the script
%                   on the Linux platform.
%                   Changed the gridness - gridnessP95 to use the gridness
%                   score with the centre field removed.
%
%
% Version 3.7       Added option to use 5x5 boxcar or 3x3 boxcar smoothing
% 10. Nov. 2009     for the rate map. (Before it was always 5 x 5)
%                   Change the calculation of the head direction rate map
%                   from using a Gaussian kernel smoothing to use a 5 bin
%                   boxcar smoothing.
%                   Change the name of the destination folder for the image
%                   files.
%                   Removed more compability issues with the Linux platform
%                   Added shuffling analysis based on all the cells in the
%                   input file.
%                   Added calculation of coherence based on unsmoothed rate
%                   map.
%                   Added minimium coverage and minimum average rate
%                   parameters. Shuffling will be skipped when any of these
%                   are to low.
%
% Version 3.8       Bug fix: When combining data the position data was not 
% 11. Nov. 2009     combined correctly.
%                   Change layout on the shuffle data output
%                   Removed NaNs from the arrays
%                   Added calculation of standard deviation for the shuffle
%                   values.
%
% Version 3.9       Added option for the smoothing of the head dirction
% 12. Nov. 2009     firing map. Now boxcar or flat window can be chosen.
%                   Added option for how to smooth the position data.
%                   Either moving mean window (like before) or boxcar
%                   smoothing.
%                   Updated the estimate for the running time for each cell
%                   to be more correct. (But still the estimates will be a
%                   little to high)
%
% Version 4.0       Added adaptive smoothing rate map for the
% 13. Nov. 2009     spatial and directional information calculation.
%                   Bugfix: binWidth was used in the head direction map and
%                   not the hdBinWidth!
%                   Change from minimum average rate to minimum number of
%                   spikes.
%
% Version 4.1       Added option to do both type of stability calculation
% 17. Nov. 2009     at the same time.
%                   Added number of spikes and session duration after speed
%                   filter to the output file.
%                   Added the best radius for the gridness score to the
%                   output file.
%                   Change the minimum number of spikes test to use the
%                   number of spikes after speed filtering.
%
% Version 4.2       New output file with all the shuffle values before the
% 17. Nov. 2009     binning is done.
%                   Bug fix in calculation of hd arc value.
%                   Change the way the hd arc value is calculated. Now the
%                   peak direction is used as the starting point for the
%                   arc and not the mean.
%
% Version 4.3       Added calculation of time spent for each head
% 26. Nov. 2009     direction. Time for each head direction bin are written
%                   to the output file.
%
% Version 4.4       Added option to set the bin width for the head
% 27. Nov. 2009     direction time map (p.hdTimeBinWidth). Also added
%                   option to use several bin widths for the binning of the
%                   shuffle data. See p.binWidthShuffleData
%
% Version 4.5       Added Dori's gridness score to the shuffling analysis.
% 01. Dec. 2009
%
% Version 4.6       Added rat name to output files. Added use of box size
% 07. Dec. 2009     to set the maximum radius of the correlogram.
%
% Version 4.7       New code to deal with errors in the position data.
% 14. Dec. 2009
%
% Version 4.8       Added calculation of border score.
% 14. Dec. 2009
%
% Version 4.9       Change code so that recordings with only one diode
% 14. Dec. 2009     can be used. You can't run head direction analysis
%                   with such data.
%
% Version 5.0       Added the radius of the inner field to the output file
% 17. Dec. 2009
%
% Version 5.1       Added binning of real data.
% 06. Jan. 2010
%
% Version 5.2       Added session, tetrode and cell information to the 
% 08. Jan. 2010     shuffle data all output file.
%
% Version 5.3       Changed coverage calculation to be more accurate for 
% 13.Jan. 2010      cylinder shaped arena.
%                   Added calculation of peak rate and field properties
%                   from the adaptive smoothed rate map.
%
% Version 5.4       Binning of real data now include all cells, also those
% 14. Jan. 2010     where number of spikes or coverage is low.
%
% Version 5.5       Added plot of adaptive smoothed rate map with the 
% 14. Jan. 2010     placefields marked with white dots.
%
% Version 5.6       Change the placefield detection algorithm from using
% 19. Jan. 2010     a recursive method to using an iterative method to save
%                   memory usage and to avoid random crashes when memory is
%                   full.
%
% Version 5.7       Added calculation of grid orientation with Tor's 
% 03. Feb. 2010     method
%
% Version 5.8       Added a full range colour version of the plot of the 
% 03. Feb. 2010     auto-correlogram.
%
% Version 5.9       Added option to keep only a segment of the recording 
% 04. Feb. 2010     for the analysis by setting the p.startTime and 
%                   p.stopTime parameters.
%
% Version 6.0       Fixed bug when cell have no spikes. Fixed problem
% 08. Feb. 2010     in orientation analysis when the auto-correlogram have
%                   to few peaks.
%
% Version 6.1       Added extra plot of rate map and correlogram without
% 22. Feb. 2010     axis.
%
% Version 6.2       Added mean orientation.
% 25. Feb. 2010     
%                   
% 
%
% Version 7.0       Now with support for both Axona and NeuraLynx in the
% 23. Mar. 2010     same program. Change the parameter p.recordingSystem to
%                   set the correct recording system.
%                   Added plot of path with spikes.
%                   Shuffling fixed from the NeuraLynx version.
%
% Version 7.1       Removed several variables from the output that are not
% 25. Mar. 2010     in use anymore.
%                   New option to set if we want the direction time bins to
%                   be written to the output file
%                   (p.includeDirectionalBins).
%                   Change the way the gridness (gridness centre removed)
%                   is calculated. Best radius is found as before but the
%                   gridness is calculated as the mean over the best radius
%                   and adjancent radii. The number of radii to do the mean
%                   over is set in the parameter p.numGridnessRadii.
%
% Version 7.2       Small change in the new gridness calculation.
% 29. Mar. 2010     
%
% Version 7.3       Another small change in the gridness calculation. The
% 30. Mar. 2010     "disk" between the centre field radius and the radius
%                   that gives the best gridness score must be of a minimum
%                   size set in the parameter p.minDiskWidth.
%
% Version 7.4       Removed border score from the shuffling for cell from
% 08. Apr. 2010     the cylinder arena. NaNs will be reported for cylinder
%                   data.
%
% Version 7.5       Added new parameter for setting the minimum time a bin
% 14. Apr. 2010     in the rate map must have been visited for it to get a
%                   real value. Before it was always 100 ms.
%                   
% Version 7.6       Fixed a small bug in the head direction map when
% 07. May. 2010     smoothed with a flat window filter. The rate in the
%                   first bins was smoothed over fewer bins than the rest
%                   of the rate map
%
% Version 7.7       Added option to set the size of the dots that mark the
% 10. May. 2010     spikes in the path plot.
%
% Version 7.8       Added option to set the width of the line that marks
% 10. May. 2010     the path in the plot of the path with spikes on.
%
% Version 7.9       Added option to set what rate the red colour in the     
% 04. Jun. 2010     rate plots should correspond to.
%
% Version 7.10       Added option to set the width of the line in the      
% 04. Jun. 2010     head direction rate map.
%
% Version 7.11      Added calculation of gridness noise  
% 25. Jun. 2010
%
% Version 7.12      Fixes possible glich in Axona timestamps (Time stamps
% 30. Jul. 2010     jumps, giving and error that accumulates trough the
%                   recording)
%
% Version 7.13      Added new grid orientation calculation, that calculates
% 30. Jul. 2010     the orientation line that gives the highest mean
%                   correlation along the line through the correlogram.
%
% Version 7.14      Added the orientation based on the best correlation 
% 09. Aug. 2010     line to the result output file.
%
% Version 7.15      Fixed bug that made the program crash if the path to 
% 11. Aug. 2010     the data was a subfolder to the program folder. 
%                   Added better compability with unix based systems.
%
% Version 7.16      Added calculation of information rate.
% 16. Aug. 2010     
%
%
% Version 8.0       Added new method for loading data. Recorded data must
% 23. Sep. 2010     be run through the databaseMaker program first.
%                   Stability option removed. Now both types of stability
%                   will be used each time. The stability calculation has
%                   also been optimezed for speed (around 5 times faster)
%                   The shuffling analysis has been optimized to be run in
%                   parallell when more than one cpu core is available.
%                   Remember to set the p.numCpuCores to a value higher
%                   than 1 to run in parallell.
%                   The gridness calculation is also parallalized and will
%                   utitilize up to 6 cores.
%                   The program has also been change so it will run
%                   smoothly on a Unix system without any need to change
%                   the input file.
%                   
% Version 8.1       Added calculation of distance between centre peak and
% 23. May. 2011     the 6 surounding peaks in the correlogram.
%                   
% Version 9.0       Different optimizations have been done to speed up
% 20. Jan. 2012     the running time.
%                   The following calculations have been removed.
%                       Dori's gridness
%                       Perfect grid spacing
%                       Spatial coherence smooth
%                       Watson U^2
%                       Grid orientation (Tor)
%                       
%                   The following calculations have been removed from the
%                   shuffling
%                       Spatial Information
%                       Border score
%
%                   In addition the following calculations have been made
%                   optional in the shuffling analysis.
%                       Gridness peak based
%                       Spatial Coherence unsmoothed
%                       Stability
%                       Mean Vector length
%
%                   spike position function have been optimized.
%
%                   Thanks to Jan Chrisitan Meyer for helping optimizing
%                   these functions:
%                       rateMap
%                       rateMapAdaptiveSmoothed
%                       correlation
%                       inCircle
%
%                   Other changes to the program.
%                       Using only one figure window for all the images.
%                       Figure window is maximized to the screen resolution
%                       to get best image quality.
%                       New color scale to images. Slightly faster
%                       plotting of images.
%                       Position samples are stored in single precision to
%                       save memoty usage.
%
% Version 9.1       Bug fix in the shuffled mean vector length calculation.
% 07. Mar. 2012     Made the gridness shuffling optional.
%
% Version 9.2       Optimised the correlation calculation to save 
% 23. Mar. 2012     calculation time.
%
% Version 9.3       Added calculation of movement direction rate map, and
% 18. Apr. 2012     the Rayleigh mean vector length for the map.
%                   Calculation is also included in the shuffling analysis.
%
% Version 9.4       Fixed reversed axes for the ratemap plot.
% 23. May. 2012
%
%
% Created by Raymond Skjerpeng, KI/CBM, NTNU, 2009 - 2012.
%
% Questions or error reports: raymond.skjerpeng@ntnu.no
function gridnessScore9_4(inputFile, outputFile, varargin)


%__________________________________________________________________________
%
%                       Program parameters
%__________________________________________________________________________

% This program has been optimized for running on multicore CPU's. Different
% parts of the program will make use of parallel execution of calculations. 
% In this parameter you can set the number of cpu cores you have available.
% Setting it to 'max' will make Matlab use the maximum possible for your 
% computer. 
%       Example:    p.numCpuCores = 'max';
%
% If you don't want it to use the maximum you can set it to a lower value
% by typing the number of cpu cores you want it to run on.
%       Example:    p.numCpuCores = 2;
%
% On a local computer the maximum number of cores you can set is 12 even if 
% your computer has more cores, this is because of limitations in the 
% Matlab parallel computing toolbox. (12 on Matlab 2011b and later, 8 on
% earlier versions)
% On kongull 12 cores will always be used.
p.numCpuCores = 4;

% Set this if the input file contains a line with room information for each
% session.
% 0 = No room information
% 1 = Room information exist
p.inputFileRoomInfo = 1;

% Size in centimeters for the bins in the ratemap
p.binWidth = 2.5; % [cm]

% Bin width for the head direction rate map.
p.hdBinWidth = 3; % [degrees]

% Bin width for the head direction time map. A map that will contain how
% much time the rat spends in each head direction.
p.hdTimeBinWidth = 6; % [degrees]


% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps
% format = 4 -> jpg
% format = 5 -> tiff (24 bit)
% format = 6 -> fig (Matlab figure)
p.imageFormat = 2;

% Low speed threshold. Segments of the path where the rat moves slower
% than this threshold will be removed. Set it to zero (0) to keep
% everything. Value in centimeters per second.
p.lowSpeedThreshold = 2.5; % [cm/s]

% High speed threshold. Segments of the path where the rat moves faster
% than this threshold will be removed. Set it to zero (0) to keep
% everything. Value in centimeters per second.
p.highSpeedThreshold = 100; % [cm/s]

% Minimum radius used in the auto-correlogram when finding the best
% gridness score
p.minRadius = 20; % [cm]


% Increment step of the radius when calculating what radius gives the best
% gridness score. 
p.radiusStep = p.binWidth; % [cm]

% When calculating gridness score based on the best radius, the program
% calculates the gridness score as an average over adjacent radii. This
% parameter sets the number of radii to use. The number must be odd. The
% middle radius will be set to be the best radius.
p.numGridnessRadii = 3;

% Threshold value used when defining the centre field. Border of centre
% field is defined as the place where the correlation falls under this
% threshold or the correlation start to increase again.
p.correlationThresholdForCentreField = 0.2;

% Method for locating the peaks in the correlogram.
% Mode = 0: New method for detection. (Raymond)
% Mode = 1: Dori's method
p.correlationPeakDetectionMode = 0;

% Sets how the gridness values are calculated.
% Mode = 0: Gridness is calculated as the mean correlation at 60 and 120
%           degrees minus the mean correlation at 30, 90 and 150 degrees.
% Mode = 1: Gridness is calculated as the minimum correlation at 60 and 120
%           degrees minus the maximum correlation at 30, 90 and 150
%           degrees.
p.gridnessCalculationMode = 1;

% Minimum allowed width of the correlogram disk. I.e the distance from the
% centre radius to the radius that gives the best gridness score. If the
% centre field radius is closer to the edge of the correlogram than the
% disk with, the gridness score will be NaN.
p.minDiskWidth = 10; % [cm]

% Set if the shuffling analysis will be done. This analysis takes a long
% time and should be omitted if you don't need the expected values. You can
% choose to do the shuffling for only selected variables by setting the
% list below.
% 1 = Do the shuffling analysis
% 0 = Omit shuffling analysis
p.doShufflingAnalysis = 1;

% Set what calculations that have to be done in the shuffling analysis.
% 1 = Do the analysis
% 0 = Omit the analysis
p.shuffleAnalysisList = zeros(6,1);
% Gridness score peak based (small time saving, if the normal gridness
% score is calculated. Huge time saving if both gridness calculations are
% omitted)
p.shuffleAnalysisList(1) = 1;
% Spatial Coherence unsmoothed (Very little time saving)
p.shuffleAnalysisList(2) = 1;
% Stability. Both Spatial and Angular. (Large time saving)
p.shuffleAnalysisList(3) = 1;
% Mean Vector Length for head direction mapo. The p.doHeadDirectionAnalysis 
% must also be set to 1 for this one to be calculated. (Small time saving)
p.shuffleAnalysisList(4) = 1;
% Normal gridness score.  (small time saving, if the peak based gridness
% score is calculated. Huge time saving if both gridness calculations are
% omitted)
p.shuffleAnalysisList(5) = 1;
% Mean vector length for movement direction. The p.doMovementDirectionAnalysis
% parameter must also be set to one for this one to be calculated (small
% time saving)
p.shuffleAnalysisList(6) = 1;

% Number of iterations to do in the shuffling analysis. The shuffling is
% done to calculate expected gridness score, expected spatial information
% and expected head direction score.
p.numShuffleIterations = 12;

% Scramble mode. Set the way the spikes are scrambled when calculating the
% expected values.
% Mode = 0: Spikes are shifted randomly around on the path for each
%           iteration. 
% Mode = 1: All the spikes are shifted by a random time t for each
%           iteration. The inter spike time intervals are kept as in the 
%           original spike times. Spike positions are calculated based on the
%           shifted spike time stamps. The minimum allowed time shift is
%           set in the parameter p.minTimeShift. This is to avoid zero
%           shift.
p.scrambleMode = 1;

% Set if the head direction analysis will be done. For this your position
% data must have been recorded in 2-spot mode. If you don't have this or
% don't need the head direction information set this parameter to 0.
% 1 = Do the head direction analysis
% 0 = Omit the head direction analysis
p.doHeadDirectionAnalysis = 1;

% Set if the movement direction analysis will be done. If set the
% directional rate map based on movement direction (not head direction)
% will be calculated. The Rayleigh mean vector length for the directional
% rate map will be calculated.
% 1 = Do the movement direction analysis
% 0 = Omit the movement direction analysis
p.doMovementDirectionAnalysis = 1;

% Percentile value for the arc percentile calculation. Value in percentage.
p.percentile = 50; % [%]


% Minimum allowed timeshift when scramble mode 1 is used.
p.minTimeShift = 20; % [sec]

% Sets the smoothing type for the spatial firing map.
% Mode = 0: Gaussian boxcar smoothing with 5 x 5 bin boxcar template
% Mode = 1: Gaussian boxcar smoothing with 3 x 3 bin boxcar template
p.smoothingMode = 0;

% Alpha value for the adaptive smoothing rate map calculation. In use for
% the spatial information calculation
p.alphaValue = 10000;

% Same as p.alphaValue, but for the head direction map
p.hdAlphaValue = 10000;

% Head direction firing map smoothing mode
% Mode = 0: Boxcar smoothing of length 5
% Mode = 1: Flat smoothing window. The size of the filter is set in the
%           parameter p.hdSmoothingWindowSize.
p.hdSmoothingMode = 1;

% Size of the smoothing window when using flat smoothing window for the
% head direction map. The size is the total span of the filter. Please make
% the size an odd integer multippel of the head direction bin width
% (p.hdBinWidth). If this is not the case the program will round the number
% of to make it a odd multippel of the head direction bin width,
p.hdSmoothingWindowSize = 14.5; % [degrees]

% Name for the folder where the images will be stored. In addition the name
% of the input file will be used in the folder name. Example: in121314.txt
% will give a folder name gridnessImages_in121314
p.imageFolder = 'gridnessImages';

% Set the minimum allowed coverage. If the animal have covered less than
% this amount of the arena the cells from the session are not included in
% the shuffling analysis. Value as percentage between 0 and 100.
p.minCoverage = 80; % [%]

% Minimum allowed number of spikes for a cell for it to be included in the
% shuffling analysis. It is the number of spikes left after speed filtering
% that must be over the minimum number of spikes value.
p.minNumSpikes = 100;

% Bin width for the shuffled data. If you need to bin with different
% binning you can enter more than one value in square brackets.
% (p.binWidthShuffleData = [0.05, 0.10, 0.20];) It will be created one file
% with binned values for each binning value in the array.
p.binWidthShuffleData = 0.01;


% Minimum number of bins in a placefield. Fields with fewer bins than this
% treshold will not be considered as a placefield. Remember to adjust this
% value when you change the bin width
p.minNumBins = 5;

% Bins with rate at p.fieldTreshold * peak rate and higher will be considered as part
% of a place field
p.fieldTreshold = 0.2;

% Lowest field rate in Hz. Peak of field.
p.lowestFieldRate = 1; % [Hz]

% Threshold used when finding peaks in the auto-correlogram in the grid
% orientation calculation
% you may need to tweak this threshold value to find correct fields when 
% grid is messy
p.gridOrientationThreshold = 0.5;

% It is possible to only analyse part of the recording by setting these
% values. If both are set to zero the whole recording will be used. When
% one or both are set to non-zero values only data within the interval is
% used for analysing.
p.startTime = 0; % [second]
p.stopTime = 0; % [second]

% Set if we include the time the rat spend in each directional bin in the 
% output file
% 0 = no
% 1 = yes
p.includeDirectionalBins = 0;

% Minimum time bins in the rate map must have been visited by the rat. Bins
% with less time will be set to NaN, and plotted as white pixels. This
% apply only to the normal rate maps and not the adaptive smoothed rate
% maps. Time in seconds.
p.minBinTime = 0.020; % [sec]

% Size of the dots that mark the spikes in the path plot. The size is set
% in dots (1 dot = 1/72 inch). Note that Matlab draws the point marker at
% one third the specified size. Default values is 6 points.
p.spikeDotSize = 14;

% Width of the line that marks the path. Default value is 0.5
p.pathLineWidth = 0.2;

% Width of the line that marks the outline of the head direction rate map
% (polar plot). Value is set in points. (1 point = 1/72 inch) 
% Default width is 0.5 points.
p.hdMapLineWidth = 1;

% Value that specify what rate the red colour in the rate maps will
% correspond to. If the value is set to zero the red colour will correspond
% to the peak rate of the map. If a map have bins with higher rate than the
% maximum set in this parameter the bins will be plotted as red. Set the
% value to zero or a positive integer or floating point number.
p.maxPlotRate = 0; 

% Set how much of the correlogram is used when finding the orientation line
% that gives the highest mean correlation in the correlogram. (Requested
% from Jonathan Whitlock). Value is set in percentage of the maximum side
% length and defines the radius of a circle with centre in the centre of
% the correlogram. Note that even on 100 percent the corners of the
% correlgoram will be cut out.
p.gridOrientationLineMaximumSize = 100;

%__________________________________________________________________________

% Convert to single precision
p.binWidth = single(p.binWidth);
p.hdBinWidth = single(p.hdBinWidth);
p.minBinTime = single(p.minBinTime);
p.hdTimeBinWidth = single(p.hdTimeBinWidth);
p.lowSpeedThreshold = single(p.lowSpeedThreshold);
p.highSpeedThreshold = single(p.highSpeedThreshold);
p.minRadius  = single(p.minRadius );
p.correlationThresholdForCentreField = single(p.correlationThresholdForCentreField);
p.minDiskWidth = single(p.minDiskWidth);
p.alphaValue = single(p.alphaValue);
p.hdAlphaValue = single(p.hdAlphaValue);
p.minCoverage = single(p.minCoverage);
p.minNumSpikes = single(p.minNumSpikes);
p.binWidthShuffleData = single(p.binWidthShuffleData);
p.minNumBins = single(p.minNumBins);
p.fieldTreshold = single(p.fieldTreshold);
p.lowestFieldRate = single(p.lowestFieldRate);
p.gridOrientationThreshold = single(p.gridOrientationThreshold);
p.maxPlotRate = single(p.maxPlotRate);

if ~isempty(varargin)
    p.targetRate = varargin{1};
else
    p.targetRate = 0;
end

% check that the number of gridness radii is an odd number
if mod(p.numGridnessRadii,2) == 0
    disp('Error: The paramter p.numGridnessRadii must be an odd number. Please set a new value')
    return
end

disp(' ')
fprintf('%s%s\n','Start analysing at ', datestr(now));


% Set the operation system
if ispc
    % Windows
    p.computer = 0;
    % Directory delimiter
    p.delim = '\';
    % Set the maximum number of cores possible with the parallel computing
    % toolbox
    p.numPossibleCpuCores = 12;
    
    if p.doShufflingAnalysis == 1
        % Create a scheduler object with information about the local resources
        sched = findResource('scheduler', 'type', 'local');

        % Maximum number of workers possible, Matlab limits it to 8 for now
        % with the parallel computing toolbox
        numCPUs = min([sched.ClusterSize, p.numPossibleCpuCores]);
        % Set the number of workers according to what the user has chosen
        if ischar(p.numCpuCores)
            if strcmpi(p.numCpuCores,'max')
                % The user wants the maximum number of workers possible, 
                if matlabpool('size') < numCPUs
                    if matlabpool('size') == 0
                        % Open the matlabpool with maximum number of workers
                        matlabpool('open', numCPUs);
                    else
                        % Close the active matlabpool first
                        matlabpool('close');
                        % Open the matlabpool with maximum number of workers
                        matlabpool('open', numCPUs);
                    end
                end
            else
                disp('Error: The numCpuCores string is not recognized. In must either be ''max'' or an integer number. In the case of a number write it without the quotes')
                return
            end
        else
            if matlabpool('size') == 0
                if p.numCpuCores > 1
                    if p.numCpuCores <= numCPUs
                        matlabpool('open', p.numCpuCores);
                    else
                        fprintf('%s%u%s%u%s\n','Warning: The number you have set for the p.numCpuCores (',p.numCpuCores,') is higher than the number of cpu cores available (',numCPUs,')')
                        disp('The program will run with the maximum possible')
                        matlabpool('open', numCPUs);
                        p.numCpuCores = numCPUs;
                    end
                end
            else
                if p.numCpuCores == 0
                    matlabpool('close');
                else
                    if matlabpool('size') ~= p.numCpuCores
                        matlabpool('close');
                        if p.numCpuCores <= numCPUs
                            matlabpool('open', p.numCpuCores);
                        else
                            fprintf('%s%u%s%u%s\n','Warning: The number you have set for the p.numCpuCores (',p.numCpuCores,') is higher than the number of cpu cores available (',numCPUs,')')
                            disp('The program will run with the maximum possible')
                            matlabpool('open', numCPUs);
                        end
                    end
                end
            end
        end
        if matlabpool('size') ~= p.numCpuCores
            if matlabpool('size') > 1
                matlabpool close;
            end
            if matlabpool('size') > 1
                matlabpool('open', p.numCpuCores)
            end
        end
    end
    % Set the position vector for the figures
    screenSize = get(0,'screenSize');
    positionVector = [20,80,screenSize(3)-40,screenSize(4)-170];
elseif isunix
    % Unix
    p.computer = 1;
    p.delim = '/';
    positionVector = [1, 1, 1200, 1200];
else
    disp('ERROR: Sorry, this program can only be run on windows or Unix')
    return
end



% Read all the information from the input file
disp('Reading and checking input file')
[status, sessionArray, unitArray, ~, shapeArray] = inputFileReader(inputFile, p.inputFileRoomInfo, 1,p);

if status == 0
    return
end

% Check that the data listed exist
status = inputDataChecker(sessionArray, unitArray);
if status == 0
    return
end


% Set the color map for the images
cmap = getCmap();

% Number of sessions listed in the input file
numSessions = int16(size(sessionArray,1));

% Total number of cells in the input file
numCells = int16(size(unitArray,1));


% Counter that keep track on how many cell we have added to the arrays
cellCounter = int16(0);
shuffleCellCounter = int16(0);
realValues = NaN(numCells, 12,'single');

if p.doShufflingAnalysis
    
    % Set the max possible number of elements in the arrays
    numElements = int16(p.numShuffleIterations) * numCells;
    
    % Will contain session, tetrode and cell number for each sample
    dataId = cell(numElements,3);
    % 1 Gridness Centre Removed 
    % 2 Gridness Peak Based Radius Centre Removed
    % 3 Spatial Coherence Unsmooth
    % 4 Spatial Stability (Half and half)
    % 5 Angular Stability (Half and half)
    % 6 Spatial Stability (Binned)
    % 7 Angular Stability (Binned)
    % 8 Head Direction Mean Vector Length
    % 9 Movement Direction Mean Vector Length
    shuffleValues = zeros(numElements, 9,'single');
end


% Open the output file
fid2 = fopen(outputFile,'w');
fprintf(fid2,'%s\t','Session(s)');
fprintf(fid2,'%s\t','Tetrode');
fprintf(fid2,'%s\t','Unit');
fprintf(fid2,'%s\t','Avg. Rate Whole Session');
fprintf(fid2,'%s\t','Avg. Rate Speed Filtered');
fprintf(fid2,'%s\t','Peak Rate (Adaptive smoothing)');
fprintf(fid2,'%s\t','Number of Fields');
fprintf(fid2,'%s\t','Field Properties');
fprintf(fid2,'%s\t','Number of spikes (After Speed Filter)');
fprintf(fid2,'%s\t','Duration (After Speed Filter)');


fprintf(fid2,'%s\t','Gridness Centre Removed');
fprintf(fid2,'%s\t','Radius');
fprintf(fid2,'%s\t','Radius Centre Field');

if p.targetRate > 0
    fprintf(fid2,'%s\t','Downsampled Gridness Centre Removed');
end

fprintf(fid2,'%s\t','Gridness Peak Based Radius Centre Removed');
if p.targetRate > 0
    
    fprintf(fid2,'%s\t','Downsampled Gridness Peak Based Radius Centre Removed');
end

fprintf(fid2,'%s\t','Number of fields detected in correlogram');
fprintf(fid2,'%s\t','Grid orientation');
fprintf(fid2,'%s\t','Spatial Information content [bits/spike]');
fprintf(fid2,'%s\t','Spatial Information rate [bits/sec]');
fprintf(fid2,'%s\t','Spatial Coherence Unsmooth');


fprintf(fid2,'%s\t','Spatial Stability (Half and half)');
if p.targetRate > 0
    fprintf(fid2,'%s\t','Downsampled Spatial Stability (Half and half)');
end

fprintf(fid2,'%s\t','Angular Stability (Half and half)');
if p.targetRate > 0
    fprintf(fid2,'%s\t','Downsampled Angular Stability (Half and half)');
end

fprintf(fid2,'%s\t','Spatial Stability (Binned)');
if p.targetRate > 0
    fprintf(fid2,'%s\t','Downsampled Spatial Stability (Binned)');
end

fprintf(fid2,'%s\t','Angular Stability (Binned)');
if p.targetRate > 0
    fprintf(fid2,'%s\t','Downsampled Angular Stability (Binned)');
end


if p.doHeadDirectionAnalysis
    fprintf(fid2,'%s\t','Peak Angular Rate');
    fprintf(fid2,'%s\t','Peak Direction');
    fprintf(fid2,'%s\t','HalfWidth');
    if p.targetRate > 0
        fprintf(fid2,'%s\t','Downsampled HalfWidth');
    end
    
    fprintf(fid2,'%s\t','HdScore');
    if p.targetRate > 0
        fprintf(fid2,'%s\t','Downsampled HdScore');
    end

    fprintf(fid2,'%s\t','Dir Information');

    fprintf(fid2,'%s\t','Mean Vector Length for Head Direction');
    
    if p.targetRate > 0
        fprintf(fid2,'%s\t','Downsampled Mean Vector Length for Head Direction');
    end
end

if p.doMovementDirectionAnalysis
    fprintf(fid2,'%s\t','Mean Vector Length for Movement Direction');
end

fprintf(fid2,'%s\t','Coverage [%]');
fprintf(fid2,'%s\t','Border Score');

for ii = 1:6
    fprintf(fid2,'%s%u\t','Grid peak distance ',ii);
end

if p.includeDirectionalBins == 1
    if p.doHeadDirectionAnalysis
        % Number of head direction bins
        numBins = round(360 / p.hdTimeBinWidth);
        start = 0;
        stop = p.hdTimeBinWidth;
        for ii = 1:numBins
            fprintf(fid2,'%s%3.1f%s%3.1f\t','Hd Time ',start,' _ ', stop);
            start = start + p.hdTimeBinWidth;
            stop = stop + p.hdTimeBinWidth;
        end
    end
end
fprintf(fid2,'\n');


sInd = strfind(inputFile,'.');
p.imageFolder = sprintf('%s%s%s',p.imageFolder,'_',inputFile(1:sInd(end)-1));





% Check if the output directory for the images is present, if not make it.
dirInfo = dir(p.imageFolder);
if size(dirInfo,1) == 0
    mkdir(p.imageFolder);
end



for s = 1:numSessions
    fprintf('%s%s\n','Loading data for session ',sessionArray{s});
    
    sInd = strfind(sessionArray{s},p.delim);
    if ~isempty(sInd)
        dirPath = sessionArray{s}(1:sInd(end));
    else
        dirPath = cd;
        if ~strcmp(dirPath(end),p.delim)
            dirPath = strcat(dirPath,p.delim);
        end
    end
    
    dirPath = strcat(dirPath, p.imageFolder);
    
    % Check if the output directory for the images is present, if not make it.
    dirInfo = dir(dirPath);
    if size(dirInfo,1) == 0
        mkdir(dirPath);
    end
    
    % Load the position data
    posFile = strcat(sessionArray{s},'_pos.mat');
    load(posFile)
    % Make sure the correct variables were loaded from the file
    if ~exist('posx','var')
        disp('Error: The position file is missing the posx variable')
        return
    end
    if ~exist('posy','var')
        disp('Error: The position file is missing the posy variable')
        return
    end
    if ~exist('post','var')
        disp('Error: The position file is missing the post variable')
        return
    end
    if ~exist('posx2','var')
        disp('Error: The position file is missing the posx2 variable')
        return
    end
    if ~exist('posy2','var')
        disp('Error: The position file is missing the posy2 variable')
        return
    end
    if ~exist('recSystem','var')
        disp('Error: The position file is missing the recSystem variable')
        return
    end
    
    if strcmpi(recSystem,'Axona')
        p.sampleTime = 0.02;
        p.videoSamplingRate = 50;
    else
        p.sampleTime = 0.04;
        p.videoSamplingRate = 25;
    end
    
    % Convert the positions arrays to single precision
    posx = single(posx);
    posy = single(posy);
    post = single(post);
    posx2 = single(posx2);
    posy2 = single(posy2);
    
    % Scale the coordinates using the shape information
    minX = nanmin(posx);
    maxX = nanmax(posx);
    minY = nanmin(posy);
    maxY = nanmax(posy);
    xLength = maxX - minX;
    yLength = maxY - minY;
    sLength = max([xLength, yLength]);
    scale = shapeArray{s}(2) / sLength;
    posx = posx * scale;
    posy = posy * scale;
    posx2 = posx2 * scale;
    posy2 = posy2 * scale;
    
    p.maxRadius = shapeArray{s}(2) - 10;
    
    if p.lowSpeedThreshold > 0 || p.highSpeedThreshold > 0
        disp('Applying speed threshold');
        % Calculate the speed of the rat, sample by sample
        speed = speed2D(posx,posy,post);
        
        if p.lowSpeedThreshold > 0 && p.highSpeedThreshold > 0
            ind = find(speed < p.lowSpeedThreshold | speed > p.highSpeedThreshold);
        elseif p.lowSpeedThreshold > 0 && p.highSpeedThreshold == 0
            ind = find(speed < p.lowSpeedThreshold );
        else
            ind = find(speed > p.highSpeedThreshold );
        end

        % Remove the segments that have to high or to low speed
        posx(ind) = NaN;
        posy(ind) = NaN;
        if p.doHeadDirectionAnalysis
            posx2(ind) = NaN;
            posy2(ind) = NaN;
        end
    end
    
    % Take out only part of the position samples if the parameters for 
    % that is set
    if p.stopTime > 0
        disp('Shortening the recording data to the set interval')
        % Find position samples in the time interval
        pInd = find(post >= p.startTime & post <= p.stopTime);
        
        if isempty(pInd)
            disp('ERROR: The interval you have set contains no position data. Check your interval setting')
            return
        end
        
        posx = posx(pInd);
        posy = posy(pInd);
        post = post(pInd);
        
        if p.doHeadDirectionAnalysis
            posx2 = posx2(pInd);
            posy2 = posy2(pInd);
        end
        
    end
    
    if p.doMovementDirectionAnalysis == 1
        % Calculate movment direction
        direction = calcRunningDirection(posx, posy);
    else
        direction = [];
    end
    
    if p.doHeadDirectionAnalysis
        % Calculate the head direction
        hdDir = calcHeadDirection(posx,posy,posx2,posy2);
    else
        hdDir = [];
    end
    splitDataArray = dataSplit(posx, posy, post, hdDir);
    
    % Calculate the box coverage
    coverage = boxCoverage(posx, posy, p.binWidth, shapeArray{s}(1), shapeArray{s}(2) / 2);
    
    % Find cells that belongs to this session
    ind = find(unitArray(:,3) == s);
    for c = 1:length(ind)
        cellFileName = sprintf('%s%s%u%s%u%s',sessionArray{s},'_T',unitArray(ind(c),1),'C',unitArray(ind(c),2),'.mat');
        
        % Load the cell data
        load(cellFileName)
        
        % Make sure the correct variables were loaded from the file
        if ~exist('cellTS','var')
            disp('The cell file is missing the ts variable')
            return
        end
        
        % Convert spike ts to single precision
        cellTS = single(cellTS);
        
        % If the time interval parameters are set, keep only the
        % spikes in the interval
        if p.stopTime > 0
            ts = ts(ts >= p.startTime & ts <= p.stopTime);
        end
        

         [numSpikesSpeedFiltered, realValuesT, shuffleValuesT] = ...
             mainFunc(posx,posy,post,hdDir,cellTS,sessionArray{s},unitArray(ind(c),1),unitArray(ind(c),2),fid2,p, splitDataArray, coverage, shapeArray{s},positionVector,cmap,direction);

        
        % Increment the cell counter
        cellCounter = cellCounter + 1;
        % Add values to the over all arrays
        realValues(cellCounter,:) = realValuesT;
        
        if p.doShufflingAnalysis
            if coverage >= p.minCoverage && numSpikesSpeedFiltered >= p.minNumSpikes
                shuffleCellCounter = shuffleCellCounter + 1;
                shuffleValues((shuffleCellCounter-1)*p.numShuffleIterations+1:shuffleCellCounter*p.numShuffleIterations,:) = shuffleValuesT;
                for ii = 1:p.numShuffleIterations
                    dataId{(shuffleCellCounter-1)*p.numShuffleIterations+ii,1} = sessionArray{s};
                    dataId{(shuffleCellCounter-1)*p.numShuffleIterations+ii,2} = unitArray(ind(c),1);
                    dataId{(shuffleCellCounter-1)*p.numShuffleIterations+ii,3} = unitArray(ind(c),2);
                end
            end
        end
    end % for cells
end % For session




if cellCounter > 0
    realValues = realValues(1:cellCounter,:);
end

if p.doShufflingAnalysis
    % Shorten the over all arrays
    if shuffleCellCounter > 0
        
        shuffleValues = shuffleValues(1:shuffleCellCounter*p.numShuffleIterations,:);
     
        % Open the output file for all the shuffle data
        sInd = strfind(outputFile,'.');
        
        outputFile3 = strcat(outputFile(1:sInd-1),'-ShuffleDataAll.xls');
        fid4 = fopen(outputFile3,'w');
        
        fprintf(fid4,'%s\t','Gridness Centre Removed');
        fprintf(fid4,'%s\t','Gridness Peak Based Radius Centre Removed');
        fprintf(fid4,'%s\t','Spatial Coherence Unsmooth');
        fprintf(fid4,'%s\t','Spatial Stability (Half and half)');
        fprintf(fid4,'%s\t','Angular Stability (Half and half)');
        fprintf(fid4,'%s\t','Spatial Stability (Binned)');
        fprintf(fid4,'%s\t','Angular Stability (Binned)');
        fprintf(fid4,'%s\t','Head Direction Mean Vector Length');
        fprintf(fid4,'%s\t','Movement Direction Mean Vector Length');
        fprintf(fid4,'%s\t','Session');
        fprintf(fid4,'%s\t','Tetrode');
        fprintf(fid4,'%s\t','Unit');
        fprintf(fid4,'\n');
        
        for ii = 1:shuffleCellCounter*p.numShuffleIterations
            
            for jj = 1:9
                fprintf(fid4,'%4.5f\t', shuffleValues(ii,jj));
            end
            fprintf(fid4,'%s\t',dataId{ii,1});
            fprintf(fid4,'%u\t',dataId{ii,2});
            fprintf(fid4,'%u\t',dataId{ii,3});
            fprintf(fid4,'\n');
        end
    end
end

% Calculate minimum and maximum values for the real data
maxValue = nanmax(nanmax(realValues));
minValue = nanmin(nanmin(realValues));

% Bin the real values
for jj = 1:length(p.binWidthShuffleData) 
    startValue = floor(minValue / p.binWidthShuffleData(jj)) * p.binWidthShuffleData(jj);
    stopValue = ceil(maxValue / p.binWidthShuffleData(jj)) * p.binWidthShuffleData(jj);

    % Number of bins for the shuffled data
    numBins = round((stopValue - startValue) / p.binWidthShuffleData(jj));

    % Allocate memory for the arrays
    binsRealValues = zeros(numBins, 12);
    
    start = startValue;
    stop = startValue + p.binWidthShuffleData(jj);
    
    for ii = 1:numBins
        for b = 1:12
            binsRealValues(ii,b) = length(find(realValues(:,b) >= start & realValues(:,b) < stop));
        end
        start = start + p.binWidthShuffleData(jj);
        stop = stop + p.binWidthShuffleData(jj);
    end
    
    % Write the results to the output file
    % Open the output file for the binned shuffle data
    sInd = strfind(outputFile,'.');
    outputFile6 = sprintf('%s%s%3.2f%s',outputFile(1:sInd-1),'-RealDataBin_',p.binWidthShuffleData(jj),'.xls');
    fid3 = fopen(outputFile6,'w');
    
    % Write header to the output file
    fprintf(fid3,'%s\t','Bin');

    fprintf(fid3,'%s\t','Gridness Centre Removed');
    fprintf(fid3,'%s\t','Gridness Peak Based Radius Centre Removed');
    fprintf(fid3,'%s\t','Spatial Information');
    fprintf(fid3,'%s\t','Spatial Coherence Unsmooth');
    fprintf(fid3,'%s\t','Spatial Stability (Half and half)');
    fprintf(fid3,'%s\t','Angular Stability (Half and half)');
    fprintf(fid3,'%s\t','Spatial Stability (Binned)');
    fprintf(fid3,'%s\t','Angular Stability (Binned)');
    fprintf(fid3,'%s\t','Head Direction Score');
    fprintf(fid3,'%s\t','Head Direction Mean Vector Length');
    fprintf(fid3,'%s\t','Border Score');
    fprintf(fid3,'%s\t','Movement Direction Mean Vector Length');
    fprintf(fid3,'\n');
    
    start = startValue;
    stop = start + p.binWidthShuffleData(jj);
    for ii = 1:numBins
        fprintf(fid3,'%3.2f%s%3.2f\t',start,'_',stop);
        for b = 1:12
            fprintf(fid3,'%u\t',binsRealValues(ii,b));
        end
        fprintf(fid3,'\n');
        start = stop;
        stop = stop + p.binWidthShuffleData(jj);
    end
    
    fclose(fid3);
end

if ispc && matlabpool('size') > 0
    matlabpool('close')
end
fclose('all');
close all
fprintf('%s%s\n','Finished: ', datestr(now));
disp('====================================================================');




%__________________________________________________________________________
%
%                           Main Function
%__________________________________________________________________________



function [numSpikesSpeedFiltered, realValues, shuffleValues] = ...
    mainFunc(x, y, t, hdDir, ts, session, tetrode, unit, fid2, p, splitDataArray, coverage, shape, positionVector,cmap,direction)

% Make sure the return variables exist
numSpikesSpeedFiltered = 0;

% 1 Gridness Centre Removed 
% 2 Gridness Peak Based Radius Centre Removed
% 3 Spatial Information
% 4 Spatial Coherence Unsmooth
% 5 Spatial Stability (Half and half)
% 6 Angular Stability (Half and half)
% 7 Spatial Stability (Binned)
% 8 Angular Stability (Binned)
% 9 Hd Score
% 10 HD Mean Vector Length
% 11 Border Score
% 12 Movement mean vector length
realValues = NaN(12,1,'single');

% 1 Gridness Centre Removed 
% 2 Gridness Peak Based Radius Centre Removed
% 4 Spatial Coherence Unsmooth
% 5 Spatial Stability (Half and half)
% 6 Angular Stability (Half and half)
% 7 Spatial Stability (Binned)
% 8 HD Mean Vector Length
% 9 Movement direction Mean Vector Length
shuffleValues = NaN(p.numShuffleIterations, 9,'single');


fprintf('%s%u%s%u\n','Calculating gridness for cell ',unit,' on tetrode ',tetrode)

averageRateSession = length(ts) / (length(t) * p.sampleTime);

if isempty(ts)
    % No spikes for this cell
    disp('No spikes for this cell');
    return
end

if p.computer == 0
    % Windows system
    ind = strfind(session,'\');
    ind2 = strfind(session,'/');
    if isempty(ind) && isempty(ind2)
        saveName = sprintf('%s%s%s%s%u%s%u',p.imageFolder,'\',session,'_t',tetrode,'c',unit);
    else
        if ~isempty(ind)
            if length(ind) == 1
                sess = session(ind(end)+1:end);
                ratName = session(1:ind(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'\',ratName,'_',sess,'_t',tetrode,'c',unit);
            else
                sess = session(ind(end)+1:end);
                ratName = session(ind(end-1)+1:ind(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'\',ratName,'_',sess,'_t',tetrode,'c',unit);
            end
        end
        if ~isempty(ind2)
            if length(ind2) == 1
                sess = session(ind2(end)+1:end);
                ratName = session(1:ind2(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'\',ratName,'_',sess,'_t',tetrode,'c',unit);
            else
                sess = session(ind2(end)+1:end);
                ratName = session(ind2(end-1)+1:ind2(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'\',ratName,'_',sess,'_t',tetrode,'c',unit);
            end
        end
    end
else
    % Unix system
    ind = strfind(session,'\');
    ind2 = strfind(session,'/');
    if isempty(ind) && isempty(ind2)
        saveName = sprintf('%s%s%u%s%u',session,'_t',tetrode,'c',unit);
    else
        if ~isempty(ind)
            if length(ind) == 1
                sess = session(ind(end)+1:end);
                ratName = session(1:ind(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'/',ratName,'_',sess,'_t',tetrode,'c',unit);
            else
                sess = session(ind(end)+1:end);
                ratName = session(ind(end-1)+1:ind(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'/',ratName,'_',sess,'_t',tetrode,'c',unit);
            end
        end
        if ~isempty(ind2)
            if length(ind2) == 1
                sess = session(ind2(end)+1:end);
                ratName = session(1:ind2(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'/',ratName,'_',sess,'_t',tetrode,'c',unit);
            else
                sess = session(ind2(end)+1:end);
                ratName = session(ind2(end-1)+1:ind2(end)-1);
                saveName = sprintf('%s%s%s%s%s%s%u%s%u',p.imageFolder,'/',ratName,'_',sess,'_t',tetrode,'c',unit);
            end
        end
    end
end


% Calculate the spike positions
[spkx,spky,spkInd] = spikePos(ts,x,y,t);


% Plot path with spikes
h = figure(1);
set(h,'position',positionVector)
plot(x, y,'k','LineWidth',p.pathLineWidth)
hold on
plot(spkx, spky,'.r','markerSize',p.spikeDotSize)
hold off
axis image
fName = sprintf('%s%s',saveName,'_Path');
imageStore(figure(1),p.imageFormat,fName,300);

% Plot path with spikes, no axis
figure(1)
axis off
fName = sprintf('%s%s',saveName,'_Path_NoAxis');
imageStore(figure(1),p.imageFormat,fName,300);

numGoodSamples = sum(isfinite(x));

avgRate = length(spkx) / (numGoodSamples * p.sampleTime);

numSpikesSpeedFiltered = length(spkx);
timeSpeedFiltered = numGoodSamples * p.sampleTime;



% Calculate the border coordinates
maxX = nanmax(x);
maxY = nanmax(y);
xStart = nanmin(x);
yStart = nanmin(y);
xLength = maxX - xStart + p.binWidth*2;
yLength = maxY - yStart + p.binWidth*2;
start = min([xStart,yStart]);
tLength = max([xLength,yLength]);


% Calculate the rate map
[map, rawMap, xAxis, yAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,start,tLength,start,tLength,p.sampleTime, p);


% Caclulate rate map with adaptive smoothing
[aMap, posPDF, aRowAxis, aColAxis]  = ratemapAdaptiveSmoothing(x, y, spkx, spky, xStart, xLength-10, yStart, yLength-10, p.sampleTime, p, shape);


% Maximum rate in the rate map
peakRate = nanmax(nanmax(aMap));
% Calculate the number of fields in the adaptive smoothed map
[nFieldsA,fieldPropA,fieldBinsA] = placefield(aMap,p.lowestFieldRate,p.fieldTreshold, p.minNumBins, aColAxis, aRowAxis);

% Plot the rate map
figure(1)
if p.maxPlotRate == 0
    maxPlotRate = nanmax(nanmax(map));
else
    maxPlotRate = p.maxPlotRate;
end
drawMap(map, xAxis, yAxis, cmap, maxPlotRate);
axis xy
% Store figure
fName = sprintf('%s%s',saveName,'_rateMap');
title(sprintf('%s%3.2f','Rate Map. Peak = ',nanmax(nanmax(map))))
imageStore(figure(1),p.imageFormat,fName,300);



% Make new figure without the axis
figure(1)
axis off
% Store figure
fName = sprintf('%s%s',saveName,'_rateMap-NoAxis');
imageStore(figure(1),p.imageFormat,fName,300);


% Plot the adaptive smoothed rate map
if p.maxPlotRate == 0
    maxPlotRate = nanmax(nanmax(aMap));
else
    maxPlotRate = p.maxPlotRate;
end
figure(1)
drawMap(aMap,aColAxis,aRowAxis,cmap,maxPlotRate);
axis xy

% Store figure
fName = sprintf('%s%s',saveName,'_rateMapAdaptiveSmoothing');
title('Adaptive smoothed rate map')
axis image
imageStore(figure(1),p.imageFormat,fName,300);

% Make a plot of the placefields
figure(1)
hold on
for ii = 1:nFieldsA
    rowBins = fieldBinsA{ii,1};
    colBins = fieldBinsA{ii,2};
    plot(aColAxis(colBins),aRowAxis(rowBins),'w.')
end
hold off
% Store figure
fName = sprintf('%s%s',saveName,'_rateMapAdaptiveSmoothingMarkedFields');
title('Adaptive smoothed rate map')
axis image
imageStore(figure(1),p.imageFormat,fName,300);



% Calculate information

spatialInformation = mapstat(aMap, posPDF);
informationRate = spatialInformationRate(aMap, posPDF);
realValues(3) = spatialInformation;

% Calculate the spatial coherence
spatialCoherenceRaw = fieldcohere(rawMap);
realValues(4) = spatialCoherenceRaw;

% Calculate the stability
[angularStability, spatialStability] = stability(splitDataArray, x, y, t, ts, p);

realValues(5) = spatialStability(1);
realValues(6) = angularStability(1);
realValues(7) = spatialStability(2);
realValues(8) = angularStability(2);

% tic
% % Calculate the correlograms
% corrMaps = correlationMaps(x, y, spkInd, map, p);
% toc


% Correlograms, alternative method
corrMaps = rotatedCorrelationMaps(map);



% Calculate border score
borderScore = borderScoreCalculation(aMap, p.binWidth);
realValues(11) = borderScore;



% Set the axis for the correlation map
corrAxis = p.binWidth * linspace(-((size(corrMaps{1},1)-1)/2),((size(corrMaps{1},1)-1)/2),size(corrMaps{1},1));

% Draw the figure
figure(1)
drawMap(corrMaps{1}+1,corrAxis,corrAxis,cmap,nanmax(nanmax(corrMaps{1}+1)));
% Store figure
fName = sprintf('%s%s',saveName,'_autoCorr');
title('Autocorrelation')
axis image
imageStore(figure(1),p.imageFormat,fName,300);


% Calculate the radius that gives the best gridness score when removing the
% centre field and the resulting gridness
%[gridnessCentreRemoved, radiusCentreRemoved, centreRadius] = gridnessRadiusCentreRemoved(corrMaps, p, corrAxis);
[gridnessCentreRemoved, radiusCentreRemoved, centreRadius] = gridnessRadiusCentreRemoved(corrMaps, p, corrAxis);
realValues(1) = gridnessCentreRemoved;

figure(1)
hold on
% Plot the inner circle that mark the area of the centre field removed
a = 0:pi/32:2*pi;
b = centreRadius * sin(a);
c = centreRadius * cos(a);
plot(b, c, 'k');
% Plot the outer radius
b = radiusCentreRemoved * sin(a);
c = radiusCentreRemoved * cos(a);
plot(b, c, 'k');

hold off
% Store figure
fName = sprintf('%s%s',saveName,'_autoCorr_Radius_Marked');
title('Autocorrelation')
axis image
imageStore(figure(1),p.imageFormat,fName,300);


% Draw a full range version of the correlogram
figure(1)
RxxFS = corrMaps{1};
RxxFS = RxxFS * 100;
RxxFS = RxxFS - nanmin(nanmin(RxxFS));
drawMap(RxxFS,corrAxis,corrAxis,cmap,nanmax(nanmax(RxxFS)));

% Store figure of fullrange correlogram
fName = sprintf('%s%s',saveName,'_autoCorr_FullRangeColour');
tStr = sprintf('%s%3.2f%s%3.2f', 'Autocorrelation. Peak = ', nanmax(nanmax(corrMaps{1})),' Trough = ', nanmin(nanmin(corrMaps{1})));
title(tStr)
axis image
imageStore(figure(1),p.imageFormat,fName,300);

% Make new figure without the axis
figure(1)
axis image
axis off
% Store figure
fName = sprintf('%s%s',saveName,'_autoCorr_FullRangeColour-NoAxis');
imageStore(figure(1),p.imageFormat,fName,300);


% Calculate gridness where the radius is based on the location of the peaks
% in the correlogram
[gridnessNoCentrePeakBased, radiusPeakBased, centreRadiusPeakBased, cpx, cpy, numCorrelogramFields, corrPeakDist] = gridnessPeakPositionBased(corrAxis,corrMaps, p);

realValues(2) = gridnessNoCentrePeakBased;


figure(1)
drawMap(corrMaps{1}+1,corrAxis,corrAxis,cmap,nanmax(nanmax(corrMaps{1}+1)));
hold on
plot(cpx, cpy,'kx');
a = 0:pi/32:2*pi;
b = centreRadiusPeakBased * sin(a);
c = centreRadiusPeakBased * cos(a);
plot(b, c, 'k');
% Plot the outer radius
b = radiusPeakBased * sin(a);
c = radiusPeakBased * cos(a);
plot(b, c, 'k');
hold off
% Store figure
fName = sprintf('%s%s',saveName,'_autoCorr_PeakBased');
title('Autocorrelation')
axis image
imageStore(figure(1),p.imageFormat,fName,300);

if p.doMovementDirectionAnalysis
    % Find the movement direction for the rat the spike times
    spkDir = direction(spkInd);
    
    spkDir(isnan(spkDir)) = [];
    
    % Do the movement direction analysis
    hd = hdstat(spkDir*2*pi/360,direction*2*pi/360,0.02, p, 1);
    
    % plot head direction map
    l = length(hd.ratemap);
    angles = 0:2*pi/l:2*pi;
    map = hd.ratemap;
    map(end+1) = hd.ratemap(1);
    % X and Y coordinates of the head direction rate map
    plotRX = cos(angles) .* map;
    plotRY = sin(angles) .* map;
    
    
    minX = min(plotRX);
    maxX = max(plotRX);
    
    minY = min(plotRY);
    maxY = max(plotRY);
    
    minValue = min([minX, minY]);
    maxValue = max([maxX, maxY]);
    maxValue = max([abs(minValue), abs(maxValue)]);
    
    % Add the axis
    aLength = 2* maxValue;
    addL = 0.05 * aLength;
    
    
    figure(1)
    cla
    hold off
    line([-maxValue - addL, maxValue + addL], [0,0], 'color', [0.5, 0.5, 0.5])
    line([0,0] ,[-maxValue - addL, maxValue + addL], 'color', [0.5, 0.5, 0.5])
    hold on;

    % Plot the rate map
    plot(plotRX, plotRY, 'k','lineWidth',p.hdMapLineWidth);
    title('')
    hold off
    axis off
    axis image
    
    
    fName = sprintf('%s%s',saveName,'_MovementDirectionMap');
    imageStore(figure(1),p.imageFormat,fName,300);
    
    
    % Calculate the mean vector length
    movementMVL = hdMeanVectorLength(angles(1:end-1), hd.ratemap);
    
    realValues(12) = movementMVL;
end

if p.doHeadDirectionAnalysis

    % Find the head direction of the rat at the spike times
    spkDir = hdDir(spkInd);
    
    spkDir(isnan(spkDir)) = [];
    
    % Do the head direction analysis
    hd = hdstat(spkDir*2*pi/360,hdDir*2*pi/360,0.02, p, 1);
    
    realValues(9) = hd.hd_score;
    
    [hdMapA, dirPDF] = hdMapAdaptiveSmoothing(spkDir, hdDir, 0.02, p);
    
    % plot head direction map
    l = length(hdMapA);
    angles = 0:2*pi/l:2*pi;
    angles = angles';
    map = hdMapA;
    map(end+1) = hdMapA(1);
    % X and Y coordinates of the head direction rate map
    plotRX = cos(angles) .* map;
    plotRY = sin(angles) .* map;
    
    minX = min(plotRX);
    maxX = max(plotRX);
    
    minY = min(plotRY);
    maxY = max(plotRY);
    
    minValue = min([minX, minY]);
    maxValue = max([maxX, maxY]);
    maxValue = max([abs(minValue), abs(maxValue)]);
    
    % Add the axis
    aLength = 2* maxValue;
    addL = 0.05 * aLength;
    
    figure(1)
    cla
    hold off
    line([-maxValue - addL, maxValue + addL], [0,0], 'color', [0.5, 0.5, 0.5]);
    line([0,0] ,[-maxValue - addL, maxValue + addL], 'color', [0.5, 0.5, 0.5]);
    hold on;
    % Plot the rate map
    plot(plotRX, plotRY, 'k','lineWidth',p.hdMapLineWidth);
    title('')
    hold off
    axis off
    axis image
    fName = sprintf('%s%s',saveName,'_HeadDirectionMapAdaptiveSmoothed');
    imageStore(figure(1),p.imageFormat,fName,300);
    
    % plot head direction map
    l = length(hd.ratemap);
    angles = 0:2*pi/l:2*pi;
    map = hd.ratemap;
    map(end+1) = hd.ratemap(1);
    % X and Y coordinates of the head direction rate map
    plotRX = cos(angles) .* map;
    plotRY = sin(angles) .* map;
    
    
    minX = min(plotRX);
    maxX = max(plotRX);
    
    minY = min(plotRY);
    maxY = max(plotRY);
    
    minValue = min([minX, minY]);
    maxValue = max([maxX, maxY]);
    maxValue = max([abs(minValue), abs(maxValue)]);
    
    % Add the axis
    aLength = 2* maxValue;
    addL = 0.05 * aLength;
    
    
    
    figure(1)
    cla
    hold off
    line([-maxValue - addL, maxValue + addL], [0,0], 'color', [0.5, 0.5, 0.5])
    line([0,0] ,[-maxValue - addL, maxValue + addL], 'color', [0.5, 0.5, 0.5])
    hold on;

    % Plot the rate map
    plot(plotRX, plotRY, 'k','lineWidth',p.hdMapLineWidth);
    title('')
    hold off
    axis off
    axis image
    
    
    fName = sprintf('%s%s',saveName,'_HeadDirectionMap');
    imageStore(figure(1),p.imageFormat,fName,300);
    
    dirInformation = directionalInformationRate(hdMapA, dirPDF);
    
    
    % Calculate the mean vector length
    mVectorLength = hdMeanVectorLength(angles(1:end-1), hd.ratemap);
    realValues(10) = mVectorLength;
end



% Draw the figure
Rxx = corrMaps{1};

Rxx = adjustMap(Rxx,radiusCentreRemoved,-1,corrAxis);
figure(1)
drawMap(Rxx+1,corrAxis,corrAxis,cmap,nanmax(nanmax(Rxx+1)));
% Store figure
fName = sprintf('%s%s',saveName,'_autoCorr_bestRadius');
title('Autocorrelation')
imageStore(figure(1),p.imageFormat,fName,300);



[gridAngle, centreX, centreY, fx, fy] = gridOrientation(corrMaps{1}, corrAxis);
if p.doShufflingAnalysis
    if coverage >= p.minCoverage && numSpikesSpeedFiltered >= p.minNumSpikes

        fprintf('%s%u%s\n','Doing shuffling analysis using ',p.numShuffleIterations,' iterations');
        
        if p.shuffleAnalysisList(1) == 1 || p.shuffleAnalysisList(5) == 1 || p.shuffleAnalysisList(2) == 1
            % Calculate shuffeled gridness values
            [spatialCoherenceArrayRaw, gridnessArrayNC, gridnessArrayPeakBasedNC] = shuffleAnalyser(x, y, t, ts, p.numShuffleIterations, tLength, start, radiusCentreRemoved, p, corrAxis, centreRadius, radiusPeakBased);

            if p.shuffleAnalysisList(5) == 1 
                shuffleValues(1:p.numShuffleIterations,1) = gridnessArrayNC;
            end
            if p.shuffleAnalysisList(1) == 1
                shuffleValues(1:p.numShuffleIterations,2) = gridnessArrayPeakBasedNC;
            end
            if p.shuffleAnalysisList(2) == 1
                shuffleValues(1:p.numShuffleIterations,4) = spatialCoherenceArrayRaw;
            end
        end

        
        if (p.doHeadDirectionAnalysis && p.shuffleAnalysisList(4) == 1) || (p.doMovementDirectionAnalysis && p.shuffleAnalysisList(6) == 1)
            % Calculate shuffled mean vector length
            [hdMeanVectorLengthArray, movementDirectionMeanVectorLengthArray] = expectedHeadDirection(p.numShuffleIterations, ts, t, hdDir, direction, p);
            shuffleValues(1:p.numShuffleIterations,8) = hdMeanVectorLengthArray;
            shuffleValues(1:p.numShuffleIterations,9) = movementDirectionMeanVectorLengthArray;
        end
        
        

        if p.shuffleAnalysisList(3) == 1
            % Calculate the shuffled stability values
            [angularStabilityArray, spatialStabilityArray] = expectedStability(p.numShuffleIterations, splitDataArray, x, y, t, p, ts);
            shuffleValues(1:p.numShuffleIterations,4) = spatialStabilityArray(:,1);
            shuffleValues(1:p.numShuffleIterations,5) = angularStabilityArray(:,1);
            shuffleValues(1:p.numShuffleIterations,6) = spatialStabilityArray(:,2);
            shuffleValues(1:p.numShuffleIterations,7) = angularStabilityArray(:,2);
        end
    else
        % Skip the shuffling if the coverage is to low or the avg rate is to
        % low
        if coverage < p.minCoverage
            disp('Skipping shuffling for this cell because the coverage is to low')
        end
        
        if numSpikesSpeedFiltered < p.minNumSpikes
            disp('Skipping shuffling for this cell because of few spikes')
        end
        
    end
end



% Do downsampled analysis if the user chose it
if p.targetRate > 0
    if p.targetRate >= avgRate
        fprintf('%s%3.1f%s\n','Error: Target rate must be lower than the average rate for the session. Average rate = ',avgRate,' Hz')
        disp('Skipping dowsampling for this cell')
        
        % Mark that downsampling is skipped for this cell
        downSkip = 1;
    else
        downSkip = 0;
        disp('Calculating downsampled values')
        % Number of spikes
        numSpikes = length(spkx);
        % Downsample the spikes
        targetSpikes = round(p.targetRate * numGoodSamples * p.sampleTime);
        randomIndex = randperm(numSpikes);
        randomIndex = randomIndex(1:targetSpikes);
        spkx = spkx(randomIndex);
        spky = spky(randomIndex);
        tsD = ts(randomIndex);
        spkInd = spkInd(randomIndex);
        
        % Calculate the rate map
        mapD = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,start,tLength,start,tLength,p.sampleTime,p);
        
        % Calculate the correlograms
        corrMapsD = correlationMaps(x, y, spkInd, mapD, p);
        
        % Set the axis for the correlation map
        corrAxisD = p.binWidth * linspace(-((size(corrMapsD{1},1)-1)/2),((size(corrMapsD{1},1)-1)/2),size(corrMapsD{1},1));
        
        % Draw the figure
        figure(1)
        drawMap(corrMapsD{1}+1,corrAxisD,corrAxisD,cmap,nanmax(nanmax(corrMapsD{1}+1)));
        % Store figure
        fName = sprintf('%s%s%3.1f',saveName,'_autoCorr-Downsampled_',p.targetRate);
        title('Autocorrelation')
        imageStore(figure(1),p.imageFormat,fName,300);

        
        % Calculate the downsampled gridness with the centre field removed
        [gridnessCentreRemovedD, radiusD] = gridnessRadiusCentreRemoved(corrMapsD, p, corrAxisD);
        
        % Calculate the downsamples gridness based on correlation peak
        % positions radius
        gridnessNoCentrePeakBasedD = gridnessPeakPositionBased(corrAxisD,corrMapsD, p);
        
        % Calculate the downsampled stability
        [angularStabilityD, spatialStabilityD] = stability(splitDataArray, x, y, t, tsD, p);

        if p.doHeadDirectionAnalysis
            % Find the direction of the rat at the spike times
            spkDir = hdDir(spkInd);

            spkDir(isnan(spkDir)) = [];

            % Do the head direction analysis
            hdD = hdstat(spkDir*2*pi/360,hdDir*2*pi/360,p.sampleTime,p,0);
            
            % Make plot of the the downsampled head direction
            % plot head direction map
            l = length(hdD.ratemap);
            angles = 0:2*pi/l:2*pi;
            map = hdD.ratemap;
            map(end+1) = hdD.ratemap(1);
            % X and Y coordinates of the head direction rate map
            plotRX = cos(angles) .* map;
            plotRY = sin(angles) .* map;


            figure(1)
            cla
            hold off
            line([-maxValue - addL, maxValue + addL], [0,0], 'color', [0.5, 0.5, 0.5])
            line([0,0] ,[-maxValue - addL, maxValue + addL], 'color', [0.5, 0.5, 0.5])
            hold on;

            % Plot the rate map
            plot(plotRX, plotRY, 'b');
            title('')
            axis off
            axis image

            fName = sprintf('%s%s%3.1f',saveName,'_HeadDirectionMap-Downsampled_',p.targetRate);
            imageStore(figure(1),p.imageFormat,fName,300);
            
            % Calculate the mean vector length
            mVectorLengthD = hdMeanVectorLength(angles(1:end-1), hdD.ratemap);
        end
        
        % Draw the figure
        RxxD = corrMapsD{1};
        RxxD = adjustMap(RxxD,radiusD,-1,corrAxisD);
        figure(1)
        drawMap(RxxD+1,corrAxisD,corrAxisD,cmap,nanmax(nanmax(RxxD+1)));
        % Store figure
        fName = sprintf('%s%s%3.1f',saveName,'_autoCorr_bestRadius-Downsampled_',p.targetRate);
        title('Autocorrelation')
        imageStore(figure(1),p.imageFormat,fName,300);
    end
end


% Draw the grid orientiation onto the autocorrelogram
figure(1)
drawMap(corrMaps{1}+1,corrAxis,corrAxis,cmap,nanmax(nanmax(corrMaps{1}+1)));
hold on
minV = min(corrAxis);
maxV = max(corrAxis);
line([minV, maxV], [centreY, centreY],'color','k')
line([centreX, fx],[centreY, fy],'color','k');
hold off
% Store figure
fName = sprintf('%s%s',saveName,'_gridOrientation(First peak)');
title('Grid orientation')
imageStore(figure(1),p.imageFormat,fName,300);

[bestOrientation, ox, oy] = orientationLine(corrMaps{1}, corrAxis, p);
figure(1)
drawMap(corrMaps{1}+1,corrAxis,corrAxis,cmap,nanmax(nanmax(corrMaps{1}+1)));
hold on

line([ox(1), ox(end)],[oy(1), oy(end)],'color','k');
hold off
% Store figure
fName = sprintf('%s%s',saveName,'_gridOrientation(higest mean correlation)');
title(sprintf('%s%u%s','Grid orientation = ', bestOrientation,' degrees'))
imageStore(figure(1),p.imageFormat,fName,300);



% Write the results to the output file
fprintf(fid2,'%s\t',session);
fprintf(fid2,'%u\t',tetrode);
fprintf(fid2,'%u\t',unit);
fprintf(fid2,'%3.3f\t', averageRateSession);
fprintf(fid2,'%3.3f\t', avgRate);
fprintf(fid2,'%3.3f\t', peakRate);

% Field properties
fprintf(fid2,'%u\t', nFieldsA);
if nFieldsA == 0
    fprintf(fid2,'%s\t','No fields');
else
    tString = '';
    for ii = 1:nFieldsA
        tString = sprintf('%s%s%u%s%3.1f%s%3.1f%s%3.1f%s%4.1f%s',tString,'Field ',ii,':  X = ',fieldPropA(ii).x,'. Y = ',fieldPropA(ii).y,'.  Peak = ',fieldPropA(ii).peakRate,' Hz.  Size = ', fieldPropA(ii).size, ' cm^2.  ');
    end
    fprintf(fid2,'%s\t',tString);
end

fprintf(fid2,'%u\t', numSpikesSpeedFiltered);
fprintf(fid2,'%4.1f\t', timeSpeedFiltered);



% Gridness no centre
fprintf(fid2,'%1.4f\t', gridnessCentreRemoved);
fprintf(fid2,'%4.3f\t', radiusCentreRemoved);
fprintf(fid2,'%4.3f\t', centreRadius);
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%1.5f\t', gridnessCentreRemovedD);
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end


% Gridness peak based radius, no centre
fprintf(fid2,'%1.5f\t', gridnessNoCentrePeakBased);
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%1.5f\t', gridnessNoCentrePeakBasedD);
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end


% Number of fields found
fprintf(fid2,'%u\t', numCorrelogramFields);
fprintf(fid2,'%3.1f\t', gridAngle);
fprintf(fid2,'%4.3f\t', spatialInformation);
fprintf(fid2,'%4.3f\t', informationRate);
fprintf(fid2,'%4.3f\t', spatialCoherenceRaw);

% Stability
fprintf(fid2,'%4.3f\t', spatialStability(1));
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%4.3f\t', spatialStabilityD(1));
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end

fprintf(fid2,'%4.3f\t', angularStability(1));
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%4.3f\t', angularStabilityD(1));
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end

fprintf(fid2,'%4.3f\t', spatialStability(2));
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%4.3f\t', spatialStabilityD(2));
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end

fprintf(fid2,'%4.3f\t', angularStability(2));
if p.targetRate > 0
    if ~downSkip
        fprintf(fid2,'%4.3f\t', angularStabilityD(2));
    else
        fprintf(fid2,'%s\t', 'NaN');
    end
end



if p.doHeadDirectionAnalysis
    % Calculate the peak rate and peak direction
    [peakRate, peakInd] = max(hd.ratemap);
    peakDirection = 360 / length(hd.ratemap) * peakInd;
    
    fprintf(fid2,'%3.3f\t', peakRate);
    fprintf(fid2,'%3.3f\t', peakDirection);
    fprintf(fid2,'%3.3f\t', hd.arc_central_quartiles * 360/(2*pi));
    if p.targetRate > 0
        if ~downSkip
            fprintf(fid2,'%3.3f\t', hdD.arc_central_quartiles * 360/(2*pi));
        else
            fprintf(fid2,'%s\t', 'NaN');
        end
    end

    fprintf(fid2,'%3.3f\t', hd.hd_score);
    if p.targetRate > 0
        if ~downSkip
            fprintf(fid2,'%3.3f\t', hdD.hd_score);
        else
            fprintf(fid2,'%s\t', 'NaN');
        end
    end

    fprintf(fid2,'%3.3f\t', dirInformation);
    
    % Mean vector length for head direction map
    fprintf(fid2,'%1.3f\t', mVectorLength);
    if p.targetRate > 0
        if ~downSkip
            fprintf(fid2,'%1.3f\t', mVectorLengthD);
        else
            fprintf(fid2,'%s\t', 'NaN');
        end
    end
end

if p.doMovementDirectionAnalysis
    % Mean vector length for movement direction
    fprintf(fid2,'%1.3f\t', movementMVL);
end


% Coverage
fprintf(fid2,'%3.2f\t', coverage);
% Border score
fprintf(fid2,'%1.3f\t', borderScore);

for ii = 1:6
    fprintf(fid2,'%3.2f\t', corrPeakDist(ii));
end

if p.includeDirectionalBins == 1
    if p.doHeadDirectionAnalysis
        % Write time spent in each directional bin
        numBins = round(360 / p.hdTimeBinWidth);
        for ii = 1:numBins
            fprintf(fid2,'%4.2f\t', hd.timeMap(ii));
        end
    end
end
fprintf(fid2,'\n');













% Calculates the movement direction for each position sample. Direction
% is defined as east = 0 degrees, north = 90 degrees, west = 180 degrees,
% south = 270 degrees. Direction is set to NaN for missing samples.
%
% Version 1.0
% 09. Nov. 2010
%
% (c) Raymond Skjerpeng, KI/CBM, NTNU,2010.
function direct = calcRunningDirection(x, y)


% Number of position samples
numSamp = length(x);
direct = nan(numSamp,1);



for ii = 2:numSamp-1
    if x(ii+1) > x(ii-1) && y(ii+1) == y(ii-1)
        % 0 degrees
        direct(ii) = 0;
    elseif x(ii+1) > x(ii-1) && y(ii+1) > y(ii-1)
        % 0 - 90
        direct(ii) = atand(abs(y(ii-1)-y(ii+1)) / abs(x(ii-1)-x(ii+1)));
    elseif x(ii+1) == x(ii-1) && y(ii+1) > y(ii-1)
        % 90 degrees
        direct(ii) = 90;
    elseif x(ii+1) < x(ii-1) && y(ii+1) > y(ii-1)
        % 90 - 180
        direct(ii) = 180 - atand(abs(y(ii-1)-y(ii+1)) / abs(x(ii-1)-x(ii+1)));
    elseif x(ii+1) < x(ii-1) && y(ii+1) == y(ii-1)
        % 180 degrees
        direct(ii) = 180;
    elseif x(ii+1) < x(ii-1) && y(ii+1) < y(ii-1)
        % 180 - 270
        direct(ii) = 180 + atand(abs(y(ii-1)-y(ii+1)) / abs(x(ii-1)-x(ii+1)));
    elseif x(ii+1) == x(ii-1) && y(ii+1) < y(ii-1)
        % 270 degrees
        direct(ii) = 270;
    elseif x(ii+1) > x(ii-1) && y(ii+1) < y(ii-1)
        % 270 - 360
        direct(ii) = 360 - atand(abs(y(ii-1)-y(ii+1)) / abs(x(ii-1)-x(ii+1)));
    else
        % Unable to calculate the angle
        direct(ii) = NaN;
    end
end






% Calculates the auto-correlogram from the rate map and rotated versions of
% the correlogram.
function corrMaps = rotatedCorrelationMaps(map)

Rxx = correlation(map);
N = 6;
corrMaps = cell(N,1);
corrMaps{1} = Rxx;

rotation = 30:30:150;

for ii = 1:N-1
    corrMaps{ii+1} = imrotate(Rxx, rotation(ii), 'bilinear', 'crop');
end



%__________________________________________________________________________
%
%                  Functions for checking the input file
%__________________________________________________________________________



% [status, sessionArray, unitArray, roomArray, shapeArray, cloverArray] =
% inputFileReader(inputFile, roomFlag, shapeFlag, cloverFlag)
%
% The input file reader reads out the information in the input file and
% returns it in arrays.
%
% INPUT ARGUMENTS
%
% inputFile         Text string setting the file name of the input file.
%                   Look below for more information about the structure of
%                   the input file.
%
% roomFlag          Setting if room information should be read out of the
%                   input file. 
%                   0 = No room information in the file.
%                   1 = Room information in the file
%
% shapeFlag         Setting if box shape information should be read out of
%                   the input file. 
%                   0 = No shape information in the file.
%                   1 = Shape information in the file. 
%
%
% cloverFlag        Setting if clover information should be read out of
%                   the input file. 
%                   0 = No clover information in the file.
%                   1 = Clover information in the file.
%
%
function [status, sessionArray, unitArray, roomArray, shapeArray] = inputFileReader(inputFile, roomFlag, shapeFlag,p)

% Status = 0 -> Input file contain errors
% Status = 1 -> Input file is ok
status = 0;

% Number of sessions possible to have listed in the input file
N = 1000;

% Mean number of cell per session
M = 100;

% Session name array
% 1: Session name (whole path)
sessionArray    = cell(N, 1);

% Room number
roomArray       = cell(N, 1);

% Box shape
shapeArray      = cell(N, 1);

% Tetrode and cell number.
% 1: Tetrode.
% 2: Cell number.
% 3: Session number. Tell which session the cell belongs to.
unitArray       = zeros(M*N, 3);

% Open the input file for binary read access
fid = fopen(inputFile,'r');

if fid == -1
    msgbox('Could''n open the input file! Make sure the filname and path are correct.','File read error','error');
    disp('Input file could not be found.')
    disp('Failed')
    return
end

% Counts the number of sessions
sessionCounter = 0;
% Count the number of cells
unitCounter = 0;

% Keep track of the line number the programs reads from in the input file
currentLine = 0;

while ~feof(fid)
    % Read a line from the input file
    str = fgetl(fid);
    currentLine = currentLine + 1;
    
    % Remove space at end of line
    str = stripSpaceAtEndOfString(str);
    
    % Check that line is not empty
    if isempty(str)
        disp('Error: There can''t be any empty lines in the input file');
        fprintf('%s%u\n','Empty line was found in line number ',currentLine);
        return
    end
    
    % Check that the line is the "session" line
    if length(str)<7
        disp('Error: Expected keyword ''Session'' in the input file');
        fprintf('%s%u\n','Error on line ', currentLine);
        return
    end
    if ~strcmpi(str(1:7),'Session')
        disp('Error: Expected keyword ''Session'' in the input file');
        fprintf('%s%u\n','Error on line ', currentLine);
        return
    else
        sessionCounter = sessionCounter + 1;
        sessionArray{sessionCounter,1} = str(9:end);
        


        if strcmpi(p.delim,'/')
            sessionArray{sessionCounter,1} = strrep(sessionArray{sessionCounter,1},'\','/');
        else
            sessionArray{sessionCounter,1} = strrep(sessionArray{sessionCounter,1},'/','\');
        end

        
        % Read next line
        str = fgetl(fid);
        currentLine = currentLine + 1;
        
        % Remove space at end of line
        str = stripSpaceAtEndOfString(str);
        
        % Check that line is not empty
        if isempty(str)
            disp('Error: There can''t be any empty lines in the input file');
            fprintf('%s%u\n','Empty line was found in line number ',currentLine);
            return
        end
    end
    
    if roomFlag
        % Room information should come next
        if length(str)<4 || ~strcmpi(str(1:4),'Room')
            fprintf('%s%u\n','Error: Expected the ''Room'' keyword at line ', currentLine)
            return
        else
            roomArray{sessionCounter} = str(6:end);
            str = fgetl(fid);
            currentLine = currentLine + 1;
            
            % Remove space at end of line
            str = stripSpaceAtEndOfString(str);

            % Check that line is not empty
            if isempty(str)
                disp('Error: There can''t be any empty lines in the input file');
                fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                return
            end
        end
    end
    
    if shapeFlag == 1
        % Shape information should come next
        % 1 dim: shape. 1 = box, 2 = cylinder, 3 = linear track
        % 2 dim: Side length or diameter of the arena.
        shape = zeros(2,1);
        if length(str)<5 || ~strcmpi(str(1:5),'Shape')
            fprintf('%s%u\n','Error: Expected the ''Shape'' keyword at line ', currentLine)
            return
        else
            temp = str(7:end);
            if length(temp)>3 && strcmpi(temp(1:3),'Box')
                shape(1) = 1;
                shape(2) = str2double(temp(5:end));
                
            elseif length(temp)>5 && strcmpi(temp(1:5),'Track')
                shape(1) = 3;
                shape(2) = str2double(temp(7:end));
            elseif length(temp) > 6 && strcmpi(temp(1:6), 'Circle')
                shape(1) = 2;
                shape(2) = str2double(temp(8:end));
            elseif length(temp)>8 && strcmpi(temp(1:8),'Cylinder')
                shape(1) = 2;
                shape(2) = str2double(temp(10:end));
            else
                disp('Error: Missing shape information. Must be box, cylinder or Track');
                fprintf('%s%u\n','Error at line ', currentLine)
                return
            end

            
            % Add the shape information to the shape array
            shapeArray{sessionCounter} = shape;
            
            % Read next line
            str = fgetl(fid);
            currentLine = currentLine + 1;
            
            % Remove space at end of line
            str = stripSpaceAtEndOfString(str);

            % Check that line is not empty
            if isempty(str)
                disp('Error: There can''t be any empty lines in the input file');
                fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                return
            end
        end
    end
    
    while ~feof(fid)
        if strcmp(str,'---') % End of this block of data, start over.
            break
        end
        
        if length(str)>7
            if strcmpi(str(1:7),'Tetrode')
                tetrode = sscanf(str,'%*s %u');
                
                % Read next line
                str = fgetl(fid);
                currentLine = currentLine + 1;
                
                % Remove space at end of line
                str = stripSpaceAtEndOfString(str);

                % Check that line is not empty
                if isempty(str)
                    disp('Error: There can''t be any empty lines in the input file');
                    fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                    return
                end
                
                while length(str) > 4 && strcmpi(str(1:4),'Unit')
                    unit = sscanf(str,'%*s %u');
                    unitCounter = unitCounter + 1;
                    
                    % Add tetrode and cell number to the cell array
                    unitArray(unitCounter,1) = tetrode;
                    unitArray(unitCounter,2) = unit;
                    unitArray(unitCounter,3) = sessionCounter;
                    
                    str = fgetl(fid);
                    currentLine = currentLine + 1;
                    
                    % Remove space at end of line
                    str = stripSpaceAtEndOfString(str);
                    
                    % Check that line is not empty
                    if isempty(str)
                        disp('Error: There can''t be any empty lines in the input file');
                        fprintf('%s%u\n','Empty line was found in line number ',currentLine);
                        return
                    end
                end
            else
                fprintf('%s%u\n','Error: Expected the Tetrode keyword at line ', currentLine);
                return
            end
        else
            fprintf('%s%u\n','Error: Expected the Tetrode keyword at line ', currentLine);
            return
        end
        
    end
    
    
end

% Shorten the arrays
sessionArray = sessionArray(1:sessionCounter,:);
roomArray = roomArray(1:sessionCounter,:);
shapeArray = shapeArray(1:sessionCounter,:);
unitArray = unitArray(1:unitCounter,:);

% Set status to success (1)
status = 1;



% Removes space at the end of the string input
function str = stripSpaceAtEndOfString(str)

if isempty(str)
    return
end

while ~isempty(str)
    if strcmp(str(end),' ')
        str = str(1:end-1);
    else
        break;
    end
end




% Test if the data listed in the input file really exist.
%
%
% INPUT ARGUMENTS
%
% sessionArray      Cell type array with the name for all the sessions in
%                   the input file. 1 row for each session.
%                   1 column: Name of the session
%
%
% unitArray         Array with the tetrode and unit numbers for each cell.
%                   Consist of 1 row and 3 columns for each cell.
%                       1 column: Tetrode number
%                       2 column: Cell number
%                       3 column: Session number for the session the cell
%                                 belongs to.
%                       4 column: Clover number (optional)
% 
%
% OUTPUT VARIABLES
%
% status        Status of the input data. Status = 1 -> All ok.
%               Status = 0 -> Some data could not be found.
%
% Version 1.0
% 06.Jul.2009
%
% Created by Raymond Skjerpeng, KI/CBM, NTNU, 2009.
function status = inputDataChecker(sessionArray, unitArray)

status = 0;

% Number of sessions in the input file
numSessions = size(sessionArray,1);

if numSessions == 0
    disp('Error: No sessions was listed')
    return
end

for ii = 1:numSessions

    videoFile = strcat(sessionArray{ii},'_pos.mat');
    d = dir(videoFile);
    if size(d,1) == 0
        fprintf('%s%s\n','Unable to find the position file: ',videoFile);
        disp('Please check your input file and data.')
        return
    end

    % Find cells listed for this session
    ind = find(unitArray(:,3) == ii);
    for c = 1:length(ind)
        cellFileName = sprintf('%s%s%u%s%u%s',sessionArray{ii},'_T',unitArray(ind(c),1),'C',unitArray(ind(c),2),'.mat');
        d = dir(cellFileName);
        if size(d,1) == 0
            fprintf('%s%s\n','Unable to find the cell file: ',cellFileName);
            disp('Please check your input file and data.')
            return
        end
    end
    
end


% Set status to success
status = 1;











%__________________________________________________________________________
%                           
%                           Border Functions
%__________________________________________________________________________



function score = borderScoreCalculation(ratemap, binSize)

fields = find_fields2(ratemap,binSize);

if fields.number_of_fields > 0
    maxfieldcov = fields.coverage.perimeter.max_one_field;
    fdist = fields.weighted_firing_distance;
    score = (maxfieldcov-2*fdist)/(maxfieldcov+2*fdist);
else
    score = -1.1;
end



function fields = find_fields2(map, binsize)
%map=clean_matrix(map,20);
%map=interpolate_border_nans(map);


bins=100;

% Interpolate map to have bins
[ly,lx] = size(map);
l = min(lx,ly);
[X,Y] = meshgrid(1:lx,1:ly);
[X0,Y0] = meshgrid(1:l/bins:lx,1:l/bins:ly);
Z0 = interp2(X,Y,map,X0,Y0);
% Interpolate values for the NaNs at the border
Z0 = interpolate_border_nans(Z0);

% Max rate
mx = max(map(:));
threshold = 0.3 * mx;
sy = size(Z0,1);
sx = size(Z0,2);


field_num=0;

[max_val_y, max_pos_y_list] = max(Z0);
[~, max_pos_x] = max(max_val_y);
max_pos_y = max_pos_y_list(max_pos_x);

ZAll = Z0;    
ZDeleted = zeros(sy,sx);
    
while(max(Z0(:))>threshold) 
    field_num=field_num+1;

    ZAux = zeros(sy,sx);
    ZAux(isnan(Z0)) = nan;    
    ZAux(max_pos_y, max_pos_x) = Z0(max_pos_y ,max_pos_x);
    mark = 0;
    count = 0;
    above_thresh=Z0>threshold;
    while(mark==0)
        mark=1;
        Zxp=[zeros(sy,1), ZAux(1:end,1:end-1)];
        Zxm=[ZAux(1:end,2:end), zeros(sy,1)];
        Zyp=[zeros(1,sx); ZAux(1:end-1,1:end)];
        Zym=[ZAux(2:end,1:end); zeros(1,sx)];
 
        aux=above_thresh.*(((Zxp>0)+(Zxm>0)+(Zym>0)+(Zyp>0))>0);
        mapold=ZAux;
        ZAux(aux>0)=Z0(aux>0);
        if(nansum(ZAux(:)-mapold(:))>0)
            mark=0;
        end    
        count=count+1;
    end
    
    ZDeleted=ZDeleted+ZAux;
%    Z0=Z0-ZAux;
    Z0=ZAll-ZDeleted;
    
    [max_val_y, max_pos_y_list]=max(Z0);
    [~, max_pos_x]=max(max_val_y);
    max_pos_y=max_pos_y_list(max_pos_x);    
     
    
    if(sum(ZAux(:)>0)<200*lx*ly*binsize^2/(sx*sy))
        field_num=field_num-1;
    else
         maps{field_num}=ZAux;    
    end    

    if(field_num==0)
        mx=max(Z0(:));
        threshold=0.3*mx;

        Z0=Z0+ZAux;        
    end
end



fields.number_of_fields = field_num;

if exist('maps','var')
    fields.coverage = field_coverage2(maps);
    fields.weighted_firing_distance = weighted_firing_distance(maps ,binsize*lx/sx)/(l*binsize);
    fields.maps = maps;    
else
    coverage.perimeter.max_one_field = 0; 
    fields.coverage = coverage;
    fields.weighted_firing_distance = 0;
end    





function M=interpolate_border_nans(M0)
M=M0;
M(1:end,1) = clean_nans(M0(1:end,1));
M(1:end,end) = clean_nans(M0(1:end,end));
M(1,1:end) = clean_nans(M0(1,1:end));
M(end,1:end) = clean_nans(M0(end,1:end));



function Z=clean_nans(Z0)
X=1:length(Z0);
X0=X;
Zcopy=Z0;
aux=isnan(Z0);
X0(aux)=[];
Z0(aux)=[];
if(length(X0)>2)
    Z=interp1(X0,Z0,X,'spline','extrap');
else
    Z=Zcopy;
end


%%%correction for when the map is full of nans
function coverage = field_coverage2(fields)
    coverage.perimeter.W = 0;
    coverage.perimeter.N = 0;
    coverage.perimeter.E = 0;
    coverage.perimeter.S = 0;
    coverage.area.total = 0;
    coverage.area.inside_area = 0;
    coverage.area.W = 0;
    coverage.area.E = 0;
    coverage.area.S = 0;
    coverage.area.N = 0; 
    coverage.weighted_distance = 0;
if ~isempty(fields)
    coverage.perimeter.max_one_field = 0;
    
    for i=1:length(fields)
        
        aux_map = fields{i}(:,1:8);
        [covered,norm] = wall_field(aux_map);
        if(covered/norm>coverage.perimeter.max_one_field) 
            coverage.perimeter.max_one_field = covered/norm;
        end 
            
        aux_map=fields{i}(:,end:-1:end+1-8);       
        [covered,norm]=wall_field(aux_map);
        if(covered/norm>coverage.perimeter.max_one_field) 
            coverage.perimeter.max_one_field=covered/norm; 
        end
        
        aux_map=fields{i}(1:8,:)'; 
        [covered,norm]=wall_field(aux_map);
        if(covered/norm>coverage.perimeter.max_one_field) 
            coverage.perimeter.max_one_field=covered/norm; 
        end         

        aux_map=fields{i}(end:-1:end+1-8,:)'; 
        [covered,norm]=wall_field(aux_map);
        if(covered/norm>coverage.perimeter.max_one_field) 
            coverage.perimeter.max_one_field=covered/norm; 
        end
    end
end


function [covered, norm] = wall_field(map)

ly = size(map,1);
aux = NaN(ly,1);

for j = 1:ly
    a = find(isfinite(map(j,:)),1,'first');
    if ~isempty(a)
        aux(j) = map(j,a);
    end
end

norm = sum(isfinite(aux));
covered = nansum(aux>0);




function wfd = weighted_firing_distance(fields,binsize)
map = fields{1};

for i=2:length(fields)
    map=map+fields{i};
end

map = map/nansum(map(:));

[ly,lx]=size(map);
my = (1:ly)'*ones(1,lx);
mx = ones(ly,1)*(1:lx);
distance_matrix=min(min(my,mx),min(flipud(my),fliplr(mx)))*binsize;
wfd=nansum(nansum(map.*distance_matrix))/nansum(nansum(map.*ones(ly,lx)));


%__________________________________________________________________________
%
%                           Gridness Functions
%__________________________________________________________________________


% Find what line in the correlogram that gives the highest mean correlation
% along the line. The line will always pass trough the centre of the
% correlogram.
function [bestOrientation, orientationColPos, orientationRowPos] = orientationLine(corrMap, corrAxis, p)

% Rotation step in degrees
rotationStep = 1;

N = length(corrAxis);

% Find the maximum position
maxX = max(corrAxis);

% Set the initial orientation line (zero degrees)
radius = p.gridOrientationLineMaximumSize * maxX / 100;
xx = -radius:p.binWidth:radius;
yy = zeros(length(xx),1);
yy = yy';

% Set the row and column axis
colAxis = corrAxis;
rowAxis = zeros(N,1);
for ii = 1:N
    rowAxis(ii) = corrAxis(N-ii+1);
end

distThreshold = p.binWidth / 2;
maxCorrelation = -inf;
bestOrientation = -1;
orientationColPos = [];
orientationRowPos = [];

numRotations = 180 / rotationStep;

for r = 1:numRotations
    % Rotation angle
    alpha = r / 360 * 2 * pi;
    [rColPos, rRowPos] = rotatePath(xx, yy, alpha);
    
    % Distance from line to each bin in the correlogram
    dist = zeros(N);
    
    for rr = 1:N
        for cc = 1:N
            dist(rr,cc) = min(sqrt((rRowPos - rowAxis(rr)).^2 + (rColPos - colAxis(cc)).^2));
        end
    end
    
    % Mean correlation over bins that are within binWidth/2 from the
    % orientation line
    meanCorr = nanmean(nanmean(corrMap(dist <= distThreshold )));
    
    if meanCorr > maxCorrelation
        maxCorrelation = meanCorr;
        bestOrientation = r;
        orientationColPos = rColPos;
        orientationRowPos = rRowPos;
    end
    
    
end




function [gridnessNoCentre, radius, centreRadius, cpx, cpy, numFields, dist2] = gridnessPeakPositionBased(corrAxis, corrMaps, p)


N = 6;

gridnessNoCentre = NaN;
radius = NaN;

corrValuesNC = zeros(N,1);

Rxx = corrMaps{1};

% Calculate the centre field radius
centreRadius = centreFieldRadius(corrAxis, Rxx, p);

numBins = size(Rxx, 1);

if p.correlationPeakDetectionMode == 1
    % Locate the peaks in the correlogram
    peakPoints = findCorrelationPeaks(Rxx);
    
    peakPointsX = peakPoints(:,1);
    peakPointsY = numBins - peakPoints(:,2) + 1;

    peakPointsX = corrAxis(peakPointsX);
    peakPointsY = corrAxis(peakPointsY);
else

    peakPoints = correlationPeakDetection(corrAxis, Rxx, p);
    peakPointsX = peakPoints(:, 1);
    peakPointsY = peakPoints(:, 2);
end

% Number of fields detected including the centre field
numFields = size(peakPoints,1);

if numFields <= 1
    % To few peaks found to do this analysis
    cpx = [];
    cpy = [];
    dist2 = [];
    return
end



% Make a copy of the array
peakPointsXt = peakPointsX;
peakPointsYt = peakPointsY;

% Locate the centre field
dist = sqrt(peakPointsX.^2 + peakPointsY.^2);
[~,ind] = min(dist);
cx = peakPointsX(ind(1));
cy = peakPointsY(ind(1));
peakPointsXt(ind(1)) = inf;
peakPointsYt(ind(1)) = inf;

% Distance from centre field to the rest of the fields
dist = sqrt((peakPointsXt-cx).^2 + (peakPointsYt-cy).^2);
dist2 = dist;

% Locate the 6 fields that are closest to the centre
nPeaks = length(dist) - 1;
if nPeaks < 6
    fieldInd = zeros(nPeaks,1);
    
    for ii = 1:nPeaks
        [~, ind] = min(dist);
        fieldInd(ii) = ind(1);
        dist(ind(1)) = inf;
    end
    
else
    fieldInd = zeros(6,1);
    
    for ii = 1:6
        [~, ind] = min(dist);
        fieldInd(ii) = ind(1);
        dist(ind(1)) = inf;
    end
end

dist2 = dist2(fieldInd);
if nPeaks < 6
    dist3 = zeros(6,1);
    for ii = 1:nPeaks
        dist3(ii) = dist2(ii);
    end
    for ii = nPeaks+1:6
        dist3(ii) = NaN;
    end
    dist2 = dist3;
end


if numFields < 4
    % To few peaks found to do this analysis
    cpx = [];
    cpy = [];
    return
end

% Correlation peaks
cpx = peakPointsX(fieldInd);
cpy = peakPointsY(fieldInd);

% Median distance to the peaks
dist = sqrt((cpx-cx).^2 + (cpy-cy).^2);
medianDist = mean(dist);

radius = 1.25 * medianDist;

% Set the part of the map outside the radius to NaN
Rxx = adjustMap(Rxx,radius,-1,corrAxis);
RxxNC = adjustMap(Rxx,radius,centreRadius,corrAxis);

for jj = 2:N
    RxxR = corrMaps{jj};

    RxxRNC = adjustMap(RxxR,radius,centreRadius,corrAxis);

    corrValuesNC(jj,ii) = pointCorr(RxxNC,RxxRNC,0,0,size(RxxNC,1));
end

% Calculate the degree of "gridness"
if p.gridnessCalculationMode == 0
    
    sTopNC = mean([corrValuesNC(3,ii),corrValuesNC(5,ii)]);
    sTroughNC = mean([corrValuesNC(2,ii), corrValuesNC(4,ii), corrValuesNC(6,ii)]);
else
    
    sTopNC = min([corrValuesNC(3,ii),corrValuesNC(5,ii)]);
    sTroughNC = max([corrValuesNC(2,ii),corrValuesNC(4,ii),corrValuesNC(6,ii)]);
end


gridnessNoCentre = sTopNC - sTroughNC;

% Add the centre field to the peak arrays
cpx = [cpx; cx];
cpy = [cpy; cy];


% Correlogram peak detection
function peakPoints = correlationPeakDetection(corrAxis, Rxx, p)

minBins = round(100 / p.binWidth^2);

peakPoints = zeros(1000, 2);
peakCounter = 0;
[N,M] = size(Rxx);
visited = ones(N, M);

visited(isnan(Rxx)) = 0;

% Remove low correlation
ind = find(Rxx <= 0);
Rxx(ind) = NaN;
visited(ind) = 0;


while sum(sum(visited)) > 0
    % Array that will contain the bin positions to the current placefield
    rowBins = [];
    colBins = [];
    
    % Find the current maximum
    [m, ind] = nanmax(Rxx);
    [~, cols] = nanmax(m);
    rows = ind(cols);
    peakRow = rows;
    peakCol = cols;
    visited(peakRow, peakCol) = 0;
    
    while 1
        rowBins = [rowBins; rows(1)];
        colBins = [colBins; cols(1)];
        
        [rows, cols, visited] = checkNeighbours(Rxx, rows, cols, visited);
        
        
        rows(1) = [];
        cols(1) = [];
        if isempty(rows)
            break;
        end
    end
    
    if length(rowBins) >= minBins
        peakCounter = peakCounter + 1;
        % Calculate the peak position based on centre of mass
        comX = 0;
        comY = 0;
        R = 0;
        for ii = 1:length(rowBins)
            R = R + Rxx(rowBins(ii),colBins(ii));
            comX = comX + Rxx(rowBins(ii), colBins(ii)) * corrAxis(M - colBins(ii) + 1);
            comY = comY + Rxx(rowBins(ii), colBins(ii)) * corrAxis(rowBins(ii));
        end
        peakPoints(peakCounter, 1) = comX/R;
        peakPoints(peakCounter, 2) = comY/R;
    end
    
    Rxx(rowBins, colBins) = NaN;
    visited(rowBins, colBins) = 0;
    
end

peakPoints = peakPoints(1:peakCounter, :);


function [rows, cols, visited] = checkNeighbours(map, rows, cols, visited)


row = rows(1);
col = cols(1);

visited(row, col) = 0;

% Set indexes to the surounding bins
leftRow = row - 1;
rightRow = row + 1;
upRow = row;
downRow = row;

leftCol = col;
rightCol = col;
upCol = col - 1;
downCol = col + 1;


% Check left
if leftRow >= 1 % Inside map
    if visited(leftRow,leftCol) && map(leftRow,leftCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; leftRow;];
        cols = [cols; leftCol];
        visited(leftRow, leftCol) = 0;
    end
end
% Check rigth
if rightRow <= size(map,2) % Inside map
    if visited(rightRow,rightCol) && map(rightRow,rightCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; rightRow];
        cols = [cols; rightCol];
        visited(rightRow, rightCol) = 0;
    end
end
% Check up
if upCol >= 1 % Inside map
    if visited(upRow,upCol) && map(upRow,upCol) <= map(row,col)
        % Add bin as part of the field
        rows = [rows; upRow];
        cols = [cols; upCol];
        visited(upRow, upCol) = 0;
    end
end
% Check down
if downCol <= size(map,1) % Inside map
    if visited(downRow,downCol) && map(downRow,downCol) <= map(row,col)
        % Add bin as part of the field

        rows = [rows; downRow];
        cols = [cols; downCol];
        visited(downRow, downCol) = 0;
    end
end




% Dori's method
function max_points = findCorrelationPeaks(aCorrMap)




diff_x_1 = zeros(size(aCorrMap));
diff_x_2 = zeros(size(aCorrMap));
diff_y_1 = zeros(size(aCorrMap));
diff_y_2 = zeros(size(aCorrMap));

% 1st order diff in the x direction
diff_x = diff(aCorrMap,1,2);
% 1st order diff in the y direction
diff_y = diff(aCorrMap,1,1);

diff_x(diff_x > 0) = 1;
diff_x(diff_x < 0) = -1;
diff_y(diff_y > 0) = 1;
diff_y(diff_y < 0) = -1;

diff_x_1(:,1:end-1) = diff_x;
diff_x_2(:,2:end) = diff_x;
diff_y_1(1:end-1,:) = diff_y;
diff_y_2(2:end,:) = diff_y;

zero_x = abs(diff_x_2 - diff_x_1) == 2;
zero_y = abs(diff_y_2 - diff_y_1) == 2;

local_max = zero_x & zero_y;

% perform the plot 

max_points = [];
cnt = 0;
for x = 2:size(local_max,2)-1
    for y = 2:size(local_max,1)-1
        if local_max(y,x) == 1 && ...
                aCorrMap(y,x) > aCorrMap(y,x-1) && ...
                aCorrMap(y,x) > aCorrMap(y,x+1) && ...
                aCorrMap(y,x) > aCorrMap(y-1,x) && ...
                aCorrMap(y,x) > aCorrMap(y+1,x-1)
            cnt = cnt + 1;
            max_points(cnt,:) = [x y];
        end
    end
end

nmaxpoints = size(max_points,1);



% delete maximum points which are close to each other 
% (defined as follows: a line between the points goes 
%  through points whos value is above 0.2 of the value 
%  of the maximal point)

thresh = 0.2;

good_max = ones(nmaxpoints,1);

for i = 1:nmaxpoints
    for j = i+1:nmaxpoints
        val1 = aCorrMap(max_points(i,2),max_points(i,1));
        x1 = max_points(i,1);
        y1 = max_points(i,2);
        val2 = aCorrMap(max_points(j,2),max_points(j,1));
        x2 = max_points(j,1);
        y2 = max_points(j,2);
        % line([x1 x2],[y1 y2]);
        if abs(x2-x1) >= abs(y2-y1)
            if x2 >= x1
                x_line = x1:x2;
            else 
                x_line = x2:x1;
            end
            y_line = round(interp1([x1 x2],[y1 y2],x_line));
        else
            if y2 >= y1
                y_line = y1:y2;
            else
                y_line = y2:y1;
            end
            x_line = round(interp1([y1 y2],[x1 x2],y_line));
        end
        y_line(y_line < 1) = 1; x_line(x_line < 1) = 1;
        y_line(y_line > size(aCorrMap,1)) = size(aCorrMap,1);
        x_line(x_line > size(aCorrMap,1)) = size(aCorrMap,1);
        
        vals = diag(aCorrMap(y_line,x_line));
        
        if val2 >= val1
            if all(vals/val2 > thresh) % delete  one point
                good_max(i) = 0;
            end
        else
            if all(vals/val1 > thresh)
                good_max(j) = 0;
            end
        end
    end % j-th maxmimum
end % i-th maximum


max_points(~good_max,:) = []; 








% Calculates the radius that gives the best gridness score
function [gridness, radius, centreRadius] = gridnessRadiusCentreRemoved(corrMaps, p, corrAxis)

numRotations = floor(180/30);

% Calculate the centre field radius
centreRadius = centreFieldRadius(corrAxis, corrMaps{1}, p);

if p.maxRadius - centreRadius < p.minDiskWidth
    % Centre field is to large to do the gridness calculation
    disp('The centre field is to large to calculate the gridness score for this cell')
    gridness = NaN;
    radius = NaN;
    return
end

% Set the start radius to test
radius = max([p.minRadius, centreRadius + p.minDiskWidth]);

numRadius = ceil((p.maxRadius-radius)/p.radiusStep);

% Array to hold the gridness scores for the different radii
gridnessArray = zeros(numRadius,2);
corrValues = zeros(numRotations,numRadius);

% Size, in number of bins, of the map
[N,M] = size(corrMaps{1});

% Calculate the distance from origo for each bin in the map
oDist = zeros(N,M,'single');
for ii = 1:N
    for jj = 1:M
        oDist(ii,jj) = sqrt(corrAxis(ii)^2 + corrAxis(jj)^2);
    end
end

for ii = 1:numRadius
    
    
    Rxx = corrMaps{1};
    % Set the part of the map outside the radius to NaN
    Rxx = adjustMap(Rxx,radius,centreRadius,oDist);
    
    for jj = 2:numRotations
        RxxR = corrMaps{jj};
        
        % Set the part of the map outside the radius to NaN
        RxxR = adjustMap(RxxR,radius,centreRadius,oDist);
        
        corrValues(jj,ii) = pointCorr(Rxx,RxxR,0,0,size(Rxx,1));

    end
    
    % Calculate the degree of "gridness"
    if p.gridnessCalculationMode == 0
        sTop = mean([corrValues(3,ii),corrValues(5,ii)]);
        sTrough = mean([corrValues(2,ii),corrValues(4,ii),corrValues(6,ii)]);
    else
        sTop = min([corrValues(3,ii),corrValues(5,ii)]);
        sTrough = max([corrValues(2,ii),corrValues(4,ii),corrValues(6,ii)]);
    end
    gridnessArray(ii,1) = sTop - sTrough;
    gridnessArray(ii,2) = radius;

    
    % Increment the radius
    radius = radius + p.radiusStep;
end



if p.numGridnessRadii > 1

    numStep = numRadius - p.numGridnessRadii;
    if numStep < 1
        numStep = 1;
    end

    if numStep == 1
        gridness = nanmean(gridnessArray(:,1));
        radius = nanmean(gridnessArray(:,2));
    else
        meanGridnessArray = zeros(numStep,1);
        for ii = 1:numStep
            meanGridnessArray(ii) = nanmean(gridnessArray(ii:ii+p.numGridnessRadii-1,1));
        end

        [gridness, gInd] = max(meanGridnessArray);
        radius = gridnessArray(gInd+(p.numGridnessRadii-1)/2, 2);
    end
else
    % Maximum gridness
    [gridness,gInd] = max(gridnessArray(:,1));
    radius = gridnessArray(gInd,2);
end






% Calculates the radius of the centre field in the correlogram
function centreRadius = centreFieldRadius(corrAxis, Rxx, p)

threshold = p.correlationThresholdForCentreField;

% Size of the auto-correlogram
[N,M] = size(Rxx);
N = single(N);
M = single(M);

% Bin width
binWidth = corrAxis(2) - corrAxis(1);

% Centre bin
cRow = (N+1) / 2;
cCol = (M+1) / 2;

radiusArray = zeros(8,1,'single');

% Calculate border of field to the right of the centre
col = cCol;
while 1
    col = col + 1;
    if col == M
        break;
    end
    if Rxx(cRow, col) < threshold || Rxx(cRow,col) > Rxx(cRow, col-1)
        break;
    end
end
radiusArray(1) = (col - cCol) * binWidth;


% Calculate border of field up from the centre
row = cRow;
while 1
    row = row - 1;
    if row == 1
        break;
    end
    if Rxx(row, cCol) < threshold || Rxx(row,cCol) > Rxx(row+1, cCol)
        break;
    end
end
radiusArray(2) = (cRow - row) * binWidth;

% Calculate border of field down to the right from the centre
col = cCol;
row = cRow;
while 1
    row = row + 1;
    col = col + 1;
    if row >= N
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row-1, col-1)
        break;
    end
    
end
radiusArray(3) = sqrt(((row - cRow) * binWidth)^2 + ((col - cCol) * binWidth)^2);


% Calculate border of field up to the right from the centre
col = cCol;
row = cRow;
while 1
    row = row - 1;
    col = col + 1;
    if row <= 1
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row+1, col-1)
        break;
    end
    
end
radiusArray(4) = sqrt((abs(row - cRow) * binWidth)^2 + (abs(cCol - col) * binWidth)^2);


% Calculate border of field up 67.5
col = cCol;
row = cRow;
while 1
    row = row - 2;
    col = col + 1;
    if row <= 1
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row+2, col-1)
        break;
    end
    
end
radiusArray(5) = sqrt((abs(row - cRow) * binWidth)^2 + (abs(cCol - col) * binWidth)^2);


% Calculate border of field up 22.5
col = cCol;
row = cRow;
while 1
    row = row - 1;
    col = col + 2;
    if row <= 1
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row+1, col-2)
        break;
    end
    
end
radiusArray(6) = sqrt((abs(row - cRow) * binWidth)^2 + (abs(cCol - col) * binWidth)^2);


% Calculate border of field down 67.5
col = cCol;
row = cRow;
while 1
    row = row + 2;
    col = col + 1;
    if row >= N
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row-2, col-1)
        break;
    end
    
end
radiusArray(7) = sqrt(((row - cRow) * binWidth)^2 + ((col - cCol) * binWidth)^2);


% Calculate border of field down 22.5
col = cCol;
row = cRow;
while 1
    row = row + 1;
    col = col + 2;
    if row >= N
        break;
    end
    if col >= M
        break;
    end
    
    if Rxx(row, col) < threshold || Rxx(row, col) > Rxx(row-1, col-2)
        break;
    end
    
end
radiusArray(8) = sqrt((abs(row - cRow) * binWidth)^2 + (abs(col - cCol) * binWidth)^2);

centreRadius = mean(radiusArray);







% Calculates the grid orientation
function [gridAngle, cx, cy, fx, fy] = gridOrientation(aCorrMap, corrAxis)

% Locate the peaks in the autocorrelogram
fieldPos = fieldPosition(aCorrMap, 0.2, 1, corrAxis);

% Number of availible fields
N = size(fieldPos,1);

if N < 2
    gridAngle = NaN;
    cx = 0;
    cy = 0;
    fx = [];
    fy = [];
    return;
end

x = fieldPos(:,1);
y = fieldPos(:,2);

% Find the field closest to the centre
dist = sqrt(x.^2 + y.^2);
[~, minInd] = min(dist);
cField = [x(minInd), y(minInd)];

% Find distance between centre field and the rest of the fields
dist = zeros(N,1);
for ii = 1:N
   if ii ~= minInd
       dist(ii) = sqrt((x(ii)-cField(1))^2 + (y(ii)-cField(2))^2);
   else
       % Set the distance to the centre field itself to infinity
       dist(ii) = inf;
   end
end

% Find the 6 closest field to the centre field if enough fields
fieldDist = zeros(6,2);
if length(dist)>6
    % Keep the 6 closest fields
    for ii=1:6
        [m,ind] = min(dist);
        fieldDist(ii,1) = m;
        fieldDist(ii,2) = ind;
        dist(ind) = inf;
    end
else
    % Keep all the fields
    for ii=1:length(dist)
        [m,ind] = min(dist);
        if m~=inf
            fieldDist(ii,1) = m;
            fieldDist(ii,2) = ind;
            dist(ind) = inf;
        end
    end
end


% Calculate the angles between the placefields and a horizontal line going
% through the centre field
angles = zeros(6,1);
tempX = zeros(6,1);
tempY = zeros(6,1);
% Centre field coordinates
cx = cField(1);
cy = cField(2);
nMissing = 0;
for ii=1:6
    if fieldDist(ii,2) == 0 % Less than 6 fields present
        angles(ii) = NaN;
        nMissing = nMissing + 1;
    else
        tx = x(fieldDist(ii,2));
        ty = y(fieldDist(ii,2));
        tempX(ii) = tx;
        tempY(ii) = ty;
        
        if (tx-cx)>=0 && (ty-cy)>=0
            angles(ii) = atan((ty-cy)/(tx-cx))*(360/(2*pi));
        end
        if (tx-cx)<0 && (ty-cy)>=0
            angles(ii) = atan(abs(tx-cx)/(ty-cy))*(360/(2*pi)) + 90;
        end
        if (tx-cx)<0 && (ty-cy)<0
            angles(ii) = atan(abs(ty-cy)/abs(tx-cx))*(360/(2*pi)) + 180;
        end
        if (tx-cx)>=0 && (ty-cy)<0
            angles(ii) = atan((tx-cx)/abs(ty-cy))*(360/(2*pi)) + 270;
        end
    end
end


[gridAngle, ind] = nanmin(angles);
fx = tempX(ind(1));
fy = tempY(ind(1));






function fieldPos = fieldPosition(map, pTreshold, pBins, mapAxis)


fieldPos = zeros(100, 2);
numFields = 0;

% Allocate memory to the arrays
[numRows, numCols] = size(map);
% Array that contain the bins of the map this algorithm has visited
visited = zeros(numRows, numCols);

% Set bins with rate below treshold to visited.
visited(map < pTreshold) = 1;
visited(isnan(map)) = 1;

% Go as long as there are unvisited parts of the map left
while ~prod(prod(visited))
    % Array that will contain the bin positions to the current placefield
    rowBins = [];
    colBins = [];
    % Find the unvisited bins in the map
    [rows, cols] = find(visited==0);
    % The first unvisited bin are set as the starting point
    legalRows = rows(1);
    legalCols = cols(1);
    % Go as long as there still are bins left in the current placefield
    
    while 1
        % Add current bin to the bin position arrays
        rowBins = [rowBins; legalRows(1)];
        colBins = [colBins; legalCols(1)];
        % Set the current bin to visited
        visited(legalRows(1),legalCols(1)) = 1;
        
        % Find which of the 4 neighbour bins that are part of the placefield
        [legalRows,legalCols] = getLegals(visited,legalRows,legalCols);
        
        % Remove current bin from the array containing bins to be added
        legalRows(1) = [];
        legalCols(1) = [];
        % Check if we are finished with this placefield
        if isempty(legalRows)
            break;
        end
    end
    if length(rowBins) >= pBins % Minimum size of a placefield
        % Find centre of mass (com)
        comX = 0;
        comY = 0;
        % Total rate
        R = 0;
        for ii = 1:length(rowBins)
            R = R + map(rowBins(ii),colBins(ii));
            comX = comX + map(rowBins(ii), colBins(ii)) * mapAxis(numCols - colBins(ii) + 1);
            comY = comY + map(rowBins(ii), colBins(ii)) * mapAxis(rowBins(ii));
        end
        numFields = numFields + 1;
        fieldPos(numFields, 1) = comX/R; 
        fieldPos(numFields, 2) = comY/R; 
    end
end

fieldPos = fieldPos(1:numFields, :);



function [legalRows, legalCols] = getLegals(visited, legalRows, legalCols)
% Current bin
cRow = legalRows(1);
cCol = legalCols(1);
% Neigbour bins
leftRow   = cRow-1;
rightRow  = cRow+1;
upRow     = cRow;
downRow   = cRow;
leftCol   = cCol;
rightCol  = cCol;
upCol     = cCol-1;
downCol   = cCol+1;

% Check left
if leftRow >= 1 % Inside map
    if visited(leftRow,leftCol)==0 % Unvisited bin
        if ~(~isempty(find(legalRows == leftRow,1)) && ~isempty(find(legalCols == leftCol, 1))) % Not part of the array yet
            % Left bin is part of placefield and must be added
            legalRows = [legalRows; leftRow];
            legalCols = [legalCols; leftCol];
        end
    end
end
% Check rigth
if rightRow <= size(visited,2) % Inside map
    if visited(rightRow,rightCol) == 0 % Unvisited bin
        if ~(~isempty(find(legalRows == rightRow, 1)) && ~isempty(find(legalCols == rightCol, 1))) % Not part of the array yet
            % Right bin is part of placefield and must be added
            legalRows = [legalRows; rightRow];
            legalCols = [legalCols; rightCol];
        end
    end
end
% Check up
if upCol >= 1 % Inside map
    if visited(upRow,upCol) == 0 % Unvisited bin
        if ~(~isempty(find(legalRows == upRow, 1)) && ~isempty(find(legalCols == upCol, 1))) % Not part of the array yet
            % Up bin is part of placefield and must be added
            legalRows = [legalRows; upRow];
            legalCols = [legalCols; upCol];
        end
    end
end
% Check down
if downCol <= size(visited,1) % Inside map
    if visited(downRow, downCol)==0 % Unvisited bin
        if ~(~isempty(find(legalRows == downRow, 1)) && ~isempty(find(legalCols == downCol, 1))) % Not part of the array yet
            % Right bin is part of placefield and must be added
            legalRows = [legalRows; downRow];
            legalCols = [legalCols; downCol];
        end
    end
end



%__________________________________________________________________________
%
%                           Stability
%__________________________________________________________________________




% Splits the session data into two halves
function splitDataArray = dataSplit(x, y, t, hdDir)

% 1 Row:    First half of data (Half and half type split)
% 2 Row:    Second half of data (Half and half type split)
% 3 Row:    First half of data (Binned type split)
% 4 Row:    Seconf half of data (Binned type split)
% 1 Col:    Posx
% 2 Col:    Posy
% 3 Col:    Post
% 4 Col:    Head direction
splitDataArray = cell(4,4);

if isempty(hdDir)
    hdFlag = 0;
    hdDir1 = [];
    hdDir2 = [];
    hdDir3 = [];
    hdDir4 = [];
else
    hdFlag = 1;
end



% Divide the data into 2 halves
duration = t(end) - t(1);
ind = find(t <= (t(1) + duration/2));
x1 = x(ind);
y1 = y(ind);
t1 = t(ind);
if hdFlag
    hdDir1 = hdDir(ind);
end

ind = find(t > (t(1) + duration/2));
x2 = x(ind);
y2 = y(ind);
t2 = t(ind);
if hdFlag
    hdDir2 = hdDir(ind);
end

splitDataArray{1,1} = x1;
splitDataArray{1,2} = y1;
splitDataArray{1,3} = t1;
splitDataArray{1,4} = hdDir1;
splitDataArray{2,1} = x2;
splitDataArray{2,2} = y2;
splitDataArray{2,3} = t2;
splitDataArray{2,4} = hdDir2;

numSamples = length(x);

% Allocate memory for the arrays
x3 = zeros(numSamples,1,'single');
y3 = zeros(numSamples,1,'single');
t3 = zeros(numSamples,1,'single');
if hdFlag
    hdDir3 = zeros(numSamples,1,'single');
end
totSamp3 = 0;

x4 = zeros(numSamples,1,'single');
y4 = zeros(numSamples,1,'single');
t4 = zeros(numSamples,1,'single');
if hdFlag
    hdDir4 = zeros(numSamples,1,'single');
end
totSamp4 = 0;

duration = t(end) - t(1);
% Number of 1 minutes bins in the trial
nBins = ceil(duration / 60);
start = t(1);
stop = start + 60;
for ii = 1:nBins
    if mod(ii,2)
        % Odd numbers
        ind = find(t >= start & t < stop);
        samps = length(ind);
        if samps > 0
            x3(totSamp3+1:totSamp3+samps) = x(ind);
            y3(totSamp3+1:totSamp3+samps) = y(ind);
            t3(totSamp3+1:totSamp3+samps) = t(ind);
            if hdFlag
                hdDir3(totSamp3+1:totSamp3+samps) = hdDir(ind);
            end
            totSamp3 = totSamp3 + samps;
        end
    else
        % Even numbers
        ind = find(t >= start & t < stop);
        samps = length(ind);
        if samps > 0
            x4(totSamp4+1:totSamp4+samps) = x(ind);
            y4(totSamp4+1:totSamp4+samps) = y(ind);
            t4(totSamp4+1:totSamp4+samps) = t(ind);
            if hdFlag
                hdDir4(totSamp4+1:totSamp4+samps) = hdDir(ind);
            end
            totSamp4 = totSamp4 + samps;
        end
    end
    start = start + 60;
    stop = stop + 60;
end

x3 = x3(1:totSamp3);
y3 = y3(1:totSamp3);
t3 = t3(1:totSamp3);
if hdFlag
    hdDir3 = hdDir3(1:totSamp3);
end

x4 = x4(1:totSamp4);
y4 = y4(1:totSamp4);
t4 = t4(1:totSamp4);
if hdFlag
    hdDir4 = hdDir4(1:totSamp4);
end

splitDataArray{3,1} = x3;
splitDataArray{3,2} = y3;
splitDataArray{3,3} = t3;
splitDataArray{3,4} = hdDir3;
splitDataArray{4,1} = x4;
splitDataArray{4,2} = y4;
splitDataArray{4,3} = t4;
splitDataArray{4,4} = hdDir4;
    






% Calculates the angular and spatial stability
% splitDataArray 4x4.
% 1 Row:    First half of data (Half and half type split)
% 2 Row:    Second half of data (Half and half type split)
% 3 Row:    First half of data (Binned type split)
% 4 Row:    Seconf half of data (Binned type split)
% 1 Col:    Posx
% 2 Col:    Posy
% 3 Col:    Post
% 4 Col:    Head direction
function [angStability, spatialStability] = stability(splitDataArray, x, y, t, ts, p)

% Calculate the extremal values
maxX = nanmax(x);
maxY = nanmax(y);
xStart = nanmin(x);
yStart = nanmin(y);
xLength = maxX - xStart + 10;
yLength = maxY - yStart + 10;
startPos = min([xStart,yStart]);
tLength = max([xLength,yLength]);


spatialStability = zeros(2,1);

% Divide the spike data into 2 halves
duration = t(end) - t(1);
ts1 = ts(ts <= duration/2);
ts2 = ts(ts > duration/2);

% Calculate the spike positions
[spkx1,spky1] = spikePos(ts1, splitDataArray{1,1}, splitDataArray{1,2}, splitDataArray{1,3});
[spkx2,spky2] = spikePos(ts2, splitDataArray{2,1}, splitDataArray{2,2}, splitDataArray{2,3});

% Calculate the rate maps
map1 = rateMap(splitDataArray{1,1},splitDataArray{1,2},spkx1,spky1,p.binWidth,p.binWidth,startPos ,tLength,startPos ,tLength,p.sampleTime,p);
map2 = rateMap(splitDataArray{2,1},splitDataArray{2,2},spkx2,spky2,p.binWidth,p.binWidth,startPos ,tLength,startPos ,tLength,p.sampleTime,p);


spatialStability(1) = zeroLagCorrelation(map1,map2);

% Divide the data by binning
numSpikes = length(ts);
ts3 = zeros(numSpikes,1);
totSpikes3 = 0;

ts4 = zeros(numSpikes,1);
totSpikes4 = 0;

duration = t(end) - t(1);
% Number of 1 minutes bins in the trial
nBins = ceil(duration / 60);
start = t(1);
stop = start + 60;

for ii = 1:nBins
    if mod(ii,2)
        ind = find(ts >= start & ts < stop);
        spikes = length(ind);
        if spikes > 0
            ts3(totSpikes3+1:totSpikes3+spikes) = ts(ind);
            totSpikes3 = totSpikes3 + spikes;
        end
    else
        ind = find(ts >= start & ts < stop);
        spikes = length(ind);
        if spikes > 0
            ts4(totSpikes4+1:totSpikes4+spikes) = ts(ind);
            totSpikes4 = totSpikes4 + spikes;
        end
    end
    start = start + 60;
    stop = stop + 60;
end
ts3 = ts3(1:totSpikes3);
ts4 = ts4(1:totSpikes4);

% Calculate the spike positions
[spkx3,spky3] = spikePos(ts3, splitDataArray{3,1}, splitDataArray{3,2}, splitDataArray{3,3});
[spkx4,spky4] = spikePos(ts4, splitDataArray{4,1}, splitDataArray{4,2}, splitDataArray{4,3});

% Calculate the rate maps
map3 = rateMap(splitDataArray{3,1},splitDataArray{3,2},spkx3,spky3,p.binWidth,p.binWidth,startPos,tLength,startPos,tLength,p.sampleTime,p);
map4 = rateMap(splitDataArray{4,1},splitDataArray{4,2},spkx4,spky4,p.binWidth,p.binWidth,startPos,tLength,startPos,tLength,p.sampleTime,p);

spatialStability(2) = zeroLagCorrelation(map3,map4);

if isempty(splitDataArray{1,4}) || isempty(splitDataArray{2,4});
    angStability = nan(2,1);
else
    angStability = zeros(2,1);

    spkInd1 = getSpkInd(ts1, splitDataArray{1,3});
    spkInd2 = getSpkInd(ts2, splitDataArray{2,3});

    % Find the direction of the rat at the spike times
    spkDir1 = splitDataArray{1,4}(spkInd1);
    spkDir2 = splitDataArray{2,4}(spkInd2);

    spkDir1(isnan(spkDir1)) = [];
    spkDir2(isnan(spkDir2)) = [];

    % Calculate the head direction maps
    hd1 = hdstat(spkDir1*2*pi/360, splitDataArray{1,4}*2*pi/360, p.sampleTime, p,0);
    hd2 = hdstat(spkDir2*2*pi/360, splitDataArray{2,4}*2*pi/360, p.sampleTime, p,0);

    % Calculate the correlation
    corrValue = corrcoef(hd1.ratemap,hd2.ratemap);
    angStability(1) = corrValue(1,2);




    spkInd3 = getSpkInd(ts3, splitDataArray{3,3});
    spkInd4 = getSpkInd(ts4, splitDataArray{4,3});

    % Find the direction of the rat at the spike times
    spkDir3 = splitDataArray{3,4}(spkInd3);
    spkDir4 = splitDataArray{4,4}(spkInd4);

    spkDir3(isnan(spkDir3)) = [];
    spkDir4(isnan(spkDir4)) = [];

    % Calculate the head direction maps
    hd3 = hdstat(spkDir3*2*pi/360, splitDataArray{3,4}*2*pi/360, p.sampleTime, p,0);
    hd4 = hdstat(spkDir4*2*pi/360, splitDataArray{4,4}*2*pi/360, p.sampleTime, p,0);

    % Calculate the correlation
    corrValue = corrcoef(hd3.ratemap,hd4.ratemap);
    angStability(2) = corrValue(1,2);
end


% Calculates the correlation for a point in the autocorrelogram. It is
% using the Pearsons correlation method. The 2 maps are assumed to be of
% same size.
function Rxy = zeroLagCorrelation(map1,map2)


[numRows, numCols] = size(map1);


sumXY = 0;
sumX = 0;
sumY = 0;
sumX2 = 0;
sumY2 = 0;
NB = 0;
for r = 1:numRows
    for c = 1:numCols
        if ~isnan(map1(r,c)) && ~isnan(map2(r,c))
            NB = NB + 1;
            sumX = sumX + map1(r,c);
            sumY = sumY + map2(r,c);
            sumXY = sumXY + map1(r,c) * map2(r,c);
            sumX2 = sumX2 + map1(r,c)^2;
            sumY2 = sumY2 + map2(r,c)^2;
        end
    end
end

if NB >= 0
    sumx2 = sumX2 - sumX^2/NB;
    sumy2 = sumY2 - sumY^2/NB;
    sumxy = sumXY - sumX*sumY/NB;
    if (sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0)
        Rxy = NaN;
    else
        Rxy = sumxy/sqrt(sumx2*sumy2);
    end
else
    Rxy = NaN;
end






% Finds the position timestamp indexes for spike timestamps
function spkInd = getSpkInd(ts,post)

ts(ts>post(end)) = [];
% Number of spikes
N = length(ts);
spkInd = zeros(N,1,'single');


currentPos = 1;
for ii = 1:N
    ind = find(post(currentPos:end) >= ts(ii),1,'first') + currentPos - 1;
    
    spkInd(ii) = ind;
    currentPos = ind;
end




%__________________________________________________________________________
%
%                           Correlation
%__________________________________________________________________________



% placefield identifies the placefields in the firing map. It returns the
% number of placefields and the location of the peak within each
% placefield.
%
% map           Rate map
% pTreshold     Field treshold
% pBins         Minimum number of bins in a field
% mapAxis       The map axis
%
function [nFields,fieldProp,fieldBins] = placefield(map,lowestFieldRate,fieldTreshold, minNumBins, colAxis,rowAxis)

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
        for ii = 1:length(binsRow)
            R = R + map(binsRow(ii),binsCol(ii));
            comX = comX + map(binsRow(ii),binsCol(ii)) * rowAxis(binsRow(ii));
            comY = comY + map(binsRow(ii),binsCol(ii)) * colAxis(binsCol(ii));
        end
        % Average rate in field
        avgRate = nanmean(nanmean(map(binsRow,binsCol)));
        % Peak rate in field
        peakRate = nanmax(nanmax(map(binsRow,binsCol)));
        % Size of field
        fieldSize = length(binsRow) * binWidth^2;
        % Put the field properties in the struct array
        fieldProp = [fieldProp; struct('x',comY/R,'y',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize)];
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





function [spatialCoherenceArrayRaw, gridnessArrayNC, gridnessArrayPeakBasedNC] = shuffleAnalyser(x, y, t, ts, N, tLength, start, radius, p, corrAxis, centreRadius, radiusPeakBased)



gridnessArrayNC = NaN(N,1,'single');
gridnessArrayPeakBasedNC = NaN(N,1,'single');
spatialCoherenceArrayRaw = NaN(N,1,'single');


numSpikes = int32(length(ts));
numSamples = int32(length(x));
% Number of rotations
numRotations = int16(6);

scrambleMode = p.scrambleMode;
binWidth = p.binWidth;
sampleTime = p.sampleTime;
parfor ii = 1:N
    
    if scrambleMode == 0
        % Make random spike positions
        spkInd = round(rand(numSpikes,1) * numSamples);
        % Remove zeros
        spkInd(spkInd==0) = [];

    elseif scrambleMode == 1
        % Shift spike time stamps by a random amount
        timeShift = randomTimeShift(t, p);
        
        % Make sure time stamps are within the duration of the session
        shiftedTs = mod(ts + timeShift, t(end));
        
        spkInd = getSpkInd(shiftedTs, t);
    end
    
    rSpkx = x(spkInd);
    rSpky = y(spkInd);
    
    % Rate map
    [map, rawMap] = rateMap(x,y,rSpkx,rSpky,binWidth,binWidth,start,tLength,start,tLength,sampleTime,p);
    
    if p.shuffleAnalysisList(2) == 1
        % Calculate the spatial coherence
        spatialCoherenceArrayRaw(ii) = fieldcohere(rawMap);
    end
    
    if p.shuffleAnalysisList(1) == 1 || p.shuffleAnalysisList(5) == 1
        % Calculate the correlograms
        corrMaps = rotatedCorrelationMaps(map);
    end

    
    
    
    if p.shuffleAnalysisList(5) == 1
        
        % Set start radius for the averaging of the gridness score over several
        % radii
        tRadius = radius - ((p.numGridnessRadii-1)/2) * p.radiusStep;
        corrValuesNC = zeros(p.numGridnessRadii,numRotations);
        for r = 1:p.numGridnessRadii

            RxxNC = corrMaps{1};
            RxxNC = adjustMap(RxxNC,tRadius,centreRadius,corrAxis);


            for jj = 2:numRotations
                RxxRNC = corrMaps{jj};
                RxxRNC = adjustMap(RxxRNC,tRadius,centreRadius,corrAxis);

                corrValuesNC(r,jj) = pointCorr(RxxNC,RxxRNC,0,0,size(RxxNC,1));
            end
            % Increment the radius
            tRadius = tRadius + p.radiusStep;
        end
        
        % Calculate the degree of "gridness"
        gridnessNC = zeros(p.numGridnessRadii,1);
        if p.gridnessCalculationMode == 0
            for r = 1:p.numGridnessRadii
                sTopNC = mean([corrValuesNC(r,3),corrValuesNC(r,5)]);
                sTroughNC = mean([corrValuesNC(r,2),corrValuesNC(r,4),corrValuesNC(r,6)]);

                gridnessNC(r) = sTopNC - sTroughNC;
            end
        else
            for r = 1:p.numGridnessRadii
                sTopNC = min([corrValuesNC(r,3),corrValuesNC(r,5)]);
                sTroughNC = max([corrValuesNC(r,2),corrValuesNC(r,4),corrValuesNC(r,6)]);

                gridnessNC(r) = sTopNC - sTroughNC;
            end
        end
        gridnessArrayNC(ii) = nanmean(gridnessNC);
    end
    
    if p.shuffleAnalysisList(1) == 1
        % Calculate the degree of "gridness" for the peak based radius
        RxxPBNC = corrMaps{1};
        RxxPBNC = adjustMap(RxxPBNC,radiusPeakBased,centreRadius,corrAxis);
        corrValuesPBNC = zeros(numRotations,1);
        for jj = 2:numRotations

            RxxRPBNC = corrMaps{jj};
            RxxRPBNC = adjustMap(RxxRPBNC,radiusPeakBased,centreRadius,corrAxis);

            corrValuesPBNC(jj) = pointCorr(RxxPBNC,RxxRPBNC,0,0,size(RxxPBNC,1));
        end

        if p.gridnessCalculationMode == 0
            sTopPBNC = mean([corrValuesPBNC(3),corrValuesPBNC(5)]);
            sTroughPBNC = mean([corrValuesPBNC(2),corrValuesPBNC(4),corrValuesPBNC(6)]);
        else
            sTopPBNC = min([corrValuesPBNC(3),corrValuesPBNC(5)]);
            sTroughPBNC = max([corrValuesPBNC(2),corrValuesPBNC(4),corrValuesPBNC(6)]);
        end

        gridnessArrayPeakBasedNC(ii) = sTopPBNC - sTroughPBNC;
    end
end


% Calculates expected mean vector length using shuffling
function  [hdMeanVectorLengthArray, movementMeanVectorLengthArray] = expectedHeadDirection(N, ts, t, hdDir, direction, p)

numSpikes = length(ts);
numSamples = length(hdDir);


hdMeanVectorLengthArray = NaN(N,1);
movementMeanVectorLengthArray = NaN(N,1);

scrambleMode = p.scrambleMode;
sampleTime = p.sampleTime;

parfor ii = 1:N
    % Make random spike directions
    if scrambleMode == 0
        % Make random spike positions
        spkInd = round(rand(numSpikes,1) * numSamples);
        % Remove zeros
        spkInd(spkInd==0) = [];

    elseif scrambleMode == 1
        % Shift spike time stamps by a random amount
        timeShift = randomTimeShift(t, p);
        
        % Make sure time stamps are within the duration of the session
        rts = mod(ts + timeShift, t(end));
        rts = sort(rts);

        spkInd = getSpkInd(rts, t);
    end
    
    if p.doHeadDirectionAnalysis == 1
        spkDir = hdDir(spkInd);

        % Do the head direction analysis
        hd = hdstatShuffle(spkDir*2*pi/360,hdDir*2*pi/360,sampleTime,p);

        l = length(hd.ratemap);
        angles = 0:2*pi/l:2*pi;
        % Calculate the mean vector length
        hdMeanVectorLengthArray(ii) = hdMeanVectorLength(angles(1:end-1), hd.ratemap);
    end
    
    if p.doMovementDirectionAnalysis == 1
        spkDir = direction(spkInd);

        % Do the head direction analysis
        hd = hdstatShuffle(spkDir*2*pi/360,direction*2*pi/360,sampleTime,p);

        l = length(hd.ratemap);
        angles = 0:2*pi/l:2*pi;
        % Calculate the mean vector length
        movementMeanVectorLengthArray(ii) = hdMeanVectorLength(angles(1:end-1), hd.ratemap);
    end

end





% Head direction processing. Returns mean, std, count peaks and length of
% the vector R, which can be used as a measure of head direction
% prefference.
% spkhd: head directions associated with each spike
% poshd: head directions associated with each time (all head directions)
% samplfq: 0.02, the sample frequency.
%
% Hd arc calculation change by Raymond Skjerpeng, 18. Nov. 2009.
function hd = hdstatShuffle(spkhd, poshd, samplfq, p)

% Number of bins in the map
bins = ceil(360 / p.hdBinWidth);
% Convert bin width to radians
binWidth = p.hdBinWidth * 2 * pi / 360;

% Create the arrays.
hdmap = zeros(1,bins);
hdnorm = zeros(1,bins);
hdAxis = zeros(1,bins);



for ii = 1:bins
    start = (ii-1) * binWidth;
    stop = ii * binWidth;
    hdAxis(ii) = (start+stop) / 2;
    hdmap(ii) = length(find(spkhd >= start & spkhd < stop));
    hdnorm(ii)= length(find(poshd >= start & poshd < stop));

end

% Transform from number of samples to amount of time
hdnorm = hdnorm * samplfq;

if p.hdSmoothingMode == 0
    % Smooth
    hdmap = mapSmoothing(hdmap);
    hdnorm = mapSmoothing(hdnorm);
else
    % Number of smoothing bins
    numSmoothingBins = round(p.hdSmoothingWindowSize / p.hdBinWidth);
    hdmap = hdFlatWindowSmoothing(hdmap, numSmoothingBins);
    hdnorm = hdFlatWindowSmoothing(hdnorm, numSmoothingBins);
end



hdmap = hdmap./hdnorm;
hdmap(end+1)  = hdmap(1);
hd.ratemap = hdmap;











% Calculates expected stability using shuffling
function [angStabilityArray, spatialStabilityArray] = expectedStability(N, splitDataArray, x, y, t, p, ts)


angStabilityArray = zeros(N,2);
spatialStabilityArray = zeros(N,2);

numSamples = length(t);

scrambleMode = p.scrambleMode;

parfor ii = 1:N
    if scrambleMode == 0
        numSpikes = length(ts);
        % Make random spike positions
        spkInd = round(rand(numSpikes,1) * numSamples);
        % Remove zeros
        spkInd(spkInd==0) = [];

    elseif scrambleMode == 1
        % Shift spike time stamps by a random amount
        timeShift = randomTimeShift(t, p);
        
        % Make sure time stamps are within the duration of the session
        rts = mod(ts + timeShift, t(end));
        
        spkInd = getSpkInd(rts, t);
    end
    
    
    tInd = find(spkInd == 0);
    if ~isempty(tInd)
        spkInd(tInd) = 1;
    end
    rTS = t(spkInd);
    
    [angStabilityArray(ii,:), spatialStabilityArray(ii,:)] = stability(splitDataArray, x, y, t, rTS, p);

end


function timeShift = randomTimeShift(t, p)

% Shift spike time stamps by a random amount
rNum = (2 * rand(1,1)) - 1;
timeShift = rNum * t(end);

while (t(end) - abs(timeShift)) < p.minTimeShift || abs(timeShift) < p.minTimeShift
    % Make sure the timeshift is far enough from the original data,
    % 10 second threshold.
    timeShift = rand(1,1) * t(end);
end



% Calculates the correlogram for the different rotations
function corrMaps = correlationMaps(x, y, spkInd, map, p)

% Number of rotations
rotStep = single(30);
N = single(floor(180/rotStep));

corrMaps = cell(N,1);
corrMaps{1} = correlation(map);

% Number of bins in the correlogram
Nr = single(size(corrMaps{1},1));

rotationAngles = zeros(N,1,'single');
rotAngle = single(0);
for ii = 1:N-1
    rotAngle = rotAngle + rotStep;
    rotationAngles(ii) = rotAngle;
end

for ii = 1:N-1

    % Increment rotation angle
    rotAngle = rotationAngles(ii);

    % Convert angle from degrees to radians
    radAngle = rotAngle*pi/180;
    % Calculate rotated coordinates
    [rx,ry] = rotatePath(x,y,radAngle);
    
    spkx = rx(spkInd);
    spky = ry(spkInd);
    
    maxX = nanmax(rx);
    maxY = nanmax(ry);
    xStart = nanmin(rx);
    yStart = nanmin(ry);
    xLength = maxX - xStart + 10;
    yLength = maxY - yStart + 10;
    start = min([xStart,yStart]);
    tLength = max([xLength,yLength]);

    map = rateMap(rx,ry,spkx,spky,p.binWidth,p.binWidth,start,tLength,start,tLength,p.sampleTime,p);

    % Calculate the autocorrelation map for the rotated data
    corrMaps{ii+1} = correlation(map);
    corrMaps{ii+1} = adjustMapSize(corrMaps{ii+1},Nr);

end




%__________________________________________________________________________
%
%                       Directional functions
%__________________________________________________________________________




% Calculates the mean vector length of the head direction rate map. The
% value will range from 0 to 1. 0 means that there are so much dispersion
% that a mean angle cannot be described. 1 means that all data are
% concentrated at the same direction. Note that 0 does not necessarily
% indicate a uniform distribution. (Section 26.5, J.H Zar - Biostatistical
% Analysis)
%
%
function r = hdMeanVectorLength(mapAxis, hdMap)


sumRate = nansum(hdMap);

X = nansum(hdMap .* cos(mapAxis)) / sumRate;
Y = nansum(hdMap .* sin(mapAxis)) / sumRate;

r = sqrt(X^2 + Y^2);






% Calculate the directional information rate
function information = directionalInformationRate(map, dirPDF)

% Skip zero values since the limit of x*log(x) as x->0 is 0 
ind = find(map>0 & dirPDF>0);
meanRate = nansum(map .* dirPDF);

if ~isempty(ind)
    % 
    accSum = 0;
    for ii = 1:length(ind)
        accSum = accSum + dirPDF(ind(ii)) * map(ind(ii)) * log2(map(ind(ii)) / meanRate);
    end
    information = accSum;
else
    information = NaN;
end




% Head direction processing. Returns mean, std, count peaks and length of
% the vector R, which can be used as a measure of head direction
% prefference.
% spkhd: head directions associated with each spike
% poshd: head directions associated with each time (all head directions)
% samplfq: 0.02, the sample frequency.
%
% Hd arc calculation change by Raymond Skjerpeng, 18. Nov. 2009.
function hd = hdstat(spkhd, poshd, samplfq, p, doTimeMap)

% Number of bins in the map
bins = ceil(360 / p.hdBinWidth);
% Convert bin width to radians
binWidth = p.hdBinWidth * 2 * pi / 360;

% Create the arrays.
hdmap = zeros(1,bins);
hdnorm = zeros(1,bins);
hdAxis = zeros(1,bins);



for ii = 1:bins
    start = (ii-1) * binWidth;
    stop = ii * binWidth;
    hdAxis(ii) = (start+stop) / 2;
    hdmap(ii) = length(find(spkhd >= start & spkhd < stop));
    hdnorm(ii)= length(find(poshd >= start & poshd < stop));

end

% Transform from number of samples to amount of time
hdnorm = hdnorm * samplfq;

if p.hdSmoothingMode == 0
    % Smooth
    hdmap = mapSmoothing(hdmap);
    hdnorm = mapSmoothing(hdnorm);
else
    % Number of smoothing bins
    numSmoothingBins = round(p.hdSmoothingWindowSize / p.hdBinWidth);
    hdmap = hdFlatWindowSmoothing(hdmap, numSmoothingBins);
    hdnorm = hdFlatWindowSmoothing(hdnorm, numSmoothingBins);
end

if doTimeMap
    if p.hdTimeBinWidth == p.hdBinWidth
        % Time spent for each head direction bin
        hd.timeMap = hdnorm;
    else
        bins = ceil(360 / p.hdTimeBinWidth);
        hdTime = zeros(1,bins);
        % Convert bin width to radians
        binWidthT = p.hdTimeBinWidth * 2 * pi / 360;
        start = 0;
        stop = binWidthT;
        for ii = 1:bins
            hdTime(ii)= length(find(poshd >= start & poshd < stop));
            start = start + binWidth;
            stop = stop + binWidth;
        end
        
        hdTime = hdTime * 0.02;
        
        if p.hdSmoothingMode == 0
            % Smooth
            hdTime = mapSmoothing(hdTime);
        else
            % Number of smoothing bins
            numSmoothingBins = round(p.hdSmoothingWindowSize / p.hdTimeBinWidth);
            hdTime = hdFlatWindowSmoothing(hdTime, numSmoothingBins);
        end
        hd.timeMap = hdTime;
    end
end

hdmap = hdmap./hdnorm;
hdnorm = hdnorm/nanmean(hdnorm) * nanmean(hdmap);

hdAxis(end+1) = hdAxis(1);
hdmap(end+1)  = hdmap(1);
hdnorm(end+1) = hdnorm(1);

hd.ratemap = hdmap;
hd.trajectorymap = hdnorm;

% mean, r and std  for frequency data
relhdmap = hdmap / nansum(hdmap);
X = nanmean(cos(hdAxis).*relhdmap);
Y = nanmean(sin(hdAxis).*relhdmap);
hdmean = atan2(Y,X);
r = sqrt(X^2+Y^2);
hdstd = sqrt(2*(1-r));
hd.mean = hdmean;
hd.r = r;
hd.std = hdstd;
hd.axis = hdAxis + pi/bins;


% Calculate the arc value
relhdmap(end) = [];
relhdmap = relhdmap / nansum(relhdmap);

% Find index to the maximum rate bin
[~, mInd] = nanmax(relhdmap);

accSum = relhdmap(mInd);
counter = 1;
cwInd = mInd;
ccwInd = mInd;
while accSum < p.percentile/100 && counter <= bins
    cwInd = cwInd - 1;
    if cwInd == 0
        cwInd = bins;
    end
    ccwInd = ccwInd + 1;
    if ccwInd > bins
        ccwInd = 1;
    end
    if ~isnan(relhdmap(cwInd))
        accSum = accSum + relhdmap(cwInd);
        counter = counter + 1;
    end
    if ~isnan(relhdmap(ccwInd))
        accSum = accSum + relhdmap(ccwInd);
        counter = counter + 1;
    end
end

hd.arc_central_quartiles = counter / bins * 2*pi;

hd.hd_score = 1 - hd.arc_central_quartiles / pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%peaks in map
[hdpeaks, hdpeak_values] = find_peaks_smooth(hdmap,5,1);
hd.peaks.angles=hdpeaks;
hd.peaks.values=hdpeak_values;
















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%find peaks in one dimension with a smoothness factor of 'smoothing_steps'.
%%%If smoothing_steps=1 this function is equivalent to findpeaks.
%%% This version does not consider curve as a circular quantity and may
%%% identify the borders as peaks.
%%% circular is 1 if the curves stand on a circle and ends should be
%%% consider as continuous
function [peaks,values] = find_peaks_smooth(curve,smoothing_steps,circular)

if circular==1
    res=[curve(end-smoothing_steps+1:end), curve, curve(1:smoothing_steps)];
else
    res=[ones(1, smoothing_steps)*(min(curve)-1), curve, ones(1, smoothing_steps)*(min(curve)-1)];
end
raux=ones(1,length(curve));
for i=1:smoothing_steps
    posp=res(smoothing_steps+1+i:end-smoothing_steps+i);
    posm=res(smoothing_steps+1-i:end-smoothing_steps-i);
    raux=raux.*(posp<curve).*(posm<curve);
end
peaks=find(raux);
values=curve(peaks);



% Moving mean window smoothing of head direction map. Care is taken around
% the 0/360 degree position.
function sMap = hdFlatWindowSmoothing(map, numSmoothingBins)

% Number of bins in the map
N = length(map);

% Allocate memory for the smoothed map
sMap = zeros(1, N);

% Make sure the number of smoothing bins is a odd number
if mod(numSmoothingBins, 2) == 0
    numSmoothingBins = numSmoothingBins + 1;
end

% Number of bins to each side of the current bin when smoothing
d = (numSmoothingBins-1) / 2;

for ii = 1:N
    if ii-d <= 0 || ii+d > N
        if ii-d <= 0
            sumRate = sum(map(1:ii+d)) + sum(map(N-(d-ii):N));
            sMap(ii) = sumRate / numSmoothingBins;
        end
        if ii+d > N
            sumRate = sum(map(ii-d:N)) + sum(map(1:(ii+d-N)));
            sMap(ii) = sumRate / numSmoothingBins;
        end
    else
        sMap(ii) = nanmean(map(ii-d:ii+d));
    end
end



% Calculates the head direction for each position sample pair. Direction
% is defined as east = 0 degrees, north = 90 degrees, west = 180 degrees,
% south = 270 degrees. Direction is set to NaN for missing samples.
%
% Version 1.0
% 06. Jan. 2009
%
% Version 1.1       Switch the 2 diodeds. Big spot is in the front.
% 23. Mar. 2010
%
% (c) Raymond Skjerpeng, CBM/KISN, NTNU, 2009-2010.
function direct = calcHeadDirection(x1,y1,x2,y2)


direct = 360 * atan2(y2-y1,x2-x1) / (2*pi) + 180;





%__________________________________________________________________________
%
%                       Statistic function
%__________________________________________________________________________







function z = fieldcohere(map)
[n,m] = size(map);
tmp = zeros(n*m,2);
k=0;
for y = 1:n
    for x = 1:m
        k = k + 1;
        xstart = max([1,x-1]);
        ystart = max([1,y-1]);
        xend = min([m x+1]);
        yend = min([n y+1]);
        nn = sum(sum(isfinite(map(ystart:yend,xstart:xend)))) - isfinite(map(y,x));
        if (nn > 0)
            tmp(k,1) = map(y,x);
            tmp(k,2) = nansum([ nansum(nansum(map(ystart:yend,xstart:xend))) , -map(y,x) ]) / nn;
        else
            tmp(k,:) = [NaN,NaN];    
        end
    end
end
index = find( isfinite(tmp(:,1)) & isfinite(tmp(:,2)) );
if length(index) > 3
    cc = corrcoef(tmp(index,:));
    z = atanh(cc(2,1));
else
    z = NaN;
end



function information = spatialInformationRate(map, posPDF)

% Mean firing rate
meanrate = nansum(nansum( map .* posPDF ));


[i1, i2] = find( (map>0) & (posPDF>0) );  % the limit of x*log(x) as x->0 is 0 
if ~isempty(i1)
    akksum = 0;
    for i = 1:length(i1);
        ii1 = i1(i);
        ii2 = i2(i);
        
        akksum = akksum + posPDF(ii1,ii2) * map(ii1,ii2) * log2( map(ii1,ii2) / meanrate ); 
    end
    information = akksum;
else
    information = NaN;
end




% Created by Sturla Molden.
function [information,sparsity,selectivity] = mapstat(map,posPDF)

meanrate = nansum(nansum( map .* posPDF ));

meansquarerate = nansum(nansum( (map.^2) .* posPDF ));
if meansquarerate == 0
   sparsity = NaN;
else
    sparsity = meanrate^2 / meansquarerate;
end
maxrate = max(max(map));
if meanrate == 0;
   selectivity = NaN;
else
   selectivity = maxrate/meanrate;
end
[i1, i2] = find( (map>0) & (posPDF>0) );  % the limit of x*log(x) as x->0 is 0 
if ~isempty(i1)
    akksum = 0;
    for i = 1:length(i1);
        ii1 = i1(i);
        ii2 = i2(i);
        akksum = akksum + posPDF(ii1,ii2) * (map(ii1,ii2)/meanrate) * log2( map(ii1,ii2) / meanrate ); 
    end
    information = akksum;
else
    information = NaN;
end





%__________________________________________________________________________
%
%                           Correlation Functions
%__________________________________________________________________________




function Rxx_new = adjustMapSize(Rxx,Nr)

% Size of map, new size must be Nr
N = size(Rxx,1);

if N == Nr
    Rxx_new = Rxx;
    return
end

Rxx_new = nan(Nr);

if N > Nr
    diff = (N - Nr) / 2;
    for ii = 1:Nr
        for jj = 1:Nr
            Rxx_new(ii,jj) = Rxx(ii+diff,jj+diff);
        end
    end
end

if N < Nr
    diff = (Nr - N) / 2;
    for ii = 1:N
        for jj = 1:N
            Rxx_new(ii+diff,jj+diff) = Rxx(ii,jj);
        end
    end
end




% Calculates the correlation for a point in the autocorrelogram. It is
% using the Pearsons correlation method.
function Rxy = pointCorr(map1,map2,rowOff,colOff,N)

% Number of rows in the correlation for this lag
numRows = N - abs(rowOff);
% Number of columns in the correlation for this lag
numCol = N - abs(colOff);

% Set the start and the stop indexes for the maps
if rowOff > 0
    rSt1 = single(1+abs(rowOff)-1);
    rSt2 = single(0);
else
    rSt1 = single(0);
    rSt2 = single(abs(rowOff));
end
if colOff > 0
    cSt1 = single(abs(colOff));
    cSt2 = single(0);
else
    cSt1 = single(0);
    cSt2 = single(abs(colOff));
end

sumXY = single(0);
sumX = single(0);
sumY = single(0);
sumX2 = single(0);
sumY2 = single(0);
NB = single(0);
for ii = 1:numRows
    for jj = 1:numCol
        if ~isnan(map1(rSt1+ii,cSt1+jj)) && ~isnan(map2(rSt2+ii,cSt2+jj))
            NB = NB + 1;
            sumX = sumX + map1(rSt1+ii,cSt1+jj);
            sumY = sumY + map2(rSt2+ii,cSt2+jj);
            sumXY = sumXY + map1(rSt1+ii,cSt1+jj) * map2(rSt2+ii,cSt2+jj);
            sumX2 = sumX2 + map1(rSt1+ii,cSt1+jj)^2;
            sumY2 = sumY2 + map2(rSt2+ii,cSt2+jj)^2;
        end
    end
end

if NB >= 20
    sumx2 = sumX2 - sumX^2/NB;
    sumy2 = sumY2 - sumY^2/NB;
    sumxy = sumXY - sumX*sumY/NB;
    if (sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0)
        Rxy = single(NaN);
    else
        Rxy = sumxy/sqrt(sumx2*sumy2);
    end
else
    Rxy = single(NaN);
end




% Calculates the auto-correlation map for the rate map
%
% Author: Raymond Skjerpeng and Jan Christian Meyer.
function Rxy = correlation(map)


bins = size(map,1);
N = bins + round(0.8*bins);
if ~mod(N,2)
    N = N - 1;
end
% Centre bin
cb = (N+1)/2;
Rxy = NaN(N);
%'correlation-function'
%tic
for r = 1:(N+1)/2
    rowOff = r-cb;
    numRows = bins - abs(rowOff);
    rSt1 = max(0, rowOff);
    rSt2 = abs(min(0,rowOff));
    for c = 1:N
        colOff = c-cb;
        numCol = bins - abs(colOff);
        cSt1 = max(0,colOff);
        cSt2 = abs(min(0,colOff));
        map1_local = map((rSt1+1):(rSt1+numRows),(cSt1+1):(cSt1+numCol));
        map2_local = map((rSt2+1):(rSt2+numRows),(cSt2+1):(cSt2+numCol));

        nans = max(isnan(map1_local),isnan(map2_local));
        NB = numRows * numCol - sum(sum(nans));

        if NB >= 20
            map1_local(nans) = 0;
            sumX = sum(sum(map1_local));
            sumX2 = sum(sum(map1_local.^2));
            sumx2 = sumX2 - sumX^2/NB;

            map2_local(nans) = 0;
            sumY = sum(sum(map2_local));
            sumY2 = sum(sum(map2_local.^2));
            sumy2 = sumY2 - sumY^2/NB;
            if ~((sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0))
                sumXY = sum(sum(map1_local .* map2_local));
                sumxy = sumXY - sumX*sumY/NB;
                Rxy(r,c) = sumxy/sqrt(sumx2*sumy2);
            end
        end
    end
end


% Fill the second half of the correlogram
for r = (N+1)/2+1:N
    rInd = cb + (cb - r);
    for c = 1:N
        cInd = cb + (cb - c);
        Rxy(r,c) = Rxy(rInd,cInd);
    end
end


% Sets the bins of the map outside the radius to NaN
function Rxx = adjustMap(Rxx,radius,centreRadius,oDist)


Rxx(oDist>radius) = NaN;
Rxx(oDist<=centreRadius) = NaN;





%__________________________________________________________________________
%
%                 Function for adjusting the postion samples
%__________________________________________________________________________




% Calculate the amount of the box the rat has covered
function coverage = boxCoverage(posx, posy, binWidth, boxType, radius)

binWidth = single(binWidth);

minX = nanmin(posx);
maxX = nanmax(posx);
minY = nanmin(posy);
maxY = nanmax(posy);

% Side lengths of the box
xLength = maxX - minX;
yLength = maxY - minY;

% Number of bins in each direction
colBins = ceil(xLength/binWidth);
rowBins = ceil(yLength/binWidth);

% Allocate memory for the coverage map
coverageMap = zeros(rowBins, colBins,'single');
rowAxis = zeros(rowBins,1,'single');
colAxis = zeros(colBins,1,'single');

% Find start values that centre the map over the path
xMapSize = colBins * binWidth;
yMapSize = rowBins * binWidth;
xOff = xMapSize - xLength;
yOff = yMapSize - yLength;

xStart = minX - xOff / 2;
xStop = xStart + binWidth;

for r = 1:rowBins
    rowAxis(r) = (xStart + xStop) / 2;
    ind = find(posx >= xStart & posx < xStop);
    yStart = minY - yOff / 2;
    yStop = yStart + binWidth;
    for c = 1:colBins
        colAxis(c) = (yStart + yStop) / 2;
        coverageMap(r,c) = length(find(posy(ind) > yStart & posy(ind) < yStop));
        yStart = yStart + binWidth;
        yStop = yStop + binWidth;
    end
    xStart = xStart + binWidth;
    xStop = xStop + binWidth;
end

if boxType == 1
    coverage = length(find(coverageMap > 0)) / (colBins*rowBins) * 100;
else
    fullMap = zeros(rowBins, colBins,'single');
    for r = 1:rowBins
        for c = 1:colBins
            dist = sqrt(rowAxis(r)^2 + colAxis(c)^2);
            if dist > radius
                fullMap(r,c) = NaN;
                coverageMap(r, c) = NaN;
            end
        end
    end
    numBins = sum(sum((isfinite(fullMap))));
    coverage = (length(find(coverageMap > 0)) / numBins) * 100;
end




% Calculate the Speed of the rat in each position sample
%
% Version 1.0
% 3. Mar. 2008
% (c) Raymond Skjerpeng, CBM, NTNU, 2008.
function v = speed2D(x,y,t)

N = length(x);
M = length(t);

if N < M
    x = x(1:N);
    y = y(1:N);
    t = t(1:N);
end
if N > M
    x = x(1:M);
    y = y(1:M);
    t = t(1:M);
end

v = zeros(min([N,M]),1,'single');

for ii = 2:min([N,M])-1
    v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
end
v(1) = v(2);
v(end) = v(end-1);





% Rotated the position angles according to the angle tAngle [radians]
function [newX,newY] = rotatePath(x,y,tAngle)

newX = x * single(cos(tAngle)) - y * single(sin(tAngle)); % Tilted x-coord
newY = x * single(sin(tAngle)) + y * single(cos(tAngle)); % Tilted y-coord






%__________________________________________________________________________
%
%                           Field functions
%__________________________________________________________________________



function [map, posPdf] = hdMapAdaptiveSmoothing(spkHd, posHd, sampleTime, p)

numBins = 360 / p.hdBinWidth;

map = zeros(numBins, 1);
posPdf = zeros(numBins, 1);

binPos = p.hdBinWidth / 2;
numSteps = round(numBins / 2);
for ii = 1:numBins
    n = 0;
    s = 0;
    for r = 1:numSteps
        % Set the current range
        range = r * p.hdBinWidth;
        % Number of samples within the range
        n = inRange(binPos, posHd, range);
        % Number of spikes within the range
        s = inRange(binPos, spkHd, range);
        
        if r >= p.hdAlphaValue/(n*sqrt(s))         
            break;
        end
    end
    map(ii) = s/(n*sampleTime);
    posPdf(ii) = n*sampleTime;
    binPos = binPos + p.hdBinWidth;
end


posPdf = posPdf ./ sum(posPdf);


function n = inRange(ca, angles, range)

dist = sqrt((angles - ca).^2);
ind = find(dist > 180);
dist(ind) = 360 - dist(ind);

n = length(dist(dist <= range));






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
% spkx          x-coordinate for all the spikes for a specific cell in the 
%               recording
% spky          y-coordinate for all the spikes for a specific cell in the
%               recording
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
function [map, posPdf, rowAxis, colAxis] = ratemapAdaptiveSmoothing(posx, posy, spkx, spky, xStart, xLength, yStart, yLength, sampleTime, p, shape)



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
            currentPosition = sqrt(binPosX^2 + binPosY^2);
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
                    s = insideCircle(binPosX, binPosY, radius, spkx, spky);

                    if r >= p.alphaValue/(n*sqrt(s))         
                        break;
                    end

                end
                % Set the rate for this bin
                map(jj,ii) = s/(n*sampleTime);
                posPdf(jj,ii) = n*sampleTime;
                
            end
            binPosY = binPosY + p.binWidth;
        end 

        binPosX = binPosX + p.binWidth;
    end
end

map(posPdf<0.100) = NaN;
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


% Calculates a 2 dimensional rate map. The map is smoothed with a Gaussian
% smoothing kernel implemented with a boxcar lowpass filter, that effectively
% approximates a Gaussian filter.
%
% posx          x-coordinate for all the position samples in the recording
% posy          y-coordinate for all the position samples in the recording
% spkx          x-coordinate for all the spikes for a specific cell in the recording
% spky          y-coordinate for all the spikes for a specific cell in the recording
% xBinWidth     Bin width for the bins in map in the x-direction [cm]
% yBinWidth     Bin width for the bins in map in the Y-direction [cm] (Usually the same as the x bin width)
% xLength       Length of the arena in the x-direction [cm](for cylinder this equals the diameter)
% yLength       Length of the arena in the y-direction [cm] (for cylinder this equals the diameter)
% sampleTime    Sample duarion. For Axona it is 0.02 sec, for NeuraLynx it is 0.04 sec
%
% Version 1.0   
% 13. Dec 2007
%
% Version 1.1   Optimization for speed by Jan Christian Meyer.
% 20. Jan. 2012
%
% (c) Raymond Skjerpeng, Centre for the Biology of Memory, NTNU, 2007.
function [map, rawMap, xAxis, yAxis, timeMap] = rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,xLength,yStart,yLength,sampleTime,p)

% Number of bins in each direction of the map
numBinsX = ceil(xLength/xBinWidth);
numBinsY = ceil(yLength/yBinWidth);

% Allocate memory for the maps
spikeMap = zeros(numBinsY,numBinsX);
timeMap = zeros(numBinsY,numBinsX);

xAxis = zeros(numBinsX,1);
yAxis = zeros(numBinsY,1);



% Overall objective:
% Foreach (x-bin,y-bin) pair,
% count in spikemap/timemap (xbins x ybins) the number of places where
% (spky is in ybin and spkx is in xbin)
% (posy is in ybin and posx is in xbin)

% Bucketsort spikes and samples into regular bins
% Fortranesqe base1-indexing, add 1 for good measure
spkx_bin_idx = floor(((spkx - xStart) / xBinWidth)) + 1;
spky_bin_idx = floor(((spky - yStart) / yBinWidth)) + 1;
timex_bin_idx = floor(((posx - xStart) / xBinWidth)) + 1;
timey_bin_idx = floor(((posy - yStart) / yBinWidth)) + 1;
for n=1:length(spkx_bin_idx)
    ii = spkx_bin_idx(n);
    jj = spky_bin_idx(n);
    if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
        spikeMap((numBinsY-jj+1),ii) = spikeMap((numBinsY-jj+1),ii) + 1;
    end
end
for n=1:length(timex_bin_idx)
    ii = timex_bin_idx(n);
    jj = timey_bin_idx(n);
    if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
        timeMap((numBinsY-jj+1),ii) = timeMap((numBinsY-jj+1),ii) + 1;
    end
end

% Transform the number of spikes to time
timeMap = timeMap * sampleTime;

rawMap = spikeMap ./ timeMap;
rawMap(timeMap < p.minBinTime) = NaN;

if p.smoothingMode == 0
    % Smooth the spike and time map
    spikeMap = boxcarSmoothing(spikeMap);
    timeMap = boxcarSmoothing(timeMap);
else
    % Smooth the spike and time map
    spikeMap = boxcarSmoothing3x3(spikeMap);
    timeMap = boxcarSmoothing3x3(timeMap);
end


% Calculate the smoothed rate map
map = spikeMap ./ timeMap;

map(timeMap<p.minBinTime) = NaN;

% Set the axis
start = xStart + xBinWidth/2;
for ii = 1:numBinsX
    xAxis(ii) = start + (ii-1) * xBinWidth;
end
start = yStart + yBinWidth/2;
for ii = 1:numBinsY
    yAxis(ii) = start + (ii-1) * yBinWidth;
end







% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Load the box template
box = boxcarTemplate2D();

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
   
   
   
% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing3x3(map)

% Load the box template
box = boxcarTemplate2D3by3();

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(map);

sMap = zeros(numPhaseBins,numPosBins,'single');

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        for k = 1:3
            % Phase index shift
            sii = k-1;
            % Phase index
            phaseInd = ii+sii;
            % Boundary check
            if phaseInd<1
                phaseInd = 1;
            end
            if phaseInd>numPhaseBins
                phaseInd = numPhaseBins;
            end
            
            for l = 1:3
                % Position index shift
                sjj = l-1;
                % Position index
                posInd = jj+sjj;
                % Boundary check
                if posInd<1
                    posInd = 1;
                end
                if posInd>numPosBins
                    posInd = numPosBins;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
            end
        end
    end
end
   
   
   
% Gaussian boxcar template 3 x 3
function box = boxcarTemplate2D3by3()

box = [0.075, 0.125, 0.075;...
       0.125, 0.200, 0.125;...
       0.075, 0.125, 0.075];

box = single(box);   
   
   
% Smooths the map with guassian smoothing
function sMap = mapSmoothing(map)

box = boxcarTemplate1D();

numBins = length(map);
sMap = zeros(1,numBins);

for ii = 1:numBins
    for k = 1:5
        % Bin shift
        sii = k-3;
        % Bin index
        binInd = ii + sii;
        % Boundry check
        if binInd<1
            binInd = 1;
        end
        if binInd > numBins
            binInd = numBins;
        end
        
        sMap(ii) = sMap(ii) + map(binInd) * box(k);
    end
end

% 1-D Gaussian boxcar template 5 bins
function box = boxcarTemplate1D()

% Gaussian boxcar template
box = [0.05 0.25 0.40 0.25 0.05];





% Finds the position to the spikes
function [spkx,spky,spkInd] = spikePos(ts,posx,posy,post)

ts(ts>post(end)) = [];
N = length(ts);
spkx = zeros(N,1,'single');
spky = zeros(N,1,'single');
spkInd = zeros(N,1,'single');

count = 0;
currentPos = 1;
for ii = 1:N
    ind = find(post(currentPos:end) >= ts(ii),1,'first') + currentPos - 1;

    % Check if spike is in legal time sone
    if ~isnan(posx(ind))
        count = count + 1;
        spkx(count) = posx(ind);
        spky(count) = posy(ind);
        spkInd(count) = ind(1);
    end
    currentPos = ind;
end
spkx = spkx(1:count);
spky = spky(1:count);
spkInd = spkInd(1:count);

                    
%__________________________________________________________________________
%
%                       Graphics functions
%__________________________________________________________________________





% Function for storing figures to file
% figHanle  Figure handle (Ex: figure(1))
% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps
% format = 4 -> jpg
% format = 5 -> tiff (24 bit)
% format = 6 -> fig (Matlab figure)
% figFile   Name (full path) for the file
% dpi       DPI setting for the image file
function imageStore(figHandle,format,figFile,dpi)

% Make the background of the figure white
set(figHandle,'color',[1 1 1]);
dpi = sprintf('%s%u','-r',dpi);

switch format
    case 1
        % Store the image as bmp (24 bit)
        figFile = strcat(figFile,'.bmp');
        print(figHandle, dpi, '-dbmp',figFile);
    case 2
        % Store image as png
        figFile = strcat(figFile,'.png');
        print(figHandle, dpi,'-dpng',figFile);
    case 3
        % Store image as eps (Vector format)
        figFile = strcat(figFile,'.eps');
        print(figHandle, dpi,'-depsc',figFile);
    case 4
        % Store image as jpg
        figFile = strcat(figFile,'.jpg');
        print(figHandle,dpi, '-djpeg',figFile);
    case 5
        % Store image as tiff (24 bit)
        figFile = strcat(figFile,'.tif');
        print(figHandle,dpi, '-dtiff',figFile);
    case 6
        % Store figure as Matlab figure
        figFile = strcat(figFile,'.fig');
        saveas(figHandle,figFile,'fig')
end



% drawMap(map, xAxis, yAxis)
%
% drawMap draws the rate map in a color coded image, using the jet color
% map. The number of color used for the scaling can be changed in the
% variable numLevels.
%
% map       Rate map that is to be displayed as image
% xAxis     The x-axis values (values for each column in the map)
% yAxis     The y-axis values (values for each row in the map)
%
% (c) Raymond Skjerpeng, KI/CBM, NTNU, 2012.
function drawMap(map, xAxis, yAxis, cmap, maxRate)

map(map>maxRate) = maxRate;

% Set the number of colors to scale the image with. This value must be the
% same as the number of levels set in the getCmap function.
numLevels = 256;

% Size of rate map
[numRows,numCols] = size(map);

% Allocate memory for the image
plotMap = ones(numRows,numCols,3);

% Peak rate of the map
peakRate = max(nanmax(map));

% set color of each bin scaled according to the peak rate, bins with NaN
% will be plotted as white RGB = [1,1,1].
for r = 1:numRows
    for c = 1:numCols
        if ~isnan(map(r,c))
            % Set the color level for this bin
            level = round((map(r,c) / peakRate) * (numLevels-1)) + 1;
            plotMap(r,c,:) = cmap(level,:);
        end
    end
end

% Display the image in the current figure window. (window must be created
% before calling this function
image(xAxis,yAxis,plotMap);
% Adjust axis to the image format
axis('image')




function cmap = getCmap()

% Set the number of colors to scale the image with
numLevels = 256;

% set the colormap using the jet color map (The jet colormap is associated 
% with an astrophysical fluid jet simulation from the National Center for 
% Supercomputer Applications.)
cmap = colormap(jet(numLevels));






