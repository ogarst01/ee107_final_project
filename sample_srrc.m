function [output] = sample_srrc(input)
plot(0:length(input)-1, input);
output = downsample(input, 32);

output = output > 0.5;
output = output(7:end-6);
end

