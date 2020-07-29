# Feli Logger
`class FeliLogger`

## Methods
### Save to log file
```pascal
class procedure save(payload: ansiString; forceLog: boolean = false); static;
```
Saves payload to log file with timestamp

### Log normal
```pascal
class procedure log(payload: ansiString); static;
```
Logs payload in console

### Log debug
```pascal
class procedure debug(payload: ansiString); static;
```
Logs payload in console in blue

### Log error
```pascal
class procedure error(payload: ansiString); static;
```
Logs payload in console in light red

### Log warn
```pascal
class procedure warn(payload: ansiString); static;
```
Logs payload in console in yellow

### Log info
```pascal
class procedure info(payload: ansiString); static;
```
Logs payload in console in light blue

### Log success
```pascal
class procedure success(payload: ansiString); static;
```
Logs payload in console in light green