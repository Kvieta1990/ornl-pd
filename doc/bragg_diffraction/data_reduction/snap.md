SNAP | BL-3 | SNS
===

## Introduction to reducing data on SNAP

### Understanding "Lite" mode

Significant effort has gone into careful compression of SNAP data to maximise processing time while maintaining diffraction resolution. These compressed data are referred to as "Lite" and, by default, this compression will be used. In a very small number of cases, the resolution of the output data can be increased by deactivating lite mode and the corresponding "Native" mode is supported for all reduction operations. This will typically manifest as a toggle called `isLite` which has (default) value of True for compressed data and can be set to False for Native mode.

```{note}
Part of the compression used in lite mode involves merging the neutron events in adjacent pixels. This affects how pixels are numbered (and, indeed, the total number of unique pixels defined). Correspondingly, all auxilliary information (for example pixel masks) must correctly correspond to the lite or native mode being used.
```

### A note on pixel grouping schemes

SNAP has 1.2M pixels in its detectors. During reduction, the events measured in these individual pixels are merged according to a pixel grouping scheme - via a process called "diffraction focussing" - leading to a small number of familiar 1d powder diffraction patterns. The choice of pixel grouping scheme is entirely arbitrary but, by default, data measured on SNAP will be reduced according to 3 different schemes: 

|Scheme Name | Number of spectra | Description |
|------------| ----------------- | ----------- |
| all        | 1 | All pixels in the instrument are merged into a single spectrum |
| bank       | 2 | Pixels in the two separate detector banks are merged into one spectrum per bank |
| column     | 6 | The pixels in the 6 vertical columns formed by the individual detector banks are merged separately |

These 3 different grouping schemes are always available and allow different views on the data, and allowing optimal compromise between angular resolution and count levels to be found. 

It is also possible to retain the unfocussed dataset, which will show the full angular resolution of the instrument: with complete powder pattern in each pixel (albeit a noisy pattern because a single pixel is small).

Finally, it is also possible to define custom pixel groups if needed for you experiment. An instrument scientist can help set these up.

### `SNAPRed` the reduction backend 

SNAP is unique amongst the SNS powder diffractometers in that it is highly reconfigurable. Each change of configuration, for example moving one of the detectors, modifies the calibration data and parameters needed to reduce data. For this reason, a sophisticated backend software application for reducing data - called [`SNAPRed`](github.com/neutrons/SNAPRed) has been developed. `SNAPRed` manages all of the effects of instrument configuration, greatly simplifying the user experience of reduction: by design, reduction is possible knowing only your neutron run numbner 

### `snapwrap` the reduction frontend

Most users will never interact directly with SNAPRed. Instead, they will usually use a specially created python wrapper called [snapwrap]((github.com/neutrons/snapwrap)) that provides easy access to the functionality via a python script, intended to be run inside the `mantidworkbench` application. Normally an instrument scientist will provide a template script and help set this up, so there is no need to know python.

### Basic data reduction using `snapwrap`

