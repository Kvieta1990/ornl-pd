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

        > Example: "QBinning": [0.01, 0.005, 40.0]

## Output and Post-Processing