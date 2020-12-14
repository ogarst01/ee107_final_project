function [srrc_filtered,half_sine_filtered, h] = channelDistortion(half_sine_modulated, srrc_modulated)
%% channel: 
lenChannel = 4;
N = 32;
h = zeros(1,4);
h(1) = 1;
h(2) = 0.5;
h(3) = 0.75;
h(4) = -2/7;

% TODO - try upsample command later
zeroPad = zeros(1,31);

h = [zeroPad, h(1), zeroPad, h(2), zeroPad, h(3), zeroPad, h(4), zeroPad];

% now send the modulated bit stream through the filter:
half_sine_filtered = conv(half_sine_modulated,h);
srrc_filtered = conv(srrc_modulated,h);

figure,
freqz(half_sine_filtered);
title('frequency response of filtered half sine')

figure,
freqz(srrc_filtered);
title('frequency response of filtered SRRC')
end