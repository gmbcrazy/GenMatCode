function waveout=alignWaveForm(waveform,varargin)

if nargin==1
   type=1;   %%%%%%%%%align data by negative peak
else
   type=varargin{1};
   %%%%%%%%%%type=2;%%%%%%%%%align data by negative peak after the first postive peak
   %%%%%%%%%%type=3;%%%%%%%%%align data by postive peak
   %
end
    

if type==1
   waveout=align(waveform);
elseif type==2
      waveout=align(waveform);

elseif type==3
      waveout=-align(-waveform);
else
    
end





function waveout=align(waveform)

for i=1:length(waveform(:,1))
    [valey(i),valey_index(i)]=min(waveform(i,:));
end

max_index=max(valey_index);
move_num=max_index-valey_index;
max_move_num=max(move_num);

waveout=zeros(length(waveform(:,1)),length(waveform(1,:)));
waveform_l=length(waveform(1,:));
for i=1:length(waveform(:,1))
    waveout(i,move_num(i)+[1:waveform_l])=waveform(i,[1:waveform_l]);
end
