function signalRecovered = MMSEEqualizer(signal, sigma2, channel_impulse_resp)

NFFT = length(signal)*100;

% define energy Eb of pulse for SNR calculation:
% Eb = (norm(g_t))^2;
Eb = 1;
% quick check -> Eb should be 1. 

% calculate SNR given noise power sigma squared(sigma2)
SNR  = sigma2./Eb;

%H = fft(downsample(channel_impulse_resp, 31));

NFFT = 32;

h_upsample = upsample(channel_impulse_resp, 31);
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
signalRecovered = ifft(Xf.*HMMSE, NFFT);
signalRecovered = conv(signal, ifft(HMMSE));
figure, 
subplot(2,1,1)
plot(signalRecovered)
title('recovered signal using Half Sine Zero forcing equalized')
subplot(2,1,2)
plot(hs_convolved)
title('original half sine modulated signal')
    
end