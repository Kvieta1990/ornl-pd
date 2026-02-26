PD Software Maintenance
===

Most of the powder diffraction utilities and relevant configuration are stored in the following directory on ORNL Analysis,

```
/SNS/NOM/shared/Dev
```

Directories involved there are mainly under version control and there is a utility there `check_status` to check the status of all directories under version control. In case any updates are available in directories, we can `cd` into the directory and commit those changes to the remote repository so history of development and updates can be kept in a trackable way. Below is listed some special respositories to pay attention to for maintenance and running purposes,

- `mantid`. This is the repository for the purpose of serving a local version of Mantid framework, which is associated with the `mantidl` command on Analysis. The purpose is to get access to some quick fix or feature implementation before the codes are merged into the central Mantid repository and deployed. This should not be taken as the development repository -- local development should be tested somewhere else before being transferred to this directory.

- `mantid_dev`. This is the local development directory for Mantid. We can code here, do testing, debugging, etc. without impacting running routines.

- `mantid_v6p8p0`. This is the legacy Mantid version `6.8.0` for POWGEN calibration file generation. `DON'T TOUCH THIS FOLDER UNTIL WE HAVE RELIABLE CALIBRATION OUTPUT FROM THE UP-TO-DATE MANTID VERSION.`.

- `mantid_total_scattering`. Similar to the `mantid` directory, this is for hosting the local version of MantidTotalScattering running on Analysis, associated with the command `mts` on Analysis. Again, this repository should not be taken as the active development repository. Only codes after local testing in other places are supposed to be transferred here.

    > The `mts` command relies on `mantid_total_scattering` and `mantid` directories.

- `mts_dev`. This is the local development directory for MantidTotalScattering.

- `pd_tools`. This is the location for hosting quite a few useful powder diffraction utilities that can be run across the system on Analysis. Editing and all `git` operations are possible only on the `bl100-analysis1.sns.gov` machine.

- `services`. This is the folder for hosting user-level services running under [Yuanpeng](https://www.ornl.gov/staff-profile/yuanpeng-zhang)'s account.

- `services_utils`. This is the folder for hosting some useful utilities regarding the user-level services running under [Yuanpeng](https://www.ornl.gov/staff-profile/yuanpeng-zhang)'s account.