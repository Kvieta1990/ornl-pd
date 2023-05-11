Software
===

A full list of software that can perform the local structure modeling for total scattering data will be presented in this page. Also, links to relevant tutorials are provided. There are two main categories of software for total scattering data analysis -- those based on unit-cell approach and those based on supercell approach. The former one is similar to the Rietveld fitting for Bragg diffraction data, where one has a unit cell defined for describing the underlying crystal structure and in practice one has a few structural parameters such as lattice constant, atomic motif positions, atomic displacement parameters, etc. to fit against the experimental total scattering data. For such an approach, one is assuming that the local structural correlation is represented by the unit cell, i.e., periodic bounday condition is assumed beyond the unit cell length scale. One can view such a unit cell as an average representative of the overall local scale structure aspect. However, such an average is different from the average unit cell as seen by the Bragg diffraction. The difference between the average as seen these two techniques is illustrated in the picture as follows,

<p align='center'>
<img src="../../imgs/local_ave_diff.png"
   style="border:none;"
   alt="lad"
   title="lad" />
<br />
</p>

Suppose we have two atoms with atom-1 fixed in the middle and atom-2 moving around atom-1 along a circular trace (the red dashed circle in the image), the local probe (e.g., with total scattering) sees the instantaneous distance between the two atoms and thus the average distance as seen by the local probe is the average of the instantaneous distances, which is, in this case, just the radius of the circle. However, from the average structure perspective, as seen by the Bragg diffraction, the average of the distance between atom-1 and atom-2 corresponds to the distance between the average position of the two atoms. In this demo case, average position of atom-1 is the center of the circle and the average position of atom-2 is represented by the orange dot in the image. Therefore, the average distance as seen by the Bragg diffraction is that represented by the pink arrow in the image.

Another typical approach for fitting the total scattering data is based on the supercell approach, using the reverse Monte Carlo method. In such an approach, one starts from a unit cell and expand it to a supercell. Afterwards, on then remove the symmetry constraint so the structure model then becomes a bix box (i.e., supercell). Then one adjust the model to match the data until a good agreement is achieved, and thus the supercell approach is considered as a data driven approach.

> On top of the driving force from the experiment data, one could also add in more constraint based on physical or chemical consideration of the underlying system, such as distacne window, bond valence sum, etc.

> Different software has its own way of deciding a 'good' agreement, but the fundamental idea is universal where one needs to define a threshold to be used as the criterion of convergence, i.e., good agreement with experimental data.

> Due the the large parameter space in the supercell approach, overfitting may become an issue. Typically, one may need to comprehensively inspect the outcome from the supercell data fitting. Or, a commonly used method is to repeat the same set of fitting multiple times to accumulate statistics. Some advanced methods concerning the overfitting issue are yet to be developed, e.g., given entropy consideration.

## Unit-cell baesd

### Diffpy-CMI

DiffPy-CMI is a flexible library of Python modules for robust modeling of structures in crystals, nano-, and amorphous materials. The package provides a fitting framework for combining multiple experimental inputs. Diffpy-CMI is available on Linux and Macintosh machines.

Link to software: <a href="https://www.diffpy.org/products/diffpycmi/index.html" target="_blank">https://www.diffpy.org/products/diffpycmi/index.html</a>

<u>Tutorial</u>

- <a href="https://www.youtube.com/watch?v=lNs8voPBjhY" target="_blank">https://www.youtube.com/watch?v=lNs8voPBjhY

- <a href="https://www.diffpy.org/products/diffpycmi/index.html" target="_blank">https://www.youtube.com/watch?v=lNs8voPBjhY</a>