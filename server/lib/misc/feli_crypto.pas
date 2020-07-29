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
    md5;



class function FeliCrypto.hashMD5(payload: ansiString): ansiString; static;
begin
    result := MD5Print(MD5String(payload));
end;

class function FeliCrypto.generateSalt(saltLength: integer): ansiString; static;
var
    output: ansiString;
    i, charAt: integer;

begin
    output := '';
    for i := 1 To saltLength do
        begin
            charAt := random(length(chars)) + 1;
            output := output + chars[charAt];
        end;
    result := output;

end;

end.
