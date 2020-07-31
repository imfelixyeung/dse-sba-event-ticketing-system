unit feli_logger;

{$mode objfpc}

interface

type 
    FeliLogger = class(TObject)
    private
    public
        class procedure save(payload: ansiString; forceLog: boolean = false); static;
        class procedure debug(payload: ansiString); static;
        class procedure log(payload: ansiString); static;
        class procedure error(payload: ansiString); static;
        class procedure warn(payload: ansiString); static;
        class procedure info(payload: ansiString); static;
        class procedure success(payload: ansiString); static;
    end;



implementation
uses 
    feli_file,
    feli_config,
    feli_constants,
    crt,
    sysutils;


class procedure FeliLogger.save(payload: ansiString; forceLog: boolean = false); static;
var lines: ansiString;
    dateTimeString: ansiString;

begin
    DateTimeToString(dateTimeString, 'yyyy-mm-dd hh:nn:ss', now);
    lines := FeliFileAPI.get(logFilePath);
    lines := lines + dateTimeString + ' ' + payload;
    FeliFileAPI.put(logFilePath, lines);
    if forceLog then writeln(payload) else
    if FeliConfig.getApplicationTerminalLog() then writeln(payload);
end;

class procedure FeliLogger.debug(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Debug]', payload]);
    textColor(blue);
    FeliLogger.save(line);
    textColor(mono);
end;


class procedure FeliLogger.log(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Log]', payload]);
    textColor(mono);
    FeliLogger.save(line);
    textColor(mono);
end;

class procedure FeliLogger.error(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Error]', payload]);
    textColor(lightRed);
    FeliLogger.save(line);
    textColor(mono);
end;

class procedure FeliLogger.warn(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Warn]', payload]);
    textColor(yellow);
    FeliLogger.save(line);
    textColor(mono);
end;

class procedure FeliLogger.info(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Info]', payload]);
    textColor(lightBlue);
    FeliLogger.save(line);
    textColor(mono);
end;

class procedure FeliLogger.success(payload: ansiString); static;
var line: ansiString;
begin
    line := format('[ETS] %0:-10s %s', ['[Success]', payload]);
    textColor(lightGreen);
    FeliLogger.save(line);
    textColor(mono);
end;

end.
