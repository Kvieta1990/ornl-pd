Introduction
===

There are several diffractometers at Spallation Neutron Source (SNS) that can perform the total scattering data collection, including [NOMAD](https://neutrons.ornl.gov/nomad), [POWGEN](https://neutrons.ornl.gov/powgen), [SNAP](https://sns.gov/snap), etc. Compared to Bragg diffraction, the data reduction for total scattering needs more careful treatments with regards to multiple aspects, such as background subtraction, normalization, necessary corrections (absortion, multiple scattering, inelastic, etc.), and proper scaling. This sections mainly focuses on the total scattering data reduction with the `mantidtotalscattering` (MTS) framework developed and maintained at SNS, ORNL, including the theoretical background, workflow of the program, and demonstration of how-to. Meanwhile, useful analysis tools for analyzing the total scattering data will also be covered briefly.

## More Background Materials

- Egami T., Billinge S. J. L., "[Underneath the Bragg Peaks: structural analysis of complex materials](https://www.elsevier.com/books/underneath-the-bragg-peaks/egami/978-0-08-097133-9)", Pergamon Press Elsevier, Oxford, England, 2003 (book).

- Neder R., Proffen T., "[Diffuse Scattering and Defect Structure Simulation](https://oxford.universitypressscholarship.com/view/10.1093/acprof:oso/9780199233694.001.0001/acprof-9780199233694)", Oxford University Press, 2008 (book).

- Billinge S. J. L., Levin I., "[The Problem with Determining Atomic Structure at the Nanoscale](https://science.sciencemag.org/content/316/5824/561)", Science, 361, 561-565 (2007).

- Billinge S. J. L., "[The rise of the X-ray atomic pair distribution function method: A series of fortunate events](https://doi.org/10.1098/rsta.2018.0413)", Philosophical Transactions of the Royal Society A Mathematical, Physical and engineering sciences, 377, 2147, (2019).

- Tucker M. G., Keen D. A., Dove M. T., Goodwin A. L., Hui Q., "[RMCProfile: reverse Monte Carlo for polycrystalline materials](https://iopscience.iop.org/article/10.1088/0953-8984/19/33/335218/meta)", Journal of Physics: Condensed Matter, 19, 33, 335218 (2007).

- Keen D. A., Goodwin A. L., "[The crystallography of correlated disorder](http://dx.doi.org/10.1038/nature14453)", Nature, 521, 303–309 (2015).

- Keen D. A., "[Total scattering and the pair distribution function in crystallography](https://dx.doi.org/10.1080/0889311X.2020.1797708)", Crystallography Reviews, 26, 3, 141–199 (2020).

- Keen D. A., "[A comparison of various commonly used correlation functions for describing total scattering](https://dx.doi.org/10.1107/S0021889800019993)", Journal of Applied Crystallography, 34, 2, 172–177 (2001).

- Peterson P. F., Olds D., McDonnell M. T., Page K., "[Illustrated formalisms for total scattering data: a guide for new practitioners](http://dx.doi.org/10.1107/s1600576720015630)", Journal of Applied Crystallography, 54, 1, 317–332 (2021).

- Playford H. Y., Owen L. R., Levin I., Tucker M. G., "[New insights into complex materials using Reverse Monte Carlo modeling](http://dx.doi.org/10.1146/annurev-matsci-071312-121712)", Annual Review of Materials Research, 44, 429-449 (2014).

- Petkov V., "[Nanostructure by high-energy X-ray diffraction](https://doi.org/10.1016/S1369-7021(08)70236-0)", Materials Today, 11, 11, 28–38 (2008).

- Proffen T., "[Analysis of disordered materials using total scattering and the atomic pair distribution function](https://dx.doi.org/10.2138/rmg.2006.63.11)", Reviews in Mineralogy and Geochemistry, 63, 255–274 (2006).

- Y. Zhang, et al. "[New capabilities for enhancement of RMCProfile: instrumental profiles with arbitrary peak shapes for structural refinements using the reverse Monte Carlo method](https://doi.org/10.1107/S1600576720013254)", J. Appl. Cryst. (2020). 53, 1509-1518.

- Y. Zhang, et al. "[Lorentz factor for time-of-flight neutron Bragg and total scattering](https://doi.org/10.1107/S2053273322010427)", Acta Cryst. (2023). A79, 20-24.