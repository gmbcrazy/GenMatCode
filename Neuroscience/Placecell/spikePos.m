function [spkx,spky,spkInd,varargout] = spikePos(ts,posx,posy,post)

% Finds the position to the spikes

ts(ts>post(end)) = [];
N = length(ts);
spkx = zeros(N,1,'single');
spky = zeros(N,1,'single');
spkInd = zeros(N,1,'single');
TSneed = zeros(N,1);

count = 0;
currentPos = 1;
NeedTSInd=[];

for ii = 1:N
    ind = find(post(currentPos:end) >= ts(ii),1,'first') + currentPos - 1;

    % Check if spike is in legal time sone
    if ~isnan(posx(ind))
        count = count + 1;
        spkx(count) = posx(ind);
        spky(count) = posy(ind);
        spkInd(count) = ind(1);
        TSneed(count)=ts(ii);
        NeedTSInd=[NeedTSInd;ii];
    end
    currentPos = ind;
end
spkx = spkx(1:count);
spky = spky(1:count);
spkInd = spkInd(1:count);
TSneed=TSneed(1:count);


if nargout==4
   varargout{1}=TSneed;
elseif nargout==5
   varargout{1}=TSneed;
   varargout{2}=NeedTSInd;

end




% 
% ts=sort(ts);
% post=sort(post);
% 
% n=histc(ts,post);
% index=find(n~=0);
% 
% spkx=[];
% spky=[];
% spkInd=[];
% 
% for i=1:length(index)
%     spkx=[spkx;zeros(n(index(i)),1)+posx(index(i))]; 
%     spky=[spky;zeros(n(index(i)),1)+posy(index(i))];
%     spkInd=[spkInd;zeros(n(index(i)),1)+index(i)];
% end



