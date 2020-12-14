% function signalRecovered = MMSEEqualizer(signal, sigma2, channel_impulse_resp)

% for debugging:
sigma2 = sqrtNsPowr2;
signal = hs_convolved;
channel_impulse_resp = channel_impulse_response;

% define energy Eb of pulse for SNR calculation:
% Eb = (norm(g_t))^2;
Eb = 1;
% quick check -> Eb should be 1. 

% calculate SNR given noise power sigma squared(sigma2)
SNR  = sigma2./Eb;

%H = fft(downsample(channel_impulse_resp, 31));

NFFT = 32;

h_upsample = upsample(channel_impulse_resp, 31);
H = (fft(h_upsample, length(channel_impulse_resp)));
%H = fft(channel_impulse_resp);
%H = fft(channel_impulse_resp);

Hconj = conj(H);

% calculate the frequency response of the MMSE Equalizer:
HMMSE = Hconj./((abs(H)).^2 + (SNR));
NFFT = length(HMMSE);

% find signal in freq domain:
Xf = fft(signal, NFFT);

% fine the frequency response using fft method:
% Xf = 1x3233
% HMMSE = 
signalRecovered = ifft(Xf.*HMMSE, NFFT);

figure, 
subplot(2,1,1)
plot(signalRecovered)
title('recovered signal using Half Sine Zero forcing equalized')
subplot(2,1,2)
plot(hs_convolved)
title('original half sine modulated signal')
    
% end