POWGEN
===

(pg3_cal)=
- {ref}`pg3_cal<pg3_cal>`

    > The calibration has been incorporated into the POWGEN autoreduction workflow so any time a suitable diamond calibration run is available, the calibration routine will be kicked off automatically. In case of problems, one then log in Analysis cluster and use the current routine for running the calibration manually -- normally, even the calibration running at the autoreduction stage encounters issues, still the input json file can be generated automatically so in most cases, one does not need to worry about manually populating the input json file here.

    The calibration routine for POWGEN. It takes the following JSON file as the input (we don't need to give the input explicitly, so on command line, just execute `pg3_cal`),

    ```
    /SNS/PG3/shared/CALIBRATION/cal_config.json
    ```

    Here is presented the contents of the configuration file,

    ```json
    {
        "Diamond": "/SNS/PG3/IPTS-32378/nexus/PG3_59441.nxs.h5",
        "RunCycle": "2025-1_11A_CAL",
        "Instrument": "PG3",
        "Date": "2025-04-15",
        "SampleEnv": "MICAS",
        "Notes": "",
        "OutputDir": "/SNS/PG3/shared/CALIBRATION/autoreduce",
        "PDCalibration": {
            "TofBinningFirst": "300,-0.0008,16667",
            "TofBinningSecond": "300,-0.0005,16667",
            "TofBinningThird": "300,-0.0003,16667",
            "ConstrainPeakPositions": false,
            "MaxPeakWindow": 0.075,
            "MinimumPeakHeight": 3.0,
            "PeakWidthPercent": 0.008,
            "TZEROrange": "0,10"
        },
        "ManualMaskFile": "2022-2_11A_CAL/Masks/PG3_43095_manual_mask.xml"
    }
    ```

    - `Diamond`

        Full path to the diamond run. Knowing the run number, the following command can be used on analysis cluster to get the full path of the corresponding data file,

        ```bash
        finddata PG3 59441
        ```

    - `RunCycle`

        Name of the run cycle. The name is following the POWGEN convention like in the example above, in the format of `<year>-<cycle>_<beamline>_CAL`.

    - `Instrument`

        Short name of the instrument. Currently, it is only supporting `PG3`.

    - `Date`

        Date of the data measurement.

    - `SampleEnv`

        Sample environment name. This will go into the file name of the final output HDF5 calibration file.

    - `Notes`

        This specifies some short notes that will go into the file name of the final output HDF5 calibration file.

    - `OutputDir`

        Output directory for the generated calibration HDF5 file.

    - `PDCalibration`

        POWGEN is using Mantid `PDCalibration` algorithm as the underlying engine for the calibration and one can refer to the documentation [here](https://docs.mantidproject.org/nightly/algorithms/PDCalibration-v1.html) for details.

    - `ManualMaskFile`

        The manual mask file to be merged into the the mask generated during the calibration process.

(all_pg3)=
- {ref}`all_pg3<all_pg3>`

    > The script here is running the reduction script located at `/SNS/PG3/shared/autoreduce/reduce_PG3_man.py`.

    This will run the same autoreduction as on Monitor ([monitor.sns.gov](https://monitor.sns.gov)). It runs locally and multiple run numbers can be processed in a batch manner. The program runs as follows,

    ```bash
    all_pg3 IPTS RunsToProcess [OutputDirectory]
    ```

    e.g., `all_pg3 29792 '193462, 193474-193484' /path/to/out/dir`

    where `[OutputDirectory]` indicates the path to output directory is `optional`.

- `confirm-powgen`

    Routine for confirming the data availability for POWGEN experiments. It can run with either of the ways below,

    ```
    confirm-powgen
    confirm-powgen <IPTS>
    confirm-powgen <IPTS> Submission_Number
    ```

    With the first way, the program will ask for a few user inputs while running. With the second way, it will run directly, taking the `<IPTS>` number and assume the submission number of `1`. With the third way, one can also specify the submission number of an `<IPTS>` -- for some experiments, there may be some continuation runs and each run has a certain submission number, `1, 2, 3, ...`.

(pg3_larc)=
- {ref}`pg3_larc<pg3_larc>`

    A handy routine to check the POWGEN auto reduction and live reduction setup to see whether we have some obvious errors. This is just for quickly checking whether necessary files are existing and are connected properly but `NOT` for checking whether the actual configuration inside the file does make sense or not.