NOMAD
===

- `nom_cal`

    The calibration routine for NOMAD. It takes the following JSON file as the input,

    ```
    /SNS/users/y8z/NOM_Shared/CALIBRATION/cal_config.json
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

- `nom_cal_local`

    This is a local version of the `nom_cal` (which is systemwise available), stored in the following directory,

    ```
    /SNS/users/y8z/NOM_Shared/CALIBRATION
    ```

    To run this routine, one has to `cd` into the directory and run `./nom_cal_local`, or one can just give the full path to the routine.