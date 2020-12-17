function [output] = sample_srrc(input)
figure(101);
plot(input);
input = input(192:end);%384:end);

output = downsample(input, 32);


output = output(7:end-6);

output = output > 0;
end

