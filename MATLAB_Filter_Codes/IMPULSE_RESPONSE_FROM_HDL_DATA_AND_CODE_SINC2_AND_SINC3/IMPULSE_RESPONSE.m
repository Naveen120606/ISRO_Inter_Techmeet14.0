clear; clc; close all;

filename = 'IMPULSE_RESPONSE_SINC2_1024.txt';
h = load(filename);
n = length(h);
rng_val = max(h) - min(h);
if rng_val > 100 * mean(abs(h))       
    h_plot = h - mean(h);             
    h_plot = h_plot / max(abs(h_plot)); 
else
    h_plot = h;
end 
figure;
plot(h_plot, 'LineWidth', 1.5);
title('Impulse Response (Auto Scaled)');
xlabel('Sample Index');
ylabel('Amplitude');
grid on;
b = h.';
a = 1;
N_fft = 8192;
[H_freq, w] = freqz(b, a, N_fft, 'whole');
fs = 4096000;
f_Hz = w * fs / (2*pi);   
f_normalized = w / pi;   
magnitude = abs(H_freq);
magnitude_dB = 20 * log10(magnitude + eps);  % eps guards against log(0)
magnitude_dB_normalized = magnitude_dB - magnitude_dB(1);
cutoff_3dB = -3;
above_cutoff = magnitude_dB_normalized >= cutoff_3dB;
cutoff_indices = find(diff(above_cutoff(1:N_fft/2)) ~= 0) + 1;
fraction_str = @(x) strrep(strtrim(rats(x)), ' ', '');  
figure('Position', [150, 50, 900, 450]);
plot(f_normalized(1:N_fft/2), magnitude_dB_normalized(1:N_fft/2), ...
     'b-', 'LineWidth', 2.2);
hold on;
yline(cutoff_3dB, 'r--', 'LineWidth', 2, 'Label', '-3 dB Cutoff');
if ~isempty(cutoff_indices)
    for i = 1:length(cutoff_indices)
        idx = cutoff_indices(i);
        frac = fraction_str(f_normalized(idx));  
        plot(f_normalized(idx), magnitude_dB_normalized(idx), 'ro', ...
             'MarkerSize', 9, 'MarkerFaceColor', 'red');
        text(f_normalized(idx), magnitude_dB_normalized(idx)+2, ...
             sprintf('f_{3dB} = %s\\pi', frac), ...
             'FontSize', 12, 'FontWeight', 'bold', 'Color', 'red', ...
             'HorizontalAlignment', 'center');
    end
end
grid on;
title('Normalized Magnitude Response (0 dB at DC)');
xlabel('Normalized Frequency (×\pi rad/sample)');
ylabel('Magnitude (dB)');
xlim([0 1]);
ylim([-80 5]);
legend('Magnitude Response', '-3 dB Cutoff', '3 dB Points', 'Location', 'best');
phase_rad = unwrap(angle(H_freq));   
phase_deg = phase_rad * 180/pi;        
figure('Position', [200, 100, 900, 450]);
plot(f_normalized(1:N_fft/2), phase_deg(1:N_fft/2), 'LineWidth', 2);
grid on;
title('Phase Response');
xlabel('Normalized Frequency (×\pi rad/sample)');
ylabel('Phase (degrees)');
xlim([0 1]);
