%function signalRecovered = MMSEEqualizer(signal, sigma2, channel_impulse_resp)
%HS_MSSE   = MMSEEqualizer(hs_convolved, sqrtNsPowr2, channel_impulse_response);

signal = hs_convolved;
sigma2 = sqrtNsPowr2;
channel_impulse_resp = channel_impulse_response;

NFFT = length(signal)*20;
% define energy Eb of pulse for SNR calculation:
% Eb = (norm(g_t))^2;
Eb = 1;
% quick check -> Eb should be 1. 

% calculate SNR given noise power sigma squared(sigma2)
SNR  = sigma2./Eb;

%H = fft(downsample(channel_impulse_resp, 31));

h_upsample = channel_impulse_resp;
H = (fft(h_upsample, NFFT));
%H = fft(channel_impulse_resp);
%H = fft(channel_impulse_resp);

Hconj = conj(H);

% calculate the frequency response of the MMSE Equalizer:
HMMSE = Hconj./((abs(H)).^2 + (SNR));

% find signal in freq domain:
Xf = fft(signal, NFFT);

% fine the frequency response using fft method:
% Xf = 1x3233
% HMMSE = 
signalRecovered = conv(signal, ifft(HMMSE, NFFT));
trimmed = signalRecovered(1:length(hs_convolved));    

figure,
subplot(5,1,1)
plot(trimmed)
title('output of equalizer')
subplot(5,1,2)
plot(hs_convolved)
title('after matched filter:')
subplot(5,1,3)
plot(hs_modulated)
title('output of modulated signal')
subplot(5,1,4)
plot(post_channel_hs)
title('output of channel')
subplot(5,1,5)
plot(half_sine_filtered_noisy)
title('noisy signal through channel')

% plot the convolution of the impulse response of the equalizer and the
% channel:
figure, 
plot(conv(channel_impulse_resp, ifft(HMMSE)))
%end