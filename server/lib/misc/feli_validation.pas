unit feli_validation;

{$mode objfpc}

interface

type 
    FeliValidation = class(TObject)
    private
    public
        class function emailCheck(email: ansiString): boolean; static;
        class function fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;
        class function lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;
        class function rangeCheck(target, min, max: integer; inclusive: boolean = true): boolean; static;
        class function rangeCheck(target, min, max: real; inclusive: boolean = true): boolean; static;
        class procedure debug; static;
    end;



implementation
uses 
    feli_logger,
    feli_stack_tracer,
    sysutils,
    regExpr;

class function FeliValidation.emailCheck(email: ansiString): boolean; static;
var re: TRegExpr;
begin
    FeliStackTrace.trace('begin', 'class function FeliValidation.emailCheck(email: ansiString): boolean; static;');
    re := TRegExpr.create('^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w+)+$');
    result := re.exec(email);
    FeliStackTrace.trace('end', 'class function FeliValidation.emailCheck(email: ansiString): boolean; static;');
end;

class function FeliValidation.fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;
var
    currentString: ansiString;
    found: boolean;
begin
    FeliStackTrace.trace('begin', 'class function FeliValidation.fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;');
    found := false;
    for currentString in checkStrings do
    begin
        if targetString = currentString then
            begin
                found := true;
                break;
            end;
    end;
    result := found;
    FeliStackTrace.trace('end', 'class function FeliValidation.fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;');
end;

class function FeliValidation.lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;
begin
    FeliStackTrace.trace('begin', 'class function FeliValidation.lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;');
    result := FeliValidation.rangeCheck(length(target), min, max, inclusive);
    FeliStackTrace.trace('end', 'class function FeliValidation.lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;');
end;

class function FeliValidation.rangeCheck(target, min, max: integer; inclusive: boolean = true): boolean; static;
begin
    FeliStackTrace.trace('begin', 'class function FeliValidation.rangeCheck(target, min, max: integer; inclusive: boolean = true): boolean; static;');
    if (min <= target) and (target <= max) then
            
            if inclusive then
                result := true
            else 
                if (min = target) or (max = target) then
                    result := false
                else
                    result := true
    else
        result := false;
    FeliStackTrace.trace('end', 'class function FeliValidation.rangeCheck(target, min, max: integer; inclusive: boolean = true): boolean; static;');
end;

class function FeliValidation.rangeCheck(target, min, max: real; inclusive: boolean = true): boolean; static;
begin
    FeliStackTrace.trace('begin', 'class function FeliValidation.rangeCheck(target, min, max: real; inclusive: boolean = true): boolean; static;');
    // Checks if min <= target <= max
    if (min <= target) and (target <= max) then
            
            if inclusive then
                result := true
            else 
                // Checks if min < target < max
                if (min = target) or (max = target) then
                    result := false
                else
                    result := true
    else
        result := false;
    FeliStackTrace.trace('end', 'class function FeliValidation.rangeCheck(target, min, max: real; inclusive: boolean = true): boolean; static;');
end;


class procedure FeliValidation.debug; static;
begin
    FeliStackTrace.trace('begin', 'class procedure FeliValidation.debug; static;');
    FeliLogger.info(format('[FeliValidation.debug]', []));
    FeliStackTrace.trace('end', 'class procedure FeliValidation.debug; static;');
end;



end.
