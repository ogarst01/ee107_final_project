%function forcedZeroSign = zeroFilterEqualizer(channelResponse, signal)

channelResponse = channel_impulse_response;
signal = srrc_convolved;

H = (fft(channelResponse));

% TODO - figure out how to truncate? 

% invert to make the Zero forcing response:
HZF = 1./H;

hzt = (ifft(HZF));

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


%% Plot in time the impulse response of the equalizer:
figure, 
plot(real(hzt))
title('equalizer impulse response in time')

%%
HZF = fft(1./H);

% make the signal output: 

hzt = real(hzt);
forcedZeroSign = conv(hzt, signal);

figure,
plot(conv(hzt,channel_impulse_response))

figure, 
subplot(2,1,1)
plot(real(forcedZeroSign))
title('output signal after convolution in time')
subplot(2,1,2)
plot(signal)
title('original signal')
%end
% 
% % Olive Garst
% % Dec. 2020
% T_bit = 1;
% fs = 32;
% %signal = randi([0 1], 1, 10);
% % signal = [0 0 1 1 1 0 1 1 0 1];
% 
% % [rxSRRC, rxHS, channel] = modulator(T_bit, fs, signal);
% rxSRRC = srrc_convolved;
% rxHS = srrc_matched_filter_impulse;
% 
% % signal = rxSRRC;
% 
% %% to do : get channel 
% 
% %%
% % EE 107 final project 
% h = zeros(1,4);
% h(1) = 1;
% h(2) = 0.5;
% h(3) = 0.75;
% h(4) = -2/7;
% 
% % for debugging:
% channelResponse = h;
% channel = h;