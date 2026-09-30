function [flickerfilter, z, p] = designFlickerFilter(fcorner)

% The approximation consists pole/zero pairs, where the zero frequency is
% higher than the pole frequency by a factor of the square root of 10, and
% the pole/zero pairs are separated by a factor of ten. Each pole/zero pair
% adds a decade to the frequency span of the approximation.

    pzfactor = 10;

    if fcorner <= 0
        flickerfilter = ss(0,0,0,1);
        z = [];
        p = [];
        return;
    end

    % In the original filter, there is 0dB after the flicker corner, 
    % thus if we need high flicker variance, the thermal floor also 
    % increases with the flicker variance due to the 0dB in the filter 
    % after corner frequency giving an unnecessary high thermal floor.


    % In order to remove the dependence of thermal floor with flicker variance, 
    % 10 poles were added at the flicker corner frequency to get only flicker 
    % noise after this filter. Thermal noise was modelled SEPARATELY with 
    % complete freedom on its variance and hence the thermal noise floor.

    % Get 40dB gain at near DC frequencies, and - inf dB gain @ freq > flicker
    % corner frequency, and 1/f profile till corner frequency

    % ------ Frequency calibration ----
    % Scale factor chosen so that |H(j*2*pi*fcorner)| ≈ -3 dB
    % after designing the multi-pole/zero 1/f approximation.

    freqScale = 1.7043;      
    f_eff     = freqScale * fcorner;

    % --- 1/f Approximation (4 decades) ---
    num_decades_1of = 4;
    powers_1of = 10 .^ (-(num_decades_1of-1) : 0);
    % frequencies: f_eff/1e3, f_eff/1e2, f_eff/1e1, f_eff

    % Poles for 1/f section
    poles_1of = -2*pi*f_eff * powers_1of;

    % Zeros: sqrt(10) above poles in frequency
    zeroz = poles_1of * sqrt(pzfactor);

    % Roll-off to remove thermal after flicker corner
    num_hf_poles = 10;
    poles_hf = -2*pi*f_eff * ones(1, num_hf_poles);

    % Combine
    p = [poles_1of, poles_hf];
    z = zeroz;

    k_correction = prod(abs(poles_hf));

    zpkform       = zpk(z, p, k_correction);
    flickerfilter = ss(zpkform);
end
