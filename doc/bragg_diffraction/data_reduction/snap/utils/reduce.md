# `reduce` 

## overview

The most important method in the snapwrap `utils` module is `reduce` which, as expected, reduces diffraction data. Its only mandatory argument is a run number. On the "happy path" where the run number corresponds to a fully calibrated instrument state, reduction will execute completely with only a run-number provided.

Thus, a minimal script to reduce the data corresponding to run 61991 would be:
```python
import snapwrap.utils as wrap

wrap.reduce(64413)
```
Executing the script above will result in a full reduction of run 64413. The reduced data will appear in the mantidWorbench workspace tree and, by default, have been reduced according to 3 standard pixel grouping schemes: `all`, `bank` and `column`. Each workspace has a different number of reduced spectra, depending on the number of subgroups defined in the pixel grouping scheme (e.g. `column` has 6 spectra, corresponding to the 6 columns of detector modules in SNAP). 

The reduced workspaces have standard names that all begin with the word `reduced` followed by the units (currently only `dsp` for d-spacing, or `qsp` for momentum transfer) the pixel grouping scheme (i.e. `all`,'`bank`,`column`) the run number and, finally a timestamp (containing year-month-day and hours, minutes and seconds). For example: 
```
reduced_dsp_all_064413_2025-02-18T170940
reduced_dsp_bank_064413_2025-02-18T170940
reduced_dsp_column_064413_2025-02-18T170940
```
would be normal output for reducing run 64413.
```{note}
While a bit visually jarring, the timestamps are useful allowing comparison of successively reduced runs.
```

```{note}
If you are only interested in a particular group (e.g. `bank`), the mantid utility to filter workpaces names can be a neat way to clean up the workspace tree. You can also use the `snapwrap` utility `wrap.file()` to keep the tree clean.
```

As with any python method, additional arguments can be passed to `reduce` inside its parentheses with simple `parameter=value` syntax. The available parameters are described here

## Optional arguments

### `cisMode`

If `True` various intermediate workspaces created during reduction are retained. This can be useful for troubleshooting, but it's a bit tricky to figure out what the many workspaces are.

```{caution}
Be aware that retaining intermediate workspaces can use up a lot of memory
```

### `continueNoDifcal`

This flag allows a "diagnostic" reduction of data to proceed when a diffraction calibration (specifically the .h5 file containing diffractometer constants) does not exist. The default setting for this parameter is `False`. 

```{note}
SNAPRed follows the Calibration Index for the relevant instrument state to find calibration files. This is built automatically when using SNAPRed to conduct a diffraction calibration workflow.
```

### `continueNoVan`

Similarly to above, this parameter allows a diagnostic assessement of data where no vanadium normalisation calibration exists. When `True`, a background extracted from the reduced diffraction pattern is used as an artificial normalisation function for the data. The default setting for this parameter is `False`.

The algorithm that extracts the the artificial normalisation (`clipPeaks`) has three parameters (`smoothingParameter`,`decreaseParameters` and `lss`), their default values are set in the config file "defaultRedcConfig.yml", and these can be overriden by using the `YMLOverride` option (see below). 

### `emptyTrash`

If `True` (the default) `snapwrap` will delete any intermediate workspaces created by `SNAPRed`. Sometimes it's useful to inspect these, which can be done by setting `emptyTrash=False`

### `keepUnfocussed`

By default set to `False`, this flag allows the retention of the unfocussed, as loaded dataset. x-units are by default d-spacing (this can be changed using the `YMLOverride` option).

### `pixelMaskIndex`

Currently, SNAPRed can apply a pixel mask with the following caveats:

1. the mask must exist as a mantid mask workspace and 
2. the workspace _must_ have the name either `MaskWorkspace` or `MaskWorkspace_N`

Masks of this type are specified by specifiying the value of `N` (note the workspace `MaskWorkspace` can be indicated with _either_ N= 0 or 1 as the first value of N used by mantid is 2).

### `qsp`

Default value is `False`. If set `True` data will be reduced into workspaces in units of momentum transfer with linear binning following the value of `linBin`. 

### `linbin`

Defaulting to 0.01, this sets the linear bin size in Angtrom that is applied to data when momentum transfer units have been specified (following `qsp=True`). Linear binning is not appropriate for data in units of d-spacing and this is not supported by `snapwrap`.

### `reduceData`

By default set to `True,` this allows control over whether the data are reduced. If set `False`, snapwrap will report relevant information on the reduction (e.g. existence and location of various calibration files) but will not actually reduce data.

### `save`

This controls whether the reduced data are saved to disk, along with the reduction record and any auxilliary workspaces (such as pixel masks). By default, this is set to be `True` and every execution of reduction will create a new time stamped folder. If set `False` data will be reduced and workspaces created, but these are not saved.

### `verbose`

By default set to `False`, this flag allows control of the mantid logging level and also allows detailed information regarding the reduction to be output to the messages window.

### `YMLOverride`

Some default settings for snapwrap are set in a `yml` file inside the repo. It is possible to override any value by copying this file, editing as needed and then setting the value of `YMLOverride` to be the path to the new `.yml`

