function cfs = smoothCFSMorletMatlab(cfs,scales,dt,ns)
N = size(cfs,2);
npad = 2.^nextpow2(N);
omega = 1:fix(npad/2);
omega = omega.*((2*pi)/npad);
omega = [0., omega, -omega(fix((npad-1)/2):-1:1)];

% Normalize scales by DT because we are not including DT in the
% angular frequencies here. The smoothing is done by multiplication in
% the Fourier domain
normscales = scales./dt;
for kk = 1:size(cfs,1)
    F = exp(-0.25*(normscales(kk)^2)*omega.^2);
    smooth = ifft(F.*fft(cfs(kk,:),npad));
    cfs(kk,:)=smooth(1:N);
end
% Convolve the coefficients with a moving average smoothing filter across
% scales
H = 1/ns*ones(ns,1);
cfs = conv2(cfs,H,'same');
