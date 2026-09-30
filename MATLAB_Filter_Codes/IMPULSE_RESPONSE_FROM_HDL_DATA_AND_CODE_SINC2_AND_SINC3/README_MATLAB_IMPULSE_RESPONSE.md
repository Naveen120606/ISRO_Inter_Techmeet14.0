## Overview
This MATLAB script loads impulse response data from a file, visualizes it, and computes the frequency response characteristics of the system. The analysis includes both magnitude and phase responses with automatic 3 dB cutoff detection.

## Features
1. **Automatic Signal Scaling**: Automatically detects and scales impulse responses with large DC offsets
2. **Frequency Response Analysis**: 
   - Computes magnitude response in dB (normalized to 0 dB at DC)
   - Identifies -3 dB cutoff frequencies
   - Plots phase response in degrees
3. **Visualization**: 
   - Time-domain impulse response plot
   - Normalized magnitude response with cutoff markers
   - Phase response plot

## Technical Specifications
- **Sampling Frequency**: 4.096 MHz (fs = 4096000 Hz)
- **FFT Size**: 8192 points
- **Frequency Range**: 0 to π rad/sample (DC to Nyquist)
- **Normalization**: Magnitude response normalized to 0 dB at DC
- **Cutoff Detection**: Automatic -3 dB point identification

## Input Requirements
- Input file: `IMPULSE_RESPONSE_SINC3_32.txt`
- Format: Plain text with impulse response coefficients (one per line)
- The script handles both centered and non-centered impulse responses automatically

## Outputs
1. **Figure 1**: Impulse response in time domain (auto-scaled)
2. **Figure 2**: Normalized magnitude response in dB with -3 dB cutoff markers
3. **Figure 3**: Phase response in degrees

## Key Calculations
- Magnitude: `20*log10(abs(H))` normalized to DC
- Phase: Unwrapped phase in degrees
- Normalized frequency: `ω/π` (0 to 1 corresponds to 0 to fs/2)
- -3 dB cutoff detection using threshold crossing algorithm

## Usage
1. Place impulse response data in `IMPULSE_RESPONSE_SINC3_32.txt`
2. Run the script in MATLAB
3. Review the three generated figures for system analysis


