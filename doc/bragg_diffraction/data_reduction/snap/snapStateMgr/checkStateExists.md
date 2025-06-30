# `checkStateExists`

Requires a stateID as an argument, returns `True` or `False` reflecting whether state folder exists in the `calibration.home` directory. 

Example:
```
import SNAPStateMgr as ssm

stateID = "3c7b8c841d10a16b"
print(f" StateID: {stateID} exists? {ssm.checkStateExists(stateID)}")
```
returns
```
StateID: 3c7b8c841d10a16b exists? True
```