unit feli_config;

{$mode objfpc}

interface


type 
    FeliConfig = class(TObject)
    public
        class function getApplicationTerminalLog(): boolean; static;
    end;



implementation
uses
    feli_file,
    feli_logger,
    feli_constants,
    fpjson,
    jsonparser,
    sysutils;

class function FeliConfig.getApplicationTerminalLog(): boolean; static;
const key = 'application-terminal-log';
var 
    configObject: TJsonObject;
    config: ansiString;
begin
    config := FeliFileAPI.get(configFilePath);
    configObject := TJsonObject(getJson(config));
    try
        result := configObject.findPath(key).asBoolean;
    except
        FeliLogger.save(format('[ETS] [Error] Unable to find key %s in %s, falling back to default true', [key, configFilePath]), true);
        result := true;
    end;
end;

end.
