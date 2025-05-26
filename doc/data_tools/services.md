System Services
===

For data tools that need to be running in the background, it is convenient to set up system services for them which can be managed in a very handy manner. The services running system-wise need admin access, e.g., with `sudo` and only a subset of people have access to manage such services. As an alternative, user-level services can be set up to run some data jobs. Here, I am noting down several services that are set up locally under the Analysis account of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang).

## NOMAD Live Reduction Service

Detailed setup instructions for running the NOMAD livereduction can be found [here](https://iris2020.net/2025-04-21-mantid_livered/). Currently, the service is set up under the local acount of `y8z` (the UCAMS of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang)). If needed, the same setup of service can be promoted to the system level. With the user-level service setup, it can be managed via,

```bash
# Reload daemon configuration
systemctl --user daemon-reload

# Start service
systemctl --user start livereduce_zyp

# Stop service
systemctl --user stop livereduce_zyp

# Restart service
systemctl --user restart livereduce_zyp

# Enable service (auto-start)
systemctl --user enable livereduce_zyp

# Disable service
systemctl --user disable livereduce_zyp

# Check service status
systemctl --user status livereduce_zyp

# View service logs
journalctl --user -u livereduce_zyp -f

# Check the log file directly
tail -F /SNS/NOM/shared/log_files/livereduce.log

# List all user services
systemctl --user list-units --type=service
```

## NOMAD Calibration Service

For NOMAD calibration file generation, it was previously incorporated into the autoreduction workflow -- anytime when a diamond calibration run is detected (based on the criterion of sample composition and run title), the calibration will be performed with the detected diamond calibration run. In the backend, the routine `nom_cal` would be running -- see the instructions [here](https://powder.ornl.gov/data_tools/nomad.html#nom-cal). However, with the ever increasing neutron flux, the diamond calibration run would yield larger and larger file size which would take more and more memory for processing. With the recent upgrade of the autoreducers, they won't allow heavy memory demanding processes -- once high memory usage is detected for certain processes, they will be killed automatically. This will break the automatic calibration running pipeline. TO get around with this, the following workflow is set up,

- Autoreduction detects the diamond calibration run and creates the input json file for running the calibration.

- A system service is set up to monitor the calibration configuration file with the Python `watchdog` module.

    - The user-level (again, under `y8z`, the UCAMS of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang)) service configuration file is pasted below,

        ```bash
        [Unit]
        Description=NOMAD calibration monitor service
        After=default.target

        [Service]
        WorkingDirectory=/SNS/users/y8z/Utilities/nom_live
        ExecStart=/SNS/users/y8z/Utilities/nom_calib/nom_calib_mon.py /SNS/users/y8z/NOM_Shared/CALIBRATION/cal_config.json
        Restart=always
        RestartSec=10

        [Install]
        WantedBy=default.target
        ```

        > Refer to the instruction [here](https://iris2020.net/2025-04-21-mantid_livered/) for setting up the local service for detailed information about where to put the file and how to set up the service.

    - The main monitor script `nom_calib_mon.py`, the wrapper script for running the calibration, together with several helper scripts can be found in the GitLab repo [here](https://code.ornl.gov/y8z/nom_calib_mon).

        > For security purpose, the repo is made private. To get access, get in touch with [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang).

- Once changes are detected for the calibration configuration file, start the calibration process, followed by generating the diagnostics plots.

- If the calibration file already exists, skip the calibration over to generate the diagnostics plots.

The service can be managed as follows,

```bash
# Reload daemon configuration
systemctl --user daemon-reload

# Start service
systemctl --user start nom_calib_mon

# Stop service
systemctl --user stop nom_calib_mon

# Restart service
systemctl --user restart nom_calib_mon

# Enable service (auto-start)
systemctl --user enable nom_calib_mon

# Disable service
systemctl --user disable nom_calib_mon

# Check service status
systemctl --user status nom_calib_mon

# View service logs
journalctl --user -u nom_calib_mon -f

# Check the log file directly
tail -F /SNS/NOM/shared/log_files/nom_calib_mon.log

# List all user services
systemctl --user list-units --type=service
```