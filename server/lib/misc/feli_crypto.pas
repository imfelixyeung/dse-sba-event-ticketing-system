unit feli_crypto;

{$mode objfpc}

interface


type 
    FeliCrypto = class(TObject)
    public
        class function hashMD5(payload: ansiString): ansiString; static;
        class function generateSalt(saltLength: integer): ansiString; static;
    end;



implementation
uses
    feli_constants,
    feli_stack_tracer,
    md5;



class function FeliCrypto.hashMD5(payload: ansiString): ansiString; static;
begin
    FeliStackTrace.trace('begin', 'class function FeliCrypto.hashMD5(payload: ansiString): ansiString; static;');
    result := MD5Print(MD5String(payload));
    FeliStackTrace.trace('end', 'class function FeliCrypto.hashMD5(payload: ansiString): ansiString; static;');
end;

class function FeliCrypto.generateSalt(saltLength: integer): ansiString; static;
var
    output: ansiString;
    i, charAt: integer;

begin
    FeliStackTrace.trace('begin', 'class function FeliCrypto.generateSalt(saltLength: integer): ansiString; static;');
    output := '';
    for i := 1 To saltLength do
        begin
            charAt := random(length(chars)) + 1;
            output := output + chars[charAt];
        end;
    result := output;
    FeliStackTrace.trace('end', 'class function FeliCrypto.generateSalt(saltLength: integer): ansiString; static;');
end;

end.
