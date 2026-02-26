# Powder Diffraction at ORNL

## Notes

1. To build the book, we first need to have `jupyter-book` installed, for which the following steps can be followed (using `conda` or `mamba`),

    ```bash
    mamba create -n jbook python=3.10
    mamba activate jbook
    mamba install conda-forge::jupyter-book
    ```

    Then suppose we are located in the main repository of the book (where we see the current `README` file), we can run the following command to build the book,

    ```bash
    jupyter-book build doc
    ```

    Then we can push all the changes to the remote repository -- a script on the deployment side will take care of looking for the compiled website and do the right thing to deploy the website. Basically, there is an `nginx` service running on the server and we just need to copy all the compiled website files for the book over to the location where `nginx` will be looking for hosting the website. The `update.sh` script in the current repository will be taking care of such an operation specifically on the server where the powder diffraction document website is hosted (on one of the ORNL research cloud instances that [Yuanpeng](https://www.ornl.gov/staff-profile/yuanpeng-zhang) has.)

2. When trying to make a file downloadable within Jupyterbook, we can put the file under, e.g., the `files` directory under `doc` and copy over the whole `files` directory to the main HTML directory on the server. Then within the book body, `<a href="relative/path/to/file/under/files/" target="_blank" download>download me</a>` can be used. However, it was found when having capital characters in the file name, the downloadable link won't work.