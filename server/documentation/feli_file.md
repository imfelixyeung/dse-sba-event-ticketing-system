# Feli File API
`class FeliFileAPI`

## Methods
### Get
```pascal
class function get(path: ansiString): ansiString; static;
```
Gets file content as string

### Get json array
```pascal
class function getJsonArray(path: ansiString): TJsonArray; static;
```
Gets file content as a json array

### Get json array
```pascal
class function getJsonObject(path: ansiString): TJsonObject; static;
```
Gets file content as a json object

### Put
```pascal
class procedure put(path, payload: ansiString); static;
```
Puts payload into file