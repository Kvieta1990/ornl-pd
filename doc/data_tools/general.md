General Tools
===

- `abs_pre_calc`

    Routine for the pre-calculation of absorption correction and autoreduction configuration for `NOMAD` and `POWGEN`. For the evaluation of the absorption, once the sample information is ready, it can already be done even before the experiment data are ready. So, the idea here is to use this routine to collect the sample information (via talking to the `ITEMS` database where the sample information will be stored), perform the absorption calculation and cache the result for later reduction use. In the documentation page for `NOMAD` autoreduction, detailed introduction and instructions for the routine are available -- see [here](https://powder.ornl.gov/auto_reduce/nomad_auto.html). Regarding the autoreduction setup, we also need to populate the characterization runs information to specify those characterization runs to be used for the reduction, including the empty container run(s), empty instrument run(s), vanadium run(s) and the calibration diamond run. With the current routine, one can do (on Analysis cluster, from the command line),

    ```bash
    abs_pre_calc -c
    ```

    to directly open the central characterization table file for editing, skipping the sample information collection and the absorption calculation steps. Or, one can do,

    ```bash
    abs_pre_calc <instrument_name> <IPTS>
    ```

    e.g., `abs_pre_calc NOM 28922`, to run the full process. First, the routine will talk to the `ITEMS` database to fetch the sample information (ID, composition ,etc.). The information will then be populated into a CSV file which will be opened automatically right after the information is collected and populated into the file. Now, at this stage, it is our chance to correct whatever incorrect information there and fill in whatever is missing. Refer to the link [here](https://powder.ornl.gov/auto_reduce/nomad_auto.html) for more details. The absorption calculation will be kicked off right next and the calculated absorption spectra will be saved into the experiment-specific directory so that later reduction with `MantidTotalScattering` (MTS) can find and use the cached absorption calculation. In `MTS`, path to the central configuration file containing instrument-specific configurations is hard coded (see the documentation [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_doc.html#instrument-specific-configs)). In the central configuration, the absorption save location for the absorption cache files should be specified. In the case for `NOMAD`, it is,

    ```
    /SNS/NOM/shared/autoreduce/abs_ms
    ```

    For `POWGEN`, it is,

    ```
    /SNS/PG3/shared/autoreduce/mts_abs_ms
    ```

    Once the absorption calculation and caching is finished, the program will prompt users with the question whether to bring up the central characterization file for editing. If yes, the characterization file will be brought up and one can fill in the characterization runs as needed.

- `mts`

    The local version of `MantidTotalScattering` (MTS) on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster.

- `mts_data`

    Routine for extracting data from the reduced $S(Q)$ data from the MTS running. In a terminal on Analysis cluster, just execute this command followed by the name of the NeXus file we want to extract.

    > This routine only works with the non-debugging mode, where only one workspace will be generated to host the finally reduced data. If the `DebugMode` is set to `true` in `MTS` (see the instructions [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_doc.html)), this routine is not applicable. Normally, the debug mode is more for developers anyways.

    - [Optional] `-h` to print out the help

    - [Optional] `-o` to specify the output directory. If not specified, the output directory will be set to be the directory containing the input file.

    - [Optional] `-w` to specify the index of the workspace to extract. When the `DebugMode` (see [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_doc.html) for `MTS` documentation) in `MTS` is set to `True`, a series of output workspaces will be saved for debugging purpose and they will be saved into a workspace group, with each workspace having a title. The flag here is to specify the index (starting from `0`) of the workspace to extract. If the input file does contain a workspace group (i.e., `DebugMode` was set to `True` when running `MTS`) and no `-w` flag is provided, the program will prompt users with input for the index of workspace to extract.

- `mantidl`

    Run a local version of Mantid Workbench on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster.

- `pystog_cli`

    Run a local version of `pystog_cli` on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster. Refer to the following links for further information about `pystog`,

    - [The source code hosted on GitHub](https://github.com/neutrons/pystog?tab=readme-ov-file)

    - [The official documentation page for `pystog`](https://pystog.readthedocs.io/en/latest/)

    - [The web page containing tutorials for `pystog`](https://powder.ornl.gov/total_scattering/data_reduction/ts_pp.html)

    Running `pystog_cli` on Analysis without any arguments provided, the help message will be displayed. Usually, the program takes in a JSON file and it will produce files compatible with the [`RMCProfile`](https://rmcprofile.ornl.gov) program, as originally the `pystog_cli` program was designed to reproduce the `stog` program that is bundled with the [`RMCProfile`](https://rmcprofile.ornl.gov) package. One can refer to the links above for detailed information about how to use `pystog` and `pystog_cli`.
    
    ``````{admonition} The '-ft' flag

    One thing that is worth mentioning is the extra flag `-ft` that can be provided to `pystog_cli` -- this flag was introduced in the wrapper script that calls `pystog_cli` so it is not directly available in the underlying `pystog_cli` routine. What this flag does is to skip the `RMCProfile` part of the data processing. Instead, it will produce pair distribution function (PDF) data in the `pdffit G(r)` format, while performing the Fourier filter, if specified to. When `-ft` is provided to `pystog_cli` on Analysis, the wrapper script will read in the provided JSON file (same as the one running `pystog_cli` without the `-ft` flag) for necessary parameters regarding the Fourier transform and filter. The output will be saved according to the `Outputs` entry in the JSON file.
    ``````