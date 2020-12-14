function [transmittedSRRC, transmittedHS, channel] = transmitter(T_bit, fs, signal)

[half_sine_modulated, t] = half_sine_sean(signal, T_bit, fs);

figure(1);
clf;
subplot(2, 1, 1);
plot(t, half_sine_modulated);
title("Half-Sine modulation: 10 random bits");
ylabel("Amplitude of modulated signal (V)");
xlabel("Time (sec)");

K = 6;
[srrc_modulated, t] = srrc(signal, T_bit, K, fs);

subplot(2, 1, 2);
plot(t, srrc_modulated);
title("SRRC-Modulation: 10 random bits (K = " + K + ")");
xlabel("Time (sec)");
ylabel("Amplitude of modulated signal (V)");

%% Plot Spectrum of the above signal

figure(2);
subplot(2, 1, 1);
n = length(half_sine_modulated);
hs_fft = fftshift(fft(half_sine_modulated, n))
f = fs*(-n/2:n/2-1)/n
plot(f, abs(hs_fft));
title("Spectrum of Half-Sine-Modulated signal (w/ 10 random bits)");
xlabel("Frequency (Hz)")
ylabel("Magntiude");

subplot(2, 1, 2);
n = length(srrc_modulated);
srrc_fft = fftshift(fft(srrc_modulated, n))
f = fs*(-n/2:n/2-1)/n
plot(f, abs(srrc_fft));
title("Spectrum of SRRC-Modulated Signal (w/ 10 random bits)");
xlabel("Frequency (Hz)")
ylabel("Magnitude");

%% Plot eye diagrams
eyediagram(half_sine_modulated, T_bit*fs, 1, 16);
title("Eye Diagram: Half Sine Pulse");
eyediagram(srrc_modulated, T_bit*fs, 1, 16);
title("Eye Diagram: SRRC-PCM");

%% Run through channel:
[srrc_filtered,half_sine_filtered, h]  = channelDistortion(half_sine_modulated, srrc_modulated);

%% Q6:
figure,
plot(srrc_filtered)
title('SRRC modulated signal')
xlabel('time')
ylabel('amplitude')

figure,
plot(half_sine_filtered)
title('half sine modulated signal')
xlabel('time')
ylabel('amplitude')

T_bit = 2;
fs = 32;

eyediagram(half_sine_filtered, T_bit*fs, 1, 16);
title("Eye Diagram: Half Sine Pulse Filtered");
 
eyediagram(srrc_filtered, T_bit*fs, 1, 16);
title("Eye Diagram: SRRC Pulse Filtered ");

%% Q7: Gaussian Noise: 
% whether or not to display images of different noise powers: 
testing = false; 

% sqrt of noise power: 
sqrtNsPowr2 = 0.0001;

[srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(half_sine_filtered, srrc_filtered, testing, sqrtNsPowr2, T_bit, fs);

% return values after adding noise
transmittedSRRC = srrc_filtered_noisy;
transmittedHS = half_sine_filtered_noisy;

channel = h;
end