unit feli_file;

{$mode objfpc}

interface

uses 
    fpjson,
    jsonparser;

type 
    FeliFileAPI = class(TObject)
    public
        class function get(path: ansiString): ansiString; static;
        class function getJsonArray(path: ansiString): TJsonArray; static;
        class function getJsonObject(path: ansiString): TJsonObject; static;
        class procedure put(path, payload: ansiString); static;
        class procedure debug; static;
    end;



implementation
uses
    feli_logger,
    feli_constants,
    sysutils;


class function FeliFileAPI.getJsonArray(path: ansiString): TJsonArray; static;
var
    load: ansiString;
begin
    load := FeliFileAPI.get(path);
    result := TJsonArray(getJson(load));
end;

class function FeliFileAPI.getJsonObject(path: ansiString): TJsonObject; static;
var
    load: ansiString;
begin
    load := FeliFileAPI.get(path);
    result := TJsonObject(getJson(load));
end;

class function FeliFileAPI.get(path: ansiString): ansiString; static;
var
    f: TextFile;
    line, all_lines: ansiString;

begin
    all_lines := '';
    if not FileExists(path) then 
        begin
            result := all_lines;
        end 
    else 
        begin
            assign(f, path);
            reset(f);

            while not eof(f) do
                begin
                    readln(f, line);
                    all_lines := all_lines + line + lineSeparator;
                end;
            
            close(f);
            result := all_lines;
        end;
end;

class procedure FeliFileAPI.put(path, payload: ansiString); static;
var
    f: TextFile;
begin
    if not FileExists(path) then FileCreate(path);    
    
    assign(f, path);
    rewrite(f);
    writeln(f, payload);
    close(f);
end;

class procedure FeliFileAPI.debug; static;
begin
    FeliLogger.info(format('[FeliFileAPI.debug]', []));
end;

end.