In order to reduce SNAP data, using `snapwrap` a user should log into the SNS analysis cluster at [analysis.sns.gov](analysis.sns.gov) either using a web browser or the [free thinlinc client application](https://www.cendio.com/thinlinc/download/). This presents a linux desktop, from which a terminal can be opened simply by right-clicking on the desktop and selecting `Open Terminal Here`. 

Once the terminal opens, just typing:

```
snapwrap
```
will open an instance of `mantid workbench` from which snapwrap can be accessed through a python script. One of the windows in the workbench is an Editor window. A buttom marked with `+` at the top right of this window will create a new script with three standard imports: 

```python
# import mantid algorithms, numpy and matplotlib
from mantid.simpleapi import *
import matplotlib.pyplot as plt
import numpy as np
```

In order to access snapwrap we must add a single additional import:
```python
import snapwrap.utils as wrap
```
the `snapwrap.utils` module includes the primary methods needed to reduce data. The most commonly used method is `reduce` which will reduce data. The only mandatory argument for `reduce` is the run number of your neutron dataset. So, to reduce the data from run 64413, the complete script would be:

```python
# import mantid algorithms, numpy and matplotlib
from mantid.simpleapi import *
import matplotlib.pyplot as plt
import numpy as np
import snapwrap.utils as wrap

wrap.reduce(44613)
```
If you need to reduce the data from many runs, this can be done with a python for loop, specifying the run numbers as a list or a range, e.g.

```python
# import mantid algorithms, numpy and matplotlib
from mantid.simpleapi import *
import matplotlib.pyplot as plt
import numpy as np
import snapwrap.utils as wrap

runs = [44613,64431,64437]
for run in runs:
    wrap.reduce(run)
```
Note, it is perfectly fine if the run numbers correspond to different instrument configurations: the underlying SNAPRed framework will automatically load the correct calibration and reduction parameters.

### Inspecting the reduced data

Each time `wrap.reduce()` is run, the output is a set of at least 3 mantid workspaces that contain the reduced data according to the 3 default pixel grouping schemes. The names of these workspaces act as keys to understand their contents. e.g. reducing run 59056 will create the following workspaces in the mantid workbench workspace tree

```
reduced_dsp_all_059056_2025-06-11T150755
reduced_dsp_bank_059056_2025-06-11T150755
reduced_dsp_column_059056_2025-06-11T150755
```
Here `reduced_` is a flag indicating that data have been reduced. `dsp` indicates that the x-unit of the data is in d-Spacing  (alternately, this could be `qsp` if an x-unit of momentum transfer was requested). `all`, `bank` and `column` correspond to the pixel grouping schemes and the final part of the name is a time stamp: `2025-06-11T150755` = June 11th 2025 at 3:07:55pm.

The mantid workbench workspace tree has a filter option. Typing, for example `bank` into this will only show workspaces with the name bank in them. This can help keep the tree tidy if you have a lot of workspaces. `snapwrap` also has a "file" function that will move unneeded workspaces to a "filecabinet" (a mantid workspace group), this can also help keep the tree tidy.

### Exporting the data

Frequently, users will want to export their data for further analysis (e.g. using GSAS-II to do a Rietveld refinement) this is supported with the `wrap.exportData()` method. By default, this will export data in formats suitable for use with GSAS-II, TOPAS, Fullprof and as plain (tab-delineated) ascii. 

Another commonly used function is `wrap.resample()` this allows easy control of data binning. The underlying binning used by SNAPRed is chosen to ensure ~10 histogram bins across the Full Width at Half Maximum (FWHM) of the standard Nist 640D Silicon standard used during calibration. Thus, it is matched to the intrinsic resolution of the instrument. This binning will be maintained in any output reduced spectrum regardless of instrument configuration and regardless of pixel grouping scheme used. 

However, commonly, internal strain in the sample, or pressure gradients cause the sample peaks to significantly broaden beyond the instrument resolution. `resample` allows consistent rebinning across the entire set of reduced data by specifying a single number to scale the native binning. Thus `wrap.resample(0.5)` will reduce the binning to 5 histogram bins across the FWHM of the silicon sample. This can be adjusted to appropriately match any sample. Around 10 bins across the sample FWHM should be the goal for data that will undergo Rietveld refinement.

In light of these considerations, we could extend our script above to:

```python
# import mantid algorithms, numpy and matplotlib
from mantid.simpleapi import *
import matplotlib.pyplot as plt
import numpy as np
import snapwrap.utils as wrap

runs = [44613,64431,64437]

for run in runs:
    wrap.reduce(run)
    wrap.resample(0.5)
    wrap.exportData(prefix="resampled_dsp")
```
This will reduce all requested runs, resample the binning of the reduced data to an appropriate level and then output all four supported formats for subsequent analysis

### Advanced usage

The above examples just show the most basic functionality of `SNAPRed` and `snapwrap`. In particular the `reduce`, `exportData` and `resample` methods all have customisable parameters that can be adjusted as needed. There are also many more advanced functions to support other data reduction needs. A common example of advanced usage is allowing the necessary corrections for pressure cells that are ubiquitous in most SNAP measurements.  

What follows are detailed descriptions of the majority of functions available in the snapwrap package which, in addition to `utils` has  other main modules: 

| module | Description |
|--------|-------------|
| utils  | Most common tools needed for reducing data, including the main function `reduce` |
|maskUtils| Functions supporting masking needs for different pressure cells, including pixel masks and bin masks|
|io | Supports input and output needs, such as exporting data|
|snapStateMgr| Tools using SNAPRed to enable easy management of multiple instrument configurations|

### The following lists individual functions of the four modules 

```{tableofcontents}
```
