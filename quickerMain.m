%function [bitStreamHS_ZF,bitStreamSRRC_ZF,bitStreamHS_MMSE,bitStreamSRRC_MMSE] = quickerMain(signal, sqrtNsPowr2)
sqrtNsPowr2 = 0.01;

%signal = bitStream;

% define some constants:
T_bit = 1;
fs = 32;
signal = bitStream; %randi([0 1], 1, 1006);
% signal = [0 0 1 1 1 0 1 1 0 1];
% signal= [0 0 0 0 0 0 1 0 0 0 0 0 0];
% signal = zeros(1, 100);
% signal(50) = 1;

% Outdoor channel really doesn't work:
%channelType = 'outdoor';
%channelType = 'indoor ';
channelType = 'starter';
% signal = signalVec;

%% Modulate signal:
% make the transmitted signal, thru channel + add noise: 
[srrc_modulated, hs_modulated, t, K] = modulator(T_bit, fs, signal);

%% Channel Distortion

[channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc_modulated,hs_modulated, channelType);

%% White Gaussian Noise

% whether or not to display images of different noise powers: 
testing = false;
% sqrt of noise power: 

[srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(post_channel_hs, post_channel_srrc, testing, sqrtNsPowr2, T_bit, fs);

% for debugging - with no noise:
%% Matched Filter
graphImpulse = false;
[srrc_convolved, srrc_matched_filter_impulse, hs_convolved, hs_matched_filter_impulse] = matchedFilter(srrc_filtered_noisy, half_sine_filtered_noisy, graphImpulse);


%% Equalizers
lengthOriginal = length(signal);
% feed the transmitted signals into the receiver:
[SRRC_equalized, hzt, ht, t, HZF, H, f] = zeroFilterEqualizer(channel_impulse_response, srrc_convolved, fs, lengthOriginal);
[HS_equalized, ~, ~, ~, ~, ~]   = zeroFilterEqualizer(channel_impulse_response, hs_convolved, fs, lengthOriginal);


%% MMSE Equalizer code: 

[SRRC_MSSE, HMMSE1] = MMSEEqualizer(srrc_convolved, sqrtNsPowr2, channel_impulse_response);
[HS_MSSE, HMMSE2]   = MMSEEqualizer(hs_convolved, sqrtNsPowr2, channel_impulse_response);


%% Sampling

% grab bits from ZF equalizer
[hs_symbols] = sample_hs(HS_equalized);
hs_bits = (hs_symbols + 1) / 2;

[srrc_symbols] = sample_srrc(SRRC_equalized);
srrc_bits = srrc_symbols;

% grab bits from MMSE equalizer
[hs_symbols] = sample_hs(HS_MSSE);
hs_bits_MMSE = (hs_symbols + 1) / 2;

[srrc_symbols] = sample_srrc(SRRC_MSSE);
srrc_bits_MMSE = srrc_symbols;

bitStreamHS_ZF = hs_bits;
bitStreamSRRC_ZF = srrc_bits;
bitStreamHS_MMSE = hs_bits_MMSE;
bitStreamSRRC_MMSE = srrc_bits_MMSE;

%%
figure,
plot(double(srrc_bits_MMSE) - double(signal), 'r')
title('error plot for SRRC - MMSE')
ylim([-2,2])

figure,
plot(double(hs_bits_MMSE) - double(signal), 'r')
title('error plot for HS - MMSE')
ylim([-2,2])
%%
figure,
plot(double(srrc_bits(1:length(signal))) - double(signal), 'r')
title('error plot for SRRC - ZF')
ylim([-2,2])

figure,
plot(double(hs_bits(1:length(signal))) - double(signal), 'r')
title('error plot for HS - ZF')
ylim([-2,2])

% figure,
% subplot(2,1,1)
% plot(signal)
% title('output of modulated signal - SSRC')
% title('after matched filter - SSRC')
% subplot(2,1,2)
% plot(hs_bits)
% title('output of equalizer (recovered signal) - SSRC')