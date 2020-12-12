clear

T_bit = 1;
fs = 32;
%signal = randi([0 1], 1, 10);
signal = [0 0 1 1 1 0 1 1 0 1];

% signal = [0 0 1 1 1 0 1 1 0 1 0 1 1 1 1 0 0 0 1 1 1 0 1 1 0 1 1 1 0 0 1 1 0];

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
sqrtNsPowr = [0.001,0.1,1,10,100];

% generate random numbers: 
noiseHS   = randn(1,length(half_sine_filtered));
noiseSRRC = randn(1,length(srrc_filtered));

% iterate throught different values: 
for i = 1:length(sqrtNsPowr)
    noiseHS    = sqrt(sqrtNsPowr(i))*noiseHS;
    noiseSRRC  = sqrt(sqrtNsPowr(i))*noiseSRRC;
    
    half_sine_filtered_noisy = half_sine_filtered + noiseHS;
    srrc_filtered_noisy      = noiseSRRC + srrc_filtered;
    
    % labels for graphs: 
    strHS = sprintf('eye diagram half sine with noise level sigma = %g',sqrtNsPowr(i));
    strSRCC = sprintf('eye diagram SRRC with noise level sigma = %g',sqrtNsPowr(i));
    
    eyediagram(half_sine_filtered_noisy, T_bit*fs, 1, 16);
    title(strHS);

    eyediagram(srrc_filtered_noisy, T_bit*fs);
    title(strSRCC);

end

hold off