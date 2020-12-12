% define the sqrt raised cosine pulse
Fs = 2048*20;

A2 = 1;

% Period = 32
T = 32; % number samples

% Truncation suggestion = 
%K = 2;
K = 8;

% roll off factor = 
alpha = 0.75;

% each symbol represented by SPS samples:
SPS = 2*K*T;

% they suggest using 32 samples, 
SRRC = A2*rcosdesign(alpha,K,SPS);

% construct the freq vector:
n = length(SRRC);
f = fs*(-n/2:n/2-1)/n;

% plot the freq response of the signal
figure,
subplot(2,1,1)
plot(f,db(fftshift(real(SRRC))));
title('g2(t) magnitude response')
xlabel('freq (Hz)')
ylabel('magnitude')
subplot(2,1,2)
plot(f,unwrap(angle(SRRC)));
title('g2(t) phase response')
xlabel('freq (Hz)')
ylabel('phase (angle)')

%% effect of alpha plots:
alpha2test = [0.25,0.5,0.75,1];

figure,
hold on
for i = 1:length(alpha2test);
    SRRCalphaTest = A2*rcosdesign(alpha2test(i),K,SPS);
    subplot(4,1,i)
    plot(f,db(SRRCalphaTest));
    %plot(f,unwrap(angle((SRRCalphaTest))));
    %plotTitle = sprintf('g2(t) phase. resp. for alpha = %g', alpha2test(i));
    plotTitle = sprintf('g2(t) mag. resp. for alpha = %g', alpha2test(i));
    title(plotTitle)
    xlabel('freq (Hz)')
    ylabel('magnitude')
    ylabel('phase')
    ylabel('magnitude')

end
hold off

%% effect of K plots:
K2test = [2,3,4,5,6];
alpha = 0.5;

figure,
hold on
for i = 1:length(K2test);
    SRRCkTest = A2*rcosdesign(alpha,K2test(i),SPS);
    subplot(5,1,i)
    % construct the freq vector:
    n = length(SRRCkTest);
    f = fs*(-n/2:n/2-1)/n;

    %plot(f, db(SRRCkTest));
    plot(f,unwrap(angle((SRRCkTest))));
    plotTitle = sprintf('g2(t) phase. resp. for K = %g', K2test(i));
    %plotTitle = sprintf('g2(t) mag. resp. for K = %g', K2test(i));
    title(plotTitle)
    xlabel('freq (Hz)')
    ylabel('phase')
    ylabel('magnitude')

end
hold off

%%
t = linspace(-K*T, K*T, Fs);

% checking w the equation given: 
xt = alpha/(sqrt(2))*((1+(2/pi)*sin(1-(2/pi)))+((1-(2/pi)*cos(pi/(4*alpha)))));

% define discontinuity at t = 0:
xt0 = 1- alpha + (4*(alpha/pi));

c = pi/Ts;

for i = 1:length(t)
    if(t(i) == 0)
        xtF(i) = xt0;
    elseif(abs(t(i)) == (Ts/(4*alpha)))
        xtF(i) = xt;
    end 
    
    % construct final x2(t) values:
    xtF(i) = sin(c*t(i)*(1-alpha))+(4*alpha*cos(c*t(i))*(1+alpha));
    xtF(i) = xtF(i)/(c*t(i)*(1-(4*alpha*t(i)/Ts)^2));
end

figure,
plot(t,xtF)
title('x(t) for SRRC')
xlabel('time (sec)')
ylabel('amplitude')

%%
Fs = 2048*29;
N = length(xtF);
G2f = fftshift(fft(xtF,N));  
f = linspace(0,T,Fs);  
T = 1;

% define the freq response of x2t:
for i = 1:length(f)
    if(f >= 0) & (f <= (1-alpha)/(2*T))
        XF(i) = sqrt(T);
    elseif (f >=  (1-alpha)/(2*T)) & (f(i) <= (1+alpha)/(2*T))
        XF(i) = sqrt(T)*cos((pi*T/(2*alpha))*(f(i) - (1-alpha)/(2*T)));
    elseif(f >((1+alpha)/(2*T)))
        XF(i) = 0;
    end
end

figure,
plot(freq,XF)

%%
[h,w] = freqz(xtF);

figure,
subplot(2,1,1)
plot(XF)
title('magnitude repsonse')

% use spectrum analyser to check results:
SpecAnlyzr1 = dsp.SpectrumAnalyzer('SampleRate',Fs,'PlotAsTwoSidedSpectrum',true);
SpecAnlyzr1(xtF')
