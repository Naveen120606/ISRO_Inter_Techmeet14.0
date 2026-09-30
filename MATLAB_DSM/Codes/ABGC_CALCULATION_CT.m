order = 2; 
OSR = 2048; 
form = 'FF'; % Chosen Form : (FF, FB)
fs = 2000*2048; % Sampling Frequency
optimFlag = 0; % optimization option for synthesizeNTF()
H_inf = 1.5; % OBG value 
f0 = 0; % Zero location

[aff, gff, bff, cff] = msblks.ADC.dsmAdcFindCTcoeff(order, OSR, form, optimFlag, H_inf, f0)