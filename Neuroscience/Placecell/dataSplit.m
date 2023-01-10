function splitDataArray = dataSplit(x, y, t, hdDir)

% Splits the session data into two halves

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
    



