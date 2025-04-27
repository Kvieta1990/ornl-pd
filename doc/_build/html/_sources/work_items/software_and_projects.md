Community Software and Projects
===

A list of powder diffraction software developed and maintained at ORNL to serve the community need.  Projects that are currently being actively worked on are also listed.

- RMCProfile

    > This is a commonly used software for total scattering data analysis. We have part of the development team at ORNL for supporting the software. We will provide continous support to the development of RMCProfile at ORNL. Please refer to our official website for more information, [https://rmcprofile.ornl.gov/](https://rmcprofile.ornl.gov/). Lead developers at ORNL are [Matt Tucker](https://www.ornl.gov/staff-profile/matthew-g-tucker) and [Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang)

    Here is an overall summary about the availability of the program on various platforms,

    | Platform\Version | 6.7.9    | 6.8.0 | 7.0 |
    |------------------|----------|-------|-----|
    | Windows CPU           | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Windows GPU           | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | MacOS Intel           | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | MacOS ARM             | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Linux CPU             | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Linux Legacy OS       | <a style="color:green">&#x2714;</a>  | <a style="color:red">&#10007;</a>   | <a style="color:green">&#x2714;</a> |
    | Linux GPU             | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Linux ARM             | <a style="color:green">&#x2714;</a>  | <a style="color:red">&#10007;</a>   | <a style="color:green">&#x2714;</a> |

    Here is an overall summary about the availability of features in different versions,

    | Feature\Version  | 6.7.9    | 6.8.0 | 7.0 |
    |------------------|----------|-------|-----|
    | Neutron Data in Real Space            | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Neutron Data in Reciprocal Space      | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | X-ray Data in Real Space              | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | X-ray Data in Reciprocal Space        | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Electron Data in Real Space           | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Electron Data in Reciprocal Space     | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Bragg Profile with GSAS (I & II)      | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Bragg Profile with Topas              | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Single Crystal Diffuse Scattering     | <a style="color:red">&#10007;</a>    | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Magnetic Systems Support              | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | EXAFS                                 | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | BVS Constraints                       | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Polyhedral Constraints                | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | ADP Constraints                       | <a style="color:red">&#10007;</a>    | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Tail Constraints                      | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Curvature Constraints                 | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Potential Constraint                  | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | LAMMPS Interface                      | <a style="color:red">&#10007;</a>    | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Nano Systems Modeling                 | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Single Phase                          | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Multiple Phase                        | <a style="color:red">&#10007;</a>    | <a style="color:red">&#10007;</a>   | <a style="color:green">&#x2714;</a> |
    | Atoms Swapping                        | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Molecular Move                        | <a style="color:red">&#10007;</a>    | <a style="color:red">&#10007;</a>   | <a style="color:green">&#x2714;</a> |
    | Weight Optimization                   | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | GPU Acceleration                      | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Resolution Correction (with QDamp)    | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:green">&#x2714;</a> |
    | Resolution Correction Beyond Gaussian | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |
    | Auxillary Programs Support            | <a style="color:green">&#x2714;</a>  | <a style="color:green">&#x2714;</a> | <a style="color:red">&#10007;</a>   |

- Spinteract

    > Spinteract is a program for refinement of magnetic interaction parameters to magnetic diffuse scattering data collected on powder and single-crystal samples. The lead developer for this program is [Joe Paddison](https://www.ornl.gov/staff-profile/joseph-paddison). Please refer to [this website](https://joepaddison.com/software/) for more information.
    
- Scatty

    > Scatty is a program for ultrafast calculation of diffuse-scattering patterns from atomistic models. The lead developer for this program is [Joe Paddison](https://www.ornl.gov/staff-profile/joseph-paddison). Please refer to [this website](https://joepaddison.com/software/) for more information.
    
- Spinvert

    > Spinvert is a program for refinement of for refinement of atomistic models to powder magnetic diffuse scattering data for frustrated magnets, spin glasses, and other magnetically disordered materials. The lead developer for this program is [Joe Paddison](https://www.ornl.gov/staff-profile/joseph-paddison). Please refer to [this website](https://joepaddison.com/software/) for more information.
    
- GSAS-II

    > There is ongoing effort on the ORNL side to get active involvement in the GSAS-II development. With regard to the powder diffraction, two main contributors are [Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) and [Joe Paddison](https://www.ornl.gov/staff-profile/joseph-paddison).
    
- Machine learning for phase transition study

    > This is a postdoc project led by [Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) about using the machine learning algorithm for studying complex phase transition problems. The postdoc working on this project is [Dayton Kizzire](https://www.ornl.gov/staff-profile/dayton-g-kizzire).
    
- Machine learning for neutron total scattering data de-noising

    > This is a SULI project led by [Yuanpeng Zhang](https://www.ornl.gov/staff-profile/yuanpeng-zhang) trying to utilize the machine learning algorithm for data denoising for neutron total scattering.