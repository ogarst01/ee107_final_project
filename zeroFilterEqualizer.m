% Olive Garst
% Dec. 2020
function [trimmed, hzt, channelResponse2, t, HZF, H, f] = zeroFilterEqualizer(channelResponse, signal, fs)
% Inputs:   channel impulse response
%           signal to be equalize
%           
% Outputs: equalized signal

% do not put 0's at the last bit (don't pad)

channelResponse2 = channelResponse;

NFFT = 10*length(signal);
H = fft(channelResponse2, NFFT);

% invert to make the Zero forcing response:
HZF = 1./H;

hzt = (ifft(HZF, NFFT));
t = 0:1/fs:(length(hzt)-1)/fs;

forcedZeroSign = conv(hzt,signal);
% The result of the above convolution produces a signal that is WAY too
% long.  Trim down to length:
total_convolution_length = length(conv(hzt, channelResponse2)) + 1;
desired_length = length(forcedZeroSign) - total_convolution_length + 1;
trimmed = forcedZeroSign(1:desired_length+1);

H = fftshift(H);
HZF = fftshift(HZF);
f = fs*(-NFFT/2:NFFT/2-1)/NFFT;
end