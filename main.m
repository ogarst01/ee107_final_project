clear;
close all

% define some constants:
T_bit = 1;
fs = 32;
signal = randi([0 1], 1, 100);
% signal = [0 0 1 1 1 0 1 1 0 1];
% signal= [0 1 0 0 0 0 0 0 0];

%% Modulate signal:
% make the transmitted signal, thru channel + add noise: 
[srrc_modulated, hs_modulated, t, K] = modulator(T_bit, fs, signal);

if (0)
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

    figure(3);
    % Eye Diagrams of Modulated Signals:
    eyediagram(hs_modulated, T_bit*fs, 1, 16);
    title("Eye Diagram: Half Sine Pulse");
    figure(4);
    eyediagram(srrc_modulated, T_bit*fs, 1, 16);
    title("Eye Diagram: SRRC-PCM");
end
%% Channel Distortion

[channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc_modulated,hs_modulated);

if(0)
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
end
%% White Gaussian Noise

% whether or not to display images of different noise powers: 
testing = false;
% sqrt of noise power: 
sqrtNsPowr2 = 0.0001;
[srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(post_channel_hs, post_channel_srrc, testing, sqrtNsPowr2, T_bit, fs);

%% Matched Filter
[srrc_convolved, srrc_matched_filter_impulse, hs_convolved, hs_matched_filter_impulse] = matchedFilter(srrc_modulated, hs_modulated);

if (0)
    figure(40);
    plot_end = (length(hs_convolved)-1)/fs;
    plot(0:1/fs:(length(hs_convolved)-1)/fs, hs_convolved);
    title("Half-Sine Matched Filter Output");
    % For HS: sample at 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 (NOT 0 or 11)
    
    figure(41);
    plot_end = (length(srrc_convolved)-1)/fs;
    plot(0:1/fs:plot_end, srrc_convolved);
    title("SRRC Matched Filter Output");
    % Sample at t=6, 7, 8, 9... (NOT at or before 5 seconds).
    
    eyediagram(hs_convolved, 1*fs);
    title("Eye Diagram: Half-Sine Matched Filter Output");
    
    eyediagram(srrc_convolved, 1*fs);
    title("Eye Diagram: SRRC Matched Filter Output");
    
    eyediagram(hs_convolved, 2*fs, 2);
    title("Eye Diagram: Half-Sine Matched Filter Output, 2 periods");
    
    eyediagram(srrc_convolved, 2*fs, 2);
    title("Eye Diagram: SRRC Matched Filter Output, 2 periods");
    
    
end

%% Equalizers

% feed the transmitted signals into the receiver:
SRRC_equalized = zeroFilterEqualizer(channel_impulse_response, srrc_convolved);
HS_equalized   = zeroFilterEqualizer(channel_impulse_response, hs_convolved);

%%

figure, 
plot(real(SRRC_equalized))
title('SRRC')

figure, 
plot(real(HS_equalized))
title('HS')

figure, 
plot(real(channel_impulse_response))
title('SRRC')