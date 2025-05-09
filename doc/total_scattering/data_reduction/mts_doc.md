MTS Documentation
===

`Mantidtotalscattering` (MTS) is a modern engine for reducing neutron total scattering data based on Mantid framework. It is a high-level framework which utilizes various low-level Mantid algorithms, going through all the necessary steps to bring the raw neutron time-of-flight scattering data to user-end analyzable data. By going through the whole workflow and applying a series of necessary corrections, it is expected that the end product is the neutron total scattering data sitting on an absolute scale. `MTS` takes in a single input file in the JSON form and current page documents all the entries in the input JSON file.

First, one can take the following example JSON input file as a bare minimal template to run the `MTS` reduction,

```json
{
    "Facility": "SNS",
    "Instrument": "NOM",
    "Title": "NOM_Si_640d",
    "Sample": {
        "Runs": "181278",
        "Background": {
            "Runs": "181279-181282",
            "Background": {
                "Runs": "179271"
            }
        },
        "Material": "Si",
        "MassDensity": 2.33,
        "PackingFraction": 0.8,
        "Geometry": {
            "Shape": "Cylinder",
            "Radius": 0.295,
            "Height": 1.8
        },
        "AbsorptionCorrection": {
            "Type": "SampleOnly"
        },
        "AbsMSParameters": {
            "ElementSize": 1.0
        }
    },
    "Normalization": {
        "Runs": "179270",
        "Background": {
            "Runs": "179271"
        },
        "Material": "V",
        "MassDensity": 6.11,
        "PackingFraction": 1.0,
        "Geometry": {
            "Shape": "Cylinder",
            "Radius": 0.2925,
            "Height": 1.8
        },
        "AbsorptionCorrection": {
            "Type": "SampleOnly"
        },
        "AbsMSParameters": {
            "ElementSize": 1.0
        }
    },
    "Calibration": {
        "Filename": "/SNS/NOM/shared/autoreduce/calibration/NOMAD_183057_2022-08-02_shifter.h5"
    },
    "OutputDir": "/SNS/NOM/IPTS-28922/shared/autoreduce/multi_banks_summed",
    "Merging": {
        "QBinning": [
            0.01,
            0.005,
            40.0
        ]
    },
    "AlignAndFocusArgs": {
        "TMin": 300,
        "TMax": 20000
    },
    "SelfScatteringLevelCorrection": {
        "Bank1": [
            15.0,
            25.0
        ],
        "Bank2": [
            20.0,
            25.0
        ],
        "Bank3": [
            20.0,
            30.0
        ],
        "Bank4": [
            30.0,
            40.0
        ],
        "Bank5": [
            30.0,
            40.0
        ],
        "Bank6": [
            10.0,
            15.0
        ]
    },
    "Environment": {
        "Name": "InAir",
        "Container": "PAC06"
    }
}
```

## Sample Section

> Mandatory

- `Runs`

    > Either this key or the `Filenames` key should be present.

    > Form: A string for specifying a series of run numbers.

    > Example: `111`, `111, 222, 333`, or `1111, 2222-2228`

    Give all the run numbers for the sample measurement to be processed. All the runs included here will be summed together, so it is necessary to make sure that all run numbers specified here correspond to the same measurement, i.e., repeated measurement for the same sample under the same condition. On instruments with high neutron flux, like `NOMAD`, a suggestion route for the data collection is to collect data by chunks. For example, if in total we require 8 C (of the proton charge accumulation) in total, one could collected 4 chunks of data, with 2 C for each chunk. In this case, we may want to put all the run number for the 4 chunks here to process them altogether. Here, one could use the combination of `,` and `-` to specify a series of run numbers in a neat form. For example, one could write `11, 22-33` to include the run number `11` and all the run numbers ranging from `22` to `33` (inclusive on both ends).

- `Filenames`

    > Either this key or the `Runs` key should be present.

    > Form: A list of path strings. Paths can be given in their relative form (to the location where MTS will be running) or absolute form.

    > Example: `Filenames: ["/path/to/NOM_182034.nxs", "/path/to/NOM_182035.nxs"]`.

    If the `Runs` key is present, MTS will be using the facility and instrument information together with the specified run numbers to figure out where to find the data files. One can also use the `Filenames` key to provide the data files explicitly.

    > One thing to keep in mind is that the data file name should be following the form like `NOM_182034.nxs`, as MTS will be using the stem name of the file to figure out the run number.

