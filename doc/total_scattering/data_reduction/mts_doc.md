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

## Container Section

## Normalization Section

## General Aspects

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

- `Environment`

    > Optional

    If existing, it specifies the sample environment for the data collection. The `Name` key is not in practical use and is just for reference purpose. The `Container` key could be used for specifying the container being used for holding the sample and the corresponding container geometry would be used for the aborption correction. In `Mantid` framework, several typical container types are pre-defined in the code base (see [here](https://github.com/mantidproject/mantid/blob/main/instrument/sampleenvironments/SNS/InAir.xml) for those defined container types for `SNS` instruments). With such standard containers, one could just give the container name, e.g., `PAC06` as in the template above and `Mantid` will grab the pre-defined geometry for the down stream calculations, e.g., the absorption calculation (see [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_abs_ms.html) for details about the absorption correction).

    As discussed in previous sections, the sample and container geometry could be defined explicitly for the absorption correction, in which case the `Container` key defined here will be ignored and the explicitly defined container geometry will take the priority.

## Output and Post-Processing