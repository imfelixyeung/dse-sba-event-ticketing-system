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
    sysutils,
    regExpr;

class function FeliValidation.emailCheck(email: ansiString): boolean; static;
var re: TRegExpr;
begin
    re := TRegExpr.create('^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w+)+$');
    result := re.exec(email);
end;

class function FeliValidation.fixedValueCheck(targetString: ansiString; const checkStrings: array of ansiString): boolean; static;
var
    currentString: ansiString;
    found: boolean;
begin
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
end;

class function FeliValidation.lengthCheck(target: ansiString; min, max: integer; inclusive: boolean = true): boolean; static;
begin
    result := FeliValidation.rangeCheck(length(target), min, max, inclusive);
end;

class function FeliValidation.rangeCheck(target, min, max: integer; inclusive: boolean = true): boolean; static;
begin
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

end;

class function FeliValidation.rangeCheck(target, min, max: real; inclusive: boolean = true): boolean; static;
begin
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

end;


class procedure FeliValidation.debug; static;
begin
    FeliLogger.info(format('[FeliValidation.debug]', []));
end;



end.
