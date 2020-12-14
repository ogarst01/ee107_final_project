% Olive Garst
% Dec. 2020
T_bit = 1;
fs = 32;
%signal = randi([0 1], 1, 10);
signal = [0 0 1 1 1 0 1 1 0 1];

[rxSRRC, rxHS, channel] = transmitter(T_bit, fs, signal);
signal = rxSRRC;
%%
% EE 107 final project 
% h = zeros(1,4);
% h(1) = 1;
% h(2) = 0.5;
% h(3) = 0.75;
% h(4) = -2/7;

% for debugging:
channelResponse = channel;

%function response = zeroFilterEqualizer(channelResponse, signal)
H = fftshift(fft(channelResponse,1024));

% TODO - figure out how to truncate? 

% invert to make the Zero forcing response:
HZF = 1./H;

hzt = ifft(HZF);

% make the signal output: 
forcedZeroSign = fftshift(ifft(HZF.*fft(signal,1024)));
%
% upsample the output
responseUp = upsample(forcedZeroSign, 32);
hUp = upsample(channel, 32);

figure, 
hold on
plot(abs(HZF), 'g')
plot(abs(H), 'r')
legend('ZF', 'channel')
hold off
title('zero forcing freq response vs. channel freq response')

%%
figure, plot(abs(H.*HZF))
title('plot to check the H * HZF = 1')

%%
HZF = fftshift(fft(1./H));
freqz(HZF)

freqz()
% end