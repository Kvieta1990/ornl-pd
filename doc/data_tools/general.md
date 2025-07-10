General Tools
===

(abs_pre_calc)=
- {ref}`abs_pre_calc<abs_pre_calc>`

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

(mts)=
- {ref}`mts<mts>`

    The local version of `MantidTotalScattering` (MTS) on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster.

(mts_data)=
- {ref}`mts_data<mts_data>`

    Routine for extracting data from the reduced $S(Q)$ data from the MTS running. Also, it has the functionality of removing the hydrogen background automatically.

    - [Optional] `-d`, followed by a file name to specify the input data file to process, in the NeXus format.

    - [Optional] `-w`, followed by an integer number. If the `DebugMode` is set to `true` in `MTS` (see the instructions [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_doc.html)), This option can be used to specify the index of the workspace to extract. If not sure about the index, just leave out this option and the program will print out the available options and prompt for the input of the index.

    - [Optional] `-g`, followed by an input file name in `json` form, which specifies some further inputs. The flag is for merging multiple banks of reduced data, e.g., from `MantidTotalScattering` reduction, into a single merged data. The provided input file should be like this,

        ```json
        {
            "MergeParams": "merge_params.json",
            "Mode": "S",
            "NumBanks": 6,
            "FileListInput": "files_to_merge_s.txt"
        }
        ```

        The `MergeParams` entry specifies a `json` file containing the parameters for the data merging and the parameter set provided will be applied to all the data to be merged. The list of datasets to be merged are provided with the `FileListInput` entry, and a plain text file should be provided to contain all the datasets to be merged, one dataset in each line. Two modes are available here -- the single-file mode and multiple-files mode, as can be specified with the `Mode` entry. `S` or `s` is for the single-file mode while `M` or `m` is for multiple-files mode. For the single-file mode, one is expecting the input dataset in the `NeXus` format. For the multiple-files mode, one is expecting the input dataset in plain text. For the `S` mode, the specification of data files in the file corresponding to the `FileListInput` entry is straightforward -- one just puts the `NeXus` file names in each of the lines in the file. The path for each dataset should be specified relative to the current running directory (i.e., where the `mts_data` command will be running). For the `M` mode, a stem name is expected for each dataset and we are expecting the names of the data files are following the standard. For example, if I put in the stem name `my_data` for a dataset, I am expecting the following files to be available,

        ```
        my_data_bank1.dat
        my_data_bank2.dat
        my_data_bank3.dat
        my_data_bank4.dat
        my_data_bank5.dat
        my_data_bank6.dat
        ```

        The number of expected files is determined by the `NumBanks` entry. Here it should be noted that for the `S` mode, even though we can extract the number of banks from the `NeXus` file, we are not doing that with the `-g` flag, meaning we still need to provide the `NumBanks` entry for the `S` mode. Here below we are attaching a template parameter file (corresponding to the `MergeParams` flag),

        ```json
        {
            "1": {
                "Qmin": "0",
                "Qmax": "1.0",
                "Yoffset": "0",
                "Yscale": "1"
            },
            "2": {
                "Qmin": "1",
                "Qmax": "1.5",
                "Yoffset": "0",
                "Yscale": "1"
            },
            "3": {
                "Qmin": "1.5",
                "Qmax": "4",
                "Yoffset": "0",
                "Yscale": "1"
            },
            "4": {
                "Qmin": "0",
                "Qmax": "0",
                "Yoffset": "0",
                "Yscale": "1"
            },
            "5": {
                "Qmin": "4",
                "Qmax": "40",
                "Yoffset": "0",
                "Yscale": "1"
            },
            "6": {
                "Qmin": "0",
                "Qmax": "0",
                "Yoffset": "0",
                "Yscale": "1"
            }
        }
        ```

        The merged data file will be saved to the same directory as for each individual dataset, individually, with the name of `<STEM>_merged.dat`. For the `S` mode, `<STEM>` is just the stem name of the corresponding `NeXus` file while for the `M` mode, `<STEM>` refers to the input stem in each of the file provided with the `FileListInput` flag.

    - [Optional] `-b`, followed by an input JSON file, the details of which will be presented below. Here follows is an example of the input JSON file,

        ```json
        {
            "InputFile": "/SNS/users/y8z/Temp/hydro_bkg_proc/NOM_BaO_HEO.nxs",
            "NIterations": [2000, 2000, 2000, 2000, 2000, 2000],
            "XWindow": [0.05, 0.05, 0.05, 0.05, 0.05, 0.05],
            "ApplyFilterSG": false,
            "PolyDegree": [7, 5, 5],
            "QMin": [0.57, 0.93, 1.73, 3.12, 3.95, 0.6],
            "QMax": [14.0, 25.0, 40.0, 40.0, 40.0, 6.0],
            "Cycles": 3
        }
        ```

        - `InputFile`
        
            To specify the input data file in the NeXus format. This is expected to be the output from `MTS`.

        - `NIterations`

            In the backend, the Mantid [`EnggEstimateFocussedBackground`](https://docs.mantidproject.org/nightly/algorithms/EnggEstimateFocussedBackground-v1.html) is used for estimating the background through the application of a top-hat convolution iteratively. This is followed by a fitting of a polynomial function against the estimated background for smoothing purpose. The current key specifies the number of iterations to be performed for `EnggEstimateFocussedBackground`. Refer to the algorithm documentation [here](https://docs.mantidproject.org/nightly/algorithms/EnggEstimateFocussedBackground-v1.html) for more details.

            > If a single number is provided as an integer, it will be applied to all the banks. Otherwise, if a list of integer numbers is provided, the length of the list should be equal to the number of banks.

        - `XWindow`

            Extent of the convolution window in the x-axis for all spectra. Refer to the algorithm documentation [here](https://docs.mantidproject.org/nightly/algorithms/EnggEstimateFocussedBackground-v1.html) for more details.

            > If a single number is provided as an integer, it will be applied to all the banks. Otherwise, if a list of integer numbers is provided, the length of the list should be equal to the number of banks.

        - `ApplyFilterSG`

            Apply a Savitzky–Golay filter with a linear polynomial over the same XWindow before the iterative smoothing procedure (recommended for noisy data).

        - `PolyDegree`

            The degree of the polynomial to fit the estimated background from `EnggEstimateFocussedBackground`.

            > The parameter will apply to each of the processing cycles (see the `Cycles` key below). If a single value is given (as an integer), it will be applied to all cycles. Otherwise, the length of the list provided here should not be smaller than the number of cycles for any of the banks.

        - `QMin`

            The lower limit in $Q$-space for each bank of data to be considered. The available data range in $Q$-space for each bank is usually different and beyond the available range, the data could be very noisy or showing strong spikes, which would prevent the background estimation from working properly. Here we can specify the range of data to be considered to suppress the problem.

            > The length of the list provided here should be equal to the number of banks.

        - `QMax`

            The upper limit in $Q$-space for each bank of data to be considered. See the details above for the `QMin` key.

            > The length of the list provided here should be equal to the number of banks.

        - `Cycles`

            Sometimes, the background estimation plus the polynomial fitting and the background removal process may need to be repeated multiple times before the background can be removed cleanly. This parameter controls the number of such cycles.

            > If a single number is provided as an integer, it will be applied to all the banks. Otherwise, if a list of integer numbers is provided, the length of the list should be equal to the number of banks, in which case different number of cycles will be applied to different banks of data. As pointed above in the `PolyDegree`, the length of the list provided with `PolyDegree` should not be smaller than the number of cycles for any of the banks.

(mantidl)=
- {ref}`mantidl<mantidl>`

    Run a local version of Mantid Workbench on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster.

(pystog_cli)=
- {ref}`pystog_cli<pystog_cli>`

    Run a local version of `pystog_cli` on Analysis. This local version is using the local conda environment under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) on Analysis cluster. Refer to the following links for further information about `pystog`,

    - [The source code hosted on GitHub](https://github.com/neutrons/pystog?tab=readme-ov-file)

    - [The official documentation page for `pystog`](https://pystog.readthedocs.io/en/latest/)

    - [The web page containing tutorials for `pystog`](https://powder.ornl.gov/total_scattering/data_reduction/ts_pp.html)

    Running `pystog_cli` on Analysis without any arguments provided, the help message will be displayed. Usually, the program takes in a JSON file and it will produce files compatible with the [`RMCProfile`](https://rmcprofile.ornl.gov) program, as originally the `pystog_cli` program was designed to reproduce the `stog` program that is bundled with the [`RMCProfile`](https://rmcprofile.ornl.gov) package. One can refer to the links above for detailed information about how to use `pystog` and `pystog_cli`.
    
    ``````{admonition} The '-ft' flag

    One thing that is worth mentioning is the extra flag `-ft` that can be provided to `pystog_cli` -- this flag was introduced in the wrapper script that calls `pystog_cli` so it is not directly available in the underlying `pystog_cli` routine. What this flag does is to skip the `RMCProfile` part of the data processing. Instead, it will produce pair distribution function (PDF) data in the `pdffit G(r)` format, while performing the Fourier filter, if specified to. When `-ft` is provided to `pystog_cli` on Analysis, the wrapper script will read in the provided JSON file (same as the one running `pystog_cli` without the `-ft` flag) for necessary parameters regarding the Fourier transform and filter. The output will be saved according to the `Outputs` entry in the JSON file.
    ``````

    ``````{admonition} About Data Scaling

    With `pystog_cli`, one can specify a scale factor for the data rescaling purpose. It should be noticed the difference from the `stog_new` program in the `RMCProfile` package which also has the same parameter. However, in `stog_new`, the scale factor is applied through division, meaning the new data will be `new = old / scale`, whereas with `pystog_cli`, the scale factor is applied via muiltiplication, i.e., `new = old * scale`
    ``````

(pystog_ck)=
- {ref}`pystog_ck<pystog_ck>`

    The routine for processing the total scattering data Fourier transform in a chunk-by-chunk manner. The idea is that the main region in $Q$-space contributing to different regions in $r$-space varies. For example, the main contribution to the high-$r$ part (e.g., $> 50\ Å$) of the signal in real-space would be coming from the very low-$Q$ region in the reciprocal space. Therefore, while Fourier transforming from the $Q$-space to $r$-space, one may choose to use just the low-$Q$ region (e.g., $< 10.0\ Å^{-1}$) of the $Q$-space data.

    ``````{admonition} About Q-range selection

    Depending on the resolution of the diffractometer, the selection of the lower and upper limit of different $Q$-space chunks corresponding to different regions in $r$-space will vary. For high-resolution diffractometers like `POWGEN`, sometimes (depending on how significant the thermal motion and distortion are dampening the diffraction signal) diffraction peaks are still distinguishable from noise up to ~$25\ Å^{-1}$. In this case, using a smaller upper limit for the $Q$-chunk corresponding to the high-$r$ region in real-space will suppress the real diffraction peaks and we will have the data 'over-corrected'.
    ``````

    For sure, using such a narrow $Q$-space data for the Fourier transform will lead to a significant broadening of the features in the real-space. However, since the features in the very high-$r$ region is very broad anyhow due to the asymptotically losing of correlations at large distances, the broadeing effect as the result of limited $Q$-range being used for the Fourier transform should not seriously matter. The benefit of doing so is obvious -- the high frequency component in the high-$Q$ region of the $Q$-space data are all filtered out while performing the inverse Fourier transform for the obtained high-$r$ part of the real-space data back into the reciprocal-space. Follow the same logic, one can choose a slightly larger $Q$ range (e.g., $< 18 Å^{-1}$) corresponding to a slightly lower range of the real-space signal (e.g., $6-50 Å$), and so on. Here down below is the formula summarizing the routine,

    $$S_{ff}(Q) = \sum_i InvFT_{r_i^l}^{r_i^u}\Bigg\{WF_i^r \times \bigg[ FT_{Q_i^l}^{Q_i^u}\Big[WF_i^Q \times S(Q))\Big] \bigg]\Bigg\}
    $$

    where $S(Q)$ refers to the original $Q$-space data coming out from the data reduction pipeline. $S_{ff}(Q)$ refers to the final output $Q$-space data after the chunk-by-chunk processing. $[r_i^l, r_i^u]$ and $[Q_i^l, Q_i^u]$ refers to the corresponding chunks in real and reciprocal space for performing the back-and-forth Fourier transform, where $i$ refers to a specific chunk. $WF$ refers to the window function that is $1$ within the chunk in either real or reciprocal space, and $0$ otherwise. $FT$ and $InvFT$ refers to the forward (from $Q$-space to $r$-space) and inverse (from $r$-space to $Q$-space) Fourier transform, respectively, with respect to the integration range as specified by the subscript and superscript for each.

    > The routine I wrote here was initialized by [Prof. Eric O’Quinn](https://ne.utk.edu/people/eric-oquinn/) who used to work at ORNL and now is a faculty member of the Department of Nuclear Engineering at University of Tennessee, Knoxville. The main idea was originated from [Joerg C Neuefeind](https://www.ornl.gov/staff-profile/joerg-c-neuefeind) working as a neutron scattering scientist on the NOMAD diffratometer at SNS, ORNL.

    The routine available on ORNL Analysis cluster takes a JSON file as the input, and here I am presenting a typical example of the input file,

    ```json
    {
        "Files": [
            "file_1.dat",
            "file_2.dat"
        ],
        "NumberDensity": [
            0.0705
        ],
        "FaberZiman": [
            0.15
        ],
        "OutputStem": [
            "out_1",
            "out_2"
        ],
        "InputForm": "S(Q)",
        "HeaderLines": 2,
        "QMin": 1.0,
        "QBin": 0.01,
        "RMax": 50.0,
        "RBin": 0.01,
        "RMinScaling": 1.1,
        "RMaxScaling": 1.5,
        "RCutoff": 1.64,
        "QChunks": [31.4, 18.37, 10.5, 6.9],
        "RChunks": [2.58, 6.0, 50.0, 314.0],
        "QSpaceOutputForm": "FK(Q)",
        "RSpaceOutputForm": "GK(r)",
        "LowRInspectRegion": [[0, 6], [-2, 1]],
        "Interactive": true,
        "Diagnostic": true,
        "DebugMode": true
    }
    ```

    - `Files`

        > Mandatory

        > Form: A list of strings

        A list of files to be processed. It can be a single file or multiple files. No matter which, file(s) should be provided as a list. Files provided should be $Q$s-pace total scattering data files in the form of $S(Q)$ (the normalized one, which goes to $1$ at high $Q$) or $S(Q) - 1$.

    - `NumberDensity`

        > Mandatory

        > Form: A list of numbers

        A list of number density values corresponding to the file list provided. If multiple entries in the list, the entries should be corresponding to the entries for `Files` in order, in which case the length should match. If a single entry is in the list here, the value will be applied to all files provided in `Files` list.

        The number density will be used for Fourier filter and data format conversion.

    - `FaberZiman`

        > Optional. If the form of the real (reciprocal) space output is specified as `GK(r)` (`FK(Q)`), this value is then `Mandatory`.

        > Form: A list of numbers

        A list of `Faber-Ziman` coefficients corresponding to the file list provided. If multiple entries in the list, the entries should be corresponding to the entries for `Files` in order, in which case the length should match. If a single entry is in the list here, the value will be applied to all files provided in `Files` list.

        The `Faber-Ziman` coefficient is defined as $\sum_{i,j}c_ic_jb_ib_j$ where $c_i$ and $c_j$ refers to the concentration of atom type $i$ and $j$, respectively. $b_i$ and $b_j$ refers to the coherent scattering length of atom type $i$ and $j$, respectively. It will be used for conversion of the data into certain forms, e.g., the $G(r)$ function as defined in {cite}`Keen:th0051`.

    - `OutputStem`

        > Mandatory

        > Form: A list of strings

        The output stem name corresponding to each of the files in `Files`. The length of the list here should be consistent with the one for `Files`.

    - `InputForm`

        > Optional, default to `S(Q)`

        > Form: A string

        Specification of the input data form. Acceptable values are `S(Q)` and `S(Q)-1`.

    - `HeaderLines`

        > Optional, default to `2`

        > Form: An integer

        Specification of the number of header lines in the input data files. Apparently, all the input data files should be consistent in terms of the number of header lines.

    - `QMin`

        > Optional, default to `0.4`

        > Form: A float

        Lower boundary in $Q$-space for the Fourier transform.

    - `QBin`

        > Optional, default to `0.01`

        > Form: A float

        Bin size of the $Q$-space data. Internally, the program will check whether the provided data is equally spaced. If not, the data will be rebinned according to the bin size provided here. Or, if the bin size in the provided data is not consistent with the provide bin size, the data will also be rebinned according to the bin size provided here.

    - `RMax`

        > Optional, default to `50.0`

        > Form: A float

        The maximum $r$ value for the output $r$-space data produced from the processing.

    - `RBin`

        > Optional, default to `0.01`

        > Form: A float

        Bin size of the $r$-space output data.

    - `RMinScaling`

        > Optional. If the value is not given, the program will bring up a low-$r$ region plot of the $g(r)-1$ data so that one can decide and input the required value from the command line interfae. 

        > Form: A float

        The lower boundary in the low-r region of the real space data for the data scaling. Internally, the prpgram will initially Fourier transform the data into real-space $g(r) - 1$ form, which should in principle oscillate around $1$ in the low-r region. Then, an average value in a specified low-$r$ region will be calculated to give an indicator for how far the data scale is off (by comparing to the level that the data should oscillate around, i.e., $1$). Then the $Q$-space data will be rescaled according to the scale factor calculated here.

    - `RMaxScaling`

        > Optional. If the value is not given, the program will bring up a low-$r$ region plot of the $g(r)-1$ data so that one can decide and input the required value from the command line interfae.

        > Form: A float

        The lower boundary in the low-r region of the real space data for the data scaling. See the notes for `RMinScaling` presented above.

    - `RCutoff`

        > Optional. If the value is not given, the program will bring up a low-$r$ region plot of the $g(r)-1$ data so that one can decide and input the required value from the command line interfae.

        > Form: A float

        The low-$r$ cutoff in $r$-space for the Fourier filter, i.e., features below this cutoff will be filtered out.

    - `QChunks`

        > Mandatory

        > Form: A list of numbers

        Specification of the `Qmax` to be used for the Fourier transform for each of the $r$-space chunks. Normally, the $r$-space chunks (see `RChunks` below) should be provided in an increasing order, i.e., from low-$r$ to high-$r$. Accordingly, the `QMax` values here should be given in a decreasing order. The length should be matching that of the `RChunks` entry.

    - `RChunks`

        > Mandatory

        > Form: A list of numbers

        Specification of the $r$-space chunking for the data processing. Normally, we are expecting that the $r$-space chunks should be provided in an increasing order, i.e., from low-$r$ to high-$r$.
        
        > The first chunk will always go from $0$ to the first entry in the list.
        
        > The ending point of the last chunk will always be internally calculated to be $\pi/\Delta Q$ (where $\Delta Q$ refers to the bin size in $Q$-space), according to the Nyquist-Shannon sampling theorem. `However, the ending point of the last chunk, e.g., '314.0' in the example given above, should still be provided, for the informative purpose`.

    - `QSpaceOutputForm`

        > Optional, default to `S(Q)`

        > Form: A string
        
        The form of the $Q$-space outpout data. Acceptable values are `S(Q)`, `F(Q)` and `FK(Q)`. Refer to the `pystog` documentation [here](https://pystog.readthedocs.io/en/latest/pystog/converter.html) for details about those forms.

    - `RSpaceOutputForm`

        > Optional, default to `g(r)`

        > Form: A string
        
        The form of the $r$-space outpout data. Acceptable values are `g(r)`, `G(r)` and `GK(r)`. Refer to the `pystog` documentation [here](https://pystog.readthedocs.io/en/latest/pystog/converter.html) for details about those forms.

    - `LowRInspectRegion`

        > Optional

        > Form: A list

        > Example: "LowRInspectRegion": [[0, 6], [-2, 1]]

        For the interactive determination of the lower and upper limit in the low-$r$ region for the scaling purpose, we need to plot the $g(r)-1$ data and focus on the low-$r$ region. The parameter here is for specifying the plotting range to save the efforts of zooming on the user side. The first entry in the list gives the lower and upper limit for the `x`-axis while the second entry is for the `y`-axis.

    - `Interactive`

        > Optional, default to `false`

        > Form: A boolean

        Specify whether or not to run the program interactivel, in which parameters including `RCutoff`, `RMinScaling` and `RMinScaling` will be ignored. They will be read in from the command line prompt. Meanwhile, plots will be generated interactively during the program running. So, the interactive mode is not suitable for running a series of files.

    - `Diagnostic`

        > Optional, default to `false`

        > Form: A boolean

        Specify whether or not to generate diagnostic data and plots. In case of `true`, the chunk-by-chunk $r$-space data and their corresponding Fourier transform in $Q$-space will be output to files and presented with plots.

    - `DebugMode`

        > Optional, default to `false`

        > Form: A boolean

        Specify whether or not to run the program in the debug mode. In case of `true`, the program will print out detailed information while encountering errors. Otherwise, only brief information will be presented in case of error.

    Output files will be generated for the processed data in both real and reciprocal space. A typical list of output files will be,

    ```
    <output_stem>_cbyc_ff_fkofq.png
    <output_stem>_cbyc_ff_fkofq.sq
    <output_stem>_cbyc_ff_gkofr.gr
    <output_stem>_cbyc_ff_gkofr.png
    <output_stem>_cbyc_gofr_parts.gr
    <output_stem>_cbyc_gofr_parts.png
    <output_stem>_cbyc_sofq_parts.png
    <output_stem>_cbyc_sofq_parts.sq
    ```

    where `<output_stem>` refers to the value provided with `OutputStem` for each of the files being processed. `<output_stem>_cbyc_ff_fkofq.sq` and `<output_stem>_cbyc_ff_fkofq.sq` are the output $Q$- and $r$-space data, respectively. The `_fkofq` and `_gkofr` part in the file names varies according to the parameters specified with `QSpaceOutputForm` and `RSpaceOutputForm`, respectively, according to the list below,

    ```
    g(r): '_gofr'
    G(r): '_pdf'
    GK(): '_gkofr'
    S(Q): '_sofq'
    F(Q): '_fofq'
    FK(Q): '_fkofq'
    ```

    Those files with `_parts` in their names correspond to the diagnostic data generated for the chunk-by-chunk Fourier transform.