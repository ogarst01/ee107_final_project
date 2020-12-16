function [output] = sample_hs(input)

% Given a continuous time Half-Sine input signal, return a bit sequence.
input = input(33:end);
output = downsample(input, 32);

plus_ones = output > 0;
minus_ones = output <= 0;

output = plus_ones - minus_ones;
end