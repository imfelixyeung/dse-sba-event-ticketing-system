# Feli User
`class FeliUser`

## Factory
### Create
```pascal
constructor create();
```
Creates an instance

### Create
```pascal
class function fromTJsonObject(userObject: TJsonObject): FeliUser; static;
```
Creates an filled instance with userObject

## Methods
### To json
```pascal
function toJson(): ansiString;
```
Converts instance to json string

### To TJsonObject
```pascal
function toTJsonObject(): TJsonObject;
```
Converts instance to an instance of TJsonObject

### Verify
```pascal
function verify(): boolean;
```
Verifies user

### Generate salted password
```pascal
procedure generateSaltedPassword();
```
Generates salted password
