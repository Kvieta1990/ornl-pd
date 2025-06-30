# `swissCheese`

`Overview`

Swiss cheese is a class that contains multiple methods to support the creation, use and management of Swiss Cheese masks. It also acts as a container for another class defined in `maskUtils` called `eye`. The nomenclature comes from the cheese analogy as the individual holes in a swiss cheese are referred to as "eyes".

An `eye` has 5 attributes: 

|Attribute | Summary |
|----------|---------|
| xUnits    | the units in the x-axis that define the bin limits of the eye. These must match mantid standard units such as `Wavelength`, `dSpacing` or `TOF` |
| xMin      | The minimium value, in units of `xUnits` above which events will be masked |
| xMax      | The maximum value, in units of `xUnits` above which events will be masked |
|inputWorkspaceIndexSet | this is a string specifying which pixels the eye affect. It follows mantid format: a comma separated list that may contain ranges specified using hyphens or colons e.g. "3452,5678,12000:12100" |
|isLite | as the pixel ranges in `inputWorkspaceIndexSet` will have different meaning depending on whether data are `Lite` or `Native`, the `isLite` Boolean must indicate which applies |

When swissCheese is instantiated, it contains a single attribute, which is an empty list called `eyeList` which acts as a container for `eye` instances. Below, the available methods to generate and organize the list of `eyes`. In addition save and load methods exist to for the `swissCheese` object.

A swiss cheese mask is instantiated with

```
import snapwrap.maskUtils as mut

cheese = swissCheese()
```

At this point, the cheese has no eyes, these can be added using various methods as described below.

## `notchFromList`

A method which is especially beneficial for diamond-anvil datasets, this allows the user to specify "notches". Notches are specific types of eye that extend across all detector pixels and, thus can "notch-out" entire sheets of events across a specified range of x-units. Required arguments are:

*  `xUnits` (typically 'dSpacing' or 'Wavelength'), 
*  `notchList`  a list of lists where the sublists have length of 2 and contain [`xMin`,`xMax`]
*  `isLite` the usual specifier

The corresponding "eyes" are created and added to the swiss cheese

## `notchFromUB`

An alternate method to create notches, if you have `ISAW` format (commonly used at the SNS to store UB matrices), this utility will load the UB of a diamond anvil and calculate what wavelengths reflections are expected to satisfy the Bragg condition. The width of the notch corresponding to each reflection is specified by a polynomial of arbitrary degree. 

i.e. the width of notch n, at wavelength lam_n is calculated as width a0+a1*lam_n+a2*lam_n_... with user specified coefficients. Required arguments are: 

Note: currently, this only works for diamond anvils.

* `wsName` the name of a mantid workspace that will hold the loaded UB matrix
* `UBPath` the full path to the ISAW format UB matrix file
* `widthCoef` the list of [a0,a1,a2...] coefficients used to calculate the width.
* `isLite` the normal compression setting
* `lamMin` defaulting to 0.5 Å this is the minimum lambda that eyes will be created for.

## `extractFromWorkspaceHistory`

It is possible to manually create a swiss cheese mask in the `mantidworkbench` show instrument view, using various provided drawing tools. After creating the mask and applying it to the workspace, this can be extracted into swiss cheese form using this method. The only argument is the workspace name.

## `makeMaskBinsTables`

This method converts all eyes into a mantid `TableWorkspace` that mantid can then apply using its algorithm `MaskBinsFromTable`. It will process all present eyes, treating those with different units separately and creating a separate TableWorkspace for these.

## `save` and `load`

These methods allow writing created swiss cheese masks to disk and then reloading them. For saving the required arguments are `filePath` and `filePrefix`. The corresponding mask will then be saved to a file at: `{filePath}{filePrefix}_{unit}.json` (where {unit} is the unit of the corresponding eyes).

For loading, the only required parameters is the full filepath.

