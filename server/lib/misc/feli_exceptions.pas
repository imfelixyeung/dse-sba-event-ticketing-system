unit feli_exceptions;

{$mode objfpc}


interface
uses
    sysutils;

type
    FeliExceptions = class(TObject)
    public
        type FeliStorageUserExist = class(Exception) end;
        type FeliStorageEventExist = class(Exception) end;
    end;



implementation


end.