function [trimmed, HMMSE] = MMSEEqualizer(signal, sigma2, channel_impulse_response)
NFFT = 2*length(signal);
% define energy Eb of pulse for SNR calculation:
% Eb = (norm(g_t))^2;
Eb = 1;

% calculate SNR given noise power sigma squared(sigma2)
SNR  = sigma2./Eb;

h_upsample = channel_impulse_response;
H = (fft(h_upsample, NFFT));

Hconj = conj(H);

% calculate the frequency response of the MMSE Equalizer:
HMMSE = Hconj./((abs(H)).^2 + (SNR));

signalRecovered = ifft(HMMSE.*fft(signal,length(HMMSE)));

% trim the output since Matlab pads with 0's for convolution
trimmed = signalRecovered(1:(length(signal)-length(channel_impulse_response)));    

end