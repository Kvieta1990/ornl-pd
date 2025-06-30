# `stateDef`

A method that accepts a run number as an argument and returns a list with two entries: 
1. The stateID (e.g. 0e04feff89cf95f3)
2. A dictionary containing the values of the 5 parameters that define the state.

Example:
```
import SNAPStateMgr as ssm

stateInfo = ssm.stateDef(64414)

print(f"stateID: {stateInfo[0]}")
print("stateDict:")
for key in stateInfo[1]:
    print(key, stateInfo[1][key])
```
provides output:
```
stateID: 04bd2c53f6bf6754
stateDict:
vdet_arc1 -65.5
vdet_arc2 105.0
WavelengthUserReq 2.1
Frequency 60
Pos 1
```