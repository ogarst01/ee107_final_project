function [srrc_convolved, srrc_impulse, hs_convolved, hs_impulse] = matchedFilter(srrc_recieved_singal, hs_recieved_signal,forReport)

[~, ~, t, K, srrc_impulse] = modulator(1, 32, [1]);
% t = t - 32*1*K*(t(2) - t(1));

[~, hs_impulse, ~, ~] = modulator(1, 32, [1]);

srrc_impulse = flip(srrc_impulse);
hs_impulse = flip(hs_impulse);

% if grabbing impulse response etc, for question 8 in report
if(forReport)
    NFFT = length(hs_impulse)*10;
    timeLab = linspace(0,1,length(hs_impulse));
    timeLabSRRC = linspace(0,1,length(srrc_impulse));
    % plot the impulse repsonse and frequency response of the filters:
    figure,
    plot(timeLabSRRC,srrc_impulse)
    xlabel('discrete points')
    ylabel('amplitude')
    title('SRRC matched filter impulse response')
    
    figure,
    plot(timeLab,hs_impulse)
    xlabel('discrete points')
    ylabel('amplitude')
    title('Half Sine matched filter impulse response')
    
    % plot frequency responseof each pulse:
    figure,
    freqz(fft(hs_impulse,NFFT));
    title('HS pulse frequency response for the matched filter')
    
    figure,
    freqz(fft(srrc_impulse,NFFT));
    title('SRRC pulse frequency response for the matched filter')
    
end

hs_convolved = conv(hs_impulse, hs_recieved_signal);
srrc_convolved = conv(srrc_impulse, srrc_recieved_singal);
end

