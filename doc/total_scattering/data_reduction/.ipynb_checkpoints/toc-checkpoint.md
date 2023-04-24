Total Scattering Data Reduction
===

In this section, some key notes on the principle and implementation for the total scattering data reduction will be first covered. The data reduction engine is developed mainly using the Mantid framework as the backbone. Built on top of the Mantid framework, a high-level workflow `mantidtotalscattering` (MTS) has been developed to perform the neutron total scattering data reduction. Further, a GUI interface has also been developed to serve as the frontend for MTS -- the ADvandced DIffraction Environment (ADDIE). The tutorial for ADDIE will then be presented to walk through the basic procedures for reducing the total scattering data, together with intructions for some critical post-processing, trying to bring the data onto an `absolute scale`.

```{tableofcontents}
```