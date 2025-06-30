PD Software Tests
===

Here we are posting the powder diffraction manual tests that we have been performing to make sure the data processing software is producing consistent result as the updating of the underlying software and architecture.

## June-2025

### POWGEN

> Testing date: 06/30/2025

> Tested version: Mantid (`6.12.0`) $\Leftrightarrow$ Mantid (`6.12.20250624.0926`)

> Tested items: Auto reduction (`IPTS-36029, run number: 60456`), manual reduction (with the configuration file located at `/SNS/PG3/IPTS-36029/shared/autoreduce/caching/snspowderreduction.xml` on ORNL Analysis)

|                         | Status | Notes                                                        |
|-------------------------|--------|--------------------------------------------------------------|
| AutoRed - Manual        | <a style="color:green">&#x2714;</a>       | Manually run the auto reduction locally                      |
| ManualRed - w/ AbsCorr  | <a style="color:green">&#x2714;</a>       | See the XML file mentioned above                                |
| ManualRed - w/o AbsCorr | <a style="color:green">&#x2714;</a>       | Load in the XML mentioned above and disable AbsCorr             |
| Calibration             | N/A    | POWGEN pins an earlier version of Mantid for calibration |

### NOMAD

> Testing date: 06/30/2025

> Tested version: Mantid (`6.10.0.1`) $\Leftrightarrow$ Mantid (`6.12.20250624.0926`)

> Tested items: Auto reduction (`IPTS-32855, run number: 203287`), manual reduction (with the input file located at `/SNS/NOM/IPTS-32855/shared/autoreduce/single_bank/Input` on ORNL Analysis)

|                         | Status | Notes                                                        |
|-------------------------|--------|--------------------------------------------------------------|
| AutoRed - Manual        | <a style="color:green">&#x2714;</a>       | Manually run the auto reduction locally                      |
| ManualRed - w/ Caching  | <a style="color:green">&#x2714;</a>       | See the mentioned XML file above. Run with `mts`                                |
| ManualRed - w/o Caching | <a style="color:green">&#x2714;</a>       | Load in the XML mentioned above and add in the `"ReCaching": true` entry. Run with `mts`          |
| Calibration             | <a style="color:green">&#x2714;</a>       | - |

### HB-2A (POWDER)

> Testing date: 06/30/2025

> Tested version: Tested version: Mantid (`6.12.0`) $\Leftrightarrow$ Mantid (`6.12.20250624.0926`)

> Tested items: Auto reduction (`IPTS-33944, run number: HB2A_exp1043_scan0063`), manual reduction (see the input [here](../files/HB2A_ManRed_Test.png))

|                         | Status | Notes                                                        |
|-------------------------|--------|--------------------------------------------------------------|
| AutoRed - Manual        | <a style="color:green">&#x2714;</a>       | Manually run the auto reduction locally                      |
| ManualRed               | <a style="color:green">&#x2714;</a>       | Launch Mantid Workbench and refer to the inputs above        |

### HB-2C (WAND$^2$)

> Testing date: 06/30/2025

> Tested version: Tested version: Mantid (`6.12.0`) $\Leftrightarrow$ Mantid (`6.12.20250624.0926`)

> Tested items: Auto reduction (`IPTS-34142, run number: 1606639`), manual reduction (use the script located at `/HFIR/HB2C/shared/WANDscripts/pd_testing/HB2C_filter_parallel_06302025.py` on ORNL Analysis)

|                         | Status | Notes                                                        |
|-------------------------|--------|--------------------------------------------------------------|
| AutoRed - Manual        | <a style="color:green">&#x2714;</a>       | Manually run the auto reduction locally                      |
| ManualRed               | <a style="color:green">&#x2714;</a>       | Run the script mentioned above with `mantidpython` and `mantidpythonnightly`        |