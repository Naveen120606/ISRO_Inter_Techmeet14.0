close all; clear; clc;

% ----------------- PARAMETERS ----------------------

order = 2;     % Order of filter
OSR = 2048;     % Oversampling Rate 
nLev = 2;       % Number of quantizer levels 
f0 = pi/(sqrt(3)*OSR);   % NTF Zero frequency
% f0 = 0;                % Use if no Zero is needed in NTF
H_inf = 1.5; % OBG (Lee's Rule)
opt = 0; % optimization option for synthesizeNTF()
xLim = 1.6;     % State limit for Dynamic Range Scaling (saturation margin)
form = 'CIFF';  % Chosen topology: Cascade of Resonators, Feedback (CIFB, CIFF, CRFB, CRFF)
Fs=OSR*2e3; 

% ------------ NTF ------------

H = synthesizeNTF(order, OSR, opt, H_inf, f0); 
f_norm = linspace(0.00001, 0.5, 1000);
f_hz = f_norm * Fs;                    
z = exp(2i*pi*f_norm);

figure(1);
semilogx(f_hz, dbv(evalTF(H,z)), 'LineWidth', 2, 'DisplayName', 'Ideal NTF');
grid on;
title('Noise Transfer Function (NTF) Frequency Response');
xlabel('Frequency (Hz) [Log Scale]');
ylabel('|H(z)| (dB)');
legend('show');

% --------------- AGBC Calculation and Dynamic Range Scaling -----------------

% A. Realize NTF (Get Unscaled a, g, b, c)
[a_unscaled, g_unscaled, b_unscaled, c_unscaled] = realizeNTF(H, form);
b_unscaled(2:end) = 0; % Set b(2:end)=0 for a maximally flat Signal Transfer Function (STF)

% B. Convert to state-space ABCD matrix
ABCD = stuffABCD(a_unscaled, g_unscaled, b_unscaled, c_unscaled, form);

% C. Dynamic Range Scaling
% Scales the internal states (ABCD) to ensure max state is below xLim=0.9
[ABCDs, umax] = scaleABCD(ABCD, nLev, f0, xLim);

% D. Map scaled ABCD matrix back to final scaled a, g, b, c coefficients
[a_scaled, g_scaled, b_scaled, c_scaled] = mapABCD(ABCDs, form);

% ---------------- Display final scaled coefficients -----------------
fprintf('\n--- 4. Final Scaled Coefficients ---\n');
fprintf('a_scaled:'); disp(a_scaled);
fprintf('g_scaled:'); disp(g_scaled);
fprintf('b_scaled:'); disp(b_scaled);
fprintf('c_scaled:'); disp(c_scaled);