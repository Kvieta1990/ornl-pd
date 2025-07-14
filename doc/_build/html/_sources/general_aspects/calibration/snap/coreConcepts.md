# Core Concepts

## Understanding "Lite" mode

Significant effort has gone into careful compression of SNAP data to maximise processing time while maintaining diffraction resolution. These compressed data are referred to as "Lite" and, by default, this compression will be used. In a very small number of cases, the resolution of the output data can be increased by deactivating lite mode and the corresponding "Native" mode is supported for all reduction operations. This will typically manifest as a toggle called `isLite` which has (default) value of True for compressed data and can be set to False for Native mode.

```{note}
Part of the compression used in lite mode involves merging the neutron events in adjacent pixels. This affects how pixels are numbered (and, indeed, the total number of unique pixels defined). Correspondingly, all auxilliary information (for example pixel masks) must correctly correspond to the lite or native mode being used.
```

## A note on pixel grouping schemes

SNAP has 1.2M pixels in its detectors. During reduction, the events measured in these individual pixels are merged according to a pixel grouping scheme - via a process called "diffraction focussing" - leading to a small number of familiar 1d powder diffraction patterns. The choice of pixel grouping scheme is entirely arbitrary but, by default, data measured on SNAP will be reduced according to 3 different schemes: 

|Scheme Name | Number of spectra | Description |
|------------| ----------------- | ----------- |
| all        | 1 | All pixels in the instrument are merged into a single spectrum |
| bank       | 2 | Pixels in the two separate detector banks are merged into one spectrum per bank |
| column     | 6 | The pixels in the 6 vertical columns formed by the individual detector banks are merged separately |

These 3 different grouping schemes are always available and allow different views on the data, and allowing optimal compromise between angular resolution and count levels to be found. 

It is also possible to retain the unfocussed dataset, which will show the full angular resolution of the instrument: with complete powder pattern in each pixel (albeit a noisy pattern because a single pixel is small).

Finally, it is also possible to define custom pixel groups if needed for you experiment. An instrument scientist can help set these up.

## `SNAPRed` the reduction backend 

SNAP is unique amongst the SNS powder diffractometers in that it is highly reconfigurable. Each change of configuration, for example moving one of the detectors, modifies the calibration data and parameters needed to reduce data. For this reason, a sophisticated backend software application for reducing data - called [`SNAPRed`](https://github.com/neutrons/SNAPRed) has been developed. `SNAPRed` manages all of the effects of instrument configuration, greatly simplifying the user experience of reduction: by design, reduction is possible knowing only your neutron run number. 

## Symbols used in this section

Throughout this section, a consistent set of symbols described below has been used. 

### A note on array indexing

An important consideration is indexing due to the complex nature of TOF datasets. Each pixel is an independent, TOF-resolving detector that collects a dataset that can be represented as an array: a list of events or a histogram. So, in general, we need to give an index for a specific pixel _and_ an index for a element in an associated data array.

As a specific example, consider the case where the events in the $i^{th}$ pixel are histogrammed according to an array of TOF bins. We can refer to this array as $\mathbf{T}_i$ where $0\leq i \leq (N_{pix}-1)$ and where $N_{pix}=1179648$ for the native instrument and $N_{pix}=18432$ for the Lite instrument (i.e. the number of pixels). The bold font indicates this quantity is an array.

In turn, we would then refer to the $j^{th}$ element within the $i^{th}$ array as $T_{i,j}$, no longer using a bold font as this is now a single value. Here, it's important to remember that, in general, the size of the data arrays can vary between pixels.    

An important operation in data handling within `SNAPRed` is diffraction focusing, whereby the data in multiple spectra are combined, effectively replacing many pixels with a single "super pixel" for each group as defined by a pixel grouping scheme. We will represent diffraction focussed data by enclosing the affected array in $\{$ and $\}$ brackets but otherwise use a similar indexing, using capital letters for the indices. Thus, if we used a pixel grouping scheme with $N_{grp}$ groups of pixels, this will result in $N_{grp}$ arrays containing d-spacings and the array for the $I^{th}$ group would be $\{\mathbf{d}\}_I$. As above, we can refer to the $J^{th}$ element within this array using $\{d\}_{I,J}$

### The symbols

| Symbol       | Units         | Description |
|-------       |-------        |-------------|
|$h$ | j.Hz$^{-1}$ | Planck's Constant |
| $m_n$ | kg | neutron mass |
|$\lambda$  | Å | wavelength values|
|$T$  | $\mu$s        | TOF values|
|$d$  | Å        | d-spacing values|
|$hkl$| | Miller indices|
|$Z$  | $\mu$s          | zeroth order diffractometer constant |
|$C$  | $\mu$s.Å$^{-1}$          | first order diffractometer constant |
|$A$  | $\mu$s.Å$^{-2}$          | second order diffractometer constant |  
