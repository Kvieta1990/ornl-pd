PD Software Tests
===

Here we are posting the powder diffraction manual tests that we have been performing to make sure the data processing software is producing consistent result as the updating of the underlying software and architecture.

## Aug-2025

NOMAD
===

Testing Date: 08/26/2025

Tested Routines: AutoRed, LiveRed & some utils

- [x] LiveRed

    > Configured on `bl1b-analysis2.sns.gov`

    > `CONDA_ENV = 'mantid-dev'` is given in the livereduction script to select the version of Mantid to use.

    Items checked,

     - `systemctl --user status livereduce_zyp.service`

     - Check log file at `/SNS/NOM/shared/log_files/livereduce.log` if any errors.

     - Check the live reduction cache file.

- [x] AutoCalib

    > Embedded in the `autoreduction` workflow, creating the input file for running calibration.

    >  A monitor service is configured on `bl1b-analysis2.sns.gov` to detect any changes for the calibration file (`/SNS/NOM/shared/CALIBRATION/cal_config.json`). If changes detected, calibration will be started.

    Items Checked,

     - Slack message sent.

     - Calibration file under `/SNS/NOM/shared/autoreduce/calibration`.

- [x] Absorption pre-calculation

    > The `abs_pre_calc` routine

    > Local MTS virtual environment is used, `/SNS/NOM/shared/Dev/mantid_total_scattering`.

    > See the bottom of the script `/SNS/software/bin/abs_pre_calc`.

    Items Checked,

     - Run the routine interactively.

     - Check the absorption cache file at `/SNS/NOM/shared/autoreduce/abs_ms_alt`.

- [x] AutoRed

    > Dummy sample information auto populated

    > When error occurs, Slack message is sent to the `nomad-monitor` channel in the `ORNL Neutron Sciences` workspace.

    Items checked,

     - Run on monitor

     - Check monitor plots

     - Check IPTS autoreduce directory

- [x] MantidTotalScattering

    Items Checked,

     - Run the routine interactively.

- [x] pystog_cli

    Items Checked,

     - Run the routine interactively.

- [x] ADDIE

    Items Checked,

     - addie

     - addie --qa

     - addie --dev

     - addie_nom

POWGEN
===

Testing Date: 08/26/2025

Tested Routines: AutoRed, LiveRed & some utils

- [x] AutoRed

    Checked Items,

     - Monitor, e.g., errors?

     - Check monitor plots

- [x] Calibration

    > Embedded in the `autoreduction` workflow, creating the input file for running calibration.

    >  A monitor service is configured on `bl11a-analysis2.sns.gov` to detect any changes for the calibration file (`/SNS/PG3/shared/CALIBRATION/cal_config.json`). If changes detected, calibration will be started.

    Checked Items,

     - Calibration file under `/SNS/PG3/shared/CALIBRATION`

- [x] LiveRed

    > A monitor is configured on

    > Cronjob configured on `bl11a-livereduce.sns.gov` to monitor failures. If error occurs, Slack message is sent to the `powgen-monitor` channel in the `ORNL Neutron Sciences` workspace and the LiveRed service will be restarted.

    Checked Items,

     - Check monitor plots


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