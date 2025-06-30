# `file`

## Overview

This is a utility to help manage large numbers of workspaces in the mantid workspace tree. It works by creating a mantid workspace group (default name `File_Cabinet`) and allows the bulk movement of workspaces in and out of that using sub strings from the workspace names, here called nameKeys (nb nameKeys are not case sensitive). The desired nameKeys must be provided as a list of strings e.g. 
```python
nameKeys = ["all","column"]
nameKeys = ['all','column']
nameKeys = ['aLL','cOLuMn']
```
are all valid and will do the same thing. 
```
nameKeys = []
```
is also valid.

## Default usage

If the following script is run 

```python
import snapwrap.utils as wrap

wrap.file(nameKeys = ["all"])
```
_any_ workspace in the tree that contains the string "all" or any mixture of cases of this (e.g. "All", "aLl" or "aLL") will be moved to a Workspace Group called `File_Cabinet`, which will be created if it doesn't exist.

```{warning}
Any workspaces called e.g. "small_data", "callBack", "allData" or similar will all be moved into the Workspace Group as they contain the string "all".

Using a nameKey "all_" might help be more specific.

Any workspaces inadvertently added to the Workspace Group can be removed using the `remove` operation described below
```

The default behaviour is to cumulatively add specified workspaces to the Workspace Group. So, if the above command has been run, creating the workspace group and moving all workspaces with "all" in their names into that and _then_ the following is run: 

```
snapwrap.file(nameKeys = ["column"])
```
all workspaces with "column" in their names will also be moved into the Workspace Group

## Optional arguments

### `operation`

`operation` controls what `file` does. It has a default value of "add" and optional values of "remove" or "empty"

```
if operation == "add"
```
workspaces matching the specified nameKey will we be added to the Workspace Group. Any workspaces already in the group will be left there.

```
if operation == "remove"
```
Any workspaces inside the Group that match the provided nameKeys will be removed from the Group.

```
if operation == "empty"
```
irrespective of any provided nameKeys, all workspaces in the Workspace Group will be removed from the Group and the Group deleted.

### `cabinetName`

By default the Workspace Group will be called "File_Cabinet" if you wish to use a different name, this can be specified using `cabinetName`. Subsequenly, multiple Workspace Groups can be maintained as needed. 
