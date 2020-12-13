clear;
close all

% define some constants:
T_bit = 1;
fs = 32;
%signal = randi([0 1], 1, 10);
signal = [0 0 1 1 1 0 1 1 0 1];

% signal = [0 0 1 1 1 0 1 1 0 1 0 1 1 1 1 0 0 0 1 1 1 0 1 1 0 1 1 1 0 0 1 1 0];

% make the transmitted signal, thru channel + add noise: 
[rxSRRC, rxHS, channel] = transmitter(T_bit, fs, signal);

% feed the transmitted signals into the receiver:
rxBits = receiverMain(rxSRRC, rxHS, T_bit, fs, channel);