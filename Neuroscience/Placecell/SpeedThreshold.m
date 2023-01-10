% Mehdi 05092016 :Comments added.
% Some comments where added from before (specially those written "Rat")
% Changes (mehdi):
% 1. speed was indexed based on SpeedThreshold and added as an output
% 2. speed is calculated from previous motion information to adopt with motion vector definition
%
% function [x,y,t] = SpeedThreshold(x,y,t,lowSpeedThreshold,highSpeedThreshold)
function [x,y,t,speed] = SpeedThreshold(x,y,t,lowSpeedThreshold,highSpeedThreshold) 

% % load variables.mat

%strange code, this value is called and replaced by its own value!
p.lowSpeedThreshold = lowSpeedThreshold;
p.highSpeedThreshold = highSpeedThreshold;

if p.lowSpeedThreshold > 0 || p.highSpeedThreshold > 0
    
    %disp('Applying speed threshold');
    % Calculate the speed of the rat, sample by sample
    speed = speed2D(x,y,t);

    % uses speeds between lowSpeedThreshold and highSpeedThreshold
    if p.lowSpeedThreshold > 0 && p.highSpeedThreshold > 0
        ind = find(speed < p.lowSpeedThreshold | speed > p.highSpeedThreshold);
        
        % only used speeds smaller than lowSpeedThreshold
    elseif p.lowSpeedThreshold > 0 && p.highSpeedThreshold == 0
        ind = find(speed < p.lowSpeedThreshold);
        
        % only used speeds higher than highSpeedThreshold
    else
        ind = find(speed > p.highSpeedThreshold);
    end
    
    % Remove the segments that are out of segments selected above for speed
    x(ind) = NaN;
    y(ind) = NaN;
    
    % (mehdi)
    speed(ind) = NaN;   
else % no threshold used, just speed-output is calculated
    speed = speed2D(x,y,t);
end
    
% Calculate the Speed of the rat in each position sample
function v = speed2D(x,y,t)

N = length(x);
M = length(t);

% Bellow codes assume x,y, and t have same sampling-frea, but just one is extended compared to the other one.
% If one is extended, use the length of shorter one : x=x(1:(min(N,M)))
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

% init. speed
v = zeros(min([N,M]),1,'single');

% instant-speed calculation. using the next point!
% for ii = 2:min([N,M])-1
%     v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
% end
% 
% v(1) = v(2);
% v(end) = v(end-1);

% instant-speed calculation. causal(lag)!
for ii = 2:min([N,M])
    v(ii) = sqrt((x(ii)-x(ii-1))^2+(y(ii)-y(ii-1))^2)/(t(ii)-t(ii-1));
end

v(1) = v(2);
