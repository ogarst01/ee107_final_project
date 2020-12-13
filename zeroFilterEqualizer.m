% Olive Garst
% Dec. 2020
% EE 107 final project 
% h = zeros(1,4);
% h(1) = 1;
% h(2) = 0.5;
% h(3) = 0.75;
% h(4) = -2/7;
% 
% h3 = upsample(h, 32);
% 
% %zeroFilterEqualizer(h3);
% channelResponse = h3;
function response = zeroFilterEqualizer(channelResponse, signal)

NZfilter = 1./(fftshift(fft(channelResponse, 10000)));
response = ifft(NZfilter, 10000);
% filter is inverse of channel response: 

% check why F(f)xC(f) = 1
% fft(channelResponse).*response -> all 1's
% works! 

%% Q10: plot the freqz response of this filter:
figure,
freqz(response)
title('frequency respone of ifft(1/channel)')

figure,
freqz(NZfilter)
title('frequency respone of 1/fft(channel)')

%end
