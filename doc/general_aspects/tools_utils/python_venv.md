Python & Virtual Environment
===

## Introduction

### Python versions and Virtual environment

These days, Python is probably the most popular programming language -- as a researcher, we want to be rigorous so let's keep the word 'probably' here. In fact, according to the programming language ranking from multiple resources, Python is indeed #1 in terms of the popularity, e.g., the one by `TIOBE Index` {cite}`tiobe_2024_tiobe` and `IEEE Spectrum` {cite}`cass_2024_the`. We love Python because it is easy to learn and use. Meanwhile, we have a large Python community supporting the development, package sharing and Q&A. Together with its popularity and large community support comes enormous tools (which then unavoidably comes with a lot of jargons). One side, this is definitely a good thing since we have a lot of tools to turn to, but the down side is also obvious -- we have too many to choose from. As a non-programmer, quite often we found ourselves not even knowing what those tools are for -- the only thing, we, as researchers, care about is probably just that we have a Python script and when we do `python my_script.py`, it gives me a meaningful output following the physics we put into the script, and that's it. So, why should we care about those tools and jargons? Yes, that is true -- we really don't need to care about those annoying stuff, until we have to. Why? Well, there are several obvious reasons that immediately pop up,

- The language is actively progressing. Developers are working on adding in more functionalities, making it easier to use, and probably faster to run. Meanwhile, we are also progressing. The requirement for features in the language on our side as users will also change from time to time, or from here to there. Therefore, quite often we would find that some useful features that we need are only available in a certain version of Python but meanwhile some other features that we also need at some point are only available in another version of Python. In this case, what do we do?

- Sometimes, even the feature requirement does not change, there will be factors that may force us to make changes. One typical reason is `security`. For example, Python `2.0` was first released in `2000` and finally came to its end of life in `2020`. People have been using it for a long time but as it is coming to its end of life, no support will be provided by the community and therefore vulnerabilty will never be patched, which will bring in serious security concerns if we keep using it. In this case, there is nothing we can do but to switch to a higher version of Python. Then at the transition stage, say, we still need some features in Python `2.0` for some of our daily routines while being forced to switched to Python `3.x`, what do we do?

- The Python community is providing us with a lot of modules (e.g., `matplotlib` for plotting, `numpy` and `scipy` for scientific calculations) as building blocks so that we don't need to always reinvent the wheel. Again, the language itself is progressing, the modules themselves are also progressing, which naturally brings in the version compatability issue. If we need the feature available in `numpy` version `x.y.z` which is only compatible with Python version `<=i.j.k` but we also need the feature available in `numpy` version `p.q.s` which is only compatible with Python version `>=l.m.n`. Then, what do we do?

To deal with such complex scenarios, the `virtual environment` comes to rescue. It basically puts a certain version of Python and all the compatible dependencies in a `self-contained` environment and we can have multiple such environments that are independent from each other so they are not interfering each other. Probably, we all know the `conda environment` with this regard. We all know it because it is probably the most popular one, among all the alternatives. In fact, for many people, `conda environment` would be used interchangeably with `virtual environment`. Anyhow, it is an `environment` and who cares whether it is `donda environment`, `fonda environment`, or `whatever environment`... Yes, that is true and indeed we don't care, until we have to.

### Tools for virtual environment management

