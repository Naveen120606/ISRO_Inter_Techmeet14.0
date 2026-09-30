close all;

v1 = HIGHPASS_DSM_OUTPUT_496_Hz_OSR_2048; % To show mirrored noise shaping
v2 = v1;
OSR = 2048; 
Fs = 2e3*OSR;

NFFTv = 2e3*OSR; % change to 32768*32 to get coherent PSD

len = length(v1);
v1 = v1(len-NFFTv+1:end); 
v1 = v1 - 0.9; 
L = length(v1);

fv = Fs/2*linspace(0, 1, NFFTv / 2 + 1); 
FS = 1.8;

v2 = out.output_data(:,2); % to show demodulated PSD   
v2 = v2(end-NFFTv+1:end);

% Demodulation test bench in MATLAB, this is performed in Verilog (RTL)

u_bipolar = (v2 - 0.9)/0.9;          

carrier = ones(size(u_bipolar));
carrier(2:2:end) = -1; % point-wise multiplying with Fs/2 periodic sequence of (-1)^n

v2 = (u_bipolar .* carrier); % Digital Modulation
len2 = length(v2);
L2 = length(v2);

fv2 = Fs/2*linspace(0, 1, NFFTv / 2 + 1); 
FS2 = 1;

% ------------- PSD -------------

wind = hann(L, 'periodic'); 

% Plot the reversed noise shaping
fft_outv = fft(v1 .* wind, NFFTv);
Ptot = (abs(fft_outv)/(FS * sum(wind) * 1/4)).^2; 
fft_onesided = abs(Ptot(1:NFFTv/2+1));

figure;
plot(fv, 10*log10(fft_onesided)); 
xlim([0 Fs/2])
title('Mirrored noise shaping for HPDSM')
grid on;

% Plot the demodulated HPDSM output
fft_outv2 = fft(v2 .* wind, NFFTv);
Ptot2 = (abs(fft_outv2)/(FS2 * sum(wind) * 1/4)).^2; 
fft_onesided2 = abs(Ptot2(1:NFFTv/2+1));

figure;
semilogx(fv2, 10*log10(fft_onesided2)); 
xlim([0 Fs/2])
title('Demodulated output of HPDSM')
grid on;

fin = 3117/(2*pi);
k = round(fin * NFFTv / Fs) + 1;

% ----------- SNDR -----------

sigbin = k-1:k+1; 
sigpow = sum(fft_onesided2(sigbin));

npow = sum(fft_onesided2(3:round(end/OSR))) - sigpow;

sndr = 10*log10(sigpow./npow);