- `Background`

    > Mandatory

    > Form: A dictionary specifying the background runs.

    > Example: `"Background": { "Runs": "11", "Background": "22"}`

    This is to specify the background runs needed for the data processing (specifically, the background subtraction). By 'background', we mean the empty container as usually, samples will be held in containers for the measurement. The `Runs` key and alternatively the `Filenames` key behaves in a consistent way as those for the sample as detailed above. The `Background` key inside the dictionary is to specify the 'background of the background', which usually refers to the empty instrument, of which the signal is supposed to be subtracted from the empty container measurement. Again, the data files could be specified either with run numbers or a list of explicit file names, following the same format as presented above for the sample, i.e., something like,

    ```json
    "Background": {
        "Runs": "11",
        "Background": ["/path/to/NOM_179271.nxs", "/path/to/NOM_179272.nxs"]
    }
    ```

    > If `Scale` parameter is provided, the empty container signal will be multiplied by the specified scale factor before being subtracted. This is expected to account for any potential over- or under-subtraction of the empty container, e.g.,

    ```json
    "Background": {
        "Runs": "11",
        "Scale": 1.2,
        "Background": ["/path/to/NOM_179271.nxs", "/path/to/NOM_179272.nxs"]
    }
    ```

- `Material`

    > Mandatory

    > Form: A string of the sample composition, following the Mantid standard. See [here](https://docs.mantidproject.org/nightly/concepts/Materials.html) for the standard.

    > Example: `H2 O`, `(H2)2 O`

    The chemical formula of the sample, which will be used for both the normalization and absorption correction purpose.

- `MassDensity`

    > Mandatory

    > Form: A float number, in `g/cm`

    This refers to the theoretical mass density of the sample assuming full packing. Together with the packing fraction to be defined, this will pins down the actuall mass density of the sample. The information is critical for the normalization and absorption correction purpose.

- `PackingFraction`

    > Mandatory

    > Form: A float number

    This is a tweaking parameter for defining the effective density of the sample. As mentioned above, one can specify the full mass density with the `MassDensity` key, and the effective density could be obtained for the sample using the packing fraction defined here. Again, this will not only impact the normalization of the total scattering data, but also will impact the absorption evaluation. Regarding its impact upon the absorption evaluation, due to the non-linearity of the absorption, the impact of the packing fraction is `NOT` simply a scale factor. This has significant impact upon the algorithm design regarding the caching of both the processed data and the absorption spectra calculated across the instrument. See [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html#performance-boost) for more details.

- `Geometry`

    > Mandatory

    > Form: A dictionary defining the sample geometry. Radius and height are given in `cm`.

    > Example: `"Geometry": { "Shape": "Cylinder", "Radius": 0.295, "Height": 1.8 }`

    We are expecting a dictionary here as the value for the sample `Geometry` key. As for the example above, the dictionary should specify the shape of the sample with the `Shape` key. Two options are acceptable here, namely `Cylinder` (the sample fills the in the center of the container) and `HollowCylinder` (the sample fills in the interlayer of the container wall). Depending on the defined shape of the sample, the required keys in the dictionary are different. The example above is for the case of `Cylinder` shape. As for the `HollowCylinder` shape, here below is presented an example,

    ```json
    "Geometry": {
        "Shape": "HollowCylinder",
        "InnerRadius": 0.295,
        "OuterRadius": 0.305,
        "Height": 1.8
    }
    ```

- `AbsorptionCorrection`

    > Mandatory

    > Form: A string

    Specification of the method to be used for the absorption correction. Following the `Paalman-Pings` framework, there are three different types of corrections, with different level of assumption. Details can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html) and references therein.

    Acceptable values are `SampleOnly`, `SampleAndContainer` and `FullPaalmanPings`, which has increasing level of accuracy but as the sacrifice, the computation time is increasing.

- `AbsMSParameters`

    > Optional

    > Form: A dictionary, which for the moment only takes in a single key `ElementSize` specifying the side length (in `mm`) of cuboids for absorption evaluation.

    MTS implements the numerical approach for evaluating the absorption of neutrons along the pathway inside the sample and container. Detailed mathematics can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html) and the Mantid documentation page [here](https://docs.mantidproject.org/v6.1.0/concepts/AbsorptionAndMultipleScattering.html). The evaluation of the absorption is fundamentally about evaluating the integral like Eqn. (11) [here](https://docs.mantidproject.org/v6.1.0/concepts/AbsorptionAndMultipleScattering.html). For the integral evaluation, the idea is to divide the whole sample (container) into small cuboids, and for each cuboid, the integration over the cuboid volume could be evaluated numerically. As such, the size of the cuboid determines the level of accuracy, and accordingly, the computation burden, of the absorption calculation. By default, the size of `1 mm` will be used and this is the `recommended` value to use, and therefore in most cases, users barely need to touch this parameter - one can leave this parameter out from the JSON input safely.

- `GaugeVolume`

    > Optional

    > Form: A path string

    The key is expecting a string that specifies the path to an XML file defining the gauge volume for the sample. The defined gauge volume here refers to the region of the sample that the neutron beam is shining on. It defines the integration volume (i.e., where the scattering events are happening) over which the numerical integration for the absorption calculation will be performed. Without the gauge volume definition, the integration volume would be assumed to be the same as the whole sample volume. In the `General Aspects` section, there is a parameter `BeamHeight` with which one can define the beam size. The defined beam size will then internally define the gauge volume for the sample. However, if the `GaugeVolume` key is provided for the sample, it will take the priority over the beam size definition.

    The Mantid algorithm `DefineGaugeVolume` is used here for the gauge volume definition and one can refer to the documentation page [here](https://docs.mantidproject.org/v4.0.0/algorithms/DefineGaugeVolume-v1.html) for more information. The XML file specified here defines the gauge volume geometry following the Mantid format. Detailed documentation about how to define geometric shape can be found [here](https://docs.mantidproject.org/nightly/concepts/HowToDefineGeometricShape.html).

    As usual, the path specified here can be either a relative path (to the location where MTS will be running) or an absolute path.

- `DummyInfo`

    > Optional

    > Form: A logical value, default as `false`

    Specify whether the sample information is dummy. For the autoreduction purpose, to save efforts for the manual input of the accurate sample information and for a quick checking, we would fill in some dummy sample information automatically, in which case the `DummyInfo` value should be set to `true` so that MTS is aware of the sample information being dummy and will be taking corresponding action to avoid weird behavior in the reduced data as the result of the improper normalization.

- `PushPositiveLevel`

    > Optional

    > Form: A float number, default as `100`.

    In case of dummy sample information, sometimes, the reduced Bragg diffraction data could be with negative intensities across the diffraction pattern. To avoid unnecessary confusions, we would like to add a postive value to the reduced data to push the data positive. The positive offset level can be given with the current key. If `DummyInfo` is `false`, the key here does not take any effects.

## Container Section

> Optional

The container section is for putting down some informaation about the container being used for holding the sample. The section is not included in the example above, since usually instruments use regular container that are already defined in the Mantid code base -- see the `Environment` key in the `General Aspects` section below. In case non-standard container is used, one needs to specify the container information explicitly, including the geometry, material, and potentially the gauge volume. The container section has the main key of `Container`, parallel to `Sample`, `Normalization`, etc.

- `Geometry`

    > Mandatory

    > Form: A dictionary

    > Example:

    ```json
    "Geometry": {
        "Shape": "HollowCylinderHolder",
        "Height": 4.0,
        "InnerRadius": 1.5,
        "InnerOuterRadius": 2.0,
        "OuterInnerRadius": 3.0,
        "OuterRadius": 4.0,
        "Center": [0.0, 0.0, 0.0]
    }
    ```

    The defined container geometry here will go into the Mantid `SetSample` algorithm call. Refer to the documentation page [here](https://docs.mantidproject.org/nightly/algorithms/SetSample-v1.html) for options of the container geometry definition in the JSON format. The example given above refers to a hollow contaienr where the sample will fill in the interlayer space between the container inner and outer wall. The length unit is given in `cm` here.

- `Material`

    > Mandatory

    > Form: A dictionary

    > Example:

    ```json
    "Material": {
        "ChemicalFormula": "(Li7)2-C-H4-N-Cl6",
        "NumberDensity": 0.1
    }
    ```

    The material definition here will go into the Mantid `SetSample` algorithm call. Refer to the documentation page [here](https://docs.mantidproject.org/nightly/algorithms/SetSample-v1.html). The `ChemicalFormula` value should follow the same format as the `Material` key for `Sample` and both of them are following the Mantid format (see the documentation [here](https://docs.mantidproject.org/nightly/concepts/Materials.html)). For the density specification, it can be given with either `NumberDensity` ($Å^{-3}$) or `MassDensity` ($g/cm^3$).

    If the `ChemicalFormula` value is among one of the pre-defined values for standard containers (vanadium can or quartz tube), namely "V", "V1", "Si O2", or "Si1 O2", one can safely leave out the density key as the density has been defined internally in the MTS code base.

- `GaugeVolume`

    > Optional

    > Form: A path string

    The key is expecting a string that specifies the path to an XML file defining the gauge volume for the container. The defined gauge volume here refers to the region of the container that the neutron beam is shining on. It defines the integration volume (i.e., where the scattering events are happening) over which the numerical integration for the absorption calculation will be performed. Without the gauge volume definition, the integration volume would be assumed to be the same as the whole container volume. In the `General Aspects` section, there is a parameter `BeamHeight` with which one can define the beam size. The defined beam size will then internally define the gauge volume for the container. However, if the `GaugeVolume` key is provided for the container, it will take the priority over the beam size definition.

    The Mantid algorithm `DefineGaugeVolume` is used here for the gauge volume definition and one can refer to the documentation page [here](https://docs.mantidproject.org/v4.0.0/algorithms/DefineGaugeVolume-v1.html) for more information. The XML file specified here defines the gauge volume geometry following the Mantid format. Detailed documentation about how to define geometric shape can be found [here](https://docs.mantidproject.org/nightly/concepts/HowToDefineGeometricShape.html).

    As usual, the path specified here can be either a relative path (to the location where MTS will be running) or an absolute path.

## Normalization Section

> Mandatory

> Keys in current section follow the same format as those in the `Sample` section above.

This refers to the `Normalization` key which takes care of the normalization measurement. By normalization, we mean the normalization over the detector efficiency and solid angle cover of detectors, with vanadium as a nearly perfect incoherent scatterer, i.e., vanadium scatters neutrons in a nearly uniform manner. Since the incoherent scattering length of vanadium is tabulated, given certain neutron flux, we know the expected number of neutrons to arrive at detectors. Therefore, with the measured neutron countings measured for vanadium, one can normalize out the detector efficiency and solid angle coverage. See the lecture notes by Dr. Yuanpeng Zhang [here](../../files/ndp_notes.pdf) and the article {cite}`Peterson:gj5253` for more details.

## General Aspects

- `Facility`

    > Mandatory

    > Form: A string with the standard name of the facility, such as `SNS`.

    Name of the facility where data were collected. Currently, we have only tested MTS on serveral instruments at `SNS`. So, the only robustly working option for the facility name here is `SNS`. Together with the instrument name to be specified and the run number for those relevant data collections, the actual data files to be processed could be located.

- `Instrument`

    > Mandatory

    > Form: A string with the standard name of the isntrument, such as `NOM` (for `NOMAD`), `PG3` (for `POWGEN`), `CORELLI`, etc. 

    As mentioned above, together with the `Facility` key and the run numbers to be given, the actual data files involved in the data processing could be located.

- `Title`

    > Mandatory

    > Form: A string, better without any white spaces (tabs or spaces).

    This will be used as the stem name for the series output files to be generated with the data processing, including the resulted reduced data in different forms and the log file to be generated regarding the reduction.

- `Calibration`

    > Mandatory

    Path to the calibration HDF5 file containing the calibration constants should be provided with this key. Path to the file can be given with either relative path (to the location where MTS will be running) or full path.

- `OutputDir`

    > Mandatory

    Specify the output directory where all the resulted reduced files will be saved into. Path can be given with either relative path (to the location where MTS will be running) or full path.

- `Merging`

    > Mandatory

    Key for specifying parameters regarding the merging of patterns for detectors.

    - `QBinning`

        > Mandatory

        > Form: A list of float numbers, with entries for the specification of minimal, binning and maximal value in $Q$-space for the reduced $S(Q)$ data.

        > Example: `"QBinning": [0.01, 0.005, 40.0]`

    - `Grouping`

        > Optional

        If not existing, the grouping stored in the provided calibration file will be used for grouping detectors for both data processing and output.

        - `Initial`

        > If the parent `Grouping` key exists, this is `Mandatory`.

        Path to the grouping file in XML format to specify the grouping of detectors at the data processing stage. Path to the file can be given with either relative path (to the location where MTS will be running) or full path.

        - `Output`

        > If the parent `Grouping` key exists, this is `Mandatory`.

        Path to the grouping file in XML format to specify the grouping of detectors at the data output stage. Path to the file can be given with either relative path (to the location where MTS will be running) or full path.

- `AlignAndFocusArgs`

    > Mandatory

    Specification of parameters for align-and-focus of data for all the detectors. It is taking and `only` taking two `mandatory` keys,

    - `TMin`, for minimal value of time-of-flight (TOF)

    - `TMax`, for maximal value of TOF

- `SelfScatteringLevelCorrection`

    > Optional

    If existing, it specifies the range in $Q$-space of the reduced total scattering data to be used for the level fitting. A stright line with both slope and intercept parameters will be fitted against the pattern of the reduced total scattering data within the specified $Q$-region for each of the banks specified in the list. Depending on the number of banks specified for the data output, the number of needed entries here will vary accordingly. The sub-keys needed here should be continuously following the pattern `Bank1`, `Bank2`, etc.

    In principle, with background subtraction and normalization in place, together with all the corrections executed along the data reduction workflow, one is expecting the high-$Q$ region in the reduced total scattering data to asymptotically approach the `self-scattering` level (see our ADDIE website to get more ideas about the expected `self-scattering` level given a certain composition, [addie.ornl.gov/helpsheet](https://addie.ornl.gov/helpsheet)). However in practice, we would always be a bit off in the high-$Q$ region of the reduced data, as compared to the `self-scattering` level. What MTS does here is to estimate the actual high-$Q$ level in the reduced data, compare to the expected `self-scattering` level and write out the suggested packing fraction to tweak the high-$Q$ level against the expected value. The idea is to tune the actual number of atoms (which would go into the data normalization factor) through tweaking the packing fraction, with the high-$Q$ level being at the expected `self-scattering` level as the target. The relevant output will be saved a log file (further details will be given in the next section). With such an output log file, a high-level wrapper routine could be composed to cycle through the calling of `MTS`, reading the output log file for the suggested packing fraction, and tweak the packing fraction in the input JSON file accordingly, until the packing fraction converges. Such a workflow has already been implemented for `NOMAD` and `POWGEN` in the autoreduction framework for both.

- `BeamHeight`

    > Optional

    > Form: A float number for defining the beam height in `cm`.

    If existing, it will be used for defining the beam size, which is critical for having an accurate absorption correction. Refer to the link [here](https://iris2020.net/2025-02-12-abs_geo/) for further discussions. As discussed in previous sections, when the `gauge volume` is defined explicitly for either the sample (container), the defined `gauge volume` will take the priority over the beam height defined here regarding the intersection region between the beam and the sample (container).

    When the beam height defined here is taking the effect, the Mantid `SetBeam` algorithm (see [here](https://docs.mantidproject.org/nightly/algorithms/SetBeam-v1.html) for documentation) would be used for defineing the beam size for the donor workspace to be used for the absorption correction. The `Slit` shape of the beam is assumed and beam width is set internally to a arbitrarily large value to guarantee the full covering for the sample horizontally. In the case of beam not fully covering the sample horizontally, we need some further implementations to cope with the special situation. For most cases at `NOMAD` and `POWGEN` instruments, the default behavior can be safely assumed. With the beam height specified, the gauge volume for either the sample or the container, or both, will be configured internally and it is assumed that the center of the gauge volume (i.e., the intersection region between the beam and the sample, or container) is set to the origin of the instrument coordinate system. In case of sample or container geometry definition with only the shape and size configured, the same assumption applies, i.e., the center of the geometry is set to the origin of the instrument coordinate system. In practice, both may not be the case and the relative position between the beam and the sample (container) could be flexibile. While the sample (container) geometry can be defined in a very flexible way to go beyond the assumption, the `SetBeam` algorithm currently does not allow such flexibilities and therefore we have to go with the assumption at this moment, for the beam definition. However, having the flexibility in the sample (contianer) geometry definition is probably enough to cover the possibilities of the relative position between the beam and the sample (container). Meanwhile, such a relative positioning between the beam and the sample (container) is expected to have a minimal impact upon the absorption correction.

- `Environment`

    > Optional

    If existing, it specifies the sample environment for the data collection. The `Name` key is not in practical use and is just for reference purpose. The `Container` key could be used for specifying the container being used for holding the sample and the corresponding container geometry would be used for the aborption correction. In `Mantid` framework, several typical container types are pre-defined in the code base (see [here](https://github.com/mantidproject/mantid/blob/main/instrument/sampleenvironments/SNS/InAir.xml) for those defined container types for `SNS` instruments). With such standard containers, one could just give the container name, e.g., `PAC06` as in the template above and `Mantid` will grab the pre-defined geometry for the down stream calculations, e.g., the absorption calculation (see [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html) for details about the absorption correction).

    As discussed in previous sections, the sample and container geometry could be defined explicitly for the absorption correction, in which case the `Container` key defined here will be ignored and the explicitly defined container geometry will take the priority.

- `ContainerPeaks`

    > Optional

    > A string, default as `None`

    With this flag, one can specify a list of peaks (in `d`-space) for the container in case there are Bragg peaks in the container signal that needs to be stripped off. The list should be given in a string and different peak positions should be separated with `comma`.

- `DebugMode`

    > Optional

    > A logical value, default as `false`

    Flag for enabling the debug mode of running MTS, in which case a series of workspaces will be saved along the way of the reduction, for checking and debugging purpose.

- `ReCaching`

    > Optional

    > Form: A logical value, default as `false`

    Flag for ignoring all the existing cache and re-caching. In MTS, the align-and-focused pattern would be saved to cache so that any furture reduction involving the same run could directly load in the saved cache without repeating the reduction from the raw event data. This significantly boosts the MTS performance. For example, with a standard Si sample, a typical NOMAD measurement with `2 C` proton charge accumulation would yield the raw event nexus file with the size of ~3 GB. Without any caching, the overall MTS processing time is ~7 minutes. With caching, the processing time could be reduced to ~0.5 minutes.

    In case the previously cache does not apply any more for the reduction, one can then use the current flag to redo the caching. For example, it is possible that previously an improper calibration file was used for the reduction. Once we get the new calibration file and want to redo the whole reduction, the previously cached files no longer apply, in which case the current flag is a pretty handy switch to ignore the existing cache.

- `AutoRed`

    > Optional

    > Form: A logical value, default as `false`

    Flag for specifying whether the reduction is for autoreduction purpose. Once the flag is set to `true`, the autoreduction mode will be activated and the data processing and output will group all detectors together. The benefit of such a manner of detectors grouping is obvious -- a single pattern of the reduced total scattering data could be obtained and we could then perform the Fourier transform automatically to obtain the pair distribution function (PDF). The downside is that patterns for detectors with different scattering angle and thus different resolution would be merged together to yield a peak shape that could be a bit complicated to interpret. Regarding this, the Rietveld program often has complicated peak profile function that could potentially describe the peak shape well enough. Concerning the impact upon the PDF data, as long as we are not fitting the data up to that high $r$ (e.g., well above 30 angstrom), the `Qdamp` and `Qbroad` parameters based on the Gaussian assumption of the peak shape would still work safely.

    When the `AutoRed` flag is `false` (the default value), the data would be reduced to multiple groups (which are usually called `banks`). Rietveld program could then take the multiple-banks data and refine the model against multiple banks of data simultaneously. To obtain PDF, one needs a routine to merge the data from multiple banks into a single pattern. This will be covered in the `Output and Post-Processing` section.

## Output and Post-Processing

Inside the specified output directory, there will be several sub-directories to be created by MTS to host the output files, as listed below,

```
GSAS
GSAS_unnorm
Logs
SofQ
Topas
Topas_unnorm
```

The reduced total scattering data in $Q$-space in the normalized $S(Q)$ form (see {cite}`Keen:th0051` for definition) will be stored in `SofQ`. The reduced bank-by-bank Bragg diffraction data in GSAS and Topas format will be saved into `GSAS` and `Topas` directory, respectively. In these two sub-directories, the Bragg diffraction data are simply the reduced total scattering data in TOF-space (transformed from $Q$-space to TOF-space using arbitrary DIFC values). Conventionally, the Bragg diffraction data are usually un-normalized data, meaning no normalization over the number of atoms in the system. Some Rietveld programs are assuming this type of Bragg data, in which case the normalized Bragg data output here may not be compatible. For example, in GSAS (I and II), it is assumed that all data points in the diffraction pattern should be with positive intensities and all negative intensities will be forced to 0. According to the definition of the normalized $S(Q)$ (see {cite}`Keen:th0051` for definition), it is totally possible that some of the intensities will be negative and therefore the corresponding Bragg diffraction data will also see some negative intensities. To deal with such an inconsistency problem, we also output the un-normalized version of the Bragg diffraction data, stored in `GSAS_unnorm` and `Topas_unnorm` sub-directory, respectively for the GSAS and Topas format of the data. The log information concerning the high-$Q$ level and the comparison to the `self-scattering` level is stored in the log file which will be saved into the `Logs` directory. All the output files are with the same stem name, which agrees with the value specified with the `Title` key.

The Bragg diffraction data are in plain text form and ready to be loaded in GSAS-II, Topas, etc. For the $S(Q)$ data, it is saved in the NeXus format and one does need a tool to extract the data out to the plain text form. For such a purpose, we have a dedicated routine on ORNL Analysis cluster, called `mts_data`, which takes a reduced data file in the NeXus format as the input and extract out all the data.

> N.B. It should be noted that the `mts_data` routine only works with the output created when `DebugMode` is set to `false` (the default) where we only have one workspace in the output NeXus file. When `DebugMode` is set to `true`, multiple workspaces will be created and put into a workspace group, in which case the `mts_data` will stop working.

As mentioned above, there are two main ways for obtaining the merged version of the overall total scattering data. One approach, with the `AutoRed` flag set to `true`, will merge the patterns from all the detectors into a single pattern. In this case, one can take the output $S(Q)$ data and perform the Fourier transform to obtain the PDF data. When `AutoRed` is `false` (the default), data will be output into different groups. For example, on NOMAD, we usually output the data into 6 groups (banks) following the 6 physical panels of the detectors. Then for the data merging, the idea is to use the high resolution bank (i.e., the data from the backscattering bank) as much as possible and we will only use those low resolution bank data when we have to (when the $Q$ region becomes inaccessible for the high angle banks). We also want to have a seamless connection of the patterns from different banks to be used in the merged data, without overlapping between banks. On NOMAD, we have implemented a dedicated routine for performing such a data merging. Detailed instructions can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/dr_howto.html).

> N.B. Specifically for NOMAD, the convention of the bank numbering is to name the forward scattering bank as `Bank-Six`, and the bank number goes from `One` to `Five` as we go from low to high scattering angle. If the bank numbering starts from `0`, `Bank-Six` will be `Bank-5`, while `Bank-4` will be the back scattering bank. Otherwise, `Banb-6` is for `Bank-Six`, and so on.

Concerning the post-processing of the total scattering, including the data rebinning, rescaling, Fourier transform, etc., we have a dedicated page with detailed instructions, as can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/ts_pp.html). Also, we are trying to host a yearly one-day workshop focusing on such data post-processing. Some useful information and resources from the past workshops can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/ts_dp_workshops.html).

## More Notes

### Caching

MTS will try to cache the data processing wherever it can, to save future data procesing time. Mainly, this is about caching the align-and-focus outcome for each single run. After align-and-focus, the neutron events can be thrown away, leaving only the histogram data, with detectors focused in a certain manner. The caching for align-and-focus is entangled with the way that absorption calculation would be performed. According to the documentation [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html), we found that the absorption spectra for detectors within certain mini-groups of detectors are very similar to each other and therefore only one absorption spectrum is needed for a certain mini-group of detectors. We have the routine available to group detectors into those mini-groups according to the similarity in their absorption spectra. The data processing and caching should follow such mini-groups. The cache files will be saved into the experiment-specific location. At SNS & HFIR, ORNL, the `IPTS` system is used and each experiment has its own unique `IPTS` number. Taking the NOMAD calibration `IPTS` as the example, the cache files will be saved into `/SNS/NOM/IPTS-28922/shared/autoreduce/cache`. The absorption calculations will also be cached, again, into the experiment-specific location. Taking the same NOMAD example for the calibration runs, the absorption cache will be saved into `/SNS/NOM/shared/autoreduce/abs_ms/IPTS-28922`.

### Instrument Specific Configs

When running the data processing against a certain instrument, MTS reads in some instrument-specific configurations from the cnetral configuration file dedicated for each instrument. The location to those central configuration files for each instrument is embedded in the MTS code base, as can be found [here](https://github.com/neutrons/mantid_total_scattering/blob/next/total_scattering/params.py). To add in more instruments, please get in touch with <a href="mailto:zhangy3@ornl.gov">Dr. Yuanpeng Zhang</a>. Here below is presented the central configuration file for NOMAD, as a typical example,

```json
{
    "ClientID": ".....",
    "Secret": ".....",
    "TokenURL": ".....",
    "IPTSURL": ".....",
    "ONCatID": ".....",
    "ONCatSecret": ".....",
    "CacheDir": "/SNS/NOM/shared/autoreduce/abs_ms",
    "EnvironmentName": "InAir",
    "DummyContainerType": "C",
    "PushPositiveLevel": 100.0,
    "InstrumentGeometryRun": "NOM_172394",
    "GroupingAllFile": "/SNS/NOM/shared/autoreduce/configs/nom_group_all.xml",
    "SampleElementSize": 1.0,
    "ContainerElementSize": 1.0,
    "MergeRunsOptions": "2",
    "ReGenerateGrouping": 0,
    "QMaxByBank": "40.0",
    "TMinBragg": "0.7,0.7,0.9,1.5,1.6,0.6",
    "TMaxBragg": "10,15,15,16.8,15.5,10",
    "QParamsProcessing": "0.0025,0.0025,55.",
    "OverrideUserConfig": true,
    "CyclePackingFrac": true,
    "TMIN": 300,
    "TMAX": 20000,
    "QMin": 0.5,
    "QMax": 35.0,
    "RMax": 50.0,
    "RStep": 0.01,
    "QOffset": 0.0,
    "RCutoff": 1.0,
    "Lorch": false,
    "FinalDIFC": [1428.818756011, 2861.506614873, 5606.556361966, 9041.704899514, 9910.536905573, 836.206546490]
}
```

Several keys on the top of the list are sensitive information concerning the connection to several databases hosted at ORNL for sample and data information and the values are left out here. Below are presented the descriptions for the other keys,

- `CacheDir`

    Specifie where the absorption cache will be saved.

- `EnvironmentName`

    Name of the sample environment, Usually it is just `InAir` and we barely need to touch it.

- `DummyContainerType`

    For the situation where no pre-populated sample information can be found, some dummy information is needed for the sample and container. This key is for specifying the dummy container type, with `C` representing a `QuartzTube03` container.

    > At SNS powder instruments NOMAD and POWGEN, we have the routine `abs_pre_calc` available for pre-populating the sample information into a table and performing the absorption correction even before the experiment. Refer to the documentation [here](https://powder.ornl.gov/auto_reduce/nomad_auto.html) for instructions.

- `PushPositiveLevel`

    This is for the autoreduction purpose without the sample information being ready. See the `PushPositiveLevel` key in the `Sample` section for details.

- `InstrumentGeometryRun`

    A typical run on NOMAD containing the instrument geometry. As long as there is no detector upgrade on the instrument, there is no need to change this.

- `GroupingAllFile`

    The XML file specifying the grouping of all detectors. Again, as long as there is no detector upgrade on the instrument, there is no need to change this.

- `SampleElementSize`

    Cuboid size in `mm` for the absorption calculation for the sample.

- `ContainerElementSize`

    Cuboid size in `mm` for the absorption calculation for the container.

- `MergeRunsOptions`

    The criterion for merging different run numbers. This is the configuration for NOMAD autoreduction. Two options are available, `1` for using the run title with dynamic temperature information and `2` for using the run title without the dynamic temperature. The default option is `2` as usually we are not interested in the temperature fluctuation around the set point.

- `ReGenerateGrouping`

    This is the key for detector grouping according to the similarity in absorption spectra as mentioned earlier. If no upgrade to the detectors, one can always stay with `0` as the input here, indicating that we don't want to re-generate the group. For NOMAD, the grouping files and information are stored in the following directory, `/SNS/NOM/shared/autoreduce/configs`.

- `QMaxByBank`

    The `QMax` value to be used for each of the output bank of data. If one value is given, it will be used for banks. Multiple values can be provided, separated by comma. The value should be given in a string, as presented in the example above.

- `TMinBragg`

    The minimal TOF value for the output Bragg diffraction data for each bank.

- `TMaxBragg`

    The maximal TOF value for the output Bragg diffraction data for each bank.

- `QParamsProcessing`

    This is the $Q$-space binning parameters used internally for MTS data processing. Since we are going to throw away the neutron events after the data processing, we have to use a fine $Q$-space binning to make sure that we can always go with a coarser bin for the binning down the road.

- `OverrideUserConfig`

    This is for the NOMAD autoreduction purpose. Any time the autoreduction is running, it will try to load or save the central configuration to the experiment-specific location so that later on, on the user side, they can change the parameter locally without influencing others. The default value for this flag is `false`, indicating that as long as the previously saved user configuration file can be found, the autoreduction routine will pick it up. If the flag is set to `true`, the central configuration will take the priority and after the reduction, the central configuration file will be copied into the experiment-specific location, with whatever existing configuration files there backed up to avoid losing history.

- `CyclePackingFrac`

    For NOMAD autoreduction purpose, we could check the log file from MTS running, grab the suggested packing fraction and start a new reduction with the tweaked packing fraction until the convergence of the packing fraction. This flag controls whether we want to perform such a loop. The default option is `true`, but in some cases, due to the poor data quality, the loop may get stuck, in which case we want to turn off the cycling.

- `TMIN`

    This value will go into the `TMin` key of `AlignAndFocusArgs` for the sample.

- `TMAX`

    This value will go into the `TMax` key of `AlignAndFocusArgs` for the sample.

- `QMin`

    This key controls the minimal $Q$ used for Fourier transform, regarding the NOMAD autoreduction to obtain the PDF.

- `QMax`

    This key controls the maximal $Q$ used for Fourier transform, regarding the NOMAD autoreduction to obtain the PDF.

- `RMax`

    This key controls the maximal $r$ of the PDF data.

- `RStep`

    This key controls the interval of the PDF data.

- `QOffset`

    The offset in $Q$-space that we want to apply to the reduced total scattering data before the Fourier transform.

- `RCutoff`

    The cutoff in $r$-space regarding the Fourier filter, i.e., all signals below the cutoff will be Fourier filtered.

- `Lorch`

    Whether to apply the lorch smoothing algorithm for the PDF data.

- `FinalDIFC`

    After the total scattering data processing, the data would be in $Q$-space. To obtain the Bragg diffraction data in TOF-space which can be imported into Rietveld programs for data analysis, we have to convert the $Q$-space data with some arbitrary values of DIFC for each bank of data. Here we can give the list of the DIFC values to be used for such a purpose and the aim is to keep consistent whatever conventional values that other data reduction programs were using.

- `ContainerPeaks`

    With this flag, one can specify a list of peaks (in `d`-space) for the container in case there are Bragg peaks in the container signal that needs to be stripped off. The list should be given in a string and different peak positions should be separated with `comma`.