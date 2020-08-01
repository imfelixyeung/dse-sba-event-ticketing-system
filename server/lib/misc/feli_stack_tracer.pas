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
        end;


implementation
uses
    feli_file,
    feli_constants,
    sysutils;

class procedure FeliStackTrace.trace(kind, name: ansiString); static;
var
    tempString, spaces: ansiString;
    i, depth: int64;
    
begin
    spaces := '';
    tempString := FeliFileAPI.get(stackTraceDepthPath);
    depth := StrToInt64(trim(tempString));
    case kind of
        'begin': depth := depth + 1;
        'end': depth := depth - 1;
    end;
    if ((depth - 3) <> 0) then for i := 0 to (depth - 3) do spaces := spaces + '  ';
    case kind of
        'begin': depth := depth + 1;
        'end': depth := depth - 1;
    end;
    tempString := kind;
    if (tempString = 'end') then tempString := ' end ';
    writeln(format('%s[%s] %s', [spaces, tempString, name]));
    FeliFileAPI.put(stackTraceDepthPath, IntToStr(depth));
end;

class procedure FeliStackTrace.out(load: String); static;
var
    tempString, spaces: ansiString;
    i, depth: int64;
    
begin
    spaces := '';
    tempString := FeliFileAPI.get(stackTraceDepthPath);
    depth := StrToInt64(trim(tempString));
    if ((depth - 4) <> 0) then for i := 0 to (depth - 4) do spaces := spaces + '  ';
    if (tempString = 'end') then tempString := ' end ';
    writeln(format('%s%s', [spaces, load]));
end;

class procedure FeliStackTrace.reset(); static;
begin
    FeliFileAPI.put(stackTraceDepthPath, '1');
end;

end.