# `isCalibrated`

This small utility accepra a run number as an argument and returns a tuple of Booleans indicating 
whether valid diffraction and normalisation calibrations (respectively) exist for that run. 

Example usage:

```
import snapwrap.snapStateMgr as ssm

runStatus = ssm.isCalibrated(66413)
print(runStatus)
```
will return `(True,True)` as both valid difcal and normcals exist.