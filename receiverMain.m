function receivedBits = receiverMain(rxSRRC, rxHS, T_bit, fs, channel)
% implement matched filter:
h3 = channel;
SRRC_equalized = zeroFilterEqualizer(h3, rxSRRC);
HS_equalized   = zeroFilterEqualizer(h3, rxHS);

% sample and detect

receivedBits = HS_equalized;
end