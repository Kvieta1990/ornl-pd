# Powder Diffraction at ORNL

## Notes

1. When trying to make a file downloadable within Jupyterbook, we can put the file under, e.g., the `files` directory under `doc` and copy over the whole `files` directory to the main HTML directory on the server. Then within the book body, `<a href="relative/path/to/file/under/files/" target="_blank" download>download me</a>` can be used. However, it was found when having capital characters in the file name, the downloadable link won't work.