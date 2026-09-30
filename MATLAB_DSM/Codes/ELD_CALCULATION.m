order = 2; % Filter order
OSR = 2048; % OSR
Fs = 32768*32; % Sampling Frequency
N = 100e3; % Number of Points
opt = 1; % Optimization (=1 for odd order)
H_inf = 1.5; % OBG (Lee's Rule)
f0 = 0; % zero location (if required)
form = 'CIFF'; 
nlev = 2; % Quantization Levels
fs = 1; % Normalized Sampling Frequency
In_FS = 1.8; % Full-Scale Input

ntf = synthesizeNTF(order,OSR,opt,H_inf,f0);
L_z = (1/ntf) - 1;
l = impulse(L_z, 10);                        % impulse response of the discrete model (10 samples)
x1 = impulse(c2d(tf(1, [1 0]), 1), 10);       % impulse response of term 1/s (10 samples)
x2 = impulse(c2d(tf(1, [1 0 0]), 1), 10);     % impulse response of term 1/s² (10 samples)
K = [x1 x2]\l;                             % loop-filter coefficients for the CT model
eld = 0.25; % ELD is from 0 to 1
ELD = [1 eld; 0 1; eld eld^2/2];
Kc = ELD*K; % [k1, k2, k0] respectively