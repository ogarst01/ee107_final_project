clear;
close all

% define some constants:
T_bit = 1;
fs = 32;
%signal = randi([0 1], 1, 10);
signal = [0 0 1 1 1 0 1 1 0 1];

%% Modulate signal:
% make the transmitted signal, thru channel + add noise: 
[srrc_modulated, hs_modulated, t, K] = modulator(T_bit, fs, signal);

figure(1);
clf;
subplot(2, 1, 1);
plot(t, hs_modulated);
title("Half-Sine modulation: 10 random bits");
ylabel("Amplitude of modulated signal (V)");
xlabel("Time (sec)");

subplot(2, 1, 2);
plot(t, srrc_modulated);
title("SRRC-Modulation: 10 random bits (K = " + K + ")");
xlabel("Time (sec)");
ylabel("Amplitude of modulated signal (V)");

% Plot Half Sine spectrum
figure(2);
subplot(2, 1, 1);
n = length(hs_modulated);
hs_fft = fftshift(fft(hs_modulated, n));
f = fs*(-n/2:n/2-1)/n;
plot(f, abs(hs_fft));
title("Spectrum of Half-Sine-Modulated signal (w/ 10 random bits)");
xlabel("Frequency (Hz)");
ylabel("Magntiude");

% Plot SRRC spectrum
subplot(2, 1, 2);
n = length(srrc_modulated);
srrc_fft = fftshift(fft(srrc_modulated, n));
f = fs*(-n/2:n/2-1)/n;
plot(f, abs(srrc_fft));
title("Spectrum of SRRC-Modulated Signal (w/ 10 random bits)");
xlabel("Frequency (Hz)");
ylabel("Magnitude");

% Eye Diagrams of Modulated Signals:
eyediagram(hs_modulated, T_bit*fs, 1, 16);
title("Eye Diagram: Half Sine Pulse");
eyediagram(srrc_modulated, T_bit*fs, 1, 16);
title("Eye Diagram: SRRC-PCM");

%% Channel Distortion

[channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc_modulated,hs_modulated);

% SRRC time-domain signal post-distortion
figure(10);
plot(post_channel_srrc);
title('SRRC modulated signal');
xlabel('time');
ylabel('amplitude');

% HS time-domain signal post-distortion
figure(11);
plot(post_channel_hs);
title('half sine modulated signal');
xlabel('time');
ylabel('amplitude');

% HS signal post-distortion freq response
figure(12);
freqz(post_channel_hs);
title('Frequency Response of Filtered Half-Sine');

% SRRC signal post-distortion freq response
figure(13);
freqz(post_channel_srrc);
title('Frequency Response of Filtered SRRC');

% HS post-distortion eye diagram
num_windows = 1;
eyediagram(post_channel_hs, num_windows*T_bit*fs, 1, 16);
title("Eye Diagram: Half Sine Pulse Filtered");
 
% SRRC post-distortion eye diagram
eyediagram(post_channel_srrc, num_windows*T_bit*fs, 1, 16);
title("Eye Diagram: SRRC Pulse Filtered ");

%% White Gaussian Noise

% whether or not to display images of different noise powers: 
testing = false;
% sqrt of noise power: 
sqrtNsPowr2 = 0.0001;
[srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(post_channel_hs, post_channel_srrc, testing, sqrtNsPowr2, T_bit, fs);

return;

% feed the transmitted signals into the receiver:
rxBits = receiverMain(rxSRRC, rxHS, T_bit, fs, channel);