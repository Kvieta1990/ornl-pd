# `reload`

## Overview

This function allows retrieval of previously reduced data into a mantid workspace. When SNAPRed reduces data, the output is automatically saved to disk along with a reduction record that captures all details of the reduction workflow and parameters used. 

In general, a given run can be reduced multiple times and each reduction will create a unique reduction record and set of reduced data, indexed by a time stamp recording when reduction was done.

The only required parameter is the run number of the data to be retrieved. In this case, the default behaviour is to load the reduced data (with separate workspaces for each pixel group) from the most recent reduction it finds. So, currently, run 64431 has been reduced 23 times with the most recent reduction timestamped `2025-03-11T110946`

```
snapwrap.reload(64431)
```
will load the three available reduced pixel groups into the workspaces: 
```
reduced_dsp_all_064431_2025-03-11T110946
reduced_dsp_bank_064431_2025-03-11T110946
reduced_dsp_column_064431_2025-03-11T110946
``` 

## Optional arguments

### `all`

This defaults to False, but if set True will load all available reductions (with different timestamps) instead of just the single most recent one.

### `keepMask`

This defaults to False, but if set True, it will load any present pixel mask (if a pixel mask was used during reduction, this mask is stored in the reduction record) into a workspace with name `MaskWorkspace_N` where the value of N increments appropriately depending on any previously existing mask workspaces in the ADS

### `pixelGroup`

This argument provides an option to only load a single pixel group from a given reduction. By default it has a value of `None` meaning that all available reduced pixel groups will be loaded. If, instead, it is given a value that is the name of a given pixel group as a string, only this group will be loaded

For example,
```
snapwrap.reload(64431,pixelGroup="bank")
```
will result in the single workspace
```
reduced_dsp_bank_064431_2025-03-11T110946
```
being loaded.