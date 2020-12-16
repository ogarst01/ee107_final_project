function [srrc_modulated, t] = srrc(signal, T_bit, K, fs)

Ts = 1/fs;

t_pulse = linspace(-T_bit*K, T_bit*K, 2*K*T_bit*fs+1);
% Drop last element
t_pulse = t_pulse(1:length(t_pulse)-1);

alpha = 0.5;
pulse_num = sin(pi*t_pulse*(1-alpha)/T_bit) + 4*alpha*(t_pulse/T_bit).*cos(pi*(t_pulse/T_bit)*(1+alpha));
pulse_denom = pi*(t_pulse/T_bit).*(1 - (4*alpha*t_pulse/T_bit).^2);
pulse = pulse_num./pulse_denom;

% Special indices of x(t)
zero_idx = find(t_pulse==0);
last_pole_idx = find(t_pulse == T_bit/(4*alpha));
first_pole_idx = find(t_pulse == -T_bit/(4*alpha));

pulse(zero_idx) = 1 - alpha + 4*alpha/pi;
special_value = (alpha/sqrt(2)) * ((1+2/pi)*sin(pi/(4*alpha)) + (1-2/pi)*cos(pi/(4*alpha)));
pulse(first_pole_idx) = special_value;
pulse(last_pole_idx) = special_value;

pulse = pulse/norm(pulse);

t = 0:Ts:T_bit*length(signal);
srrc_modulated = zeros(size(t));
for idx = 1:length(signal)
   if signal(idx) > 0
       srrc_modulated(T_bit*fs*(idx-1)+1) = 1;
   else
       % Do nothing, let the vector remain zero at this element.
   end    
end

figure,
plot(pulse)

sum = 0;

for i = 1:length(pulse)
    sum = sum + (pulse(i)).^2;
end

sum

srrc_modulated = conv(srrc_modulated, pulse);
% This will leave a "tail" of zeros after the interesting part of the
% convolution
srrc_modulated = srrc_modulated(1+K*fs*T_bit:length(srrc_modulated)-K*fs*T_bit+1);
end