Concerning the `virtual environment`, we have multiple alterntive tools to set up such self-contained `virtual environments`. Typical examples are [`virtualenv`](https://virtualenv.pypa.io/en/latest/), [`mamba`](https://github.com/mamba-org/mamba), [`pixi`](https://pixi.sh/latest/), [`peotry`](https://python-poetry.org/) and [`uv`](https://github.com/astral-sh/uv). Maybe there are more, but those are what I am aware of. `conda` is one of those tools and it is a bit special and is worth some special notes here. We have two different `conda`'s -- one is the `conda` from the `Anaconda` company and the other is the `conda` from the [`conda-forge`](https://conda-forge.org/) community. It is something associated with the `Anaconda` version of `conda` that is becoming non-free now (though, it is not the `conda` tool that is becoming non-free, as we will see later), but the `conda-forge` community version of `conda` is still all free. In terms of the usage, the two versions of `condas` do not really make any differences. The `conda` commands that we execute on a daily base are basically the same between the two versions. Another tool to specially mention is `mamba` -- it is also coming from `conda-forge` and works very much like `conda`. For many typical commands we were executing before with `conda`, like `conda env list`, `conda activate`, etc., we only need to replace `conda` with `mamba`.

### Packages

It is actually not true that the `Anaconda` and `conda-forge` version of `conda` is all the same. The major difference is on the channel to pull the `conda packages` from. Here, we come across with the terminology of `conda package`. Literally, it means a package -- developers implement some modules for certain purposes, like `numpy` for scientific calculation, and they package the module up in a certain way and host it somewhere on the cloud so that users can install on their machines. `conda` is one of the ways for packaging up modules and again, it is probably the most popular one. For `conda packages`, they are hosted in the cloud in `channels` which is just like a big pool of `conda packages`. When uploading or downloading `conda packages`, we need to specify the `channel` to push into or pull from. If no `channel` is specified for the uploading or downloading, thta means we have some default `channel` being used there. If we are using the `Anaconda` version of `conda`, the default channel is just called `defaults`. If the `conda-forge` version of `conda` is used, the default channel is `conda-forge`. Now, we are ready to mention that it is those packages included in the `defaults` channel maintained by `Anaconda` that becomes non-free. This means,

- If `conda packages` are installed from channels other than the `defaults` channel maintained by `Anaconda`, they can be used, for free, and the `Anaconda` version of the `conda` tool can still be used, for free, since the `conda` tool itself is still free.

- If `conda packages` are installed from the `defaults` channel maintained by `Anaconda`, they `cannot` be used for free, for organizations with 200 or more people.

Apart from `conda packages`, there are other ways to package up Python modules to be released for people to downloand and install. Another typical type of packaging is through the [`The Python Package Index (PyPI)`](https://pypi.org/) and the tool associated with the package installation is also very popular, namely `pip`. One thing to note is, `pip` is only a package installation tool but `not` a virtual environment management tool. That means it does have as powerful compatability checking capability as those environment management tools, such as `conda`. Therefore, when using `pip` to install packages into a virtual environment, it is possible that packages with conflicting dependencies can be installed into the same environment, which then will break the environment due to the conflicts.

## Q & A

```{admonition} Q: What is 'conda'?
:class: hint

***A***: When we say `conda`, we may refer to,

- the `conda` tool for virtual environment management -- basically, it is just the `conda` command. As mentioned above, the `conda` tool carries two possible meanings,

    - the `conda` tool provided by `Anaconda`, which uses the `defaults` channel maintained by `Anaconda` as the default channel.

    - the `conda` tool provided by `conda-forge`, which uses the `conda-forge` channel maintained by the community as the default channel.

- the `conda` environment, i.e., the self-contained environment for Python and modules to live in, independently

- the `conda` package, i.e., the package like `numpy` that incorporates the modules to be used in our Python script regarding certain functionalities.
```

```{admonition} Q: How is the commercial to non-commercial switching for the virutal environment tools relevant to me?
:class: hint

***A***: It depends. Two scenarios here,

- On ORNL Analysis, many data reduction and analysis software are deployed with `conda environment` and the switching to non-commercial tools will have impacts on all of them. However, in this case, as general users of those software, we are not supposed to see any differences in our daily routines. For example, if we want to launch the `Mantid Workbench`, we still do `mantidworkbench`.

- If we want to set up virtual environments on our own, we need to take some actions -- details will be covered in the next question.
```

```{admonition} Q: What should I do regarding the commercial to non-commercial switching?
:class: hint

***A***: First, we need to make it clear that the `conda` tool itself is `free` and it is only the packages in the `defaults` channel maitained by `Anaconda` is `non-free`. So, no matter whether the `conda` tool was installed via `Anaconda` or `conda-forge`, the `conda` command can still be used without any problems. Action is potentially needed regarding those packages we previously installed via `conda`. For example, I have a `conda environment` called `my_env` and I was ever installing some packages through the `defaults` channel into the `my_env` environment, then I can no longer use those packages in the `my_env` environment. If it is just several packages that become non-usable, we can first execute `conda list --show-channel-urls` to see what packages were installed via the `defaults` channel and then use `conda remove the_package` to remove those packages. Otherwise, we need to remove the `my_env` environment, create a new one and reinstall those packages via the `conda-forge` channel or whatever other channels. It can be tedious if we reinstall all those packages one by one. The following steps could be followed as a quicker solution,

- Although the `conda` command installed via `Anaconda` is still free, I personally think it is better to uninstall it and install the `conda-forge` version of `conda`, the reason being that the `Anaconda` version of `conda` is using the `defaults` channel by default and it is highly possible then to hit the `non-free` zone if we are still using the `Anaconda` version of `conda` for virtual environments management and packages installation. To uninstall `conda`, refer to the instructions [here](https://www.anaconda.com/docs/getting-started/anaconda/uninstall).

- Install a new virtual environment management tool. The `conda-forge` version of `conda` is for sure a very good solution, since most of the `conda` commands that we used before will stay the same. For the installation, see [here](https://conda-forge.org/download/).

- Export the existing conda environment to a `YAML` file for later use for rebuilding the environment. Assuming the conda environment is called `my_env`, the export command will be,

    ```bash
    conda env export -n my_env > environment.yml
    ```

- Rebuild the environment using the new installed `conda` with the previously exported `YAML` file,

    ```bash
    conda env create -f environment.yml
    ```

- Another alternative environment too to choose is `mamba`, which is also provided by `conda-forge`. Installation instructions can be found [here](https://mamba.readthedocs.io/en/latest/installation/mamba-installation.html). The procedure for rebuilding conda environments will be the same as above, `except` that we need to replace `conda` with `mamba` in those commands.
```

```{admonition} Q: I heard of tools like 'pixi', etc. Should we worry about using them?
:class: hint

***A***: No, if you don't want to. Having the `conda-forge` version of `conda` or the `mamba` tool should be good enough for our needs. But if you do want to give it a try, check out their website [here](https://pixi.sh/latest/). Also, quite a few other options exist, including [poetry](https://python-poetry.org/) and [uv](https://github.com/astral-sh/uv).
```