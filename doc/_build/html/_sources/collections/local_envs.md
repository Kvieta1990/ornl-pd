Local Dev & Test Setups
===

## Mantid

> On ORNL Analysis, there are three versions of `Mantid` available for both the Workbench and the Python interface,

| Command                | Version Info                   |
|------------------------|--------------------------------|
| mantidworkbench        | Production version             |
| mantidworkbenchqa      | QA version for testing         |
| mantidworkbenchnightly | Nightly version for developing |
| mantidpython           | Production version             |
| mantidpythonqa         | QA version for testing         |
| mantidpythonnightly    | Nightly version for developing |

Instructions for building `Mantid` locally can be found [here](https://developer.mantidproject.org/GettingStarted/GettingStarted.html) and here I am only noting down the steps on ORNL Analysis cluster that runs Red Hat 9.

- Create the conda environment, by running,

    ```bash
    mamba create -n mantid-developer mantid/label/nightly::mantid-developer
    ```

    > Here, we may need to change the default name `mantid-developer` of the conda environment to something else in case to deal with different versions of `Mantid` since the package dependencies for different versions of `Mantid` may vary.

    > Sometimes, when a new conda environment is created and activated, launching a previous `Mantid` build would fail, either due to some packages are missing or some incompatible configurations. In this case, one has to remove the `build` directory and run the `cmake` and `ninja` steps again -- see instructions below.

- Assuming the default conda environment name `mantid-developer` is being used, activate the environment by,

    ```bash
    mamba activate mantid-developer
    ```

- With the `mantid-developer` environment, if we want to always keep up with the latest development of `Mantid` (say, with the `main` branch), we may need to do the following update for the conda environment to keep consistent,

    ```
    mamba update -c mantid/label/nightly --all
    ```

- Check out `Mantid` source code and change into the directory,

    ```bash
    git clone https://github.com/mantidproject/mantid.git
    cd mantid
    ```

- Configure the build environment,

    ```bash
    cmake --preset=linux
    ```

    which will create a `build` directory under `mantid`.

- Navigate into the `build` directory and compile the program,

    ```bash
    cd build
    ninja
    ```

- Launch the local version of the `Mantid` Workbench, assuming we are still located in the `build` directory,

    ```bash
    ./bin/launch_mantidworkbench.sh
    ```

    > On ORNL Analysis cluster, there exists a local build of `Mantid` under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang). The source codes are stored at `/SNS/users/y8z/NOM_Shared/Dev/mantid`, and `Mantid` Workbench can be launched by the command `mantidl`, pointing to this local version of `Mantid` build.

- There is no direct entry point to launch the Python interface with a local `Mantid` build. One has to run the `AddPythonPath.py` script under `<Mantid_Dir>/build/bin/` with a certain version of Python -- see, e.g., the instructions below for local build of `MantidTotalScattering`.

## MantidTotalScattering

> On ORNL Analysis, there are three versions of `MantidTotalScattering` available,

| Command                     | Version Info                   |
|-----------------------------|--------------------------------|
| `mantidtotalscattering`       | Production version             |
| `mantidtotalscattering --qa`  | QA version for testing         |
| `mantidtotalscattering --dev` | Nightly version for developing |

