# `autoStateName`

This is a small utility that generates a string representation of a state, useful to give a concise description of the state parameters. Requires a state dictionary (generated either by `pullStateDict` or `stateDef`)

Example:
```
import snapwrap.snapStateMgr as ssm

id,dict = ssm.stateDef(64413)
desc = ssm.autoStateName(dict)
print(desc)
```
returns the string
```
-65.5: 105.0: 2.1: 60: 1
```
this is clearly the two detector angles, wavelength, frequency and guide status.