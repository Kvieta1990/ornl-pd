Roadmap
===

Keep track of the powder diffraction software development at ORNL, covering the key features implementation & plans, project-level activities, documentation & major updates, and among others, for data reduction and analysis software.

```{admonition} Powder Diffraction Plan Board
:class: hint

The roadmap Kanban board for powder diffraction software development at ORNL is hosted on GitHub [here](https://github.com/users/Kvieta1990/projects/6) for workload management.

To make contribution, get in touch with <a href="mailto:zhangy3@ornl.gov">Yuanpeng Zhang</a>.
```

``````{admonition} Work in Progress
:class: attention

- Powder diffraction data visualization tools and reduction configuration tools development in the ORNL `nova` platform. Here is the production environment, [nova.ornl.gov](https://nova.ornl.gov), and here is the test environment, [nova-test.ornl.gov](https://nova-test.ornl.gov).

- Texture correction for total scattering.

    > Use spherical harmonics to correct for the texture effect. This involves the correction over both the azimuthal and the polar angle. The polar angle bit is tricky as resolution effect is entangled with the potential texture effect.
``````

``````{admonition} New Features & Bug Fixes
:class: tip

- Analysis cluster monitor tool for monitoring the available system resources on available nodes, [https://addie.ornl.gov/analysis_mon](https://addie.ornl.gov/analysis_mon)

- RMCProfile in GSAS-II. See details [here](https://github.com/Kvieta1990/Kvieta1990/issues/68).

- Batch data merging tool for post processing the MantidTotalScattering reduction. See the documentation [here](https://powder.ornl.gov/data_tools/general.html#mts-data). For the feature mentioned here, refer to the `-g` flag.
``````

``````{admonition} Planned Items

- Add in NESL sample environment support in `MTS`.

- Fix the Bragg peak shape name output for the RMCProfile implementation in GSAS-II.

- Configuration of live and auto reduction on NOVA.

- Visualization of incommensurate magnetic structure on ADDIE web platform.

- RMCProfile version 6 upgrade

    - Test out the ADP constraint
    - Document the LAMMPS implementation and make tutorials for it
    - Check the X-ray resolution implementation, for both RMCProfile and Topas4RMC
    - Update the RMCProfile local dev env setup notes
    - Final testing before releasing, running through all the exercises

- RMCProfile version 7 developing

    - Add in the Topas Bragg profile support
    - Add in the resolution matrix support
    - Make sure all tutorials are working and representative
``````

``````{admonition} Backlog -- Items on the radar but not planned yet 
:class: note

- Proper normalization of HB-2A data by applying proper corrections to the vanadium measurement.

- Workshop for Mantid training among the instrument team.

- Make livereduction and autoreduction consistent for POWGEN.

- Web page for Mantid funky commands and usage, serving as a collection of tips for Mantid usage among the team.

- Criterion for determining the change of DIFC's, useful for checking whether calibration file from different cycles can be reused.

- Utility for checking the change of calibration constants and the number of masked pixels (and their distribution) when using diamond data with different measurement time for calibration.

- Output POWGEN autoreduction data in plain text.

    - Bragg data in d, Q and TOF spaces.

    - SofQ in .dat format & PDF in .dat format.

- Some useful routines for POWGEN configuration.

    - Tool for copy over the central configuration file and automatically bring up the editor for users to edit for a specified IPTS.

    - Parse the autoreduction json configuration file and prepare the XML file needed for manual reduction.

    - Alternative parameter for running the manual autoreduction to save output to a different folder.

- Same approach of auto and live reduction configuration on NOMAD as for POWGEN.

- Routines development on the data acquisition side.

    - Instrument control through API on command line.

    - PV monitoring.

- Updates for the HFIR estimator tool on ADDIE

    - Need to convert the origin choice 1 to origin choice 2 automatically to avoid the GSAS-II complaint on origin choice.

    - Need to generate a list of atoms from the uploaded CIF to a list of atom types with check box in front and update the web interface dynamically. Users can then check those magnetic species in the list. On our side, we need to grab the multiplicity of the selected sites and populate the corresponding input for the estimator.

- Add the link to the PowderDoc website on instrument landing page

- Update NOMAD & POWGEN data reduction demo links to point to the PowderDoc website pages

- Use the MongoDB vector search capability to implement some useful tools to mine the ONCAT database.

- RMCProfile version 7 support in GSAS-II.
``````

# Archive

## Jun-2025

- Automatic calibration job running on instrument machine. This is about the automatic calibration once a diamond run is detected. Due to the proton power upgrade, the strong scatterer diamond would yield more neutron counting than before which would create large file size and thus require large memory for data handling. The autoreducer cannot take such heavy a load and now with this implementation, we managed to tranfer the heavy loaded job of calibration to those instrument machines.

- Beam size definition is now available in the `abs_pre_calc` routine for the pre-calculation of absorption correction.

- User definition of sample and container geometry for absorption correction.

- A chunk-by-chunk Fourier filter routine `pystog_ck` made available to general users on Analysis cluster. This is based on the work by [Prof. Eric O’Quinn](https://ne.utk.edu/people/eric-oquinn/) and [Dr. Joerg C Neuefeind](https://www.ornl.gov/staff-profile/joerg-c-neuefeind). Detailed instructions can be found [here](https://powder.ornl.gov/data_tools/general.html).

- A hydrogen background removal routine is available on Analysis through `mts_data`. This is a wrapper routine for [EnggEstimateFocussedBackground](https://docs.mantidproject.org/nightly/algorithms/EnggEstimateFocussedBackground-v1.html) which estimates the background via a cycling process of applying the top-hat convolution and [CalculatePolynomialBackground](https://docs.mantidproject.org/nightly/algorithms/CalculatePolynomialBackground-v1.html) which fits a polynomial function to the estimated background for the purpose of smoothing. Detailed instructions can be found [here](https://powder.ornl.gov/data_tools/general.html#mts_data).

## May-2025

- SNS and HFIR instruments monitor mobile apps are available. See the link [here](https://powder.ornl.gov/collections/mobile_apps.html), thanks to the nice work by [Dr. Jie Xing (ORNL)](https://www.ornl.gov/staff-profile/jie-xing).

- For the tools relevant to powder Bragg diffraction or PDF simulation, sometimes the underlying engine (`GSAS-II` for powder Bragg diffraction and `diffpy-CMI` for PDF) would fail to process the uploaded CIF files, due to the flexible nature of the CIF file formatting. We now incorporate `VESTA` as the backend engine to take the uploaded CIF file and export a `VESTA` version of the CIF file, followed by whatever process that users request. With this, we can deal with however formatted CIFs that are compatible with `VESTA`.

## Apr-2025

- Data streaming and caching from live reduction to auto reduction for performance boosting.

    > Process data on live streaming, caching to save processing time at the autoreduction stage when data is ready.

- Consistent way of producing total scattering data on NOMAD and POWGEN, using the [`mantidtotalscattering`](https://github.com/neutrons/mantid_total_scattering) framework.

## Mar-2025

- Some useful routines made available to general users on the analysis cluster for total scattering data post-processing. This includes,

    - `pystog_cli`: the command-line interface for performing Fourier transform, data scaling, etc. for total scattering data. Refer to the GitHub repo [here](https://github.com/neutrons/pystog) for detailed information.

    - `mts_data`: the command-line interface for extracting data from the NeXus file produced by `mantidtotalscattering`.

- On POWGEN, we now have the mechanism to automatically restart the livereduction service in case of failure. If the failure still persists after several trials, notification will be sent out to Slack.

- On NOMAD, now even no `abs_pre_calc` was ever performed to collect sample information, we can still move ahead with the autoreduction by filling in some dummy sample information. The reduction won't be rigorous but it will give users the chance to quickly check the data.

- On top of the k-vector search capability, now given a k-vector, GSAS-II can communicate with isodistort for subgroups generation.

- Experimental planning tool available in ADDIE web platform for HB-2A and HB-2C at HFIR. URL: [https://addie.ornl.gov/hfirestimate](https://addie.ornl.gov/hfirestimate).

- Uniform atomic move introduced for RMCProfile package to avoid bias from the cell shape. Proceed to the [RMCProfile website](https://rmcprofile.ornl.gov/download) to download the up-to-date package.

- Local web interface for RMCProfile monitor and data & configuration visualization. Proceed to the [RMCProfile website](https://rmcprofile.ornl.gov/download) to download the up-to-date package.

## Feb-2025

- On top of the k-vector search capability, now given a k-vector, GSAS-II can communicate with isodistort for subgroups generation.

- Experimental planning tool available in ADDIE web platform for HB-2A and HB-2C at HFIR. URL: [https://addie.ornl.gov/hfirestimate](https://addie.ornl.gov/hfirestimate).

- Uniform atomic move introduced for RMCProfile package to avoid bias from the cell shape. Proceed to the [RMCProfile website](https://rmcprofile.ornl.gov/download) to download the up-to-date package.

- Local web interface for RMCProfile monitor and data & configuration visualization. Proceed to the [RMCProfile website](https://rmcprofile.ornl.gov/download) to download the up-to-date package.

## Jan-2025

- `k-vector` search implementation and tutorial available in GSAS-II. See the link [here](https://advancedphotonsource.github.io/GSAS-II-tutorials/k_vec_tutorial/k_vec_tutorial.html) and [here](https://advancedphotonsource.github.io/GSAS-II-tutorials/k_vec_tutorial_non_zero/k_vec_tutorial_non_zero.html), for the case of zero and non-zero `k-vector`, respectively.

- Live reduction for POWGEN and NOMAD transferred successfully to dedicated virtual hosts.

## Dec-2024

- Automated calibration checking implemented in monitor platform, by showcasing the alignment of diamond peaks across pixels.

- The pipeline for absorption pre-calculation which seamlessly flows into autoreduction established for NOMAD.

## Nov-2024

- Reliable and error-proofing configuration for POWGEN auto and live reduction.

- Automatic packing fraction adjustment in autoreduction for NOMAD to absolute scale total scattering data.

## Aug-2024

- Tutorials available for the data processing and post-processing on NOMAD. URL: [powder.ornl.gov/total_scattering/data_reduction/dr_howto.html](https://powder.ornl.gov/total_scattering/data_reduction/dr_howto.html).

## Jun-2024

- The second data processing workshop for total scattering held at ORNL, as the satellite workshop for the ACNS meeting. Information available [here](https://powder.ornl.gov/total_scattering/data_reduction/ts_dp_workshops.html#satellite-workshop-with-acns-meeting-2024-at-knoxville).

## May-2024

- Powder diffraction software documentation website fired up. URL: [powder.ornl.gov](https://powder.ornl.gov).

- Magnetic pair distribution function simulation added in ADDIE platform. URL: [addie.ornl.gov/simulating_mpdf](https://addie.ornl.gov/simulating_mpdf).

- Web interface for configuring POWGEN autoreduction in ADDIE. URL: [addie.ornl.gov/landing_powgen](https://addie.ornl.gov/landing_powgen).

## Feb-2024

- Commensurate mcif file visualization in ADDIE web platform. URL: [addie.ornl.gov/conf_viewer](https://addie.ornl.gov/conf_viewer).

- Model-free pair distribution function analysis implemented in ADDIE web interface. URL: [addie.ornl.gov/pdf_model_free](https://addie.ornl.gov/pdf_model_free).

- Automated calibration for NOMAD and POWGEN.

## Jan-2024

- ADDIE web interface becomes publicly facing and the service dockerized. URL: [addie.ornl.gov](https://addie.ornl.gov).

## Nov-2023

- Fast absorption correction by performing the calculation with detectors groups. Unsupervised machine learning algorithm implmented for clustering detectors according to their similarity in the absorption spectra.

## Aug-2023

- Neutron and X-ray calculator implemented in the ADDIE web interface. URL: [addie.ornl.gov/helpsheet](https://addie.ornl.gov/helpsheet).

- Dynamic and informative periodic table for neutron scattering properties implemented in the ADDIE web interface. URL: [addie.ornl.gov/scatteringinspector](https://addie.ornl.gov/scatteringinspector).

## Jun-2023

- The first data processing workshop for total scattering held at ORNL, as the satellite workshop for the SHUG meeting. Information available [here](https://powder.ornl.gov/total_scattering/data_reduction/ts_dp_workshops.html#satellite-workshop-with-shug-meeting-2023).

## May-2023

- Data reduction with `mantidtotalscattering` implemented in ADDIE GUI interface.

- Self-scattering level checking and logging in `mantidtotalscattering`.

- Resonance filtering implemented in `mantidtotalscattering`. Useful for processing samples with resonant absorption in certain wavelength range.

## Apr-2023

- Detailed documentation for `mantidtotalscattering` workflow is available. URL: [powder.ornl.gov/total_scattering/data_reduction/princple_implementation.html](https://powder.ornl.gov/total_scattering/data_reduction/princple_implementation.html).

## On and Before Jan-2023

- Post processing interface for NOMAD. A dedicated GUI interface made available for post processing NOMAD data in ADDIE. This includes the capability of visualizing and merging data from banks and performing the Fourier transform usingthe `pystog` engine to produce the pair distribution function patterns.

- Automatic merging of data for HB-2A. For measurements with the same sample log values, like temperature, etc., we could merge all the data automatically on-the-fly.

- Event filtering for HB-2C data. We developed multiple handy routines for automated data processing and event filtering for HB-2C powder data.

- Normalization with collection time on HB-2A using `HB2AReduce`.

- Caching of the absorption correction for POWGEN to boost the performance.

- Detector masking algorithm implemented in the calibration process for NOMAD.

- Implementation of the absorption correction in the POWGEN data reduction GUI.

- First and second order of Placzek correction for the inelastic scattering implemented in `mantidtotalscattering`.

- Detailed documentation available for summarizing the workflow for absorption and multiple scattering correction. URL: [powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html).

- Implementation of multiple scattering correction using the numerical integration approach.

- Numerical integration for absorption correction with time-of-flight instruments, following the `Paalman-Pings` framework.

- Several useful utilities for HB-2A experiment planning implemented in the ADDIE web interface. URL: [addie.ornl.gov/landing_hfir_hb2a](https://addie.ornl.gov/landing_hfir_hb2a).

    - [Detector Locator](https://addie.ornl.gov/hb2a_det_loc)

    - [Detector Normalizor](https://addie.ornl.gov/hb2a_det_norm)

    - [Container Selector](https://addie.ornl.gov/hb2a_can_sel)

- A forum for powder diffraction relevant topics discussion among the user community is available. URL: [powder.ornl.gov/forum](https://powder.ornl.gov/forum).

- Peak integration algorithm developed for HB-2C. Useful for phase transition studies.

- Robustly working data reduction GUI for both HB-2A and HB-2C.