In the source codes repository on GitHub (see [here](https://github.com/neutrons/mantid_total_scattering)), it was detailed several options for the local development for MantidTotalScattering (MTS). Here I am noting down the one that is most commonly used. Following the instructions above for the local build of `Mantid`, we should already have the `mantid-developer` conda environment ready and get `Mantid` built locally, and here I am assuming we are using the default name of the environment, namely, `mantid-developer`.

```bash
git clone https://github.com/neutrons/mantid_total_scattering.git
cd <MTS-repo-loc>
virtualenv -p <mantid-developer-env-loc>/bin/python --system-site-packages .venv
source .venv/bin/activate
python <mantid-repo-loc>/build/bin/AddPythonPath.py
pip install -r requirements.txt -r requirements-dev.txt
python setup.py develop
```

where `<MTS-repo-loc>` should be replaced with the path to the MTS source codes repository. `<mantid-developer-env-loc>` refers to the location of the `mantid-developer` environment, which can be obtained via `conda env list`. `<mantid-repo-loc>` is the path to the `Mantid` source codes repository.

After the setup steps, MTS can be started by running `mantidtotalscattering <input_json_file>`. One can refer to the documentation [here](https://powder.ornl.gov/total_scattering/data_reduction/mts_doc.html) for details about the input JSON file for MTS.

Here follows is a `bash` script that is deployed on ORNL Analysis to quickly launch the local build of MTS,

```bash
#!/bin/bash

source /gpfs/neutronsfs/instruments/NOM/shared/Dev/mantid_total_scattering/.venv/bin/activate
python /gpfs/neutronsfs/instruments/NOM/shared/Dev/mantid/build/bin/AddPythonPath.py > /dev/null 2>&1

cwd=${PWD}

cd /gpfs/neutronsfs/instruments/NOM/shared/Dev/mantid_total_scattering/
python setup_local.py develop

cd ${cwd}

mantidtotalscattering $1
```

The script is saved as `/SNS/software/powder/mts` on Analysis and a soft link for it is created at `/SNS/software/bin/mts` to make `mts` system-wise available to all users.

> `setup_local.py` script above is an alternative version of `setup.py` in the respository. With `setup_local.py`, the terminal output associated with the script running will be suppressed.

## ADDIE

> On ORNL Analysis, there are three versions of `ADDIE` available,

| Command     | Version Info                   |
|-------------|--------------------------------|
| `addie`       | Production version             |
| `addie --qa`  | QA version for testing         |
| `addie --dev` | Nightly version for developing |

The source codes for ADDIE are hosted on GitHub [here](https://github.com/neutrons/addie). To develop locally, first check out the repository,

```bash
git clone https://github.com/neutrons/addie.git
cd addie
```

Then the local development environment can be set up as below,

```bash
conda env create --file environment.yml
conda activate addie
pip install -e .
```

The name of the conda environment to be created is defined in the `environment.yml` file, which is defaulted to `addie`. If there is already an existing environment named `addie`, one can temporarily change the name in `environment.yml` to something else like `addie_new` before running the commands above. After running the commands above, ADDIE can be launched via,

```bash
python addie/main.py
```

assuming one is still located within the ADDIE repo directory (`addie` is a sub-directory under the main repo directory). Or, simply run,

```bash
addie
```

On Analysis, a wrapper `bash` script was created,

```bash
#!/bin/bash

. /opt/anaconda/etc/profile.d/conda.sh

conda activate /SNS/users/y8z/miniconda/envs/addie

if [[ "$@" =~ "--mode=mantid" ]]; then
    python /SNS/users/y8z/NOM_Shared/Dev/addie/addie/main.py --mode=mantid
else
    python /SNS/users/y8z/NOM_Shared/Dev/addie/addie/main.py --mode=idl
fi

conda deactivate
```

and saved as `/SNS/software/powder/addie_nom` and a soft link was created for it, at `/SNS/software/bin/addie_nom` to make it system-wise available to general users.

## PyStoG

The source codes of `PyStoG` are stored on GitHub [here](https://github.com/neutrons/pystog.git). To develop locally, first check out the codes,

```bash
git clone https://github.com/neutrons/pystog.git
```

There is no special setups needed for running `PyStog` locally. The local modules can be imported as such (in Python),

```python
import sys
sys.path.append("<pystog_repo_loc>/src")
import pystog
from pystog import Converter
from pystog import Transformer
from pystog import FourierFilter
from pystog import StoG
```

where `<pystog_repo_loc>` should be replaced with the full path to the `PyStoG` repository. On Analysis, there is a local conda environment for `PyStoG` under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang), at,

```
/SNS/users/y8z/miniconda/envs/pystog/
```

which has `PyStoG` installed. For the installation, it is straightforward, by running,

```bash
conda create -n pystog
conda activate pystog
conda install -c neutrons pystog
```

If the name `pystog` has already been taken, just change it to something else, like `pystog_new`. On Analysis, a wrapper `Python` script was created to call the CLI (command-line interface) of `PyStoG`, using the local environment mentioned above,

```python
#!/SNS/users/y8z/miniconda/envs/pystog/bin/python3.12
# -*- coding: utf-8 -*-
import re
import sys
from pystog.cli import pystog_cli
if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw|\.exe)?$', '', sys.argv[0])
    sys.exit(pystog_cli())
```

It is saved as `/SNS/software/powder/pystog_cli` and a soft link was created for it, at `/SNS/software/bin/pystog_cli` to make it system-wise available to general users.

## GSAS-II

GSAS-II is an open source program for performing scattering data analysis. The source codes are now hosted on GitHub (repo is [here](https://github.com/AdvancedPhotonSource/GSAS-II)) and are open for the community to make contributions.

> As of writing (May-01-2025), the new `main` branch has become the main developing branch and the original main branch `master` has retired.

Notes for developers are well documented and here below are listed several useful resources concerning the local development of GSAS-II,

- [GSAS-II Home Page](https://advancedphotonsource.github.io/GSAS-II-tutorials/index.html)

- [Notes for GSAS-II developers](https://advancedphotonsource.github.io/GSAS-II-tutorials/developers.html)

- [Installing GSAS-II for code development](https://advancedphotonsource.github.io/GSAS-II-tutorials/install_dev.html)

- [Local Development of GSAS-II with VSCode](https://iris2020.net/2025-04-21-gsasii_dev_new/)

On ORNL Analysis, a wrapper `bash` script is available for general users to test out the latest development of GSAS-II. The script wraps up all setup steps, including the conda environment creation, fetching GSAS-II source codes and the program launching. In the old days, those binary files necessary for GSAS-II running need to be downloaded into a specific location for GSAS-II to work. However, with the new `main` branch, GSAS-II can figure out those binaries automatically. So, although the wrapper script still downloads those binaries, they are not taking any real effect. The script is fetching the source codes from a forked repository under the name of [Dr. Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) at, [https://github.com/Kvieta1990/GSAS-II/tree/main](https://github.com/Kvieta1990/GSAS-II/tree/main). One can download the script [here](../files/gsasii_manual_test/G2full_Linux64.sh) for checking.

As a general user, one does not need to worry about the technical details above. On Analysis, one can simply execute,

```bash
test_gsas2
```

to fire up the test version of GSAS-II locally on Analysis. `test_gsas2` is another wrapper script that download the wrapper script mentioned above (hosted [here](https://powder.ornl.gov/files/gsasii_manual_test/G2full_Linux64.sh)) to locally and execute it. On Analysis, `test_gsas2` was saved as `/SNS/software/powder/test_gsas2` and a soft link was created at `/SNS/software/bin/test_gsas2` to make it system-wise available to general users.