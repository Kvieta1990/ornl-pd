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

    > Form: A float number, in `mm`

    Specification of the side length of cuboids for absorption correction. MTS implements the numerical approach for evaluating the absorption of neutrons along the pathway inside the sample and container. Detailed mathematics can be found [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html) and the Mantid documentation page [here](https://docs.mantidproject.org/v6.1.0/concepts/AbsorptionAndMultipleScattering.html). The evaluation of the absorption is fundamentally about evaluating the integral like Eqn. (11) [here](https://docs.mantidproject.org/v6.1.0/concepts/AbsorptionAndMultipleScattering.html). For the integral evaluation, the idea is to divide the whole sample (container) into small cuboids, and for each cuboid, the integration over the cuboid volume could be evaluated numerically. As such, the size of the cuboid determines the level of accuracy, and accordingly, the computation burden, of the absorption calculation. By default, the size of `1 mm` will be used and this is the `recommended` value to use, and therefore in most cases, users barely need to touch this parameter - one can leave this parameter out from the JSON input safely.

## Container Section

## Normalization Section

This refers to the `Normalization` key which takes care of the normalization measurement. By normalization, we mean the normalization over the detector efficiency and solid angle cover of detectors, with vanadium as a nearly perfect incoherent scatterer, i.e., vanadium scatters neutrons in a nearly uniform manner. Since the incoherent scattering length of vanadium is tabulated, given certain neutron flux, we know the expected number of neutrons to arrive at detectors. Therefore, with the measured neutron countings measured for vanadium, one can normalize out the detector efficiency and solid angle coverage. See the lecture notes by Dr. Yuanpeng Zhang [here](../files/Yuanpeng_Neutron_Data_Proc_Lecture_04032025.pdf) and the article {cite}`Peterson:gj5253` for more details.

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

## Output and Post-Processing