function y=Noise50HzRemove(data,fs,f0)
% f0 = 50;                %#notch frequency
fn = fs/2;              %#Nyquist frequency
freqRatio = f0/fn;      %#ratio of notch freq. to Nyquist freq.
notchWidth = 0.0025;       %#width of the notch
% notchWidth = 0.025;       %#width of the notch

%Compute zeros
zeros = [exp( sqrt(-1)*pi*freqRatio ), exp( -sqrt(-1)*pi*freqRatio )];
%#Compute poles
poles = (1-notchWidth) * zeros;

% figure;
% zplane(zeros.', poles.');

b = poly( zeros ); %# Get moving average filter coefficients
a = poly( poles ); %# Get autoregressive filter coefficients

% figure;
% freqz(b,a,32000,fs)

%#filter signal x
y = filter(b,a,data);