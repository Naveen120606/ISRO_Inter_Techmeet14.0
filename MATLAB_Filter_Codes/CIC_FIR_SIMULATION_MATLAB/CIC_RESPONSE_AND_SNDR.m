close all;

v1 = HIGHPASS_DSM_OUTPUT_500_Hz_OSR_2048; % Contains output of HPDTDSM including flicker, offset and thermal noise
noisyData = v1;

% ------------ Demodulation for simulation purpose (Actually done in HDL code) ------------

u_bipolar = 2*double(v1(:));

carrier = ones(size(u_bipolar));
carrier(2:2:end) = -1; % period 2Ts, freq Fs/2

v1 = (u_bipolar .* carrier);

R = 512; % Make length of v1, a multiple of decimation factor R
L = length(v1);
L_new = floor(L / R) * R;
v1 = v1(end - L_new + 1 : end);
Fs = 2e3;
FS = 1;

% ------------------- CIC --------------------
% R --> Decimation Factor, M --> Differential Delay, N --> Number of Stages 

R1 = 512; M1 = 1; N1 = 4; % Final used design for max SQNR for 20 bit ADC Resolution and least passband droop (1dB)
R2 = 1024; M2 = 1; N2 = 2; % Can change to check for other R/N

cic1 = dsp.CICDecimator(R1 ,M1, N1); % MATLAB construct object representing CIC filter
cic2 = dsp.CICDecimator(R2 ,M2, N2);

fvtool(cic1); % fvtool is used to plot frequency response

% for CIC1 ---- 0Hz - 216.74dB, 000488*pi (pi/2048) ---- 215.84dB (1 dB passband droop), Simulated SQNR - 108dB, can be used for 20 bit resolution

y = cic1(v1); % Uses cic1 to filter data v1
% y = cic2(y); % Can be used for cascading cic1 and cic2 for other R, N combinations
downsample = 4;
y = y(1:downsample:end); % Downsampling by downsample (Since R is 1024, and OSR is 2048)
filteredData = y;
v1 = y;

% can adjust NFFTv for coherent sampling if smearing in FFT is observed

NFFTv = 2000; % v1 will contain filtered data depending on which filter is being used
L = NFFTv;
fv = Fs/2*linspace(0, 1, NFFTv / 2 + 1); % Frequency vector (Hz)


% ------------------ PSD ------------------

wind = hann(L, 'periodic');
fft_outv = fft(v1 .* wind, NFFTv);

Ptot = (abs(fft_outv)/(FS * sum(wind) * 1/4)).^2; % Page 372 of [3]
fft_onesided = abs(Ptot(1:NFFTv/2+1));
figure;
semilogx(fv, 10*log10(fft_onesided)); 
xlim([0 Fs/2])
xlabel('Frequency [Hz]');
ylabel('Amplitude [dB]');
grid on;

% ---------------- SNDR ----------------

fin = 500; 
k = round(fin * NFFTv / Fs) + 1;
sigbin = k-1:k+1;
% For signal power, integrate over input signal BW
sigpow = sum(fft_onesided(sigbin));
% For noise Power, integrate till nyquist frequency and subtract signal power.
npow = sum(fft_onesided(3:round(end))) - sigpow;
sndr = 10*log10(sigpow./npow);
