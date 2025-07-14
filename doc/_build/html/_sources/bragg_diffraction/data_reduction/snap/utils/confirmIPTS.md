# `confirmIPTS`

This command allows updating of the Expermient Tracking section of the IPTS website that records the status of user's access to reduced data.

Example usage:
```
confirmIPTS(12345)
```
Where 12345 is the IPTS number. 

There are 3 optional arguments:
 
* `subNum`: integer, default is 1, (this is just the number after the decimal point in an ipts e.g. 1 for IPTS-12345.1)
* `redType`: a string from this list: [“Scripts”, “CIS”, “auto”]
* `comment`: free form string (default: “SNAPRed/snapwrap”)