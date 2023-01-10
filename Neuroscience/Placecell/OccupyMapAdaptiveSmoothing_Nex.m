% Mehdi 05092016: Comments added.
% Mehdi 14092016: Changes added.
% Changes: 
% 1. vectorPosition was converted to a unity vecotr to contain pure
%    direction information. this was named "direction_map"
% 2. distance_map, speed_map, and pass_map were added.
function [occ_map, Vectormap, aRowAxis, aColAxis, DistanceIndex, direction_map, distance_map, speed_map, pass_map, ppc, ppcCohPass, ppcCohOccp, plv, plvCoh] = OccupyMapAdaptiveSmoothing_Nex(filename,timerange,p)

% filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';
% cellName='Ch13Cell1';
%p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
%p.ImageSize=[132.99 132.99];
% p.sampleTime=1/adfreq;
p.binWidth=4;
% p.minBinTime=0.02;
% p.smoothfactor=[1 1];
% p.lowSpeedThreshold=5;
% % % p.highSpeedThreshold=0;
% p.RawminBinTime=0.1;
% p.alphaValue=1000;

% load variables.mat

clearvars -except NexFile FileIndex AnalysisP p ParameterFilter  filename timerange

% PosX: PosXSmooth.
% ts: First-TimeStamp of PosXSmooth (assmued same for PosXSmooth and PosYSmooth).
% Ypos: PosYSmooth.
% adfreq: sampling frequency of PosYSmooth (assmued same for PosXSmooth and PosYSmooth)
% NumPos: length(Ypos)
[~,~,~,~,PosX] = nex_cont2(filename,'PosXSmooth');
[adfreq,NumPos,ts,~,PosY] = nex_cont2(filename,'PosYSmooth');

% creating PosX/PosY timeStamps
temp_time = ts+((1:length(PosX))-1)/adfreq;

% creating index for PosX/PosY timeStamps which is in the valid "timerange"
temp_index = [];
for i = 1:length(timerange(1,:))
     [temp_index] = [temp_index;find(timerange(1,i)<temp_time & temp_time<timerange(2,i))];
end

% analysis only for valid "timerange"
PosX = PosX(temp_index);
PosY = PosY(temp_index);

clear temp_index temp_time

% Lag of tracking compared to the stimultion-time (& ephys) = firt time-stamp
Lag = ts;

% loads the image used for ???
fileimage = p.fileimage;

% read the image (arena: X-pixels x Y-pixels x color)
arena = imread(fileimage);

% loads the image-size used for ???
ImageSize = p.ImageSize;

% finds the outline of apparatus (The black-color region)
[cols,rows,~] = find(arena(:,:,1)<15 & arena(:,:,2)<15 & arena(:,:,3)<15);

% conversion from pixels to cm
% image is 512x512 pixel, so the arena size is converted to cm by multiplying to total-cm/total-pixel
rows = rows*ImageSize(1)/512;
cols = cols*ImageSize(2)/512;

% Defines the x- and y-limits of behaviour (the black line)
Xstart = min(rows); Xend=max(rows);
Ystart = min(cols); Yend=max(cols);

% x-timestamps: ((1:NumPos)-1)*p.sampleTime+Lag
% generates new pos-x and -y which pass the SpeedThreshold
[x,y,~,speed] = SpeedThreshold(PosX, PosY, ((1:NumPos)-1)*p.sampleTime+Lag, p.lowSpeedThreshold, p.highSpeedThreshold);

[occ_map,IndexMap,~,aRowAxis,aColAxis] = OccupancyVector_map(x,y,Xstart,Ystart,Xend,Yend,p);

x=x(:);
y=y(:);

NormTrace=NORMtrace([x y],p);
x=NormTrace(:,1);
y=NormTrace(:,2);



% instant direction vector
directVector = [diff(x) -diff(y)];

% instant distance movement
distance = [diff(x) -diff(y)];

