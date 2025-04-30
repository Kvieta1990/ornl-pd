Local Developing & Testing Setups
===

## Mantid

Instructions for building `Mantid` locally can be found [here](https://developer.mantidproject.org/GettingStarted/GettingStarted.html) and here I am only noting down the steps on ORNL Analysis cluster that runs Red Hat 9.

- Create the conda environment, by running,

    ```bash
    mamba create -n mantid-developer mantid/label/nightly::mantid-developer
    ```

    > Here, we may need to change the default name `mantid-developer` of the conda environment to something else in case to deal with different versions of `Mantid` since the package dependencies for different versions of `Mantid` may vary.

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