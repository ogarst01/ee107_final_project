function [half_sine_modulated, t] = half_sine_sean(signal, T_bit, fs)

Ts = 1/fs;
t_hs = linspace(0, T_bit, T_bit*fs+1);
% Drop last element
t_hs = t_hs(1:length(t_hs)-1);

hs = sin(pi*t_hs/T_bit);
hs = hs/norm(hs);

t = 0:Ts:T_bit*length(signal);
half_sine_modulated = zeros(size(t));
for idx = 1:length(signal)
   if signal(idx) > 0
       half_sine_modulated(T_bit*fs*(idx-1)+1) = 1;
   else
       half_sine_modulated(T_bit*fs*(idx-1)+1) = -1;
   end    
end
half_sine_modulated = conv(half_sine_modulated, hs);
% This will leave a "tail" of zeros after the interesting part of the
% convolution
half_sine_modulated = half_sine_modulated(1:length(t));
end