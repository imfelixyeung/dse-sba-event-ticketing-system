# Feli Validation
`class FeliValidation`

## Methods
### Email check
```pascal
class function emailCheck(email: ansiString): boolean; static;
```
Checks if email is valid

### Fixed value check
```pascal
class function fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;
```
Checks if check strings contains target string

### Length check
```pascal
class function lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;
```
Checks if target length is within [min, max] or {min, max}

### Range Check
```pascal
class function rangeCheck(target, min, max: integer/real; inclusive: boolean = true): boolean; static;
```
Checks if target is within [min, max] or {min, max}