% for vectorMap (Lu's definition)
vectorPosition = [diff(x) -diff(y)];
vectorPosition(isnan(vectorPosition)) = 0;

% (mehdi)
%--------------------------------------------------------------------------
% make unity movement vecotr (independent of speed), pure direction
%--------------------------------------------------------------------------
% to avoid devision by zero (remove directVector=0+0i)
if ~isempty(find(directVector(:,1)==0 & directVector(:,2)==0, 1))
    directVector(directVector(:,1)==0 & directVector(:,2)==0, :)=[nan nan];
end 
directVector = directVector./[sqrt(directVector(:,1).^2+directVector(:,2).^2)  sqrt(directVector(:,1).^2+directVector(:,2).^2)]; % devision by each vector-length
%--------------------------------------------------------------------------
% Set instant movement vector zero for those nan(out of speedThreshold)
directVector(isnan(directVector)) = 0;
distance(isnan(distance)) = 0;

[m,n] = size(IndexMap);

% X- and Y-coordinates of vectorMap
VectormapX = zeros(m,n);
VectormapY = zeros(m,n);

% direction_map in bin i-j (= directionMapX + i* directionMapY)
DirectMapX = zeros(m,n);
DirectMapY = zeros(m,n);

% (mehdi)
% Total distance travelled in bin i-j
distance_map = zeros(m,n);
% Average speed in bin i-j
speed_map = zeros(m,n);
% The number of passages in bin i-j
pass_map = zeros(m,n);

DistanceWhole = 0;
NUMvisit = zeros(m,n);

% pairwise phase/length consistency
ppc_map = nan*zeros(m,n);
plv_map = nan*zeros(m,n);


% loops over the whole bins of the map

% So, it assumes that
% r(n) = [x(n+1)-x(n)]+i*[y(n+1)-y(n)]
% Rk-l = ?_(n?Bin(k,l))?r(n)?
% r(n): position vector of sample n-th
% Rk-l: value of vector map in the bin k-l
% And so this calculation doesn’t include the very last sample
for i = 1:m
    for j = 1:n
        % Return IndexMap{i,j} removing the very last position sample if exist in bin i-j
            %(removes IndexMap{i,j}==length(x), "last-index")
        % so it has assumed that vec(n) =x(n)-x(n-1)+i*y(n)-y(n-1). value of vec(n) at time(n)
        % vec_ij = vec_x+i*vec_y
        IndexMap{i,j} = setdiff(IndexMap{i,j},length(x));
        
        if ~isempty(IndexMap{i,j})
            % if atleast two samples in bin i-j has happenned (if not, direction_map of that bin will be zero)
            if length(IndexMap{i,j})>=2
                % VectormapX+1i*VectormapY
                VectormapX(i,j)= sum(vectorPosition(IndexMap{i,j},1));
                VectormapY(i,j)= sum(vectorPosition(IndexMap{i,j},2));
                
                % number of samples in bin i-j
                NUMvisit(i,j) = length(IndexMap{i,j});
                % distance travelled in bin i-j               
                temp = sum(sqrt(sum(directVector(IndexMap{i,j},:)'.^2)));
                
                % Total distance
                DistanceWhole = DistanceWhole + temp;                
                
                % DirectMapX+i*DirectMapY (i:in formula imaginary indic) is the resultant vecotr of all passes in bin  k-l 
                DirectMapX(i,j)= sum(directVector(IndexMap{i,j},1));
                DirectMapY(i,j)= sum(directVector(IndexMap{i,j},2));
                
                % added by mehdi.
                % Distance-map: Distance travelled in bin i-j
                distance_map(i,j) = sum(sqrt(sum(distance(IndexMap{i,j},:)'.^2)));
                % average speed in bin i-j
                speed_map(i,j) = mean(speed(IndexMap{i,j}));                 
                
                % find the number of "pass" : non-continous pass through a bin
                df = diff(IndexMap{i,j});
                df(df<=1) = [];         % "<=" was used instead of "==" in case of repetiotion index in IndexMap{i,j}; though shouldn' happend
                pass_map(i,j) = length(df)+1;
                
                                
                % calculating binwise angular direction consistency (mehdi)
                % ---------------------------------------------------------
                idx = find(diff(IndexMap{i,j})~=1);
%                 pass= cell(5,1);
                pass={};
                if isempty(idx)
                    pass{1,1} = IndexMap{i,j}; % all current indexes belong to one pass
                else
                    pass{1,1} = IndexMap{i,j}(1:idx(1));
                    for kk=1:length(idx)-1
                        pass{end+1,1} = IndexMap{i,j}(idx(kk)+1:idx(kk+1));
                    end
                    pass{end+1,1} = IndexMap{i,j}(idx(end)+1:length(IndexMap{i,j}));
                end  
                
                dirPass = nan*ones(length(pass),1);
                if length(pass)>1
                    for kk=1:length(pass)
                        dirPass(kk,1) = sum(directVector(pass{kk},1))+1i*sum(directVector(pass{kk},2));
                    end 
                    ppc_map(i,j) = calcPPC(angle(dirPass));
                    plv_map(i,j) = abs(sum(dirPass)) / length(dirPass);                    
                else
                    ppc_map(i,j) = nan;
                    plv_map(i,j) = nan;
                end                                
                % ---------------------------------------------------------
            end
        end
    end
end
% to match the occ_map, those limits of occ_map was set to distance_map, speed_map, and pass_map
VectormapY(isnan(VectormapY)) = 0;
VectormapX(isnan(VectormapX)) = 0;

VectormapY(isnan(occ_map)) = 0;
VectormapX(isnan(occ_map)) = 0;

% DistanceIndex: The average vector length normalized by total travelled distance
% Calculates average direction_map length in each bin, and averages the total direction_map in all bins by the total travelled distance
DistanceIndex = sum(sum(sqrt(DirectMapY.^2+DirectMapX.^2)))/DistanceWhole;




% 
clear Temp
Temp=NORMtrace([aColAxis(:) aRowAxis(:)],p);
aColAxis=Temp(:,1);
aRowAxis=Temp(:,2);
aRowAxis=aRowAxis(end:-1:1);

% aRowAxis=aRowAxis+p.binWidth/100/2;

% VectormapY=VectormapY.*weighted;


%??
meshgrid(aColAxis,aRowAxis);

% coloumn-wise vectorMap
VectormapX = VectormapX(:);
VectormapY = VectormapY(:);
Vectormap = [VectormapX VectormapY];

%(mehdi)
% Distance-map normalized by the total travelled distance. (normalization)
distance_map = distance_map/sum(distance_map(:));

% speed_map normalized to the overall average speed of animal in this session (normalization)
speed_map = speed_map/mean(speed_map(:));

% devide by total passes through all bin (normalization)
pass_map = pass_map/sum(pass_map(:));
% pass_map = ppc_map+1;

% ppc and plv
ppc_map(occ_map==0) = nan;
ppc_map(isnan(occ_map)) = nan;
ppc = mean(ppc_map(~isnan(ppc_map)));

plv_map(occ_map==0) = nan;
plv_map(isnan(occ_map)) = nan;
plv = mean(plv_map(~isnan(plv_map)));

% ppcCoh, and plvCoh
% when pass is 1, ppc_map is "nan", so count this in sigma of pass_map
index1 = ~isnan(ppc_map(:));
index2 = ~isnan(pass_map(:));
ppcCohPass = sum(ppc_map(index1).*pass_map(index1))/sum(pass_map(index2));

index1 = ~isnan(ppc_map(:));
index2 = ~isnan(occ_map(:));
ppcCohOccp = sum(ppc_map(index1).*occ_map(index1))/sum(occ_map(index2));


index1 = ~isnan(plv_map(:));
index2 = ~isnan(pass_map(:));
plvCoh = sum(plv_map(index1).*pass_map(index1))/sum(pass_map(index2));

% to match the occ_map, those limits of occ_map was set to distance_map, speed_map, and pass_map
speed_map(occ_map==0)    = 0;
distance_map(occ_map==0) = 0;
speed_map(isnan(occ_map))    = 0;
distance_map(isnan(occ_map)) = 0;

pass_map(occ_map==0) = 0;
pass_map(isnan(occ_map)) = 0;

% pass_map(occ_map==0) = nan;
% pass_map(isnan(occ_map)) = nan;

DirectMapY(isnan(DirectMapY)) = 0;
DirectMapX(isnan(DirectMapX)) = 0;

DirectMapY(isnan(occ_map)) = 0;
DirectMapX(isnan(occ_map)) = 0;

% coloumn-wise direction_map
DirectMapX = DirectMapX(:);
DirectMapY = DirectMapY(:);
direction_map = [DirectMapX DirectMapY];







% ppc definition from Vinck et al, neuroimage (2010)
function ppc = calcPPC(phRad)

% number of phases
N = length(phRad);

% formula (14)
ppc=0;
for ii=1:N-1
    for jj=ii+1:N
        ppc = ppc + cos(phRad(ii))*cos(phRad(jj))+sin(phRad(ii))*sin(phRad(jj));
    end
end
ppc = ppc * 2/N/(N-1);