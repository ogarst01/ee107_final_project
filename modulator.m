function [srrc_modulated, half_sine_modulated, t, K] = modulator(T_bit, fs, signal)

% Modulate the input signal (in half-sine) and plot modulated signal
[half_sine_modulated, t] = half_sine_sean(signal, T_bit, fs);


% Do the same for the SRRC case
K = 6;
[srrc_modulated, t] = srrc(signal, T_bit, K, fs);

end