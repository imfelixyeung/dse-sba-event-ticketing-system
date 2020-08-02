unit feli_response;

{$mode objfpc}

interface
uses fpjson;

type
    FeliResponse = class(TObject)
        public
            error, msg: ansiString;
            resCode: integer;
            function toTJsonObject(): TJsonObject; virtual;
            function toJson(): ansiString; virtual;
        end;
    
    FeliResponseDataObject = class(FeliResponse)
        public
            data: TJsonObject;
            function toTJsonObject(): TJsonObject; override;
        end;

    FeliResponseDataArray = class(FeliResponse)
        public
            data: TJsonArray;
            function toTJsonObject(): TJsonObject; override;
        end;

implementation
uses 
    feli_logger,
    feli_stack_tracer;
function FeliResponse.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliResponse.toTJsonObject(): TJsonObject;');
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    if (msg <> '') then resObject.add('message', msg);
    result := resObject;
    FeliStackTrace.trace('end', 'function FeliResponse.toTJsonObject(): TJsonObject;');
end;

function FeliResponse.toJson(): ansiString;
var jsonObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliResponse.toJson(): ansiString;');
    jsonObject := toTJsonObject();
    result := jsonObject.formatJson;
    FeliStackTrace.trace('end', 'function FeliResponse.toJson(): ansiString;');
end;

function FeliResponseDataArray.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliResponseDataArray.toTJsonObject(): TJsonObject;');
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    resObject.add('data', data);
    result := resObject;
    FeliStackTrace.trace('end', 'function FeliResponseDataArray.toTJsonObject(): TJsonObject;');
end;

function FeliResponseDataObject.toTJsonObject(): TJsonObject;
var
    resObject: TJsonObject;
begin
    FeliStackTrace.trace('begin', 'function FeliResponseDataObject.toTJsonObject(): TJsonObject;');
    resObject := TJsonObject.create();
    resObject.add('status', resCode);
    if (error <> '') then resObject.add('error', error);
    resObject.add('data', data);
    result := resObject;
    FeliStackTrace.trace('end', 'function FeliResponseDataObject.toTJsonObject(): TJsonObject;');
end;

end.