close all;
v1 = out.output_data(:,2);

OSR = 2048; 
Fs = 2e3*OSR;
NFFTv = 32768*32;
len = length(v1);
v1 = v1(len-NFFTv+1:end); % Take last NFFTv samples of v1 as it is stablized by then
v1 = v1 - 0.9; % remove DC 
L = length(v1);
fv = Fs/2*linspace(0, 1, NFFTv / 2 + 1); 
FS = 1.8;

% --------------- PSD ------------------

wind = hann(L, 'periodic'); % periodic hanning window is used instead of only hanning to avoid any spectral leakage
fft_outv = fft(v1 .* wind, NFFTv);

Ptot = (abs(fft_outv)/(FS * sum(wind) * 1/4)).^2; % page 372 of [3]
fft_onesided = abs(Ptot(1:NFFTv/2+1));
figure;
semilogx(fv, 10*log10(fft_onesided)); 
xlim([0 Fs/2])
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;

% -------------- SQNR ---------------

fin = (3117/(2*(pi))); 
k = round(fin * NFFTv / Fs) + 1;
sigbin = k-1:k+1; % Taking 3 bins as the signal bins due to periodic hanning window
sigpow = sum(fft_onesided(sigbin));
npow = sum(fft_onesided(3:round(end/OSR))) - sigpow;

sndr = 10*log10(sigpow./npow);