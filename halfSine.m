% define A1:
A1 = 1;
Ts = 1;

Fs = 10*2048*8;

% build up the half sine wave: 
% problem - be careful to only use 32 points for the pulse
N = 32;
t = linspace(0,1 - (1/N),N);
g1t = sin(pi*t/Ts);

% plot the half sine wave:
figure,
plot(t,g1t)
title('plot of g1(t)')
xlabel('time in seconds')
ylabel('amplitude')

% plot the frequency response of g1(t):
N = length(g1t);
L = 2^10;
G1f = fftshift(fft(g1t,L));  
freq = linspace(-1,1,L)*(Fs/2);  

figure,
freqz(g1t);
title('frequency response of unfiltered half sine using freqz')

figure,
subplot(2,1,1)
plot(freq,db(abs(G1f)))
xlabel('frequency (Hz)')
ylabel('magnitude (dB)')
title('magnitude response of g1(t)')
ylim([-100, 0])

subplot(2,1,2)
plot(freq,unwrap(angle(G1f)))
xlabel('frequency (Hz)')
ylabel('phase (deg)')
title('phase response of g1(t)')
ylim([-100, 0])

