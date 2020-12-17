% Olive Garst
% Dec. 2020
function [forcedZeroSign, hzt, channelResponse, t, HZF, H, f] = zeroFilterEqualizer(channelResponse, signal, fs, lengthOriginal)

signal2 = signal;
channelResponse2 = channelResponse;

NFFT = 10*length(signal);

H = fft(channelResponse2, NFFT);

HZF = 1./H;

hzt = (ifft(HZF, NFFT));

forcedZeroSign = conv(hzt,signal2);t = 1;f = 1;
end