% Olive Garst
% Dec. 2020
function [forcedZeroSign] = zeroFilterEqualizer(channelResponse, signal, typePulse, lengthOriginal)
% srrcType = 'srrc';
% HStype  = 'half';

lengthOriginal = length(signal);

if(typePulse == 'half')
    H = fft(channelResponse, lengthOriginal);
    HZF = 1./H;
    forcedZeroSign = ifft(HZF.*(fft(signal)));%conv(hzt,signal);
%     trimmed = forcedZeroSign(1:(lengthOriginal*32 + 1));
    
else

    H = fft(channelResponse, lengthOriginal);

    HZF = 1./H;

    forcedZeroSign = ifft(HZF.*(fft(signal)));
    
%     trimmed = forcedZeroSign(1:(lengthOriginal*32 + 400));

end
    
end