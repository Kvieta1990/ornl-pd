# A note on data binning...

## Logarithmic binning

The diffraction resolution of a Time-of-flight diffractometer is typically complex and depends on multiple instrument characteristics (including moderator design, flight path, beam divergence pixel size etc.) in addition to geometric factors such as scattering angle. For powder Bragg diffraction a key consideration is the uncertainty of the d-spacing of a peak $\delta d$, which manifests as the Bragg peak width and, in general, the peak profile (and leads to the well-known assymetriy of TOF Bragg peaks). By using the de Broglie relation to equate wavelength to neutron momentum and substituting this into Bragg's law, we can express d-spacing in terms of the time-of-flight measurement. Differentiating with respect to these measurement variables allows us to estimate $\delta d$ as shown by Worlton et al {cite:p}`WORLTON1976`:

$\frac{\delta d}{d} = \sqrt{[\delta \theta ^2 cot ^2 \theta + (\frac{\delta T}{T})^2 + (\frac{\delta L}{L})^2}$ - (0)

* $\delta \theta$ is the total uncertainty of scattering angle (a combination of beam divergence convolved with sample size and pixel angular acceptance). Details of neutron guides can lead to a wavelength dependence of divergence, however, this can often be neglected.
* $\theta$ is the scattering angle (i.e. half od $2\theta$)  
* $\delta L$ is the total flight uncertainty, since this is small relative to L, thd entire $\frac{\delta L}{L}$ term can often be neglected.
* $\delta T$ the total uncertainty in time-of-flight T. An important contribution to this uncertainty is the source pulse width. This latter depends on details of the moderator but if often found to be linearly dependent on wavelength, and therefore time-of-flight, meaning $\frac{\delta T}{T}$ can be taken as a constant 

Under these assumptions, it can be seen that - for diffraction measured by a detector at fixed angle - $\frac{\delta d}{d}$ is a constant. Or, in other words, the Bragg peaks will sharpen at a linear rate as d-spacing decreases. It is important that when neutron events are sampled as a function of time-of-flight that the sampling frequency should also linearly increase as d-spacing. This manifests in the choice of histogram bin sizes ,which would ideally be linearly proportional to d-spacing. 

In logarithmic binning, the histogram bin edges are generated recursively with successive edges relating to the preceding edge via:

$x_{j+1} = x_j(1+\Delta X_i)$ - (1)

Where the unitless parameters $\Delta X_i$ are constant for a given spectrum, $i$ and will be referred to as the logarithmic binning parameter.

From (1) we can $n^{th}$ bin edge can be determined from the first bin edge $x_0$ via:

$x_{n} = x_0(1+\Delta X_i)^n$ - (2)

And that the bin width of the $n^{th}$ bin, $w_n = x_{n+1} - x_n$ will be:

$w_n = x_0 \Delta X_i (1+\Delta X_i)^n$ - (3)

The ratio of (3) over (2) shows that, for this binning scheme, 

$\frac{w_n}{x_n} = \Delta X_i$ - (4)

which is a constant, hence logarithmic binning has the desired property bin widths being linearly proportionaly to x-value. All data reduced by SNAPRed will use logarithmic binning.

## Choice of binning parameter $\Delta X_i$

Ultimately, all analysis of powder Bragg intensities is via some kind of peak-fitting approach, typically using Rietveld refinement. Consequently, the sampling rate of a given Bragg peak (i.e. the number of measurements across its extent) must consider the peak model that will be deployed. These models can be complicated, particularly for TOF diffraction peaks (The commonly used "TOF profile function 3" in the GSAS refinement package {cite}`GSAS` has up to 21 potential coefficients). The sampling density can be quantified by defining the quantity $N_{FWHM}$ to be the number of histogram bins across a given peak's Full Width Half Maximum $F$. Correspondingly, in spectrum $i$, for a Bragg peak centred on $d_n$, we need a bin width $w_n$ given by:

$w_n=\frac{F_n}{N_{FWHM}}=\Delta X_i d_n$

where we've replaced $x$ with $d$ as the units will be in d-spacing (but keep the log binning param as $X$ as it is dimensionless). We can then rearrange to give: 

$\Delta X_i = \frac{F_n}{N_nd_n}$

If we estimate the resolution of our spectrum by fitting a Gaussian peak shape to Bragg peaks observed from a ideal, strain-free cpeak profile calibrant (such as NIST silicon (640d) powder) we can calculate the FWHM as $F_n=2\sqrt{2ln2}\sigma$ where $\sigma$ is the variance of the Gaussian and taking $d_n$ as its position. Since $\frac{\delta d_n}{d}$ is a constant, this will apply to the entire spectrum.  

Using this approach, SNAPRed determines the log binning parameter by first modelling the instrument resolution - using empirically determined parameters for the resolution Equation (0) at the individual pixel level. It then assesses, according to a chosen pixel scheme, the average value of $\frac{\delta d}{d}$ for a given pixel group and determines $\Delta X_i$ using a fixed value of $N_{FWHM}$ ensuring that all Bragg peaks, irrespective of their d-spacing or how pixels are combined are equivalently sampled.

### Conversion to momentum transfer

When conducting analysis of SNAP data using the pair-distribution function approach, it is common to convert reduced data from units of d-spacing, d (Å) to units of momemtum transfer, Q (Å$^{-1}$). These quantities are inversely related via the relation $Q = \frac{2\pi}{d}$. Thus, if the original x-array containing N histogram bin edges is: 

$\mathbf{d} = [d_0,d_1,d_2,...d_N]$

the transformation will generate a new x-array

$\mathbf{q} = [q_0,q_1,q_2,...q_N]$

during conversion (by mantid's `ConvertUnits`) it is ensured that x-arrays always increase from smallest to largest value. Due to the inverse relation between $d$ and $Q$, this means that

$q_k = \frac{2\pi}{d_N-k}$

The corresponding bin widths can be calculated as

$w^q_k = q_{k+1} - q{k} = \frac{2\pi}{d_{N-k-1}}-\frac{2\pi}{d_{N-k}}$

Substituting expression (2) for $d$  and simplifying we can show that

$w^q_k = \frac{2\pi \Delta X}{d_0(1+\Delta X)^{N-k}}$

and

$w^q_k = Q_0\Delta X(1+\Delta X)^k$

showing that the resultant q array is also log-binned with identical binning parameter as the original d-array. Moreover, if we divide equivalent bin widths in the $q$ and $d$ arrays:

$\frac{w^q_n}{w_n}=\frac{q_0\Delta d(1+\Delta X)^n}{d_0\Delta d(1+\Delta X)^n}=\frac{q_0}{d_0}=\frac{2\pi}{d_Nd_0}$

we find that these are identical barring multiplication by a factor of $\frac{2\pi}{d_Nd_0}$. 
