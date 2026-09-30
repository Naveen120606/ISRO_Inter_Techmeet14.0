---------------------------- MATLAB Codes ---------------------------------

SQNR_CALCULATION - Script to plot PSD and evaluate SQNR for the DSM output
HP_DTDSM_SHAPING_AND_DEMODULATION - To visualise noise shaping for HPDSM and calculation of SQNR using digital demodulation, simulated SQNR of 139dB for 496Hz, with zero at pi/rt3OSR, include HP DSM data file – HIGHPASS_DSM_OUTPUT_496_Hz_OSR_2048
designFlickerFilter - Function to generate custom 1/f filter with input param of flicker corner frequency and gives the filter response used to generate flicker in simulink. This models only flicker, there is no thermal flatness, thermal noise is modelled separately.
FLICKER_MODEL - Include the above function, and give the flicker corner to plot the filter response used to generate flicker noise (1/f, 10dB/dec). 40dB is the filter gain at low frequencies.
ELD_CALCULATION - calculation of k0, k1 and k2 coefficients to compensate for ELD, only ‘a’ is changed, ‘b’, ‘g’, and ‘c’ parameters remain unchanged.
ABGC_CALCULATION_DT - Get the agbc coefficients for given parameters and topology for DTDSM.
AGBC_CALCULATION_CT - Get the agbc coefficients for given parameters and topology for CTDSM without zero.
AGBC_CALCULATION_CT_ZEROES - Get the agbc coefficients for CTDSM if zeros in NTF is desired.

---------------------------- MATLAB Simulink Files -----------------------------

Fs = 2ksps —

Discrete Time DSM —

DT_DSM_FIRST_ORDER_OSR_2048 - Single bit, first order, SQNR = 102dB
DT_DSM_SECOND_ORDER_OSR_2048 - Single bit, second order, SQNR = 149dB
DT_DSM_THIRD_ORDER_OSR_512 - Single bit, third order, SQNR = 148dB
DT_DSM_SECOND_ORDER_OSR_1024_ONE_BIT_QUANTIZER - SQNR = 130.8dB
DT_DSM_SECOND_ORDER_OSR_1024_TWO_BIT_QUANTIZER - SQNR = 135.2dB
DT_DSM_SECOND_ORDER_OSR_1024_THREE_BIT_QUANTIZER - SQNR = 143dB
DT_DSM_CIFB_LOWPASS_2nd_2048 - CIFB Architecture, without zero, SQNR = 143dB
DT_DSM_CIFF_LOWPASS_2nd_2048_WITHOUT_ZERO - CIFF Architecture, SQNR = 145.23dB
DT_DSM_CIFF_LOWPASS_2nd_2048_WITH_ZERO - CIFF Architecture with ‘g’, SQNR = 150.79dB
DT_DSM_CRFF_LOWPASS_2nd_2048 - CRFF Architecture with zero (pi/rt3OSR), SQNR = 150dB
DT_DSM_CRFB_LOWPASS_2nd_2048 - CIFB Architecture with zero (pi/rt3OSR), SQNR = 147.8dB
DT_DSM_CIFF_MODEL_SECOND_ORDER_OSR_2048_FLICKER_NOISE - This adds flicker noise, offset and thermal noise to existing CIFF architecture with zero, to run this, first the FLICKER_MODEL script needs to be run. SQNR = 80.0 dB (without chopping).
DT_DSM_CIFF_HIGH_PASS_MODEL_SECOND_ORDER_OSR_2048_FLICKER_NOISE - Simulated plots of high pass noise shaping (traditional bowl like NTF mirrored about Fs/2). To run this, first FLICKER_MODEL needs to be run.
DT_DSM_CIFF_HIGH_PASS_SECOND_ORDER_FLICKER_NOISE_CHOPPING - Demodulation of the HPDSM and evaluation of SQNR, SQNR = 142.5dB

CTDSM —

CTDSM_CIFF_SECOND_2048_WITHOUT_ELD - Without NTF zero and without ELD, SQNR = 143.19dB
CTDSM_CRFF_SECOND_2048_WITHOUT_ELD - No ELD is modelled, with NTF zero, SQNR = 147.17dB
CTDSM_CIFF_SECOND_2048_WITH_ELD_PRE_COMPENSATION - With ELD=0.25Ts, without zero, without compensation, SQNR = 139.13dB, poles moved away from origin
CTDSM_CIFF_SECOND_2048_WITH_ELD_COMPENSATION - ELD = 0.25Ts is compensated, without zero, SQNR = 142dB, poles are pulled back to origin.
CTDSM_CRFF_SECOND_2048_ANTI_ALIASING - An input of 0.99Fs is and the anti-alias property is verified as it gets rejected by the NTF notches.
CTDSM_CIFF_SECOND_WITH_FLICKER_WITHOUT_ELD - Flicker noise is added, SQNR = 89.72dB.
CTDSM_CIFF_WITH_LOCAL_CHOPPING - Local chopping around integrator (modelled using an ideal opamp) is used, simscape and simscape electrical toolbox is used, it should be downloaded.  SQNR = 147.17dB, run ELD_CALCULATION before running this file. 
CTDSM_CIFF_SECOND_2048_SINGLE_CHOPPING,, first FLICKER_MODEL needs to be run and change sigbins in sigpow in SQNR_CALCULATION from 3:round(end/OSR) to 1:round(end/OSR) to include DC bins. SQNR = 143.64dB
CTDSM_CIFF_SECOND_2048_RESIDUAL_OFFSET_CHOPPING, first FLICKER_MODEL needs to be run and change sigbins in sigpow in SQNR_CALCULATION from 3:round(end/OSR) to 1:round(end/OSR) to include DC bins. Injection/Feedthrough is modelled as pulses @Fs/2. SQNR = 120.86dB.
CTDSM_CIFF_OPAMP_NESTED_CHOPPING - to run this file , first FLICKER_MODEL needs to be run and change sigbins in sigpow in SQNR_CALCULATION from 3:round(end/OSR) to 1:round(end/OSR) to include DC bins. Residual DC is upconverted and filtered. SQNR = 133.08dB.
CTDSM_AUTOZEROING_MODELLING - Autozeroing is simulated on simulink for a 1-bit quantizer.  Offset is reduced using a pre-amplifier and autozeroing is done on the pre-amplifier. Offset is reduced from 0.3V to 0.021V (reduced by a factor of A_preamp for the comparator offset and 1/(A_preamp+1) for the preamplifier.


L_z_REALIZATION – 

Includes 4 data files, which contains the sampled output sequence of L(z) – No delay, with tau = 0.25Ts (with and without compensation), and tau = 0.5Ts (without compensation). Import these 4 data files, and then run the ztrans.m file to see the pole movement of NTF away from origin and pulling back of NTF poles back to origin. 
Simulink Files – 
REALIZE_DISCRETE_LOOP_FILTER_L_z_WITHOUT_DELAY - Get the sampled output sequence without any ELD.
REALISE_DISCRETE_LOOP_FILTER_L_z_WITH_COMPENSATION - Get L(z) for the ELD compensated version.