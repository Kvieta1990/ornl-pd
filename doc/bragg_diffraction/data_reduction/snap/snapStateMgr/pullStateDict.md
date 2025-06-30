# `pullStateDict`

Sometimes it's useful to be able to pull a state definition directly from the specified calibration folder, rather than from a run number (and corresponding data file). This function does this, the required input parameter is a string of the stateID. If needed, the stateID can be easily generated from a run number using `stateDef`

Example:
```
import SNAPStateMgr as ssm

stateDict = ssm.pullStateDict("3c7b8c841d10a16b")

for key in stateDict:
    print(key,":",stateDict[key])
```
returns:
```
vdet_arc1 : -90.0
vdet_arc2 : 66.0
WavelengthUserReq : 2.1
Frequency : 60
Pos : 1
```