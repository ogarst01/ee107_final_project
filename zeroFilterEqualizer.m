% Olive Garst
% Dec. 2020
function trimmed = zeroFilterEqualizer(channelResponse, signal)
% Inputs:   channel impulse response
%           signal to be equalize
%           
% Outputs: equalized signal

% do not put 0's at the last bit (don't pad)

signal2 = signal;%srrc_convolved;

channelResponse2 = channelResponse;

NFFT = 10*length(signal);

H = fft(channelResponse2, NFFT);

% invert to make the Zero forcing response:
HZF = 1./H;

hzt = (ifft(HZF, NFFT));
% 
% figure, 
% hold on
% plot(abs(HZF), 'g')
% plot(abs(H), 'r')
% legend('ZF', 'channel')
% hold off
% title('zero forcing freq response vs. channel freq response')
% 
% %%
% figure, plot(abs(H.*HZF))
% title('plot to check the H * HZF = 1')


%% Plot in time the impulse response of the equalizer:
% figure, 
% plot(hzt)
% title('equalizer impulse response in time')

%%
% make the signal output: 

forcedZeroSign = conv(hzt,signal2);
total_convolution_length = length(conv(hzt, channelResponse2)) + 1;
desired_length = length(forcedZeroSign) - total_convolution_length + 1;
trimmed = forcedZeroSign(1:desired_length+1);

end