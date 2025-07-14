# `checkCalibrationStatus`

This function has four arguments: 

1. `runNumber`: run number, can be None 
2. `stateID` (default None): ignored if runNumber not none, otherwise will specify which state to check the general calibration status of
3. `isLite`: (default True): whether to check lite or native calibration status
4. `calType`: (default "difcal") one of two strings: "difcal" or "normcal" to specify whether diffraction or normalisation calibration is to be checked

It returns a dictionary with information regarding the requested calibration status. calType may be either "difcal" or "nrmcal" and the information returned will respect this.

If `runNumber` is specified, then the specific calibration status of that run will be returned observing the validity of all existing calibrations (which typically are deliminted to apply to a finite set of runs).  


Example:
```
import snapwrap.snapStateMgr as ssm

isLite = True
calDict = ssm.checkCalibrationStatus(64413)
for key in calDict:
    if key != "calibIndex":
        print(key,":",calDict[key])
    else:
        print("\nCalibration Index entries:\n")
        for calibEntry in calDict[key]:
            for key2 in calibEntry:
                print(key2,":",calibEntry[key2])
```
returns
```
stateID : 04bd2c53f6bf6754
calibrationType : difcal
isLite : True
calFolder : /SNS/SNAP/shared/Malcolm/test/testsnapwrap/Calibration/Powder/04bd2c53f6bf6754/lite/diffraction/
indexPath : /SNS/SNAP/shared/Malcolm/test/testsnapwrap/Calibration/Powder/04bd2c53f6bf6754/lite/diffraction/CalibrationIndex.json
calibIndexList : [{'version': 2, 'runNumber': '64413', 'useLiteMode': True, 'appliesTo': '>=50000,<=50010', 'comments': 'test', 'author': 'test', 'timestamp': 1745847221.2151346}, {'version': 1, 'runNumber': '64413', 'useLiteMode': True, 'appliesTo': '>=50000', 'comments': 'test', 'author': 'test', 'timestamp': 1745416628.1169195}, {'version': 0, 'runNumber': '64413', 'useLiteMode': True, 'appliesTo': '>=0', 'comments': 'The default configuration when loading StateConfig if none other is found', 'author': 'SNAPRed Internal', 'timestamp': 1745415804.0368154}]
stateIsCalibrated : True
runIsCalibrated : True
numberCalibrations : 2
latestCalibrationDate : 2025-04-28 09:33:41
latestCalibrationDict : {'version': 2, 'runNumber': '64413', 'useLiteMode': True, 'appliesTo': '>=50000,<=50010', 'comments': 'test', 'author': 'test', 'timestamp': 1745847221.2151346}
latestValidCalibrationDate : 2025-04-23 09:57:08
latestValidCalibrationDict : {'version': 1, 'runNumber': '64413', 'useLiteMode': True, 'appliesTo': '>=50000', 'comments': 'test', 'author': 'test', 'timestamp': 1745416628.1169195}
```
note that `calDict["calibIndexList"]` is a list of dictionaries, one for each calibration that exists in the index.
