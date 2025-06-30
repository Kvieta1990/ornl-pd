# `indexStates`

## Overview

This is a simple utility that reports all available states (those that have been instantiated) and their current calibration status. 

typical usage is: 

```python 
import snapwrap.utils as wrap

snapwrap.indexStates()
```
which gives output that looks like: 
```
 StateID        | Desc.                   | Status  |No. difcals| latest |No. nrmcals| latest |
b358bc9ca6f9f3de| -65.5: 105.0: 3.0: 30: 1| UNCALIB |     0     |        |     0     |        |
d1946b4615db2d4e| -50.0:  90.0: 6.4: 60: 2| UNCALIB |     0     |        |     0     |        |
b810d6da5d4af06e| -65.5: 105.0: 1.8: 60: 1| PARTIAL |     0     |        |     2     |  64417 |
ffefaa93ccb23678| -65.5: 105.0: 2.1: 60: 2| PARTIAL |     0     |        |     1     |  64459 |
685b9dc2fd699205| -65.5:  90.0: 6.4: 60: 1| PARTIAL |     0     |        |     1     |  64446 |
0e04feff89cf95f3| -90.0:  66.0: 6.4: 60: 1| PARTIAL |     0     |        |     1     |  64439 |
c073719d9101e8f2| -65.5: 105.0: 6.4: 60: 1| PARTIAL |     0     |        |     1     |  64415 |
17fcca13ece67241| -50.0:  90.0: 6.4: 60: 1| PARTIAL |     0     |        |     1     |  64422 |
74370ebaa23119db| -65.5:  90.0: 2.1: 60: 1| *CALIB* |     1     |  64444 |     1     |  64443 |
702ba297516db7bf| -50.0: 105.0: 6.4: 60: 1| *CALIB* |     8     |  64433 |     3     |  64433 |
e1d38f0788481997| -76.0: 105.0: 2.1: 60: 1| *CALIB* |     3     |  63438 |     3     |  63436 |
04bd2c53f6bf6754| -65.5: 105.0: 2.1: 60: 1| *CALIB* |     1     |  64413 |     1     |  64412 |
27588df26158e93c| -50.0: 105.0: 2.1: 60: 1| *CALIB* |     3     |  64431 |     1     |  64430 |
3c7b8c841d10a16b| -90.0:  66.0: 2.1: 60: 1| *CALIB* |     1     |  64437 |     1     |  64436 |
ce8a5e1e29a1de97| -50.0:  90.0: 2.1: 60: 1| *CALIB* |     1     |  64420 |     1     |  64419 |
```


## Optional arguments

### `isLite`

The only optional parameter is `isLite`, which defaults to True. If you set false, it will query calibration.home for any calibrated native states