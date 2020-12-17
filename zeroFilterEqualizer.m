% Olive Garst
% Dec. 2020
function [trimmed] = zeroFilterEqualizer(channelResponse, signal, typePulse, lengthOriginal)
% srrcType = 'srrc';
% HStype  = 'half';

if(typePulse == 'half')
    NFFT = lengthOriginal*33;
    H = fft(channelResponse,NFFT);
    HZF = 1./H;
    forcedZeroSign = ifft(HZF.*(fft(signal,NFFT)), NFFT);%conv(hzt,signal);
    trimmed = forcedZeroSign(1:(lengthOriginal*32 + 1));
    
else
    NFFT = lengthOriginal*40;

    H = fft(channelResponse,NFFT);

    HZF = 1./H;

    forcedZeroSign = ifft(HZF.*(fft(signal,NFFT)), NFFT);
    
    trimmed = forcedZeroSign(1:(lengthOriginal*32 + 400));

end
    
end