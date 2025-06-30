# `autoMask`

## Overview

This utility is able to generate automatic pixel masks, which are applicable for certain sample environments. Currently it only works for the Paris-Edinburgh cells, which are commonly used on SNAP. It requires an input workspace that is an unfocussed workspace, containing data from a sample measured in a PE cell and which should normally be in units of wavelength (TOF is also usually OK). It then converts the data into a simple 2d image, by summing the events in each pixel. It then applies a thresholding algorithm (the ["Li thresholding" algorithm](https://scikit-image.org/docs/0.25.x/auto_examples/developers/plot_threshold_li.html) from the scikit-image package) to identify masked pixels. Finally, the image mask is converted into a mantid pixel mask workspace that can then be used during data reduction.

## Optional arguments

### `maskType`

This is envisaged for future expansion of the mask provision. Currently, the default option "PE" for Paris-Edinburgh cells is the only supported mask type.

### `plotOn`

Defaulting to `True`, this will pop up a 2d plot visually showing the mask that has been created. Changing the value of this parameter to `False` will prevent this image being shown.