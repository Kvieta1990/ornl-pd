Build Mantid Locally
===

Detailed documentation for Mantid developers regarding the local build on Linux (this is what we we focus on here) can be found [here](https://developer.mantidproject.org/GettingStarted/GettingStartedCondaLinux.html). In this doc, I am trying to note down the bare minimum set of procedures we need to go through, to build Mantid locally.

- First, we need to install `pixi`, which can be done by following the instructions [here](https://pixi.prefix.dev/latest/installation/).

- If not yet done, check out the Mantid source code,

    ```bash
    cd <somewhere>
    git clone https://github.com/mantidproject/mantid.git
    cd mantid
    ```

- Install dependencies for `pixi`,

    ```bash
    pixi install --frozen
    ```

- Build source codes,

    ```
    pixi run cmake --preset=linux
    cd build
    pixi run ninja
    ```

    > Possibly, we can replace `pixi run ninja` with `pixi run ninja -j 8` to run the compiling jobs in parallel to make it faster.

- Launch Mantid workbench

    - Located in the `build` directory, we can do
    
        ```bash
        pixi run ./bin/launch_mantidworkbench.sh
        ```

    - If out side the Mantid source codes repository, we can do,

        ```bash
        pixi run --manifest-path <full_path_to_mantid_source_repo> <full_path_to_mantid_source_repo>/build/bin/launch_mantidworkbench.sh
        ```

- To access the compiled Mantid libraries from another Python environment, we do,

    ```bash
    python <full_path_to_mantid_source_repo>/build/bin/AddPythonPath.py
    ```

    where `python` is whichever specific Python we want to run (and whichever one we want to give access to the compiled Mantid libraries).