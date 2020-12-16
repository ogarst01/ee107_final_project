%%

% define some constants:
T_bit = 1;
fs = 32;
signal = randi([0 1], 1, 104);
% signal = [0 0 1 1 1 0 1 1 0 1];
% signal= [0 0 0 0 0 0 1 0 0 0 0 0 0];
% signal = zeros(1, 100);
% signal(50) = 1;

% Outdoor channel really doesn't work:
channelType = 'outdoor';
%channelType = 'indoor ';
% channelType = 'starter';
% signal = signalVec;

% to display functions
displayModulate = false;
displayChannel = false;
displayMatched = false;
plotZFEqualizer = false;
plotMMSEqualizer = false; 
%% Modulate signal:
% make the transmitted signal, thru channel + add noise: 
[srrc_modulated, hs_modulated, t, K] = modulator(T_bit, fs, signal);

if (displayModulate)
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

[channel_impulse_response, post_channel_srrc, post_channel_hs] = channel(srrc_modulated,hs_modulated, channelType);

if(displayChannel)
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
sqrtNsPowr2 = 0;
[srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(post_channel_hs, post_channel_srrc, testing, sqrtNsPowr2, T_bit, fs);

% for debugging - with no noise:
%srrc_filtered_noisy = post_channel_srrc;
%half_sine_filtered_noisy = post_channel_hs;

%% Matched Filter
[srrc_convolved, srrc_matched_filter_impulse, hs_convolved, hs_matched_filter_impulse] = matchedFilter(post_channel_srrc, post_channel_hs);

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
[SRRC_equalized, hzt, ht, t, HZF, H, f] = zeroFilterEqualizer(channel_impulse_response, srrc_convolved, fs);
[HS_equalized, ~, ~, ~, ~, ~]   = zeroFilterEqualizer(channel_impulse_response, hs_convolved, fs);

if(0)
    
    figure, 
    subplot(4,1,1)
    plot(SRRC_equalized)
    title('recovered signal using SRRC Zero forcing equalized')
    subplot(4,1,2)
    plot(srrc_convolved)
    title('SRRC channel-distorted signal')
    subplot(4, 1, 3);
    [undistorted_srrc_matched_filter_output, ~, ~, ~] = matchedFilter(srrc_modulated, hs_modulated);
    plot(undistorted_srrc_matched_filter_output);
    title("Undistorted SRRC Matched Fitler Output");
    subplot(4,1,4);
    plot(hs_modulated);
    title("Original Modulated Signal");
    
    figure, 
    subplot(4,1,1)
    plot(HS_equalized)
    title('recovered signal using Half Sine Zero forcing equalized')
    subplot(4,1,2)
    plot(hs_convolved)
    title('Half-Sine channel-distorted Signal')
    subplot(4, 1, 3);
    [~, ~, undistorted_hs_matched_filter_output, ~] = matchedFilter(srrc_modulated, hs_modulated);
    plot(undistorted_hs_matched_filter_output);
    title("Undistorted Half-Sine Matched Filter Output");
    subplot(4,1,4);
    plot(hs_modulated);
    title("Original Modulated Signal");
    
    figure,
    plot(f, abs(H));
    hold on
    plot(f, abs(HZF));
    legend("Channel Frequency Response", "Equalizer Frequency Response");
    title("Frequency Responses (Magnitude)");
    xlabel("Frequency (Hz)");
    ylabel("Magnitude");
    
    figure,
    plot(0:1/fs:(length(ht)-1)/fs, ht);
    title("Channel Impulse Response");
    xlabel("Time (sec)");
    
    figure,
    plot(0:1/fs:(length(hzt)-1)/fs, hzt);
    title("Equalizer Impulse Response");
    xlabel("Time (sec)");
    
    % plot eye diagrams: 
    eyediagram(SRRC_equalized, 2*fs, 2);
    title("Eye Diagram: SRRC Zero Forcing Equalizer Output, 2 periods");
     
    eyediagram(HS_equalized, 2*fs, 2);
    title("Eye Diagram: HS Zero Forcing Equalizer Output, 2 periods");
end

%% MMSE Equalizer code: 

[SRRC_MSSE, HMMSE1] = MMSEEqualizer(srrc_convolved, sqrtNsPowr2, channel_impulse_response);
[HS_MSSE, HMMSE2]   = MMSEEqualizer(hs_convolved, sqrtNsPowr2, channel_impulse_response);

if(0)
    figure, 
    subplot(2,1,1)
    plot(SRRC_MSSE)
    title('recovered signal using SRRC MSSE')
    subplot(2,1,2)
    plot(srrc_convolved)
    title('original SRRC modulated signal')
    
    figure, 
    subplot(2,1,1)
    plot(HS_MSSE)
    title('recovered signal using Half Sine MSSE')
    subplot(2,1,2)
    plot(hs_convolved)
    title('original half sine modulated signal')
    
    % plot eye diagrams: 
    eyediagram(SRRC_MSSE, 2*fs, 2);
    title("Eye Diagram: SRRC MSSE, 2 periods");
     
    eyediagram(HS_MSSE, 2*fs, 2);
    title("Eye Diagram: HS MSSE, 2 periods");
    
    figure,
    subplot(5,1,1)
    plot(hs_modulated)
    title('output of modulated signal - HS')
    subplot(5,1,2)
    plot(post_channel_hs)
    title('output of channel -HS')
    subplot(5,1,3)
    plot(half_sine_filtered_noisy)
    title('noisy signal through channel - HS')
    subplot(5,1,4)
    plot(hs_convolved)
    title('after matched filter - HS')
    subplot(5,1,5)
    plot(HS_MSSE)
    title('output of MMSE equalizer - HS')
    
    figure,
    subplot(5,1,1)
    plot(srrc_modulated)
    title('output of modulated signal - SSRC')
    subplot(5,1,2)
    plot(post_channel_srrc)
    title('output of channel - SSRC')
    subplot(5,1,3)
    plot(srrc_filtered_noisy)
    title('noisy signal through channel - SSRC')
    subplot(5,1,4)
    plot(srrc_convolved)
    title('after matched filter - SSRC')
    subplot(5,1,5)
    plot(SRRC_MSSE)
    title('output of equalizer (recovered signal) - SSRC')
  
    % plot the convolution of the impulse response of the equalizer and the
    % channel:
    % ideally these should come out to be dirac deltas: 
    figure, 
    plot(conv(channel_impulse_response, ifft(HMMSE1)))
    title('Dirac Delta check for the SRRC pulse')

    figure, 
    plot(conv(channel_impulse_response, ifft(HMMSE2)))
    title('Dirac Delta check for the HS pulse')
    
    % plot frequency responses of the 2 pulses:
    % plotting the frequency response of the MMSE filter:
    figure,
    NFFT = length(srrc_modulated)*20;
    freqz(HMMSE1)
    title('frequency response')
    
    figure,
    NFFT = length(hs_modulated)*20;
    freqz(HMMSE2)
    title('frequency response')

end
%%
% test with various noise levels (3.21)
noiseVec = [0,0.0001,0.001,0.01,10000];
SNR_hsTesting = zeros(1,length(noiseVec));
SNR_srrcTesting = zeros(1,length(noiseVec));
if(0)
    for i = 1:length(noiseVec)
        % run all the equalizers for the various noise levels:
        % add noise:
        sqrtNsPowr2 = noiseVec(i);
        [srrc_filtered_noisy,half_sine_filtered_noisy] = addNoise(post_channel_hs, post_channel_srrc, testing, sqrtNsPowr2, T_bit, fs);

        % run through matched filter:
        [srrc_convolved, srrc_matched_filter_impulse, hs_convolved, hs_matched_filter_impulse] = matchedFilter(post_channel_srrc, post_channel_hs);

        % equalizer step
        [SRRC_MSSE, HMMSE1] = MMSEEqualizer(srrc_convolved, sqrtNsPowr2, channel_impulse_response);
        [HS_MSSE, HMMSE2]   = MMSEEqualizer(hs_convolved, sqrtNsPowr2, channel_impulse_response);
        
%         eyediagram(SRRC_MSSE, 2*fs, 2);
%         title("Eye Diagram: SRRC MSSE, 2 periods");
% 
%         eyediagram(HS_MSSE, 2*fs, 2);
%         title("Eye Diagram: HS MSSE, 2 periods");

%         figure,
%         subplot(5,1,1)
%         plot(hs_modulated)
%         title('output of modulated signal - HS')
%         subplot(5,1,2)
%         plot(post_channel_hs)
%         title('output of channel -HS')
%         subplot(5,1,3)
%         plot(half_sine_filtered_noisy)
%         title('noisy signal through channel - HS')
%         subplot(5,1,4)
%         plot(hs_convolved)
%         title('after matched filter - HS')
%         subplot(5,1,5)
%         plot(HS_MSSE)
%         title('output of MMSE equalizer - HS')
% 
%         figure,
%         subplot(5,1,1)
%         plot(srrc_modulated)
%         title('output of modulated signal - SSRC')
%         subplot(5,1,2)
%         plot(post_channel_srrc)
%         title('output of channel - SSRC')
%         subplot(5,1,3)
%         plot(srrc_filtered_noisy)
%         title('noisy signal through channel - SSRC')
%         subplot(5,1,4)
%         plot(srrc_convolved)
%         title('after matched filter - SSRC')
%         subplot(5,1,5)
%         plot(SRRC_MSSE)
%         title('output of equalizer (recovered signal) - SSRC')
%         

        [hs_symbols] = sample_hs(HS_equalized);
        hs_bits = (hs_symbols + 1) / 2;

        [srrc_symbols] = sample_srrc(SRRC_equalized);
        srrc_bits = srrc_symbols;

        SNR_hsTesting(i)   = snr(double(hs_bits), signal);
        SNR_srrcTesting(i) = snr(double(srrc_bits), signal);
    end
end

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


if(0)
    figure,
    plot(0:length(signal)-1, signal);
    hold on
    plot(0:length(hs_bits)-1, hs_bits);
    plot(0:length(srrc_bits)-1, srrc_bits);
    legend("Original Signal", "Half-Sine Recovered", "SRRC-recovered");
    title("Recieved vs Transmitted Bits");
    xlabel("Bit Index");
    ylabel("Bit");
end

%% Rearrange Data

num_pixels = ceil(length(hs_bits) / 8);
hs_pixels = reshape(hs_bits, [8, num_pixels])';

num_pixels = ceil(length(srrc_bits) / 8);
srrc_pixels = reshape(srrc_bits, [8, num_pixels])';

% Find signal to noise ratio: (ideally is 0 db = 1 -> signal to noise
% ratio of 1
SNR_hs   = snr(double(hs_bits), signal);
SNR_srrc = snr(double(srrc_bits), signal);

figure,
subplot(2,1,1)
stem(double(hs_bits))
title('Recovered Signal Using Half Sine Pulse + ZF Equalizer')
subplot(2,1,2)
stem(signal)
title('Original Signal')

figure,
subplot(2,1,1)
stem(double(srrc_bits))
title('Recovered Signal Using SRRC Pulse + ZF Equalizer')
subplot(2,1,2)
stem(signal)
title('Original Signal')

figure,
subplot(2,1,1)
stem(double(hs_bits_MMSE))
title('Recovered Signal Using Half Sine Pulse')
subplot(2,1,2)
stem(signal)
title('Original Signal')

figure,
subplot(2,1,1)
stem(double(srrc_bits_MMSE))
title('Recovered Signal Using SRRC Pulse')
subplot(2,1,2)
stem(signal)
title('Original Signal')
%%
figure,
plot(double(srrc_bits_MMSE) - signal, 'r')
title('error plot for SRRC')
ylim([-2,2])

figure,
plot(double(hs_bits_MMSE) - signal, 'r')
title('error plot for HS')
ylim([-2,2])
%% TO DO: 
% - Why is the SNR always 0? Could something be going wrong
% - How to input images, etc.
% - Clean up main - there's too many outputs being printed - will take 
%   forever to run
% - try diff channel types early - this messed the whole thing up
