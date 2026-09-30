

[ff_ss,ff_z,ff_p] = designFlickerFilter(100000); % 100kHz worst case flicker corner frequency
[b,a] = ss2tf(ff_ss.A,ff_ss.B,ff_ss.C,ff_ss.D);
[r,p,k] = residue(b,a);
[mag,phz,w] = bode(ff_ss);grid on;
f = w/(2*pi);
mag_dB = 20*log10(abs(squeeze(mag)));
semilogx(f,mag_dB);grid on;
title('1/f Filter Magnitude Response')
xlabel('Hz');ylabel('dB')


