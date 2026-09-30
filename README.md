# Delta-Sigma ADC Decimation Filter ASIC

## Overview

This repository contains the RTL design, simulation, and ASIC implementation details for a high-precision Decimation Filter designed for a Delta-Sigma Analog-to-Digital Converter (ADC). The objective of this project is to process a high-frequency, 1-bit oversampled bitstream from a Delta-Sigma Modulator (DSM) to achieve an Effective Number of Bits (ENOB) greater than 16 at Nyquist sampling frequencies ranging from 0.5 ksps to 2 ksps.

The system utilizes a High-Pass Discrete-Time Delta-Sigma Modulator (HP-DTDSM) architecture with system-level chopping to mitigate flicker noise and offset. The digital backend features an optimized Cascaded Integrator-Comb (CIC) filter designed for low hardware complexity and high signal-to-noise and distortion ratio (SNDR).

## Key Features

* **Target Performance:** > 16 ENOB, 20-bit output resolution, 0.5 - 2 ksps sampling rate.

* **Modulator Architecture:** 2nd-order High-Pass Discrete-Time Delta-Sigma Modulator (CIFF topology).

* **Noise Mitigation:** Implementation of system-level chopping (F_s/2 modulation) and Mirrored Integrators to completely eliminate flicker noise and DC offsets without folding quantization noise into the baseband.

* **Decimation Filter:** Hardware-efficient 4th-order CIC filter with a decimation factor of 512, followed by a 4x downsampler (Total OSR = 2048).

* **Optimized Datapath:** Output truncation techniques implemented without droop compensation, specifically tuned for maximum SNDR and minimum hardware footprint.

* **ASIC Node:** Validated and synthesized using a 65nm technology library.

## System Architecture

### 1. Delta-Sigma Modulator (Analog Front-End Modeling)

Extensive architectural exploration was conducted comparing Continuous-Time (CT) and Discrete-Time (DT) DSMs. The final selected architecture is a **High-Pass DTDSM**.

* **Oversampling Ratio (OSR):** 2048

* **Quantizer:** 1-bit (to ensure inherent linearity and avoid complex DEM logic)

* **Out of Band Gain (OBG):** 1.5 (optimized for stability)

### 2. Digital Decimation Filter (RTL)

The high-frequency 1-bit output stream from the modulator is processed through the following digital stages running at a system clock of 4.096 MHz:

1. **Demodulator:** Multiplies the incoming 1-bit bitstream by a periodic F_s/2 square wave sequence to translate the high-pass shaped signal back to the baseband.

2. **CIC Filter:** A 4th-order filter with a decimation ratio (R) of 512. The structure uses a cascaded integrator chain, a downsampler, and a comb chain.

3. **Downsampler:** An additional 4x downsampler reduces the sampling frequency to the final target of 2 ksps.

4. **Truncation Logic:** The internal 38-bit accumulator output is heavily optimized and truncated to the required 20-bit ADC resolution using precise bit-slicing \[35:16\].

## ASIC Implementation Flow

The digital filter was synthesized and taken through the complete Physical Design (PD) flow.

* **Technology Node:** 65nm

* **Synthesis:** RTL was synthesized into a gate-level netlist emphasizing power, area, and timing optimizations.

* **Physical Design Layout:**

  * **Floorplanning & Power Planning:** Custom power rings, stripes, and core area definitions.

  * **Placement & Clock Tree Synthesis (CTS):** Optimized standard cell placement and balanced clock distribution.

  * **Routing:** Fully routed design ensuring zero Design Rule Check (DRC) violations.

* **Timing Analysis:** Operating at a 250 ns clock period (4 MHz), the critical path (38-bit ripple-carry propagation) exhibits robust positive slack, utilizing only \~1.36% of the available clock period.

## Performance Results

### Post-Layout Simulation

The final SDF-annotated post-layout simulation successfully met the project specifications:

| **Input Frequency (Hz)** | **SNDR (dB)** | **ENOB** | **Passband Droop (dB)** | 
| 10 | 112.40 | 18.40 | 1.1 | 
| 500 | 113.64 | 18.60 | 1.1 | 
| 990 | 111.05 | 18.15 | 1.1 | 

## Tools Used

* **System-Level Modeling:** MATLAB, Simulink, Delta-Sigma Toolbox

* **RTL Simulation & Verification:** Vivado, VCS

* **Logic Synthesis:** Design Compiler

* **Physical Design (P&R):** Innovus

## Repository Structure

*(Note: Adjust this structure based on the actual folders pushed to your repository)*

```
├── CIC_RTL_Codes/                # Verilog source files (CIC)
├── FIR_RTL_Codes/                # RTL code files for FIR 
├── MATLAB_DSM/              # MATLAB code files for Delta Sigma Modulator
├── MATLAB_Filter_Codes/             # MATLAB code files for digital filter
└── README.md           # Project documentation

```

4. The output will be dumped into a `.txt` or `.csv` file, which can be analyzed using the provided MATLAB scripts in the `docs/` or `sim/` folder to calculate the resulting PSD, SNDR, and ENOB.
