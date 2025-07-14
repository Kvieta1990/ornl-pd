# `propagateDifcal`

## Overview

It is fequently useful (and sometimes necessary) to copy a diffraction calibration (difcal) from one state to another. This is a valid operation when the donor and destination states have identical detector positions. When provided with the run number of an existing difcal operation, `propagateDifcal` automatically identifies (existing) compatible states and copies the calibration across, while also updating the calibration indices used by SNAPRed to locate the new calibration.

```{note}
This utility only works for instrument scientists with write access to the calibration directory
```
Typical usage would be 

```python

import snapwrap.utils as wrap

wrap.propagateDifcal(64431)
```

If necessary, it is possible to create a new state first, making it available to propage the difcal to. This can be done with a separate module called `snapStateMgr` which has a function called `createState` 

For example: 
```python
import snapwrap.utils as wrap
import snapStateMgr as ssm

ssm.createState(64433) #creates 6.4Å state
snapwrap.propagateDifcal(64431) #propagates an existing calibration made using run 64431 to this state
```
## Optional arguments

### `isLite`

Calibrations are lite/native dependent and must be conducted separately for each mode. Since propagation of a difcal relies on it existing, the corresponding calibration must have been conducted. 

By default `isLite=True` but, if an existing `native` calibration needs to be transferred, this can be done by specifying `isLite=False`.

### `propagate`

It is good practice to examine the expected outcome of propagation _without actually propagating any data_. Consequently, this is the default behaviour and the parameter `propagate` set equal `False`.

Once you are sure everything looks good, setting `propagate=True` will actually propagate the calibration. Once this happens, an entry will be created in the calibration index of the corresponding state and will henceforth be treated as a formal calibration.
