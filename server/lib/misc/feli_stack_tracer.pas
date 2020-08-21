unit feli_stack_tracer;

{$mode objfpc}

interface
uses fpjson;

type
    FeliStackTrace = class(TObject)
        public
            class procedure trace(kind, name: ansiString); static;
            class procedure reset(); static;
            class procedure out(load: String); static;
            class procedure breakPoint(); static;
        end;

function simpleSpaceReplaceText(str: ansiString): ansiString;


implementation
uses
    feli_file,
    feli_constants,
    feli_config,
    sysutils;

function simpleSpaceReplaceText(str: ansiString): ansiString;
var
    i: integer;
    tempStr: ansiString;
begin
    tempStr := '';
    
    for i := 1 to length(str) do
        begin
            if ((i - 1) mod 4) = 0  then
                tempStr := tempStr + '|'
            else
                tempStr := tempStr + ' ';
        end;
    
    result := tempStr;
end;

class procedure FeliStackTrace.trace(kind, name: ansiString); static;
var
    tempString, spaces: ansiString;
    i, depth: integer;
    
begin
    if (FeliConfig.getIsDebug()) then begin
        spaces := '';
        tempString := FeliFileAPI.get(stackTraceDepthPath);
        depth := StrToInt(trim(tempString));
        case kind of
            'begin': depth := depth + 1;
            'end': depth := depth - 1;
        end;
        if ((depth - 3) <> 0) then for i := 0 to (depth - 3) do spaces := spaces + '| ';
        case kind of
            'begin': depth := depth + 1;
            'end': depth := depth - 1;
        end;
        tempString := kind;
        if (tempString = 'end') then tempString := ' end ';
        spaces := simpleSpaceReplaceText(spaces);
        writeln(format('%s[%s] %s', [spaces, tempString, name]));
        FeliFileAPI.put(stackTraceDepthPath, IntToStr(depth));
    end;
end;

class procedure FeliStackTrace.out(load: String); static;
var
    tempString, spaces: ansiString;
    i, depth: integer;
    
begin
    spaces := '';
    tempString := FeliFileAPI.get(stackTraceDepthPath);
    depth := StrToInt(trim(tempString));
    if ((depth - 4) <> 0) then for i := 0 to (depth - 4) do spaces := spaces + '| ';
    if (tempString = 'end') then tempString := ' end ';
    spaces := simpleSpaceReplaceText(spaces);
    writeln(format('%s%s', [spaces, load]));
end;

class procedure FeliStackTrace.reset(); static;
begin
    FeliFileAPI.put(stackTraceDepthPath, '1');
end;

class procedure FeliStackTrace.breakPoint(); static;
begin
    write('Press Enter to continue');
    readln();
end;


end.