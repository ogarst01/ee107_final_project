function [srrc_convolved, srrc_impulse, hs_convolved, hs_impulse] = matchedFilter(srrc_recieved_singal, hs_recieved_signal)

[srrc_impulse, ~, t, K] = modulator(1, 32, [0 0 0 0 0 0 1 0 0 0 0 0]);
% t = t - 32*1*K*(t(2) - t(1));

[~, hs_impulse, ~, ~] = modulator(1, 32, [1]);

hs_convolved = conv(hs_impulse, hs_recieved_signal);
srrc_convolved = conv(srrc_impulse, srrc_recieved_singal);
end

