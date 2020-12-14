%% HALF SINE: 
% sampling rate R = bits/s
Ts = 1; % second
R = 32;
width = R*Ts;

amp=sqrt(2/R);
HalfSine=amp*sin((2*pi*[0:31]/32)/2);
fvtool(HalfSine,'Analysis','impulse')
fvtool(HalfSine,'Analysis','freq')

% using the equation:
t = linspace(0,Ts,2048*10);
g1t = sin(pi*t/Ts);

Fs = 2048*10;
SpecAnlyzr1 = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',true);
SpecAnlyzr1(g1t')

%%
coeff = 1;
A1 = 1;
T = 10;
t = linspace(0,T,2048*10);
g1t = coeff*A1*sin(pi.*t./T);

figure(3)
plot(t,g1t)
title('plot of g1(t)')

% Plot freq. response:
figure(4)
subplot(2,1,1)
plot(fftshift(db(abs(fft(g1t,2000)))))
title('g1(t) magnitude response')
xlabel('w')
ylabel('magnitude (dB)')
subplot(2,1,2)
plot(angle(fft(g1t,2000)))
title('g1(t) phase response')
xlabel('w')
ylabel('magnitude')

%% SRRC:
% Period = 32
T = 32; % number samples

% Truncation suggestion = 
K = 2;
%K = 10;

% roll off factor = 
alpha = 0.75;

% each symbol represented by SPS samples:
SPS = 2*K*T;

% they suggest using 32 samples, 
SRRC = rcosdesign(alpha,K,SPS);

Fs = 2048*10;
SpecAnlyzr1 = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',true);
SpecAnlyzr1(SRRC')

figure,
plot(SRRC)

figure,
subplot(2,1,1)
plot(fftshift(db(abs(fft(SRRC,2000)))))
title('g1(t) magnitude response')
xlabel('w')
ylabel('magnitude')
subplot(2,1,2)
plot(angle(fft(SRRC,2000)))
title('g1(t) phase response')
xlabel('w')
ylabel('magnitude')

%% TRASH:

f = linspace(0,10,Fs);

T = 1/2048;
%%
for i = 1:length(f)
    if(abs(f) >= 0) & ((abs(f) <= (1-alpha)/(2*T)))
        XF(i) = sqrt(T);
    elseif ((abs(f) >= 0) & ((abs(f) <= (1-alpha)/(2*T))))
        XF(i) = sqrt(T)*cos((pi*T/(2*alpha))*(abs(f) - (1-alpha)/(2*T)));
    elseif(abs(f)>(1+alpha)/(2*T))
        XF(i) = 0;
    else
        XF(i) = 0;
    end
end


Fs = 2048*10;
SpecAnlyzr1 = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',true);
SpecAnlyzr1(g1t')
figure(100)

%%
alpha = 0.5;
T = 1;
t = linspace(0,T,2048*10);

for i = 1:length(t)
    nume(i) = sin(pi*(t(i)/T).*(1-alpha)) + (4*alpha*cos(pi*(t(i)/T)*(1+alpha)));
    denume(i) = pi*(t(i)/T).*(1-(4*alpha*t(i)/T)^2);

    xt = nume./denume;
    
    % check for edge cases:
    if(i == 1)
        xt(i) = 1 - alpha + 4*(alpha/pi);
    end
    
    if((t(i) == T/(4*alpha)) || (t(i) == -T/(4*alpha)))
        xt(i) = (alpha/sqrt(2))*((1+2/pi)*sin(pi/(4*alpha)) + ((1-(2/pi)*cos(pi/(4*alpha)))));
    end
    
end

Fs = 2048*10;
SpecAnlyzr1 = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',true);
SpecAnlyzr1(xt')
figure(100)