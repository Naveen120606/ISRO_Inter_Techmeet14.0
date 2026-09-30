close all;
R  = 2;   % decimation factor (Half-band)

t=(1:8192001);
OSR = 2048;
v1 = HIGHPASS_DSM_OUTPUT_500_Hz_OSR_2048; % Load DSM Data
u_bipolar = 2*double(v1(:));
carrier = ones(size(u_bipolar));
carrier(2:2:end) = -1; % period 2Ts, freq Fs/2

v1 = (u_bipolar .* carrier);
Fs = 2e3;
FS = 1;

% Load the filter coefficients obtained from DSP System Toolbox
load('HALF_BAND_FILTER_COEFFICIENTS.mat');

M=11; % OSR = 2048

% 11 cascaded Half band filters
for m=1:M
    xf = filter(Num2222, 1, v1);   % filter at full rate
    y  = xf(1:R:end);             % decimate by R (simple downsample by 2)
    v1 = y;
    disp(length(y))
    Fs_new = Fs / R;              % Fs becomes Fs/2 after each halfband
end

plot(y); % Filtered output in time domain of the cascaded half band filter

% y looks like a sawtooth because 500Hz has only 4 samples per cycle due to
% Fs of 2kHz, in order to see no AM modulated output due to MATLAB
% interpolation, Fs (2000Hz) should be a multiple of the input frequency (500Hz)

v1 = y; 

% ---------------------- PSD --------------------------

NFFTv = 500;
Fs = 2000;
fv = Fs / 2 * linspace(0, 1, NFFTv / 2 + 1); % Frequency vector (Hz)
v1 = v1(end-NFFTv+1:end); % sampled @Fs

L = length(v1);
wind = hann(L, 'periodic');
fft_outv = fft(v1 .* wind, NFFTv);

Ptot = (abs(fft_outv)/(FS * sum(wind) * 1/4)).^2; % page 372 or [3]
fft_onesided = abs(Ptot(1:NFFTv/2+1));
figure;
semilogx(fv, 10*log10(fft_onesided)); 
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;

% ----------------- SNDR ------------------

fin = 500;
k = round(fin * NFFTv / Fs) + 1;
sigbin = k-1:k+1;
sigpow = sum(fft_onesided(sigbin));
npow = sum(fft_onesided(3:end)) - sigpow;

sndr = 10*log10(sigpow./npow);  % 91.228 dB SNDR Obtained