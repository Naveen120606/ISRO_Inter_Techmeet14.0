clear; clc;
OSR    = 2048;
Fs     = 2000 * OSR;          
fb     = Fs/(2*OSR);          % signal band edge = 1000 Hz
order  = 2;                   
Hinf   = 1.5;                 % out-of-band gain
f0     = pi/(sqrt(3)*OSR);    % Location of Zero
formCT = 'FF';                % 'FF' -> CRFF, 'FB' -> CRFB
tdac   = [0 1];               % DAC pulse timing (NRZ)
nlev   = 2;                   % 1-bit quantizer
opt  = 0; 

ntf0 = synthesizeNTF(order, OSR, opt, Hinf, f0);
[~, p0, k0] = zpkdata(ntf0,'v');

% Zero Locations
wz   = pi/(sqrt(3)*OSR);      
z1   = exp(1j*wz);
z2   = conj(z1);

if order == 2
    z_new = [z1 z2];
else
    % 3rd order: one DC zero plus complex pair
    z_new = [1 z1 z2];
end

% Build NTF with same poles, desired zeros
ntf = zpk(z_new, p0, k0, 1);  % Ts = 1 sample

[ABCDc, tdac2] = realizeNTF_ct(ntf, formCT, tdac); 
[ABCDc_s, umax] = scaleABCD(ABCDc, nlev); % Scale for dynamic range

% Map CT ABCD to CR coefficients

if strcmp(formCT,'FB')
    formMap = 'CRFB';
else
    formMap = 'CRFF';
end

[a_ct, g_ct, b_ct, c_ct] = mapABCD(ABCDc_s, formMap);

fprintf('CT coefficients (%s):\n', formMap);
fprintf('  a = [%s]\n', num2str(a_ct));
fprintf('  g = [%s]\n', num2str(g_ct));
fprintf('  b = [%s]\n', num2str(b_ct));
fprintf('  c = [%s]\n', num2str(c_ct));