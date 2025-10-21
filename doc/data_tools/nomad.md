NOMAD
===

(nom_cal)=
- {ref}`nom_cal<nom_cal>`

    > The calibration has been incorporated into the NOMAD autoreduction workflow so any time a suitable diamond calibration run is available, the calibration routine will be kicked off automatically. In case of problems, one then log in Analysis cluster and use the current routine for running the calibration manually -- normally, even the calibration running at the autoreduction stage encounters issues, still the input json file can be generated automatically so in most cases, one does not need to worry about manually populating the input json file here.

    The calibration routine for NOMAD. It takes the following JSON file as the input (we don't need to give the input explicitly, so on command line, just execute `nom_cal`),

    ```
    /SNS/NOM/shared/CALIBRATION/cal_config.json
    ```

    Here is presented the contents of the configuration file,

    ```json
    {
        "Diamond": "/SNS/NOM/IPTS-34905/nexus/NOM_213940.nxs.h5",
        "Instrument": "NOM",
        "Date": "2025-04-22",
        "SampleEnv": "furnace",
        "OutputDir": "/SNS/NOM/shared/autoreduce/calibration",
        "GenShadowMask": "shadow_mask_furnace_213940.in",
        "DiaLattParam": 3.5671299351,
        "GroupMethod": "KMEANS_ED",
        "SaveInitCalTable": true,
        "Quiet": false,
        "ArbCalFile": "arb_starting_cal.h5",
        "MaskFile": "outputmask.xml"
    }
    ```

    - `Diamond`

        Full path to the diamond run. Knowing the run number, the following command can be used on analysis cluster to get the full path of the corresponding data file,

        ```bash
        finddata NOM 213940
        ```

    - `Instrument`

        Short name of the instrument. Currently, it is only supporting `NOMAD`.

    - `Date`

        Date of the data measurement.

    - `SampleEnv`

        Sample environment name. The value should be consistent with the name being used in the characterization file for NOMAD, as given in the following file,

        ```
        /SNS/users/y8z/NOM_Shared/autoreduce/auto_exp.csv
        ```

        See [here](https://powder.ornl.gov/auto_reduce/nomad_auto.html) for more information about the NOMAD characterization file.

    - `OutputDir`

        Output directory for the generated calibration HDF5 file.

    - `GenShadowMask`

        The shadow mask file name. This is a file to be `generated` by the calibration routine and its name can be arbitrary.

    - `DiaLattParam`

        Lattice parameter of the standard diamond sample.

    - `GroupMethod`

        In the calibration routine, there is a step for grouping detectors according to the similarity of their diffraction patterns. Originally, calibration was performed following such a grouping manner, but the recently implemented routine no longer uses this way and the grouping step is only for creating the mask for those `bad` pixels, by which we mean those diffraction patterns that do not yield a successful peak fitting.

    - `SaveInitCalTable`

        Flag for whether to save the calibration table corresponding to the first stage of the calibration, i.e., peaks are lining up without further calibration.

    - `Quiet`

        If set to `true`, the terminal output of the routine running will be suppressed.

    - `ArbCalFile`

        This is an arbitrary calibration file as the starting point for the calibration routine. It is a file stored in the following directory,

        ```
        /SNS/users/y8z/NOM_Shared/CALIBRATION/inputs
        ```

        Usually, we don't need to change this.

    - `MaskFile`

        Output mask file, to be stored in the following directory,

        ```
        /SNS/users/y8z/NOM_Shared/CALIBRATION/inputs
        ```

        Usually, we don't need to touch this.

(nom_cal_local)=
- {ref}`nom_cal_local<nom_cal_local>`

    This is a local version of the `nom_cal` (which is systemwise available), stored in the following directory,

    ```
    /SNS/users/y8z/NOM_Shared/CALIBRATION
    ```

    To run this routine, one has to `cd` into the directory and run `./nom_cal_local`, or one can just give the full path to the routine. This routine does take an argument to specify the input json file which follows exactly the same form as presented for `nom_cal` above.

(all_nom)=
- {ref}`all_nom<all_nom>`

    > The script here is running the reduction script located at `/SNS/NOM/shared/autoreduce/reduce_NOM_man.py`.

    This will run the same autoreduction as on Monitor ([monitor.sns.gov](https://monitor.sns.gov)). It runs locally and multiple run numbers can be processed in a batch manner. The program runs as follows,

    ```bash
    all_nom IPTS RunsToProcess [OutputDirectory]
    ```

    e.g., `all_nom 29792 '193462, 193474-193484' /path/to/out/dir`

    where `[OutputDirectory]` indicates the path to output directory is `optional`.

(confirm-nom)=
- {ref}`confirm-nom<confirm-nom>`

    Routine for confirming the data availability for NOMAD experiments. It can run with either of the ways below,

    ```
    confirm-nom
    confirm-nom <IPTS>
    confirm-nom <IPTS> Submission_Number
    ```

    With the first way, the program will ask for a few user inputs while running. With the second way, it will run directly, taking the `<IPTS>` number and assume the submission number of `1`. With the third way, one can also specify the submission number of an `<IPTS>` -- for some experiments, there may be some continuation runs and each run has a certain submission number, `1, 2, 3, ...`.

(addie_nom)=
- {ref}`addie_nom<addie_nom>`

    Run a local version of `ADDIE` for data reduction and post-processing. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster.

(nom_cp)=
- {ref}`nom_cp<nom_cp>`

    > The data comparison routine for NOMAD, useful for comparing between two sets of measurements, panel by panel. Here, by 'panel', we mean the eight-pack of helium3 tube detectors.

    The routine takes a single json file as the mandatory input, specifying all the needed input parameters. An example input json file is presented below,

    ```json
    {
        "Data1": {
            "Title": "Furnace2025A",
            "Sample": "213940",
            "VanadiumRod": "213943",
            "EmptyContainer": "213942",
            "EmptyInstrument": "213944",
            "CalibrationFile": "/SNS/users/y8z/NOM_Shared/autoreduce/calibration/NOMAD_213940_2025-04-22_furnace.h5"
        },
        "Data2": {
            "Title": "Furnace2025B",
            "Sample": "223368",
            "VanadiumRod": "223370",
            "EmptyContainer": "223369",
            "EmptyInstrument": "223372",
            "CalibrationFile": "/SNS/users/y8z/NOM_Shared/autoreduce/calibration/NOMAD_223368_2025-08-27_furnace.h5"
        },
        "SampleName": "Diamond",
        "EightPackIndex": "2-3",
        "SaveDirectory": "EP_1-37_Furnace_2025A_2025B"
    }
    ```

    where the `Data1` and `Data2` blocks specify the two sets of measurements to be compared, including the sample, vanadium rod, empty container and empty instrument runs. The calibration file for each set of measurements should also be provided with the `CalibrationFile` key. The `SampleName` key tells the sample name, `EightPackIndex` tells the program the index of eight-packs to process. Value can be given like `1, 3, 5`, `1-10`, or `1, 3-15` where the number connected by `-` will be expanded to a continuous range of integers. The `SaveDirectory` specifies the output directory and the path can be relative to where the program is executed. Also, we don't need to worry about creating the directory ourselves -- the program will create this output directory if it is not already there.

    The program will output a single `HTML` file for each eight-pack which contains a series of comparisons, such as that between the raw sample, sample divided by vanadium, etc. The top part of each generated `HTML` file has a navigation with links leading us to the corresponding comparison. The plot included in the resulted `HTML` file is created with `plotly` and is `interactive` (i.e., we can zoom and pan on each plot).